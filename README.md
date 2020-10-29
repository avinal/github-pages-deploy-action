# Github Pages Deploy Action for Documentation and Static Site Generators

Auto generate documentation and static sites for Java and Python.
Detailed process will be updated soon.

## Requirements 
1. A GitHub Actions WorkFlow configuration
2. A Makefile with commands to generate html files. 

## Useful Awesome code snippets and tricks used in this GitHub Action
1. Git
    * Clone a single specific git branch
        ```shell
            git clone --single-branch --branch <branch-name> <remote-repository-url>
        ```
    * Create empty branch and publish
        ```shell
            git checkout --orphan <empty-branch-name>
            git rm -rf .
            git commit --allow-empty -m "<commit-message>"
            git push origin <empty-branch-name>
        ```
    * Reset every unstaged changes 
        ```shell
            git reset --hard
        ```
2. Shell Script
    * Use a command stored in a variable
        ```shell
            # let command be git branch -v
            command="git branch -v"
            command_array=(${command})
            "${command_array[@]}"
        ```
    * Copy a folder with exact same directory-structure and files to another folder
        ```shell
            cp -a source/. destination
        ```
    * Install a package without recommended packages
        ```shell
            sudo apt install --no-install-recommends <package-name>
        ```
3. Docker
    * Run commands in non interactive mode in Debian based containers while installing packages like tzdata
    ```dockerfile
        # add these to your Dockerfile
        ARG DEBIAN_FRONTEND=noninteractive
        ENV TZ=<TimeZone>/<City>
        # Now run
        RUN apt-get update && apt-get install -y tzdata <other-packages>
    ```
