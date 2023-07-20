#!/bin/bash

# Function to create changelog sections for different commit types
create_changelog_section() {
  local section_title="$1"
  local commits="$2"
  if [[ -n "$commits" ]]; then
    echo "### $section_title" >> CHANGELOG.md
    echo >> CHANGELOG.md
    echo "$commits" >> CHANGELOG.md
    echo >> CHANGELOG.md
  fi
}

echo "Generating changelog..."
previous_tag=$(git describe --abbrev=0 --tags 2>/dev/null) || true

if [[ -n "$previous_tag" ]]; then
  # Pull the latest changes from the remote repository
  git pull origin main

  # Use awk to filter commit messages by type and format them
  changelog=$(git log --pretty=format:"-%s (%h)" "$previous_tag"..HEAD |
    awk '/^-[[:space:]]*(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\(.+\))?:/ {gsub(/^-/, "- "); print}')

  # Create separate changelog sections based on commit types (assuming conventional commit messages)
  features=$(echo "$changelog" | grep -E '^-( feat|feature)')
  fix=$(echo "$changelog" | grep -E '^-( fix)')
  docs=$(echo "$changelog" | grep -E '^-( docs|doc)')
  style=$(echo "$changelog" | grep -E '^-( style)')
  refactor=$(echo "$changelog" | grep -E '^-( refactor)')
  perf=$(echo "$changelog" | grep -E '^-( perf)')
  test=$(echo "$changelog" | grep -E '^-( test)')
  chore=$(echo "$changelog" | grep -E '^-( chore|build|ci)')
  revert=$(echo "$changelog" | grep -E '^-( revert)')

  # Create the release notes for the current release
  release_notes="# Release Notes - Version $GITHUB_RUN_NUMBER"  # Using the GitHub Run Number as the release number

  # Add each changelog section to the release notes
  release_notes+=$(create_changelog_section "Features" "$features")
  release_notes+=$(create_changelog_section "Bug Fixes" "$fix")
  release_notes+=$(create_changelog_section "Documentation" "$docs")
  release_notes+=$(create_changelog_section "Styles" "$style")
  release_notes+=$(create_changelog_section "Code Refactoring" "$refactor")
  release_notes+=$(create_changelog_section "Performance Improvements" "$perf")
  release_notes+=$(create_changelog_section "Tests" "$test")
  release_notes+=$(create_changelog_section "Chores, Build, and CI" "$chore")
  release_notes+=$(create_changelog_section "Reverts" "$revert")

  # Update the existing CHANGELOG.md file with the new release notes
  echo -e "$release_notes\n$(cat CHANGELOG.md)" > CHANGELOG.md

  # Commit the updated CHANGELOG.md file
  git add CHANGELOG.md
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"
  git commit -m "Update Changelog for Release [skip ci]"

  # Push the changes to the remote repository
  git push --quiet --set-upstream origin HEAD
fi

