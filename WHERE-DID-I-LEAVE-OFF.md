# 1 Nov 2025

created development-spec.md and got started.

Gone as far as "Pull Request Development Start". CoPilot created a lot of the getting started code.

Looks like creation of the release branch is manual but validated with an action and script 'version-management.ps1'. 

Can we create an action that creates the release branch with correct name?

I also ran the 'setup-repository.ps1' script: `.\setup-repository.ps1 github-action-testing ormico`
but then I checked the repository settings I noticed there were no branch rules for feature/*, bug/*, hotfix/*, or release/*. I thought there should be.

Check with Copilot and/or update DEVELOPMENT-SPEC.md
