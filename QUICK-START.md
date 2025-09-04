# 🚀 Quick Start Guide

This guide will help you get the CI/CD pipeline up and running in 15 minutes.

## ⚡ Quick Setup (5 minutes)

### 1. Prerequisites Check
Ensure you have:
- [x] GitHub repository with Actions enabled
- [x] Admin access to the repository
- [x] GitHub CLI installed (optional, for automated setup)

### 2. Copy CI/CD Files
Copy the entire `.github` folder to your repository root:
```
your-repo/
├── .github/
│   ├── workflows/
│   ├── scripts/
│   └── README.md
├── version.json
└── your-project-files...
```

### 3. Update Version File
Edit `version.json` to match your project's current version:
```json
{
  "version": "1.0.0",
  "build": 0,
  "prerelease": "",
  "metadata": "",
  "updated": "2025-09-02T00:00:00Z",
  "updatedBy": "initial-setup"
}
```

## 🔧 Repository Configuration (5 minutes)

### Option A: Automated Setup (Recommended)
```powershell
# Run from repository root (Windows/PowerShell)
.\scripts\setup-repository.ps1

# Or for dry run first:
.\scripts\setup-repository.ps1 -DryRun
```

### Option B: Manual Setup
1. **Enable GitHub Actions**: Repository Settings → Actions → Allow all actions
2. **Configure branch protection** for `main`:
   - Require PR before merging
   - Require status checks: `build-and-test`, `security-scan`, `version-check`
   - Require branches to be up to date
3. **Create environments**: `development`, `testing`, `staging`, `production`

## 🧪 Test the Pipeline (5 minutes)

### 1. Test PR Build
```bash
# Create a test feature branch
git checkout -b feature/test-pipeline

# Make a small change and increment version
# Edit version.json: change "1.0.0" to "1.0.1"

# Commit and push
git add .
git commit -m "Test CI/CD pipeline"
git push origin feature/test-pipeline

# Create PR to main branch
# Watch the PR build workflow run automatically ✅
```

### 2. Test Feature Build
```bash
# Go to Actions tab in GitHub
# Click "Feature Branch Build" workflow
# Click "Run workflow"
# Select your feature branch
# Check "Create preview release"
# Click "Run workflow"
# Watch preview release get created ✅
```

### 3. Test Release Creation
```bash
# Create a release branch
git checkout main
git checkout -b release/2025-09-02-01
git push origin release/2025-09-02-01

# Watch release workflow run automatically
# GitHub release will be created ✅
# Docker images will be pushed ✅
```

## ✅ Verification Checklist

After setup, verify these work:
- [ ] PR to main triggers build and version validation
- [ ] Feature branch manual build creates preview release
- [ ] Release branch creates GitHub release and Docker images
- [ ] Branch protection prevents direct pushes to main
- [ ] Test results appear in PR comments

## 🎯 Next Steps

### For .NET Projects (Most Common)
The pipeline is ready to use! The default configuration works with:
- .NET 8 applications
- Standard project structure with `.sln` file in `src/` folder
- Unit tests using `dotnet test`

### For Other Project Types
Customize these files:
1. **Update build commands** in workflows:
   - `pr-build.yml` lines 143-150 (build commands)
   - `feature-build.yml` lines 80-88 (build commands)
   - `release-create.yml` lines 95-103 (build commands)

2. **Update test commands** in workflows:
   - `pr-build.yml` lines 152-159 (test commands)
   - `test-runner.yml` lines 54-65 (test commands)

3. **Update project paths** if different from `src/SimpleWeatherList.sln`

## 🔍 Common Issues

### Issue: "Action not found" errors
**Solution**: The lint errors you see are normal in VS Code. Actions will work when running in GitHub.

### Issue: Version validation fails
**Solution**: Ensure you increment the version in `version.json` for PRs to main:
- Bug fix: `1.0.0` → `1.0.1` (patch)
- New feature: `1.0.0` → `1.1.0` (minor) 
- Breaking change: `1.0.0` → `2.0.0` (major)

### Issue: Container registry permissions
**Solution**: GitHub Container Registry permissions are configured automatically. Ensure `GITHUB_TOKEN` has package write permissions.

### Issue: Branch protection not working
**Solution**: Run the setup script or manually configure branch protection rules in repository settings.

## 🎉 You're Ready!

Your CI/CD pipeline is now configured! Here's what you get:

- ✅ **Automated PR validation** with test results
- ✅ **Preview releases** for feature testing  
- ✅ **Automated releases** with Docker images
- ✅ **Version management** with validation
- ✅ **Security scanning** and code quality checks
- ✅ **Automated cleanup** of old artifacts

## 📞 Need Help?

- Check the [full documentation](.github/README.md)
- Review the [requirements](../REQUIREMENTS.md) and [design](../DESIGN.md) documents
- Look at workflow run logs in the Actions tab
- Check the [phase tracking](../PHASE-TRACKING.md) for implementation status

Happy coding! 🚀
