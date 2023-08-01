#!/bin/bash

# Bump the specified segment of the version number
bump_version() {
    local version="$1"
    local segment="$2"

    IFS='.' read -ra parts <<< "$version"
    local major="${parts[0]}"
    local minor="${parts[1]}"
    local patch="${parts[2]}"

    if [[ "$segment" == "major" ]]; then
        ((major++))
        minor=0
        patch=0
    elif [[ "$segment" == "minor" ]]; then
        ((minor++))
        patch=0
    elif [[ "$segment" == "patch" ]]; then
        ((patch++))
    fi

    echo "$major.$minor.$patch"
}

# Update the first occurrence of the version number in the pyproject.toml file
update_version_in_file() {
    local new_version="$1"

    awk -v new_version="$new_version" '/version =/{ if (!found) { gsub(/"[^"]+"/, "\"" new_version "\""); found = 1 } } 1' pyproject.toml > temp.toml
    mv temp.toml pyproject.toml
}

if [[ $# -ne 1 ]]; then
    echo "Usage: ./bump_version.sh <patch|minor|major>"
    exit 1
fi

segment="$1"

current_version=$(grep -E -m 1 -o '(version = "[^"]+")' pyproject.toml | awk -F'"' '{print $2}')

if [[ -z "$current_version" ]]; then
    echo "Failed to find the version number in pyproject.toml"
    exit 1
fi

new_version=$(bump_version "$current_version" "$segment")

update_version_in_file "$new_version"

echo "Version bumped from $current_version to $new_version"

# Create a new tag
tag_name="v$new_version"
git commit -am "Bump version to $new_version"
git push origin
git tag "$tag_name"

# Push the new tag to the remote repository
git push origin "$tag_name"
