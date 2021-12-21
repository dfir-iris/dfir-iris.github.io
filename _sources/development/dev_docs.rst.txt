Documentation build
===================

The general documentation is written in RST and built with Sphinx.  
The API documentation is written in YAML and follows the OpenAPI specification.  

1. Pre-requisites
-----------------
Building the documentation requires the following:

  - ``sphinx`` : The core engine for the documentation. `See here <https://www.sphinx-doc.org/en/master/usage/installation.html>`_. 
  - ``redoc-cli`` : The engine that builds the API reference.  

2. Building
-----------
The documentation repository includes a makefile to simply the build.

1. Open a terminal and head to the the ``docs`` directory of the repository
2. Issue the following command ``make html``.
3. That's it ! The documentation will be available in the ``docs\build`` directory. 
 
