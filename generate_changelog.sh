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

  # Create the CHANGELOG.md file and add each changelog section
  echo "# Changelog" > CHANGELOG.md
  echo >> CHANGELOG.md
  create_changelog_section "Features" "$features"
  create_changelog_section "Bug Fixes" "$fix"
  create_changelog_section "Documentation" "$docs"
  create_changelog_section "Styles" "$style"
  create_changelog_section "Code Refactoring" "$refactor"
  create_changelog_section "Performance Improvements" "$perf"
  create_changelog_section "Tests" "$test"
  create_changelog_section "Chores, Build, and CI" "$chore"
  create_changelog_section "Reverts" "$revert"

  # Commit the generated CHANGELOG.md file
  git add CHANGELOG.md
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"
  git commit -m "Generate Changelog [skip ci]"

  # Push the changes to the remote repository
  git push --quiet --set-upstream origin HEAD
fi

