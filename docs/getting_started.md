# Quick Start

The most straight forward and recommended way to use IRIS is with Docker. This is presented here. 

!!! danger "Disclaimer"

    Iris is in its early stage. It can already be used in production, but please set backups of the database and DO NOT expose the interface on the Internet.
    We highly recommended the use of a private dedicated and secured network. 
    

## Pre-requisites

### Hardware

Iris is not very resourceful and can be run on a small laptop (4 cores, 8Gb of RAM). However, for large organization and heavy usage, 
it will need to be greatly scaled up.  
We don't have benchmarks yet but keep in mind that the database can grow rapidly and modules can be resourceful depending on their purposes.  
The source code includes a burst test that you can adjust to recreate the load Iris might face.   

### Docker
Docker and docker compose are needed to build and run the project. Depending on the OS you will find all the information to install them on 
the official website of [Docker](https://docs.docker.com/get-docker/).  

The platform is tested on Linux and MacOS (including Apple Silicon). While it should work on Windows, some path needed by the dockers to store permanent files might need to be changed in the dockerfiles. 


## Build and run

You have found a home for Iris and installed Docker and Docker compose, it is time to build the containers.

Iris is split on 5 Docker services, each with a different role.

- ``app - iris_webapp``: The core, including web server, DB management, module management etc.
- ``db``: A PostgresSQL database
- ``RabbitMQ``: A RabbitMQ engine to handle jobs queuing and processing
- ``worker``: Jobs handler relying on RabbitMQ
- ``nginx``: A NGINX reverse proxy

Each service can be built independently, which is useful when developing. In this QuickStart everything is built at once.

``` bash
#  Clone the iris-web repository
git clone https://github.com/dfir-iris/iris-web.git
cd iris-web

# Copy the environment file 
cp .env.model .env
# [... optionally, do some configuration as specified below ...]

# Build the dockers
docker-compose build

# Run IRIS 
docker-compose up
```

Iris will be available on the host interface, port 4433, HTTPS protocol.  
By default, an ``administrator`` account is created. The password is printed in stdout the very first time Iris is started. It won't be printed anymore after that.  
You can search for ``WARNING :: post_init :: create_safe_admin :: >>>`` in the logs to find the password.  

If you want to define an admin password at the first start, you can also create and define the environment variable **IRIS_ADM_PASSWORD** in the `app` docker instance (see the webApp Dockerfile). This has no effects once the administrator account is created.   

## Optional configuration

You can skip this part if you just want to try or develop. If used in production, please configure the .env file at the root of the project:

- Nginx: you might want to specify your own certificate as specified above
- Database credentials: **POSTGRES_PASSWORD** and **DB_PASS** (you can also customise the usernames)
- IRIS secrets: **SECRET_KEY** and **SECURITY_PASSWORD_SALT**

The very first time the app builds might take quite a while. After that if a service needs an update, the building process is faster.




