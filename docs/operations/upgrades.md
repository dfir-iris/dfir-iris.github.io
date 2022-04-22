# Upgrades

Most of the time, Iris handles upgrades of the database automatically when a new version is started, thus no specific actions are required.  
**However**, some breaking changes might need manual intervention.  Please use the selectors below to assess if a manual action is required. 

!!! cite ""
    <label for="cversion-select">Your current version:</label>
    <select name="current_version" class="md-select" id="cversion-select">
        <option value="">--Please choose current version--</option>
        <option value="v1.2.1">v1.2.1</option>
        <option value="v1.3.0">v1.3.0</option>
        <option value="v1.3.1">v1.3.1</option>
        <option value="v1.4.0">v1.4.0</option>
        <option value="v1.4.1">v1.4.1</option>
    </select>

    <label for="tversion-select">Upgrading to:</label>
    <select name="target_version" class="md-select" id="tversion-select">
        <option value="">--Please choose target version--</option>
        <option value="v1.2.1">v1.2.1</option>
        <option value="v1.3.0">v1.3.0</option>
        <option value="v1.3.1">v1.3.1</option>
        <option value="v1.4.0">v1.4.0</option>
        <option value="v1.4.1">v1.4.1</option>
    </select>

    <button class="md-button ml-mr-auto" onclick='check_versions();'>
      <span class="">Check upgrades conditions</span>
    </button>

<div id="migration-info"></div>

**For production environments, it is highly recommended to make backups of the DB in case any issues occur during upgrades.**  

-------------
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

### v1.4.1
**This only applies if you are coming from IRIS <= v1.3.1.**

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
6. Pull the last changes from the repository, checkout to `v1.4.1`, build and run. 
  
```bash
git pull origin 
git checkout v1.4.1
docker-compose build 
docker-compose up 
```
7. The data should be successfully transferred.

**Do not forget to clear out your browser cache, many JS files were changed.**

### v1.4.0
**This version already has a patch. Please directly upgrade to [v1.4.1](#v141)**

<script>
  function check_versions() {
    var cversion = document.getElementById("cversion-select").value;
    var tversion = document.getElementById("tversion-select").value;

    if (!cversion || !tversion) { return ;}

    var map = {
      "v1.2.1": {
        "v1.3.0": "Auto",
        "v1.3.1": "Auto",
        "v1.4.0": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v140">v1.4.0</a></p>`,
        "v1.4.1": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v141">v1.4.1</a></p>`,
      }, 
      "v1.3.0": {
        "v1.3.1": "Auto",
        "v1.4.0": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v140">v1.4.0</a></p>`,
        "v1.4.1": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v141">v1.4.1</a></p>`,
      }, 
      "v1.3.1": {
        "v1.4.0": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v140">v1.4.0</a></p>`,
        "v1.4.1": `<p><span class="twemoji"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.22 1.754a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575L6.457 1.047zM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm-.25-5.25a.75.75 0 0 0-1.5 0v2.5a.75.75 0 0 0 1.5 0v-2.5z"></path></svg></span> <code>Action required</code> - See <a href="#v141">v1.4.1</a></p>`,
      }, 
      "v1.4.0": {
        "v1.4.1": "Auto",
      }
    }
    const div = document.getElementById('migration-info');
    div.innerHTML = '';

    if (cversion === tversion) {
       div.innerHTML = `<div class="admonition question">
            <p class="admonition-title">Let's talk</p>
            <p>We're not sure that's really useful. Coffee instead ?</p>
            </div>`;
        return;
    }

    if (cversion in map) {
      if (tversion in map[cversion]) {
        if (map[cversion][tversion] == 'Auto') {
          div.innerHTML = `<div class="admonition success">
            <p class="admonition-title">Good news</p>
            <p>`+ cversion +` can be upgraded to `+ tversion + ` automatically</p>
            </div>`
            return;
        } else {
          div.innerHTML = `<div class="admonition danger">
            <p class="admonition-title">Caution</p>
            <p>`+ map[cversion][tversion] +`</p>
            </div>`
          return;
        }
      } 
    } 
    div.innerHTML = `<div class="admonition failure">
    <p class="admonition-title">Incompatible</p>
    <p>Migration from `+ cversion +` to `+ tversion + ` is not possible</p>
    </div>`;
    
  }
</script>