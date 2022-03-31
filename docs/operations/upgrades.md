# Upgrades

Most of the time, Iris handles upgrades of the database automatically when a new version is started, thus no specific actions are required.  
**However**, some breaking changes might need manual intervention.  Please use the table below to assess if a manual action is required. 

| From / To|	v1.2.1|	v1.3.0|	v1.3.1|	v1.4.0|
|-----|----|----|----|-----|
v1.2.1|	X|	Auto|	Auto|	:octicons-alert-16: `Action required` - See [v1.4.0](#v1.4.0)|
v1.3.0|	X|	X|	Auto|	:octicons-alert-16: `Action required` - See [v1.4.0](#v1.4.0)|
v1.3.1|	X|	X|	X|	:octicons-alert-16: `Action required` - See [v1.4.0](#v1.4.0)|
v1.4.0|	X|	X|	X|	X|

!!! caution
    For production environments, it is highly recommended to make backups of the DB in case any issues occur during upgrades.  

## Backing-up DB
Only if you run in production and/or data is critical. 

1. List the current running docker containers `docker container list`
2. Spot the IRIS DB container name or ID, and execute the backup

```bash
  docker exec <container> pg_dump -U postgres iris_db | \ 
    gzip > ../iris_db_backup.gz
```

3. Ensure the backup was successful by looking at the gz file 

```bash
  zcat ../iris_db_backup.gz | less 
```

-------------
## Upgrading
1. Stop the dockers ``docker-compose stop``
2. Remove the application dockers ``docker-compose rm app worker``
3. Get the last version of Iris ``git checkout master`` - or any tagged versions
4. Build the new versions ``docker-compose build --no-cache app worker``
5. Run IRIS again. The app will handle the DB migration ``docker-compose up``

-------------

## Rolling back

In case something went wrong, you can rollback to your previous version and restore data. 

1. Remove the faulty docker DB ``docker-compose down db --volumes``
2. Checkout to the previous version working of IRIS 
3. Rebuild the images ``docker-compose build --no-cache``
4. Spin up the docker DB, and ONLY this one. ``docker-compose up db``
5. Get the ID or name of the docker DB ``docker container list``
6. Restore the DB data ``zcat ../iris_db_backup.gz | docker exec -i <container> psql -U postgres -d iris_db``
7. Spin up the rest of the dockers ``docker-compose up``
8. Your data should back.



## Version specific upgrades

### v1.4.0

This version brings breaking changes in the DB docker by adding a named volume instead of the default one.
This implies that previous existing database is ignored as the new docker won't know which volume was previously used.   
To prevent this, please **strictly follow the guide below**. This will copy the data of the existing volume, to the new named one. 

1. Spot the IRIS DB container with ``docker container list``. It should look like `iris-web-db-x`
2. Fetch the current db volume ID (`name` field with the command below)

```bash
docker inspect <iris_db> | grep -A5 "Mounts"

# Example of output
"Mounts": [
  {
      "Type": "volume",
      "Name": "a90b9998a3233a68438c8e099bd0ba98d9f62c9734e40297b8067f9fdb921eb9",
      "Source": "/var/lib/docker/volumes/a90b9998a3233a68438c8e099bd0ba98d9f62c9734e40297b8067f9fdb921eb9/_data",
      "Destination": "/var/lib/postgresql/data",
```
3. Stop all the IRIS dockers : ``docker-compose stop``  
4. Create a new empty volume : ``docker volume create --name iris-web_db_data``   
5. Run a volume copy via a dummy image : 
```bash
docker run --rm -it -v <previous_db_volume_id>:/from:ro -v iris-web_db_data:/to alpine ash -c "cd /from ; cp -av . /to"

# With the example of 2., this gives 
docker run --rm -it -v a90b9998a3233a68438c8e099bd0ba98d9f62c9734e40297b8067f9fdb921eb9:/from:ro -v iris-web_db_data:/to alpine ash -c "cd /from ; cp -av . /to"
```
6. Pull the last changes from the repository, checkout to `v1.4.0`, build and run. 
  
```bash
git pull origin 
git checkout v1.4.0
docker-compose build 
docker-compose up 
```
7. The data should be successfully transferred.

