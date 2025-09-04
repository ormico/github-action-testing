# Repository Setup Script
# This script configures the GitHub repository with required settings for the CI/CD pipeline

param(
    [Parameter(Mandatory=$false)]
    [string]$RepositoryName = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Owner = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false
)

# Check if GitHub CLI is installed
function Test-GitHubCLI {
    try {
        $null = gh --version
        Write-Host "✓ GitHub CLI is available"
        return $true
    }
    catch {
        Write-Error "❌ GitHub CLI is not installed or not in PATH"
        Write-Host "Please install GitHub CLI: https://cli.github.com/"
        return $false
    }
}

# Check if user is authenticated with GitHub CLI
function Test-GitHubAuth {
    try {
        $null = gh auth status
        Write-Host "✓ GitHub CLI authentication is valid"
        return $true
    }
    catch {
        Write-Error "❌ GitHub CLI authentication failed"
        Write-Host "Please run: gh auth login"
        return $false
    }
}

# Get repository information
function Get-RepositoryInfo {
    if (-not $RepositoryName -or -not $Owner) {
        try {
            $repoInfo = gh repo view --json name,owner | ConvertFrom-Json
            $script:RepositoryName = $repoInfo.name
            $script:Owner = $repoInfo.owner.login
            Write-Host "✓ Repository detected: $Owner/$RepositoryName"
        }
        catch {
            Write-Error "❌ Could not detect repository information"
            Write-Host "Please run this script from within a GitHub repository or specify -RepositoryName and -Owner parameters"
            exit 1
        }
    }
}

# Configure branch protection rules
function Set-BranchProtection {
    param(
        [string]$Branch,
        [array]$RequiredChecks
    )
    
    Write-Host "Configuring branch protection for '$Branch'..."
    
    # Format checks for GitHub API
    $formattedChecks = @()
    foreach ($check in $RequiredChecks) {
        if ($check -is [string]) {
            $formattedChecks += @{ context = $check }
        } else {
            $formattedChecks += $check
        }
    }
    
    $protection = @{
        required_status_checks = @{
            strict = $true
            checks = $formattedChecks
        }
        enforce_admins = $false
        required_pull_request_reviews = @{
            required_approving_review_count = 1
            dismiss_stale_reviews = $true
            require_code_owner_reviews = $false
        }
        restrictions = $null
        allow_force_pushes = $false
        allow_deletions = $false
    }
    
    $protectionJson = $protection | ConvertTo-Json -Depth 10
    
    if ($DryRun) {
        Write-Host "DRY RUN: Would configure branch protection:"
        Write-Host $protectionJson
    }
    else {
        try {
            # First, ensure the branch exists
            $branchExists = gh api repos/$Owner/$RepositoryName/branches/$Branch 2>$null
            if (-not $branchExists) {
                Write-Warning "Branch '$Branch' does not exist. Branch protection will be applied when branch is created."
                return
            }
            
            # Use GitHub CLI to set branch protection
            $tempFile = [System.IO.Path]::GetTempFileName()
            $protectionJson | Out-File -FilePath $tempFile -Encoding UTF8
            
            $result = gh api repos/$Owner/$RepositoryName/branches/$Branch/protection -X PUT --input $tempFile 2>&1
            Remove-Item $tempFile
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Branch protection configured for '$Branch'"
            } else {
                Write-Warning "Branch protection may need manual configuration for '$Branch'"
                Write-Host "Error details: $result"
            }
        }
        catch {
            Write-Error "❌ Failed to configure branch protection for '$Branch': $_"
            Write-Host "You may need to configure branch protection manually in GitHub repository settings"
        }
    }
}

# Create GitHub environments
function New-GitHubEnvironment {
    param(
        [string]$EnvironmentName,
        [array]$Reviewers = @(),
        [int]$WaitTimer = 0,
        [bool]$ProtectedBranches = $true
    )
    
    Write-Host "Creating environment '$EnvironmentName'..."
    
    $environment = @{
        wait_timer = $WaitTimer
        reviewers = $Reviewers
        deployment_branch_policy = @{
            protected_branches = $ProtectedBranches
            custom_branch_policies = $false
        }
    }
    
    $environmentJson = $environment | ConvertTo-Json -Depth 10
    
    if ($DryRun) {
        Write-Host "DRY RUN: Would create environment:"
        Write-Host $environmentJson
    }
    else {
        try {
            $tempFile = [System.IO.Path]::GetTempFileName()
            $environmentJson | Out-File -FilePath $tempFile -Encoding UTF8
            
            $result = gh api repos/$Owner/$RepositoryName/environments/$EnvironmentName -X PUT --input $tempFile 2>&1
            Remove-Item $tempFile
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Environment '$EnvironmentName' configured"
            } else {
                Write-Warning "Environment creation may need manual setup for '$EnvironmentName'"
                Write-Host "Error details: $result"
            }
        }
        catch {
            Write-Error "❌ Failed to create environment '$EnvironmentName': $_"
        }
    }
}

