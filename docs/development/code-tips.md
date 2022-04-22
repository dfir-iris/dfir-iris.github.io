# Coding tips
## Routes
IRIS does not defines a separate API for users, meaning the HTML pages are actually using the API themselves. Routes don't need to handle the authentication and roles. These are handles by wrappers (see snippets below).  

### Page route
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


### API route 
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
