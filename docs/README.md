# Documentation Index

This directory contains comprehensive documentation for the GitHub Actions CI/CD pipeline.

## 📚 Documentation Categories

### 👥 User Documentation
Documentation for developers using the CI/CD pipeline:

- **[Feature Build User Guide](FEATURE-BUILD-USER-GUIDE.md)** - How to use the feature branch build workflow
- **[Setup Script User Guide](SETUP-SCRIPT-USER-GUIDE.md)** - How to configure repository settings
- **[Quick Start Guide](../QUICK-START.md)** - Getting started with the CI/CD pipeline
- **[Hotfix Process Guide](../HOTFIX-PROCESS.md)** - Step-by-step hotfix workflow

### 🔧 Developer Documentation  
Technical documentation for maintaining and extending the pipeline:

- **[Feature Build Developer Guide](FEATURE-BUILD-DEVELOPER.md)** - Technical implementation of feature builds
- **[Setup Script Developer Guide](SETUP-SCRIPT-DEVELOPER.md)** - Technical implementation of repository setup
- **[Script Organization](SCRIPT-ORGANIZATION.md)** - Best practices for script organization and locations
- **[Design Document](../DESIGN.md)** - Overall system architecture and design decisions
- **[Phase Tracking](../PHASE-TRACKING.md)** - Development progress and completed phases

### 📋 Requirements and Specifications
- **[Requirements](../REQUIREMENTS.md)** - Functional and non-functional requirements
- **[Development Specification](../DEVELOPMENT-SPEC.md)** - Detailed development requirements

## 🎯 Quick Navigation

### I want to...

**Use the CI/CD pipeline** → Start with [Quick Start Guide](../QUICK-START.md)

**Run a feature build** → Read [Feature Build User Guide](FEATURE-BUILD-USER-GUIDE.md)

**Set up repository** → Follow [Setup Script User Guide](SETUP-SCRIPT-USER-GUIDE.md)

**Create a hotfix** → Follow [Hotfix Process Guide](../HOTFIX-PROCESS.md)

**Understand the architecture** → Review [Design Document](../DESIGN.md)

**Modify a workflow** → Check the relevant developer guide:
- Feature builds: [Feature Build Developer Guide](FEATURE-BUILD-DEVELOPER.md)
- Repository setup: [Setup Script Developer Guide](SETUP-SCRIPT-DEVELOPER.md)

**Set up a new repository** → Run `scripts/setup-repository.ps1` (see [Setup Guide](SETUP-SCRIPT-USER-GUIDE.md))

## 📖 Documentation Standards

### User Guides
- **Audience**: Developers using the pipeline
- **Focus**: How to accomplish tasks
- **Format**: Step-by-step instructions with examples
- **Tone**: Clear, practical, action-oriented

### Developer Guides  
- **Audience**: DevOps engineers and workflow maintainers
- **Focus**: Technical implementation and architecture
- **Format**: Technical explanations with code examples
- **Tone**: Detailed, precise, comprehensive

### Maintenance
- **Update frequency**: When workflows change
- **Review cycle**: Quarterly for accuracy
- **Version control**: All changes tracked in git

## 🔄 Contributing to Documentation

### Adding New Documentation
1. **Choose the right category** (User vs Developer)
2. **Follow naming convention**: `WORKFLOW-NAME-TYPE.md`
3. **Update this index** to include the new document
4. **Cross-reference** from other relevant documents

### Updating Existing Documentation
1. **Keep user guides current** with workflow changes
2. **Update developer guides** when implementation changes
3. **Maintain cross-references** between related documents
4. **Test instructions** to ensure they work

### Documentation Review Process
1. **Technical accuracy**: Verify all instructions work
2. **Clarity**: Ensure explanations are understandable
3. **Completeness**: Check all scenarios are covered
4. **Consistency**: Maintain consistent style and format

---

**Need help with documentation?** Contact the DevOps team or create an issue.
