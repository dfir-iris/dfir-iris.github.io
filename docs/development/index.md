# Development 
!!! info "This page is under construction and more elements will be added over time"

This documentation is not a detailed how-to develop IRIS. It gives some insights to help understand the basic code of the project.  
For a module development, please refer [here](modules/).   

**What's here**  

- [Structure overview](#structure-overview) defines the general structure of the code 
- [Code snippets](#code-snippets) defines basic codes overview
- [DB migration](#db-migrations) gives some hint if your code implies a DB change 

!!! hint 
    Some instructions are available [here](environment/) to setup a development environment. 


## Structure overview 
### Flask 
IRIS uses [Flask](https://flask.palletsprojects.com/en/2.1.x/) for the web engine.  

#### Routes and blueprints
Each page and API endpoints (eg `/login`, `/dashboard`, `/case/assets/list`, etc) refers to a route in the IRIS Flask app. They define what the application should do when Flask receives a request on an URI.  
To keep structure in the projects, these routes are grouped by `Blueprints`. The Blueprints reflects the structure shown in the IRIS UI left menu. For instance there is a `case` and an `activities` Blueprint.  

The Blueprints and thus routes are defined in `source > app > blueprints`.   
All the blueprints are registered in `source > app > views.py`.  

#### Templates 
IRIS uses dynamic page templating when an URI is visited. These [Jinja2](https://jinja.palletsprojects.com/en/3.1.x/) templates are filled at runtime with the needed information and then returned to the client.   
Each route offering a page (i.e non-API endpoints) thus relies on a template. These are set in a folder named `templates` in each Blueprint.  
For instance, for the dashboard template : `source > app > blueprints > dashboard > templates > index.html`.  

#### Static contents 
Static content is served from a common folder under `source > app > static > assets`.  It contains CSS, JS and images. These can be accessed by pages using `"/static/assets/<the-resource>"`.  

### SQLAlchemy 
For the database management, the application uses [SQLAlchemy](https://www.sqlalchemy.org/) with a PostgreSQL backend. There is - normally - no need to directly deal with PostgreSQL, everything goes through SQLAlchemy.   
It provides a Python overlay which allows to talk to the DB with objects.   

#### Models 
Each table of the app is defined by a model.  These are defined in `source > app > model`.  When IRIS starts, it looks for the already created tables and creates the missing ones if needed.  
If changes are done on a table or field, then a migration is needed. This is explained in `Alembic migration scripts`.  


#### Requests 
To help structuring the code, we are trying to move the DB code from the routes code. This is partially done and work in progress.  
If your route requests the DB, please put the DB code in `source > app > datamgmt`.  


### Alembic 
To apply schema migration without the need to rebuild the DB, IRIS uses [Alembic](https://alembic.sqlalchemy.org/en/latest/).  
It allows to define migration scheme and IRIS calls it when it starts so users can upgrade without too much hassles. 

### Hooks, modules and tasks 
Modules are handled via tasks thanks to Celery and RabbitMQ. [More info here](hooks/) and [here](http://127.0.0.1:8080/development/modules/). 


### IRIS startup
When starting-up, IRIS initiates a bunch of DB objects, whether it is started for the first time or just restarted. Objects already created are not recreated, but the missing ones are applied. This ensure a smoot migration between versions.  
These are defined in `source > app > post_init.py`.  The scripts also contains the code allow DB migration with Alembic.  

---------------
## Code snippets
### Routes
IRIS does not defines a separate API for users, meaning the HTML pages are actually using the API themselves. Routes don't need to handle the authentication and roles. These are handles by wrappers (see snippets below).  

#### Page route
A page returns an HTML content and should use the following code structure : 
```python title="Example of page route"
@blueprint.route('/a/good/route', methods=['GET']) # (1)
@login_required # (2)
def view_a_good_route(caseid, url_redir):  # (3)
    if url_redir:
        return redirect(url_for('bluprintname.method_name', cid=caseid))  # (4)

    # route code 
    
    return render_template("a_good_route.html", variable_1=var_1, ...)  # (5)
```

1. This defines which URI the route is handling as well as the methods it supports (ie GET, POST, etc). In IRIS, we try to limit one method per route.  
2. This defines the security of the endpoint. `@login_required` is used for users page and `@admin_login_required` is used for admin restricted pages.  
3. `caseid` and `url_redir` are variable provided by `@login_required` and `@admin_login_required` wraps. `caseid` indicates which case ID the user tried to access the route with. `url_redir` indicates the caseid provided wasn't valid and a redirection is needed.  
4. In case a redirection is needed, provide the URL to which the redirection should be done. It's often the page method itself except for modales.  
5. A page route needs to return an HTML template. `variable_1` is a value that can be accessed from within the template itself. More variables can be added, or not at all.  


#### API route 
An API route returns a JSON content. Two types are pre-defined and should be used : 
```python title="Standard API returns"
response_success(msg="A success message", data=<data associated with the success feedback>)

response_error(msg="An error message", data=<data associated with the error feedback>, status=<status code, by default 400>)
```

Below is an example of standard API route. 
```python title="Example of page route"
@blueprint.route('/a/good/api_route', methods=['GET']) # (1)
@api_login_required # (2)
def view_a_good_route(caseid):  # (3)

    # API route code 
    
    return response_success("ok", data=my_data_object)  # (4)
```

1. This defines which URI the route is handling as well as the methods it supports (ie GET, POST, etc). In IRIS, we try to limit one method per route.  
2. This defines the security of the endpoint. `@api_login_required` is used for users API endpoints and `@api_admin_required` is used for admin restricted endpoints.  
3. `caseid` is provided `@api_login_required` and `@api_admin_required` wraps. It indicates which case ID the user tried to access the endpoint with. 
5. One of the standard return defined above.   

-------
## DB Migrations 
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


