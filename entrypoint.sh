#! /bin/bash

git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "GitHub Actions"
remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

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

cd .. && mkdir -p public
cp -a "${repository}/${INPUT_DOCS_FOLDER}/." public/

cd "${repository}"
git reset --hard

git checkout --orphan "${INPUT_PAGES_BRANCH}"
git rm -rf .
cd ..

cp -a  public/. "${repository}/"

cd "${repository}"
git add publisher "${remote_repo}"

git stage -A
git commit -m "Deploy to GitHub Pages" 
git push -f publisher "${INPUT_PAGES_BRANCH}"
echo "Github Pages Deployed"
