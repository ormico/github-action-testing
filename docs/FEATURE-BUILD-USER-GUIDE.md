# Feature Branch Build - User Guide

## 🎯 Overview

The **Feature Branch Build** workflow allows developers to manually test and validate feature branches, with optional preview release creation for sharing with stakeholders.

## 🚀 Quick Start

### 1. Access the Workflow
1. Navigate to your repository's **Actions** tab
2. Click on **"Feature Branch Build"** in the workflow list
3. Click the **"Run workflow"** dropdown button

### 2. Configure Your Build
- **Branch**: Select your feature branch from the dropdown
- **Create preview release**: ☑️ Check if you want to create a shareable preview
- **Custom preview suffix**: Optional - provide a custom name for your preview

### 3. Run the Build
Click **"Run workflow"** to start the process.

## 📋 Use Cases

### Scenario 1: Quick Validation ⚡
**When**: You want to verify your feature branch builds and tests pass
**How**: 
1. Select your branch
2. Leave "Create preview release" **unchecked**
3. Run workflow

**Result**: Build and test validation only, no artifacts created

### Scenario 2: Preview for Testing 🔍
**When**: You want to share your feature with QA team or stakeholders
**How**:
1. Select your branch  
2. **Check** "Create preview release"
3. Optionally provide a custom suffix (e.g., "user-auth-v2")
4. Run workflow

**Result**: 
- Full build, test, and security scan
- Docker image available for testing
- Preview artifacts ready for deployment

### Scenario 3: Integration Testing 🧪
**When**: You need to test your feature in a containerized environment
**How**:
1. Create a preview release (Scenario 2)
2. Use the generated Docker image:
```bash
# Pull the preview image
docker pull ghcr.io/your-org/simpleweatherlist.web:1.2.3-preview-abc123-15

# Run for testing
docker run -p 8080:80 ghcr.io/your-org/simpleweatherlist.web:1.2.3-preview-abc123-15
```

## 🏷️ Version Naming

### Preview Versions
When you create a preview release, versions are automatically generated:

**Auto-generated format**: `{base-version}-preview-{branch-hash}-{build-number}`
- **Example**: `1.2.3-preview-a1b2c3d4-15`
- **Base version**: From your `version.json` file (1.2.3)
- **Branch hash**: 8 characters from your branch name (a1b2c3d4)
- **Build number**: GitHub Actions run number (15)

**Custom format**: `{base-version}-{your-suffix}-{build-number}`
- **Example**: `1.2.3-user-auth-v2-15` (if you entered "user-auth-v2")

## 📦 What You Get

### All Builds
- ✅ **Build verification** - Confirms your code compiles
- ✅ **Test results** - Unit test execution and reporting
- ✅ **Build summary** - Detailed results in Actions tab

### Preview Releases Only
- ✅ **Docker image** - Ready-to-deploy container
- ✅ **Build artifacts** - Compiled application files
- ✅ **Security scan** - Vulnerability assessment
- ✅ **Image manifest** - Metadata about your build

## 🔍 Monitoring Your Build

### 1. Real-time Progress
- Watch the workflow execution in the Actions tab
- Each step shows progress and logs
- Green ✅ = success, Red ❌ = failure

### 2. Build Summary
After completion, check the workflow summary for:
- Overall build status
- Test results
- Preview release information (if created)
- Docker image details

### 3. Artifacts Location
- **Docker images**: GitHub Container Registry (`ghcr.io`)
- **Build artifacts**: Available in Actions → Artifacts section
- **Test results**: Displayed in workflow summary

## ⚠️ Important Notes

### Retention Periods
- **Build artifacts**: 30 days
- **Docker images**: Available until manually cleaned
- **Image manifests**: 90 days

### No Automatic Deployment
- Preview releases are **not automatically deployed**
- Use generated Docker images for manual testing
- Deployment must be done separately

### Branch Protection
- This workflow **does not affect** branch protection rules
- It's for testing only, not for merging to main
- Create a PR to main when ready for formal review

## 🛠️ Troubleshooting

### Build Fails
1. **Check the logs** in the failed workflow step
2. **Common issues**:
   - Compilation errors in your code
   - Failing unit tests
   - Missing dependencies

### Preview Creation Fails
1. **Docker build issues**: Check for Dockerfile problems
2. **Registry permissions**: Ensure GitHub Container Registry access
3. **Security scan failures**: Review dependency vulnerabilities

### Can't Find Your Branch
- Ensure your branch is **pushed to GitHub**
- Branch dropdown only shows **remote branches**
- Refresh the page if you just pushed

## 💡 Tips

### Best Practices
- **Use meaningful branch names** for easier identification
- **Run preview builds before creating PRs** to catch issues early
- **Share preview images with QA** for early feedback
- **Clean up old previews** to save storage space

### Custom Suffixes
Use descriptive custom suffixes for better organization:
- `api-changes` for API modifications
- `ui-redesign` for interface updates  
- `bug-fix-123` for specific bug fixes

## 🔗 Next Steps

After your feature build succeeds:
1. **Test your preview** (if created)
2. **Address any issues** found
3. **Create a Pull Request** to main branch for formal review
4. **Use PR Build workflow** for integration testing

---

**Need help?** Check the [Developer Guide](FEATURE-BUILD-DEVELOPER.md) for technical details or contact your DevOps team.
