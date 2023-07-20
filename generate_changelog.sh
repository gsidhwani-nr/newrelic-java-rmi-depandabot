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
  changelog=$(git log --pretty=format:"-%s (%h)" "$previous_tag"..HEAD)
  echo "LOG=$changelog" >> $GITHUB_ENV

  # Create separate changelog sections based on commit types (assuming conventional commit messages)
  features=$(echo "$changelog" | grep -E '^-( feat|feature)(\(.+\))?:' | sed 's/^-\s/- /')
  fix=$(echo "$changelog" | grep -E '^-( fix)(\(.+\))?:' | sed 's/^-\s/- /')
  docs=$(echo "$changelog" | grep -E '^-( docs|doc)(\(.+\))?:' | sed 's/^-\s/- /')
  style=$(echo "$changelog" | grep -E '^-( style)(\(.+\))?:' | sed 's/^-\s/- /')
  refactor=$(echo "$changelog" | grep -E '^-( refactor)(\(.+\))?:' | sed 's/^-\s/- /')
  perf=$(echo "$changelog" | grep -E '^-( perf)(\(.+\))?:' | sed 's/^-\s/- /')
  test=$(echo "$changelog" | grep -E '^-( test)(\(.+\))?:' | sed 's/^-\s/- /')
  chore=$(echo "$changelog" | grep -E '^-( chore|build|ci)(\(.+\))?:' | sed 's/^-\s/- /')
  revert=$(echo "$changelog" | grep -E '^-( revert)(\(.+\))?:' | sed 's/^-\s/- /')

  # Add header and each changelog section to the CHANGELOG.md file
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
fi

