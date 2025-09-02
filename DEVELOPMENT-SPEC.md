# Introduction

The goal of this task is to implement a comprehensive Build, Release, and Deployment framework on GitHub, using GitHub Actions and other processes where necessary and GitHub configurations and settings.

This task will be performed in phases.

Review the Preliminary Requirements and then begin the first phase documented after the Preliminary Requirements.

To complete each phase we may iterate or have targeted development.

After each phase or iteration, requirements may be clarified, changed, or added to. Do not alter the Preliminary Requirements section, instead create a REQUIREMENTS.md document to record the official requirements. This document can me modified by developers and CoPilot.

Record the current and completed phases so that Copilot knows where to pick up with each session. 



## Preliminary Requirements

### Preliminary Technical Requirements

1. All scripts should be written using PowerShell, not bash.
1. Any code needed other than PowerShell scripts should be written in c# and dotnet 8 if possible or whatever is most appropriate otherwise.
2. Final result should be a working example in this repository and template that can be used in other repositories and projects.
   1. This repository contains a simple Web application in the src folder named SimpleWeatherList. This application is implemented in dotnet 8 and also can be built as a docker container. 
   2. There is a Release Pipeline already started in the main1.yml that shows how to build the docker image and push it to the github container registry.
   3. main1.yml should be used as a starting point and example, but not as the desired final result.
3. If in order to satisfy our requirements, we need to configure a repository in a particular way such as certain branch rules and required checks then document the steps to be taken and why and write a script using the github cli or other tools.

### Preliminary Functional Requirements

1. Pull Request Builds:  Build application and run all Tests
   1. Because GitHub Pull Request Actions cannot perform a merge before building we would like to require branches to be up to date before merging branch protection
   2. Do we want to run just Unit Tests or also e2e and ui tests if applicable?
2. One Off Developer Triggered feature branch builds 
   1. Verify branch by performing same steps as Pull Request.
   2. Optionally, produce a Preview Release from a feature branch
   3. Preview Release should be identified by adding a version suffix such as "-previewNN" where NN should auto-incremented in some manner after each additional build. 
      1. The NN could start on 0 and auto-increment for each additional build per branch or some other method.
      2. If possible, it would be good for preview build to name their version suffix in such a way to avoid collision with preview releases from other branches. We would not want developers working in different branches to both produce preview branches versioned 1.0.11.0-preview00 for example.
3. All projects should use semantic versioning 2.0.0.
4. How should we handle incrementing version numbers? 
   1. Should versions be incremented on each PR? Manually by the developer? Can we perform a check on each PR to ensure that the version was updated? This would need to vary per target language or build environment.
   2. Semantic Versioning seems to only document 3 segment versions. Ex: 1.2.3 But, dotnet projects frequently use 4 segment versions. What do other languages and systems uses? 
   3. I would like to have a build version that auto-increments on each release, preview or production.
5. Handle a Release Train where:
   1. Changes are developed in feature branches with the naming scheme 'feature/{feature name}'. It's ok if feature branches include the Github issue number but is not required.
   2. Bugs can be fixed in bug branches but it is ok to also use a feature branch. The bug branch naming scheme is 'bug/{bug name}'. We should use the same PR GitHub Action and rules for bugs and features.
   3. Release - Create the Release Packages, Containers, or other Artifacts. Releases are triggered by creating a Release branch. The release branch naming scheme is 'release/{release id}'
   4. Creating an initial Release may also deploy changes to Developer testing environment. 
      1. This should be configurable. Not all repositories may require this, or may configure it later.
   5. Testing - Once a Release has been created it can be promoted to Testing.
      1. If a testing environment is configured, deploy artifacts to the testing environment and trigger integration, e2e, and/or ui testing.
         1. Running Tests should be in a separate action which is triggered from the Test Promotion Action so that tests can be re-run. We may even want to have a list of tests that could be re-run more granularly.
      2. A Release must pass all tests before it can be promoted to Testing.
   6. Staging - similar to Testing, artifacts are promoted and deployed to Staging environment and tests are run. 
      1. Testing and Staging are separately optional. Same test suite.
      2. The difference between Testing and Staging is that Testing is generally configured with a smaller but targeted data set and may be configured slightly differently that production such as using smaller servers. Staging is configured more closely or identically to Production and has a data set that is either much closer to production data and size or is a copy of production data. 
      3. Deploying to Staging is performed right before deploying to ensure that the Production Deployment is likely to not fail. A limited test suite may also run.
      4. Like Testing and Development Deploys, Stating can be optional if it isn't required for a particular repository.
      5. If Testing is configured, then Testing must be successful before Staging Deploy can be triggered.
   7. Production - Promote released packages to Production and Deploy to the Production environment.
         1. If Staging is configured, then Staging must be successful before Production Deploy can be triggered.
6. Release Branches - A Release branch is normally created from the main branch. This triggers the Release GitHub Action.
   1. How should release branches be created? Manually or through some process such as running a specific manual GitHub action or pressing a button on a Release Dashboard?
7. Hotfixes - If a bug fix needs to be added to a Release, then we want to create a hotfix branch off of the target Release branch. 
   1. Should the Hotfix merge back into the target Release branch or should we create a new release branch off of the target Release branch and merge the hotfix into that branch? 
   2. This process should be documented and enforced via GitHub Action or some other mechanism.
8. Release Branches Naming - How should we name release branches? I originally thought it should be the version number but I currently think that would be a bad idea. Perhaps Releases should simply increment, or be datetime based.
   1. How can we enforce release branch naming? Can we have a GitHub setting or GitHub action that enforces our naming requirement?
   2. 
9.  

### Documentation Requirements

1. Each phase will be documented both in development and use: Developer documentation and user documentation.
2. Document how terminology is uses such as Build, Release, Deployment or other jargon that could be confusing or mixed up or mean the same thing.
3. Write documentation using markdown.
4. Include diagrams if helpful.
5. Diagrams may also be written as PlantUml but it may present an issue in how to display the diagram.
6. Plain language is desired and helpful in understanding, but can be augmented with detailed technical discussion.
7. Document tools, languages, and services used.
8. When helpful, include links to official documentation such as Github, GitHub cli, GitHub Actions, git, dotnet, Docker, etc.
9. Requirements and documentation should correct terminology usage where this document or initial requirements used it incorrectly.

***

Extra:
* Can we clean up old preview releases to preserve free space in our package and container registry?
* Can we clean up old feature branches?
* Can we enforce removing feature branches from repo after PR merge?

# Design Phase

Analyze Preliminary Requirements.

Suggest improvements.

Suggest answers to questions that are posed.

Understand overall goals and respond if there are better ways to achieve some of the goals that what are documented in the preliminary requirements.

Organize requirements from preliminary into a requirements document.

From requirements document and this document, create a design document.

Suggest next phases in Design Document.

# Phase 1 Planning

Detailed planning for core build pipeline

* Q-001: Test Scope - Accept recommendation.
* Q-002: Version Increment Strategy - Accept recommendation. Plan implement validation.
* Q-003: Version Format - Accept recommendation.
* Q-004: Preview Version Collision Avoidance - Accept recommendation. Will this be injected automatically into build by Github Action? For example, as VersionSuffix?
* Q-005: Release Branch Creation - Accept recommendation.
* Q-006: Release Branch Naming - Accept recommendation.
* Q-007: Hotfix Merge Strategy - Accept recommendation.

# Repository Setup

Initial repository configuration.

We already have a repository (this one). Perform any other setup tasks for this repository.

# Pull Request Development Start

Implement Pull Request.
Include Version validation.
