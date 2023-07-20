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

  # Get the current date in YYYY-MM-DD format
  release_date=$(date +"%Y-%m-%d")

  # Create the release notes for the current release
  release_notes="## $GITHUB_RUN_NUMBER ($release_date)\n\n"
  release_notes+=$(create_changelog_section "Features" "$(echo "$changelog" | grep -E '^-( feat|feature)')")
  release_notes+=$(create_changelog_section "Bug Fixes" "$(echo "$changelog" | grep -E '^-( fix)')")
  release_notes+=$(create_changelog_section "Documentation" "$(echo "$changelog" | grep -E '^-( docs|doc)')")
  release_notes+=$(create_changelog_section "Styles" "$(echo "$changelog" | grep -E '^-( style)')")
  release_notes+=$(create_changelog_section "Code Refactoring" "$(echo "$changelog" | grep -E '^-( refactor)')")
  release_notes+=$(create_changelog_section "Performance Improvements" "$(echo "$changelog" | grep -E '^-( perf)')")
  release_notes+=$(create_changelog_section "Tests" "$(echo "$changelog" | grep -E '^-( test)')")
  release_notes+=$(create_changelog_section "Chores, Build, and CI" "$(echo "$changelog" | grep -E '^-( chore|build|ci)')")
  release_notes+=$(create_changelog_section "Reverts" "$(echo "$changelog" | grep -E '^-( revert)')")

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

