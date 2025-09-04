# Official Requirements Document

This document contains the official requirements for the Build, Release, and Deployment framework implementation. This document can be modified by developers and Copilot as requirements are clarified, changed, or added.

## Technical Requirements

### TR-001: Scripting and Code Standards
- All scripts must be written using PowerShell (not bash)
- Additional code should be written in C# and .NET 8 when possible, or the most appropriate technology otherwise
- Final result should provide a working example in this repository and serve as a template for other repositories

### TR-002: Repository Structure
- Repository contains SimpleWeatherList web application in `src` folder
- Application is implemented in .NET 8 with Docker container support
- Existing `main1.yml` workflow serves as starting point but not final result

### TR-003: Repository Configuration
- Document and script repository configuration requirements (branch rules, required checks)
- Use GitHub CLI or other tools for automation
- Provide setup scripts and documentation

## Functional Requirements

### FR-001: Pull Request Builds
- **Primary**: Build application and run all tests on Pull Requests
- **Branch Protection**: Require branches to be up to date before merging (GitHub PR Actions cannot perform merge before building)
- **Test Scope**: Run Unit Tests (UI/E2E tests scope to be determined based on application needs)

### FR-002: Developer-Triggered Feature Branch Builds
- **Verification**: Perform same steps as Pull Request builds
- **Preview Releases**: Optional production of preview releases from feature branches
- **Versioning**: Preview releases use version suffix `-previewNN` where NN auto-increments
- **Collision Avoidance**: Preview build versioning should avoid collisions between different branches

### FR-003: Semantic Versioning
- All projects must use Semantic Versioning 2.0.0
- **Version Segments**: Support both 3-segment (1.2.3) and 4-segment (1.2.3.4) versions as appropriate for target platform
- **Auto-increment**: Build version auto-increments on each release (preview or production)
- **Version Management**: Define strategy for version increment triggers (per PR, manual, or automated checks)

### FR-004: Release Train Process
- **Feature Branches**: `feature/{feature-name}` naming scheme (GitHub issue numbers optional)
- **Bug Branches**: `bug/{bug-name}` naming scheme (can use feature branch workflow)
- **Release Branches**: `release/{release-id}` naming scheme triggers release creation
- **Unified Workflow**: Same PR GitHub Action and rules for bugs and features

### FR-005: Environment Deployment Pipeline
1. **Development Environment**: 
   - Optional deployment triggered by release branch creation
   - Configurable per repository

2. **Testing Environment**:
   - Release promotion triggers deployment and test execution
   - Separate test action for re-runnable, granular testing
   - Must pass all tests before promotion to next stage
   - Optional per repository

3. **Staging Environment**:
   - Similar to Testing but with production-like configuration and data
   - Optional if Testing is not configured
   - Testing must succeed before Staging deployment (if both configured)
   - Limited test suite execution

4. **Production Environment**:
   - Final promotion and deployment
   - Staging must succeed before Production deployment (if Staging configured)

### FR-006: Release Management
- **Release Branch Naming**: Increment-based or datetime-based (not version-based)
- **Naming Enforcement**: A manually executed GitHub Action will create the release branch according to our naming and other criteria. 

### FR-007: Hotfix Process
- **Hotfix Branches**: Created from target Release branch for bug fixes
- **Merge Strategy**: Define whether hotfix merges back to Release branch or creates new release branch
- **Process Enforcement**: Document and enforce via GitHub Actions

### FR-008: Testing Environment Process
- **Unit Test Execution**: Unit Tests should run in PR builds. 
- **Integration Test Execution**: E2E, UI, and Integration tests should run in Testing environment due to longer execution time and infrastructure requirements.

### FR-009: Version Increment Process
- **Manual Version Increment**: Require manual version increment in PRs. 
- **Automated Version Increment Check**: Automated validation on PR build that version was updated appropriately.

### FR-010: Version Format
- **4-segment**: Use 4-segment versioning (Major.Minor.Patch.Build) where Build auto-increments, aligning with .NET conventions. 

### FR-011: Preview Version Collision Avoidance
**Preview Branch Suffix**: Avoid preview version collisions between branches by including branch identifier in preview suffix: `-preview-{branch-hash}-{increment}`

### FR-012: Release Branch Naming
- **Date-based naming**: Date-based naming: `release/YYYY-MM-DD-{increment}` for traceability and sorting.

### FR-013: Hotfix Merge Strategy
- **Release Branch**: Create new release branch from hotfix for clean release history and proper versioning.

## Documentation Requirements

### DR-001: Phase Documentation
- Each development phase documented for both developers and users
- Development documentation and user documentation

### DR-002: Terminology and Standards
- Define and document terminology (Build, Release, Deployment, etc.)
- Correct any terminology misuse from preliminary requirements
- Use markdown format for all documentation

### DR-003: Visual Documentation
- Include diagrams when helpful
- Support PlantUML diagrams (address display considerations)
- Use plain language with technical detail augmentation

### DR-004: Reference Documentation
- Document all tools, languages, and services used
- Include links to official documentation (GitHub, GitHub CLI, GitHub Actions, Git, .NET, Docker, etc.)

## Open Questions and Decisions Needed

### Q-001: Test Scope
**Question**: Should PR builds run just Unit Tests or also E2E and UI tests?
**Recommendation**: Start with Unit Tests for PR builds. E2E/UI tests should run in Testing environment due to longer execution time and infrastructure requirements.

### Q-002: Version Increment Strategy
**Question**: Should versions increment on each PR, manually, or with automated checks?
**Recommendation**: Hybrid approach - require manual version increment with automated validation on PR that version was updated appropriately.

### Q-003: Version Format
**Question**: 3-segment vs 4-segment versioning?
**Recommendation**: Use 4-segment versioning (Major.Minor.Patch.Build) where Build auto-increments, aligning with .NET conventions.

**MODIFIED** 3 Aug 2025
Accept recommendation.

### Q-004: Preview Version Collision Avoidance
**Question**: How to avoid preview version collisions between branches?
**Recommendation**: Include branch identifier in preview suffix: `-preview-{branch-hash}-{increment}`

### Q-005: Release Branch Creation
**Question**: Manual or automated release branch creation?
**Recommendation**: Manual trigger through GitHub Actions workflow_dispatch with validation.

### Q-006: Release Branch Naming
**Question**: How to name release branches?
**Recommendation**: Date-based naming: `release/YYYY-MM-DD-{increment}` for traceability and sorting.

### Q-007: Hotfix Merge Strategy
**Question**: Hotfix merge back to Release branch or create new release branch?
**Recommendation**: Create new release branch from hotfix for clean release history and proper versioning.

## Enhancement Opportunities

### E-001: Cleanup Automation
- Automated cleanup of old preview releases to preserve registry space
- Automated cleanup of old feature branches
- Enforce feature branch removal after PR merge

### E-002: Release Dashboard
- Consider implementing release dashboard for release management
- Provide visibility into release pipeline status

### E-003: Advanced Testing
- Granular test re-execution capabilities
- Test result reporting and history

## Current Phase Status

**Current Phase**: Design Phase
**Completed Phases**: None
**Next Phase**: Implementation Phase 1 (to be defined in Design Document)
