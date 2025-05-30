#!/bin/bash

# Set variables
RELEASE_BRANCH="release"
MAIN_BRANCH="main"
DEV_BRANCH="dev"
TAG_NAME="v$(date +%Y.%m.%d)"
TAG_MESSAGE="Release $TAG_NAME"
RELEASE_TITLE="Release $TAG_NAME"
RELEASE_BODY="Automated release created on $(date)"

# Pull latest from main and dev
git checkout $MAIN_BRANCH
git pull origin $MAIN_BRANCH
git checkout $DEV_BRANCH
git pull origin $DEV_BRANCH

# Create or update release branch
git checkout -B $RELEASE_BRANCH
git merge $DEV_BRANCH --no-edit

# Push release branch and tag
git push origin $RELEASE_BRANCH
git tag -a $TAG_NAME -m "$TAG_MESSAGE"
git push origin $TAG_NAME

# Create PR from release to main
gh pr create --base $MAIN_BRANCH --head $RELEASE_BRANCH --title "$RELEASE_TITLE" --body "$RELEASE_BODY"
echo "✅ Pull request created. Please approve and merge it in GitHub."
read -p "⏳ Press Enter once the PR is approved and merged..."

# Create GitHub release
gh release create $TAG_NAME --title "$RELEASE_TITLE" --notes "$RELEASE_BODY"
echo "🎉 Release $TAG_NAME created successfully!"

