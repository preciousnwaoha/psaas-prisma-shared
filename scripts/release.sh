#!/bin/bash

#  First make file executable:
chmod +x scripts/release.sh

# Usage: ./scripts/release.sh patch "Your commit message"
VERSION_TYPE=$1
COMMIT_MESSAGE=$2

if [ -z "$VERSION_TYPE" ]; then
  echo "🚨 Please specify a version bump type: patch, minor, or major"
  exit 1
fi

if [ -z "$COMMIT_MESSAGE" ]; then
  echo "🚨 Please provide a commit message"
  exit 1
fi



echo "🔨 Building package..."
npm run build || exit 1

echo "⚙️ Running prepare (variant of prepublishOnly)..."
npm run prepare || exit 1

# Commit any pending work first
echo "📂 Committing build artifacts..."
git add .
git commit -m "$COMMIT_MESSAGE" || exit 1

echo "📦 Bumping version..."
npm version $VERSION_TYPE || exit 1

echo "🚀 Pushing commits and tags..."
git push --follow-tags || exit 1

# echo "📬 Publishing to GitHub Packages..."
# npm publish || exit 1

echo "✅ Release complete!"

# Example:
# ./scripts/release.sh patch "chore: bump version, build, generate Prisma client"