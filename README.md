# Github Pages Deploy Action for Documentation and Static Site Generators

![License](https://img.shields.io/github/license/avinal/github-pages-deploy-action?style=flat-square)
![Release](https://img.shields.io/github/v/release/avinal/github-pages-deploy-action?style=flat-square)

Plenty of people use Python site generators and lot other people use Javadoc to document their code. The process of hosting these are really time taking and often it is done manually in multiple steps such as, run site/documetnation generator on local machine then commit all changes to some branch and then push generated files to GitHub. How awesome it will be if you can automate these tasks? You just have to document your code and rest part will be automatically happen as soon as you push changes to GitHub. If you have used GitLab, this process is almost streamlined. Sadly GitHub doesn't natively support Python and other generators. GitHub only support Jekyll natively. 

No more worries now. GitHub Action can do that. You just have to document your code and rest part will be automatically happen as soon as you push changes to GitHub. Currently Java and Python are supported. Support for other languages will be available soon. 

## How to automate these actions ? 
1. A GitHub Actions WorkFlow configuration - Same workflow configuration can work for multiple repository using same generators. A general configuration is given below. 
```yml
    name: GitHub Pages Deploy Action
    on:
        # Branch name(s) which have the source file for site/documentation
        push: [ <write-branch-here> ]
    jobs:
        deploy-pages:
            name: Deploy to GitHub Pages
            runs-on: ubuntu-latest
            steps:
                # Use avinal/github-pages-deploy-action@<latest-release-tag> for latest stable release
                # Do not change the line below except the word main with tag number maybe
                - uses: avinal/github-pages-deploy-action@main
                  with:
                    # GitHub access token with Repo Access
                    GITHUB_TOKEN: ${{ github.token }}
                    # For JavaDoc - "java"
                    # For python write python package and additional packages if any - "python3 python3-pip" 
                    LANGUAGE: "<write-as-directed-above>"
                    # Write make command to generate html e.g.- "make html"
                    MAKE_COMMAND: "make html"
                    # Write the branch name for storing github pages source 
                    PAGES_BRANCH: "gh-pages"
                    # Write the branch name having source files for site/documentation
                    BUILD_FROM: "master"
                    # Write the name of the output folder where generated html is stored by makefile.
                    DOCS_FOLDER: "docs"
```
2. A Makefile with commands to generate html files. Given below are two simplest Makefiles for Java and Python Pelican Static Site generator. Feel free to add more configurations.
    * Java
        ```makefile
            BASEDIR=$(CURDIR)
            OUTPUTDIR=$(BASEDIR)/docs # you may change docs with custom folder name
            PACKAGE=<your-java-package-name> # write the package name here

            html:
                javadoc "$(PACKAGE)" -d "$(OUTPUTDIR)" -encoding UTF-8

            .PHONY: html
        ```
    You can add additional command line arguments to javadoc. 
    * Pelican static site generator (Python)
        ```makefile
            PY?=python3
            PELICAN?=pelican
            PELICANTHEME?=pelican-themes

            BASEDIR=$(CURDIR)
            INPUTDIR=$(BASEDIR)/content
            OUTPUTDIR=$(BASEDIR)/output
            THEMEDIR=$(BASEDIR)/themes/alchemy
            CONFFILE=$(BASEDIR)/pelicanconf.py
            PUBLISHCONF=$(BASEDIR)/publishconf.py

            theme:
	            "$(PELICANTHEME)" --install "$(THEMEDIR)"

            html: theme
                "$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

            .PHONY: theme html
        ```
    Most Python Static-site/documentation generators provides a default **Makefile**. You can use the same with minor changes.
3. After this action is ran first time, a new branch will be created. You have to tell GitHub to use that branch for GitHub Pages. 
    * Goto your repository *Settings* and scroll down to *GitHub Pages.
    * Under *Source* click on *Branch* drop-down menu and select the new branch(e.g- gh-pages) and click *Save*.
    * A message will appear above this setting e.g - **Your site is published at https://avinal.github.io/**. This is your website address. You can now use it anywhere. 
First deployment may take up to 30 minutes to be published.

**Hurray, You have successfully automated your site/documentation process 😁**


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

