#!/bin/bash

# !!!NOTICE!!
# Personal token with full access rights is required to run this scripts
# Once you got persona token, set enviroment variable GH_TOKEN with it

####################################################
#               INPUTS FROM USER                   #
####################################################
github_username="ikameglobal"

read -p "Enter package name: " package_name
# If package name is not provided, warn user and exit
if [ -z "$package_name" ]; then
    echo "Package name is required"
    exit 1
fi
# Check if package name is available on pypi
package_name_available=$(curl -s https://pypi.org/project/$package_name/)
if [[ $package_name_available == *"Page Not Found"* ]]; then
    echo "Package name is available"
else
    echo "Package already exists. See https://pypi.org/project/$package_name/ for more details"
    read -p "Do you want to continue? (y/N): " continue
    if [ "$continue" != "y" ]; then
        exit 1
    fi
fi

read -p "Description: " description
# If description is not provided, set to "Nothing"
if [ -z "$description" ]; then
    description="Nothing"
fi

read -p "Enter email (minhpc@ikameglobal.com): " email
if [ -z "$email" ]; then
    email="minhpc@ikameglobal.com"
fi

package_name_underscore=$(echo "$package_name" | sed 's/-/_/g')

####################################################
#                  RESTRUCTURE                     #
####################################################
# Enable workflows
mv .github/workflows/dev.yml.rename .github/workflows/dev.yml
mv .github/workflows/release.yml.rename .github/workflows/release.yml

mv README.md.rename README.md
mv src "$package_name_underscore"

####################################################
#               REPLACE VARIABLES                  #
####################################################
# Replace <package-name>, <email> and <github-username> in README.md, docs/installation.md, mkdocs.yml, pyproject.toml
sed -i "s/<package-name>/$package_name/g" README.md
sed -i "s/<package-name>/$package_name/g" docs/installation.md
sed -i "s/<package-name>/$package_name/g" mkdocs.yml
sed -i "s/<package-name>/$package_name/g" pyproject.toml
sed -i "s/<package-name>/$package_name/g" .github/workflows/release.yml

sed -i "s/<github-username>/$github_username/g" README.md
sed -i "s/<github-username>/$github_username/g" docs/installation.md
sed -i "s/<github-username>/$github_username/g" mkdocs.yml
sed -i "s/<github-username>/$github_username/g" pyproject.toml
sed -i "s/<github-username>/$github_username/g" .github/workflows/release.yml

sed -i "s/<email>/$email/g" README.md
sed -i "s/<email>/$email/g" docs/installation.md
sed -i "s/<email>/$email/g" mkdocs.yml
sed -i "s/<email>/$email/g" pyproject.toml
sed -i "s/<email>/$email/g" .github/workflows/release.yml

sed -i "s/<description>/$description/g" README.md
sed -i "s/<description>/$description/g" pyproject.toml

# Replace <package-name-underscore>
sed -i "s/<package-name-underscore>/$package_name_underscore/g" pyproject.toml
sed -i "s/<package-name-underscore>/$package_name_underscore/g" mkdocs.yml
sed -i "s/<package-name-underscore>/$package_name_underscore/g" tox.ini
sed -i "s/<package-name-underscore>/$package_name_underscore/g" tests/test_app.py
sed -i "s/<package-name-underscore>/$package_name_underscore/g" docs/api.md
sed -i "s/<package-name-underscore>/$package_name_underscore/g" docs/usage.md

####################################################
#                COMMIT CHANGES                    #
####################################################
# uncomment the following to init repo and push code to github
git add .
pre-commit run --all-files
git add .
git commit -m "Setup repo"
git branch -M main

# Uncomment the following to config github secret used by github workflow.
#gh secret set PERSONAL_TOKEN --body $GH_TOKEN
#gh secret set PYPI_API_TOKEN --body $PYPI_API_TOKEN
#gh secret set TEST_PYPI_API_TOKEN --body $TEST_PYPI_API_TOKEN

git push -u origin main
