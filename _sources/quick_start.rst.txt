.. _quick_start:

Quick Start
===========

The most straight forward and recommended way to use Iris is with Docker. This is presented here. 

1. Pre-requisites
-----------------
Hardware
``````````
Iris is not very resourceful and can be run on a small laptop (4 cores, 8Gb of RAM). However for large organization and heavy usage, 
it will need to be greatly scaled up.
We don't have benchmarks yet but keep in mind that the database can grow rapidly and modules can be resourceful depending on their purposes.  
The source code includes a burst test that you can adjust to recreate the load Iris might face. 

Docker
```````
Docker and docker compose are needed to build and run the project. Depending on the OS you will find all the information to install them on 
the official website of `Docker <https://docs.docker.com/get-docker/>`_. 


2. Build
---------
You have found a home for Iris and installed Docker and Docker compose, it is time to build the containers.

Iris is split on 5 Docker services, each with a different role.
  - ``app - iris_webapp``: The core, including web server, DB management, module management etc.
  - ``db``: A PostgresSQL database
  - ``RabbitMQ``: A RabbitMQ engine to handle jobs queuing and processing
  - ``worker``: Jobs handler relying on RabbitMQ
  - ``nginx``: A NGINX reverse proxy

Each service can be built independently, for development for example. In this QuickStart everything will be built at once.

First of all, clone the iris-web repository. Then, at the root of the project, copy the **.env.model** file into **.env**.

You can skip this part if you just want to try or develop. If used in production, please configure the .env file at the root of the project:
  - Nginx: you might want to specify your own certificate as specified above
  - Database credentials: **POSTGRES_PASSWORD** and **DB_PASS** (you can also customise the usernames)
  - IRIS secrets: **SECRET_KEY** and **SECURITY_PASSWORD_SALT**


Finally, you can build all.

.. code:: bash

   git clone https://github.com/dfir-iris/iris-web.git
   cd iris-web
   cp .env.model .env
   # [... optionally, do some configuration as specified above ...]
   docker-compose build
   
The very first time the app builds might take quite a while. After that if a service needs an update, the building process is faster.

3. Run
-------
One last command is needed : 

.. code:: bash

   docker-compose up

Iris will be available on the web interface, port 4433, HTTPS protocol.
By default an ``administrator`` account will be created. The password will be printed in stdout the very first time Iris is started so please pay attention.
If you want to define an admin password at the first start, you can also create and define the environment variable **IRIS_ADM_PASSWORD** in the `app` docker instance (see the webApp Dockerfile).