# Configure repository settings
function Set-RepositorySettings {
    Write-Host "Configuring repository settings..."
    
    $settings = @{
        allow_squash_merge = $true
        allow_merge_commit = $false
        allow_rebase_merge = $true
        delete_branch_on_merge = $true
        allow_auto_merge = $true
    }
    
    $settingsJson = $settings | ConvertTo-Json -Depth 10
    
    if ($DryRun) {
        Write-Host "DRY RUN: Would configure repository settings:"
        Write-Host $settingsJson
    }
    else {
        try {
            $tempFile = [System.IO.Path]::GetTempFileName()
            $settingsJson | Out-File -FilePath $tempFile -Encoding UTF8
            
            $result = gh api repos/$Owner/$RepositoryName -X PATCH --input $tempFile 2>&1
            Remove-Item $tempFile
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Repository settings configured"
            } else {
                Write-Warning "Repository settings may need manual configuration"
                Write-Host "Error details: $result"
            }
        }
        catch {
            Write-Error "❌ Failed to configure repository settings: $_"
        }
    }
}

# Enable GitHub Actions and set permissions
function Set-ActionsPermissions {
    Write-Host "Configuring GitHub Actions permissions..."
    
    $permissions = @{
        enabled = $true
        allowed_actions = "all"
        default_workflow_permissions = "write"
        can_approve_pull_request_reviews = $false
    }
    
    $permissionsJson = $permissions | ConvertTo-Json -Depth 10
    
    if ($DryRun) {
        Write-Host "DRY RUN: Would configure Actions permissions:"
        Write-Host $permissionsJson
    }
    else {
        try {
            $tempFile = [System.IO.Path]::GetTempFileName()
            $permissionsJson | Out-File -FilePath $tempFile -Encoding UTF8
            
            $result = gh api repos/$Owner/$RepositoryName/actions/permissions -X PUT --input $tempFile 2>&1
            Remove-Item $tempFile
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ GitHub Actions permissions configured"
            } else {
                Write-Warning "Actions permissions may need manual configuration"
                Write-Host "Error details: $result"
            }
        }
        catch {
            Write-Error "❌ Failed to configure Actions permissions: $_"
        }
    }
}

# Test if branch protection can be applied
function Test-BranchProtectionSetup {
    Write-Host "Testing branch protection setup requirements..."
    
    # Check if we have admin permissions
    try {
        gh api repos/$Owner/$RepositoryName --jq '.permissions' > $null
        Write-Host "Repository permissions check completed"
    }
    catch {
        Write-Warning "Cannot verify repository permissions. You may need admin access to set up branch protection."
    }
    
    # Check if main branch exists
    try {
        $mainBranch = gh api repos/$Owner/$RepositoryName/branches/main 2>$null
        if ($mainBranch) {
            Write-Host "✓ Main branch exists and can have protection applied"
        }
    }
    catch {
        Write-Warning "Main branch may not exist yet. Branch protection will be applied when main branch is created."
    }
}

# Main execution
Write-Host "=== GitHub Repository Setup Script ==="
Write-Host "This script will configure your repository for the CI/CD pipeline"
Write-Host ""

# Validate prerequisites
if (-not (Test-GitHubCLI)) { exit 1 }
if (-not (Test-GitHubAuth)) { exit 1 }

# Get repository information
Get-RepositoryInfo

Write-Host ""
Write-Host "Repository: $Owner/$RepositoryName"
if ($DryRun) {
    Write-Host "Mode: DRY RUN (no changes will be made)"
}
Write-Host ""

# Test setup requirements
Test-BranchProtectionSetup

# Configure repository settings
Set-RepositorySettings

# Set up GitHub Actions permissions
Set-ActionsPermissions

# Configure branch protection for main branch
Write-Host ""
Write-Host "Setting up branch protection rules..."
$mainBranchChecks = @("build-and-test", "security-scan", "version-check")
Set-BranchProtection -Branch "main" -RequiredChecks $mainBranchChecks

# Create environments
Write-Host ""
Write-Host "Creating GitHub environments..."
New-GitHubEnvironment -EnvironmentName "development" -WaitTimer 0
New-GitHubEnvironment -EnvironmentName "testing" -WaitTimer 0
New-GitHubEnvironment -EnvironmentName "staging" -WaitTimer 300  # 5 minute wait
New-GitHubEnvironment -EnvironmentName "production" -WaitTimer 600  # 10 minute wait

Write-Host ""
Write-Host "=== Repository Setup Complete ==="
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Verify branch protection rules in GitHub repository settings"
Write-Host "2. Configure environment reviewers if needed:"
Write-Host "   Go to Settings > Environments > [environment] > Add reviewers"
Write-Host "3. Add any required secrets for deployments:"
Write-Host "   Go to Settings > Secrets and variables > Actions"
Write-Host "4. Test the CI/CD workflows:"
Write-Host "   - Create a feature branch and PR to test PR workflow"
Write-Host "   - Use Actions tab to run feature build workflow"
Write-Host "   - Create a release branch to test release workflow"
Write-Host ""

if ($DryRun) {
    Write-Host "Note: This was a dry run. Re-run without -DryRun to apply changes."
    Write-Host "Command: .\setup-repository.ps1"
}

Write-Host ""
Write-Host "If branch protection rules were not applied automatically,"
Write-Host "you can configure them manually in GitHub:"
Write-Host "1. Go to Settings > Branches"
Write-Host "2. Add rule for 'main' branch"
Write-Host "3. Enable: 'Require pull request reviews'"
Write-Host "4. Enable: 'Require status checks to pass before merging'"
Write-Host "5. Add status checks: build-and-test, security-scan, version-check"
Write-Host "6. Enable: 'Require branches to be up to date before merging'"
