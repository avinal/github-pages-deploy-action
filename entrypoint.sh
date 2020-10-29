#! /bin/bash

# Clone the target repo
clone_repo_url="https://github.com/${GITHUB_REPOSITORY}.git"
git clone --single-branch --branch "${INPUT_BUILD_FROM}" "${clone_repo_url}"
echo "repository cloned"

# Seperate Reposory name from user/repository
IFS='/' read -ra reponame <<< "${GITHUB_REPOSITORY}"
repository="${reponame[1]}"
echo "repository name resolved ${repository}"

# Install Language packages
DEBIAN_FRONTEND=noninteractive 
if [[ "${INPUT_LANGUAGE}" == "python" ]] 
then
    echo "Python specified ... Installing Python"
    apt-get install --no-install-recommends -y python3.8
    pip3 install "${repository}/requirements.txt"
elif [[ "${INPUT_LANGUAGE}" == "java" ]]
then
    echo "Java specified ... Installing Java"
    apt-get install --no-install-recommends -y openjdk-8-jdk
fi

cd "${repository}"
git checkout "${INPUT_BUILD_FROM}"

# Run make command
make_command=(${INPUT_MAKE_COMMAND})
"${make_command[@]}"

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config user.name "${GITHUB_ACTOR}"
echo "Config added"

# Deploy Pages
ghp-import -m "GitHub Pages Updated" -b "${INPUT_PAGES_BRANCH}" "${INPUT_DOCS_FOLDER}"
git push -f origin "${INPUT_PAGES_BRANCH}"
echo "Page Deployment Successfull"
