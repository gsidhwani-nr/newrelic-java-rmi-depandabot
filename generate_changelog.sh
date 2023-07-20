#!/bin/bash

# Function to create changelog sections for different commit types
create_changelog_section() {
  local section_title="$1"
  local commits="$2"
  if [[ -n "$commits" ]]; then
    echo "$section_title" >> _CHANGELOG.md
    echo >> _CHANGELOG.md
    echo "$commits" >> _CHANGELOG.md
    echo >> _CHANGELOG.md
  fi
}

echo "Generating changelog..."
previous_tag=$(git describe --abbrev=0 --tags 2>/dev/null) || true
echo $previous_tag

# Get the current date in YYYY-MM-DD format
release_date=$(date +"%Y-%m-%d")
echo $release_date

# Create the release notes for the current release
release_notes="## Release Notes:\n\n## $RELEASE_VERSION($release_date)\n\n"
echo "Generating changelog..2."
echo $release_notes

if [[ -n "$previous_tag" ]]; then
  # Pull the latest changes from the remote repository
  git pull origin main

  # Use awk to filter commit messages by type and format them
  changelog=$(git log --pretty=format:"-%s (%h)" "$previous_tag"..HEAD |
    awk '/^-( feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\(.+\))?:/ {gsub(/^-/, ""); print}')
echo "Generating changelog..3."
  echo $changelog

  # Accumulate the changes for the current release
  release_notes+=$(create_changelog_section "### Features" "$(echo "$changelog" | grep -E '^feat')")
  release_notes+=$(create_changelog_section "### Fixes" "$(echo "$changelog" | grep -E '^fix')")
  echo "Generating changelog..4."
  echo $release_notes
  release_notes+=$(create_changelog_section "### Documentation" "$(echo "$changelog" | grep -E '^docs')")
fi
echo "Generating changelog..4."
  echo $release_notes


# Update the existing CHANGELOG.md file with the new release notes
echo -e "$release_notes\n$(cat _CHANGELOG.md)" > _CHANGELOG.md 
cp _CHANGELOG.md _BODY.md
echo -e $(cat CHANGELOG.md)>>_CHANGELOG.md
echo -e $(cat _CHANGELOG.md)>CHANGELOG.md 

# Commit the updated CHANGELOG.md file
 git add CHANGELOG.md
 git config --local user.email "action@github.com"
 git config --local user.name "GitHub Action"
 git commit -m "Update Changelog for Release [skip ci]"

# Push the changes to the remote repository
 git push --quiet --set-upstream origin HEAD

