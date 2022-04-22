# DB Migrations 
In case a DB migration is needed, you need to provide an alembic migration script.  

**In a terminal and from within the IRIS virtual env** :  

1. Go to `source` 
2. Issue the following command : `alembic -c app/alembic.ini revision -m "A few words to describe your changes"` 

This creates a new revision file `source > app > alembic > versions`.  It's a Python file that basically describes what needs to be updated DB-wise. You can take example from the ones we already have generated. 

!!! hint 

    During your tests you might face the issue that Alembic does not apply your changes after you executed it once. It's because it keeps tracks of the latest applied revision in a table `alembic_version`. It doesn't know you changed the revision file.  
    In that case the trick is to connect to the DB, and then delete the entry in the alembic_version. This will force it to reapply all revisions at startup.
    If you're using the DB docker you can use the following:

    - `docker exec -it <db_container_id> /bin/sh` 
    - `su postgres`
    - `psql`
    - `\c iris_db;` 
    - `DELETE FROM alembic_version;` 
    - Restart the IRIS web app - your changes should be applied