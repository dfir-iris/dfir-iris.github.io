Setting up an IRIS development environment
===========================================

This documentation is not a How-To develop IRIS. It only proposes a setup to easily develop and test IRIS.
It follows an (issue)[https://github.com/dfir-iris/iris-web/issues/39] raised on the Github of the project.  

It recommends the use of a hybrid development environment, as most of the time only the web-app needs to be changed: 

- Pycharm or any Python IDE for the web-app 
- Docker for db, nginx, celery and worker. The three later are even optional if you don't develop modules. 

Web-app
--------

For the webapp configuration, a specific `.ini` need to be created.
- Create `config.priv.ini` in source/app by copying the `config.docker.ini`present in the same directory. 
- Change `PG_SERVER = db` to  `PG_SERVER = 127.0.0.1` or whatever IP is the Postgresql/docker running with
- 
That's the only configuration change needed for the app to run outside docker. The `docker.priv.ini` is already excluded in gitignore. 

Then Pycharm need to be setup with a dedicated environment, by adding a new configuration:
- Script path : `source/run.py`
- Python interpreter 3.8 
- Working directory: `source`

To have pylint, right click on `source` in the directory tree and `mark directory as` > `sources root`.  
The requirements then need to be installed. Pycharm should detect the requirements.txt and propose to install de dependencies. 
Otherwise they can be installed with the following command (issued in the virtual environment) : 
`pip3 install -r source\requirements.txt`

## Run 
1. Spin up the docker db `docker-compose up db`
2. Run the Pycharm configuration you created 
3. The interface should be accessible on http://127.0.0.1:8000 (and https://127.0.0.1:4433 if you started the nginx docker) 

IRIS can now be developed and debugged on the fly. 

## Tests in docker 
Once the code is working by running on Pycharm, we highly recommend to test it on Docker. To do so, the app docker need to be erased and rebuilt.    

1. `docker-compose rm app`
2. `docker-compose build app`
3. `docker-compose up db app`

**Development considerations**   
If the development results in DB modification, please use Alembic and add a migration script so users don't loose their data when they upgrade. 