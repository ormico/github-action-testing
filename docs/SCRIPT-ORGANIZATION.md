# Script Organization and Best Practices

## 📁 Current Script Structure

```
├── scripts/                    # User-facing scripts
│   └── setup-repository.ps1   # Repository configuration (manual execution)
└── .github/scripts/            # CI/CD workflow scripts  
    └── version-management.ps1  # Used by GitHub Actions workflows
```

## 🎯 Folder Strategy Rationale

### Why Two Script Folders?

#### `scripts/` (Repository Root)
**Purpose**: User-facing scripts that developers run manually
- ✅ **Easy Discovery**: Located at repository root for visibility
- ✅ **User Access**: Not buried in `.github` folder structure
- ✅ **Security**: No special permissions needed
- ✅ **Documentation**: Clear separation of user vs. system scripts

**Contains**:
- `setup-repository.ps1` - Repository configuration script
- Future utility scripts for developers

#### `.github/scripts/` (GitHub Folder)
**Purpose**: Scripts used by GitHub Actions workflows only
- ✅ **Co-location**: Near the workflows that use them
- ✅ **GitHub Convention**: Standard practice in GitHub Actions community
- ✅ **Security**: `.github/` folder has special permissions in GitHub
- ✅ **Workflow Integration**: Clear which scripts are for CI/CD

**Contains**:
- `version-management.ps1` - Used by multiple workflows for versioning

## 🔍 Best Practice Analysis

### Industry Standards

#### GitHub Actions Community Practice
```
✅ RECOMMENDED: Keep workflow scripts in .github/scripts/
❌ NOT RECOMMENDED: Move workflow scripts to root level
```

**Reasoning**:
1. **Security**: `.github/` folder has restricted write access
2. **Convention**: Expected location by GitHub Actions community
3. **Organization**: Clear separation of CI/CD vs. user scripts
4. **Tool Support**: GitHub tools expect scripts in `.github/scripts/`

#### Repository Organization Best Practices
```
✅ RECOMMENDED: User scripts in /scripts/ folder
✅ RECOMMENDED: CI/CD scripts in /.github/scripts/ folder
❌ NOT RECOMMENDED: All scripts in one location
```

## 📋 Script Usage Mapping

### User Scripts (`scripts/`)
| Script | Purpose | Executed By | Frequency |
|--------|---------|-------------|-----------|
| `setup-repository.ps1` | Repository setup | Developers (manual) | Once per repository |

### Workflow Scripts (`.github/scripts/`)
| Script | Purpose | Used By Workflows | Frequency |
|--------|---------|-------------------|-----------|
| `version-management.ps1` | Version operations | `pr-build.yml`, `feature-build.yml`, `release-create.yml` | Every workflow run |

## 🔧 Implementation Details

### Current Workflow References
The following workflows reference `.github/scripts/version-management.ps1`:

#### 1. PR Build Workflow (`pr-build.yml`)
```yaml
# Lines 126 and 249
./.github/scripts/version-management.ps1 -Action get-build -BuildNumber ${{ github.run_number }}
```

#### 2. Feature Build Workflow (`feature-build.yml`)
```yaml
# Line 53
./.github/scripts/version-management.ps1 -Action get-build -BuildNumber ${{ github.run_number }}

# Line 66  
./.github/scripts/version-management.ps1 -Action set-preview -PreviewSuffix $previewSuffix -BuildNumber ${{ github.run_number }}
```

#### 3. Release Create Workflow (`release-create.yml`)
```yaml
# Line 78
./.github/scripts/version-management.ps1 -Action get-build -BuildNumber ${{ github.run_number }}
```

### Why We Keep These References
- **No need to change**: Current paths work correctly
- **Follow convention**: Industry standard practice
- **Security**: Scripts used by workflows should be in `.github/scripts/`
- **Maintenance**: Easier to maintain when co-located with workflows

## 📚 Documentation Strategy

### Script Documentation Organization

#### User-Facing Scripts
- **Location**: `docs/SCRIPT-NAME-USER-GUIDE.md`
- **Audience**: Developers using the scripts
- **Content**: How to use, examples, troubleshooting

#### Workflow Scripts (Developer Documentation)
- **Location**: `docs/SCRIPT-NAME-DEVELOPER.md`
- **Audience**: DevOps engineers maintaining workflows
- **Content**: Technical implementation, integration points

### Current Documentation
| Script | User Guide | Developer Guide |
|--------|------------|-----------------|
| `setup-repository.ps1` | ✅ `docs/SETUP-SCRIPT-USER-GUIDE.md` | ✅ `docs/SETUP-SCRIPT-DEVELOPER.md` |
| `version-management.ps1` | ⏳ Future | ⏳ Future |

## 🔄 Migration Considerations

### What We Changed
1. **Moved `setup-repository.ps1`**: From root → `scripts/setup-repository.ps1`
2. **Updated all references**: In documentation files
3. **Created comprehensive documentation**: User and developer guides

### What We Kept
1. **`version-management.ps1`**: Remains in `.github/scripts/`
2. **Workflow references**: No changes needed to workflow files
3. **Existing functionality**: All workflows continue to work

### Future Additions

#### New User Scripts (goes in `scripts/`)
- Database migration utilities
- Environment setup helpers
- Testing utilities

#### New Workflow Scripts (goes in `.github/scripts/`)
- Deployment helpers
- Notification scripts
- Cleanup utilities

## ✅ Verification

### Script Locations Verified
```powershell
# User scripts
Test-Path "scripts/setup-repository.ps1"  # ✅ True

# Workflow scripts  
Test-Path ".github/scripts/version-management.ps1"  # ✅ True
```

### Workflow References Verified
```bash
# All workflows still reference correct paths
grep -r "\.github/scripts/version-management\.ps1" .github/workflows/
# ✅ Returns 4 matches in 3 workflow files
```

### Documentation Updated
- ✅ All script path references updated
- ✅ New comprehensive documentation created
- ✅ Documentation index includes all guides

## 🚨 Important Notes

### For Future Script Additions

#### Ask Yourself:
1. **Who executes this script?**
   - Developers manually → `scripts/`
   - GitHub Actions → `.github/scripts/`

2. **What's the purpose?**
   - Repository setup/utilities → `scripts/`
   - Workflow automation → `.github/scripts/`

3. **How often is it used?**
   - Occasionally by humans → `scripts/`
   - Frequently by automation → `.github/scripts/`

### Migration Rules
- ✅ **DO**: Keep workflow scripts in `.github/scripts/`
- ✅ **DO**: Put user scripts in `scripts/`
- ❌ **DON'T**: Move workflow scripts to root level
- ❌ **DON'T**: Mix user and workflow scripts

## 📖 Related Documentation

- **[Setup Script User Guide](SETUP-SCRIPT-USER-GUIDE.md)** - How to use setup script
- **[Setup Script Developer Guide](SETUP-SCRIPT-DEVELOPER.md)** - Technical implementation
- **[Feature Build Developer Guide](FEATURE-BUILD-DEVELOPER.md)** - Workflow script usage examples

---

**Established**: September 3, 2025  
**Purpose**: Document script organization decisions and best practices  
**Review**: When adding new scripts to the repository
