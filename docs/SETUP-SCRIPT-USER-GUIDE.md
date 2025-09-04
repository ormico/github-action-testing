# Repository Setup Script - User Guide

## 🎯 Overview

The `setup-repository.ps1` script automates the configuration of GitHub repository settings required for the CI/CD pipeline. It configures branch protection, environments, and GitHub Actions permissions.

## 📍 Location

```
scripts/setup-repository.ps1
```

**Why this location?**
- **Easy to find**: Scripts folder at repository root
- **Separate from CI/CD scripts**: Distinguishes setup scripts from workflow scripts
- **User-accessible**: Not buried in `.github` folder structure

## 🚀 Quick Start

### Prerequisites
1. **GitHub CLI installed** - [Download here](https://cli.github.com/)
2. **Authenticated with GitHub** - Run `gh auth login`
3. **Repository admin permissions** - Required for branch protection and environments

### Basic Usage

```powershell
# From repository root
.\scripts\setup-repository.ps1
```

### Test First (Recommended)
```powershell
# See what would be configured without making changes
.\scripts\setup-repository.ps1 -DryRun
```

## 🔧 Command Options

### Parameters
```powershell
.\scripts\setup-repository.ps1 [OPTIONS]
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-RepositoryName` | String | Auto-detect | Specific repository name |
| `-Owner` | String | Auto-detect | Repository owner/organization |
| `-DryRun` | Switch | False | Test mode - show what would be done |

### Examples
```powershell
# Auto-detect repository (recommended)
.\scripts\setup-repository.ps1

# Dry run to test configuration
.\scripts\setup-repository.ps1 -DryRun

# Specify repository explicitly
.\scripts\setup-repository.ps1 -Owner "myorg" -RepositoryName "myrepo"

# Test specific repository configuration
.\scripts\setup-repository.ps1 -Owner "myorg" -RepositoryName "myrepo" -DryRun
```

## 📋 What Gets Configured

### 1. Repository Settings
- **Merge options**: Squash merge ✅, Merge commits ❌, Rebase merge ✅
- **Branch management**: Auto-delete merged branches ✅
- **Auto-merge**: Enable auto-merge when conditions met ✅

### 2. Branch Protection Rules (main branch)
- **Required reviews**: 1 approving review required
- **Status checks**: `build-and-test`, `security-scan`, `version-check`
- **Up-to-date requirement**: Branches must be current with main
- **Restrictions**: No force pushes, no branch deletion
- **Dismiss stale reviews**: When new commits are pushed

### 3. GitHub Environments
| Environment | Wait Timer | Purpose |
|-------------|------------|---------|
| `development` | 0 minutes | Development deployments |
| `testing` | 0 minutes | QA and testing |
| `staging` | 5 minutes | Pre-production validation |
| `production` | 10 minutes | Production deployments |

### 4. GitHub Actions Permissions
- **Actions enabled**: Repository can run GitHub Actions
- **Allowed actions**: All actions permitted
- **Workflow permissions**: Write access to repository
- **PR approvals**: Workflow cannot approve its own PRs

## ✅ Verification

The script provides real-time feedback. Look for these success indicators:

```
✓ GitHub CLI is available
✓ GitHub CLI authentication is valid
✓ Repository detected: owner/repository-name
✓ Main branch exists and can have protection applied
✓ Repository settings configured
✓ GitHub Actions permissions configured
✓ Branch protection configured for 'main'
✓ Environment 'development' configured
✓ Environment 'testing' configured
✓ Environment 'staging' configured
✓ Environment 'production' configured
```

### Manual Verification

After running the script, verify in GitHub web interface:

#### 1. Branch Protection
1. Go to **Settings** → **Branches**
2. Verify rule exists for `main` branch
3. Check required status checks and review requirements

#### 2. Environments  
1. Go to **Settings** → **Environments**
2. Verify all 4 environments exist
3. Check wait timers and protection rules

#### 3. Actions Permissions
1. Go to **Settings** → **Actions** → **General**
2. Verify actions are enabled with appropriate permissions

## 🔍 Testing and Validation

### Test Commands Used During Development

Here are the exact commands used to verify the script works correctly:

#### 1. Dry Run Verification
```powershell
# Test what would be configured
.\scripts\setup-repository.ps1 -DryRun
```
**Expected Output**: JSON configuration for all settings without applying changes

#### 2. Branch Protection Verification
```powershell
# Check branch protection after script runs
gh api repos/ormico/github-action-testing/branches/main/protection | ConvertFrom-Json | ConvertTo-Json -Depth 5
```
**Verified Results**:
- ✅ Required status checks: `build-and-test`, `security-scan`, `version-check`
- ✅ Required reviews: 1 approving review
- ✅ Dismiss stale reviews: enabled
- ✅ Force pushes: disabled
- ✅ Branch deletion: disabled

#### 3. Environment Verification
```powershell
# List created environments
gh api repos/ormico/github-action-testing/environments | ConvertFrom-Json | Select-Object -ExpandProperty environments | Select-Object name
```
**Verified Results**:
- ✅ `development` environment created
- ✅ `testing` environment created  
- ✅ `staging` environment created
- ✅ `production` environment created

#### 4. Repository Settings Verification
```powershell
# Check merge settings
gh api repos/ormico/github-action-testing | ConvertFrom-Json | Select-Object allow_squash_merge,allow_merge_commit,allow_rebase_merge,delete_branch_on_merge,allow_auto_merge
```
**Verified Results**:
- ✅ `allow_squash_merge`: True
- ✅ `allow_merge_commit`: False  
- ✅ `allow_rebase_merge`: True
- ✅ `delete_branch_on_merge`: True
- ✅ `allow_auto_merge`: True

#### 5. Actions Permissions Verification
```powershell
# Check Actions permissions
gh api repos/ormico/github-action-testing/actions/permissions | ConvertFrom-Json
```
**Verified Results**:
- ✅ `enabled`: True
- ✅ `allowed_actions`: all

## ⚠️ Troubleshooting

### Common Issues and Solutions

#### 1. "GitHub CLI is not installed"
**Solution**: Install GitHub CLI from https://cli.github.com/

#### 2. "GitHub CLI authentication failed"
**Solution**: Run `gh auth login` and follow prompts

#### 3. "Cannot verify repository permissions"
**Solution**: Ensure you have admin access to the repository

#### 4. Branch protection setup fails
**Symptoms**: Script hangs or shows warnings about branch protection
**Solutions**:
1. **Check permissions**: You need admin access
2. **Manual setup**: Script provides fallback instructions
3. **Verify main branch exists**: Branch protection requires an existing branch

**Manual Fallback Instructions** (provided by script):
1. Go to Settings → Branches
2. Add rule for 'main' branch  
3. Enable: 'Require pull request reviews'
4. Enable: 'Require status checks to pass before merging'
5. Add status checks: `build-and-test`, `security-scan`, `version-check`
6. Enable: 'Require branches to be up to date before merging'

#### 5. Environment creation fails
**Solution**: Check repository permissions and try manual creation in Settings → Environments

### Debug Information
Add `-Verbose` flag for detailed logging:
```powershell
.\scripts\setup-repository.ps1 -Verbose
```

## 🔄 Re-running the Script

The script is **idempotent** - safe to run multiple times:
- Existing configurations are updated, not duplicated
- No harmful side effects from re-running
- Use for updating settings as requirements change

## 🚨 Important Notes

### What This Script Does NOT Do
- ❌ **Create repositories** - Repository must already exist
- ❌ **Manage secrets** - Secrets must be added manually
- ❌ **Configure deployments** - Deployment configuration is separate
- ❌ **Set up team permissions** - Team access must be configured separately

### Security Considerations
- **Admin permissions required**: Script needs full repository admin access
- **GitHub token used**: Uses your authenticated GitHub CLI session
- **API calls made**: Multiple GitHub API calls to configure settings
- **No secrets stored**: Script does not handle or store secrets

## 📚 Related Documentation

- **[Developer Guide](../docs/SETUP-SCRIPT-DEVELOPER.md)** - Technical implementation details
- **[Quick Start Guide](../QUICK-START.md)** - Overall pipeline setup
- **[Design Document](../DESIGN.md)** - Repository setup requirements

## 🆘 Getting Help

1. **Check the output**: Script provides detailed feedback on what failed
2. **Try dry run mode**: Use `-DryRun` to see what would be configured
3. **Manual setup**: Use the fallback instructions provided by the script
4. **Contact support**: Reach out to your DevOps team with script output

---

**Last Updated**: September 3, 2025  
**Script Version**: 2.0 (Enhanced with better error handling)
