API
***

Iris is meant to be plug-able to fit and integrates with the existing environments.   

Through the REST API, one can do almost as much as it is possible to do through the web interface.  

API Keys
########


The first step is to obtain an API key. Each user is automatically attributed an API token.  
It can be found on the left panel, under username and My Settings. 

.. image:: /_static/token_access.png
  :width: 800
  :alt: Token access



.. admonition:: Attention
   :class: warning

   In case the token is exposed and needs to be change, a new one can be generated with the `Renew` option.
   Renewing a token revokes the previous one. 



Endpoints
#########
A list of the endpoints accessible by the API is available `here <../_static/iris_api_reference.html>`_. 

How to use
########## 
The API token is a Bearer and needs to be present in the header `Authorization` when issuing requests. 
For example, to list all the cases: 

.. code:: bash 

   curl --request GET \
  --url http://localhost:8000/manage/cases/list \
  --header 'Authorization: Bearer mWpCUVNzBMU5EnbIAK50jLPhYjKBTHZjobdogc_n_yixpJTmt9tzAf8WYDI7m5XgB9wCJnlaXlHIh9RZjtp2fA' \
  --header 'Content-Type: application/json'


The only way to revoke a token is to renew the current one. Once done, the previous API token does not exist anymore
on the database and it becomes ineffective. 