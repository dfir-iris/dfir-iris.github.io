# IRIS Documentation 

The documentation is built with [MkDocs Materials](https://squidfunk.github.io/mkdocs-material).

## Installation
To install an environment in which you can build the doc, follow the steps below. The building step requires [IRIS Client](https://github.com/dfir-iris/iris-client) to be installed. 

    pip3 install mkdocs-material mkdocstrings mkdocs-git-revision-date-plugin
    git clone git@github.com:Iris-Tim/iris-doc-src.git
    cd iris-doc-src/
    
    # To preview the changes while writing 
    mkdocs serve 

    # To build 
    mkdocs build

## License

The contents of this repository is available under [LGPL3 license](LICENSE.txt).

