Q & A
======

Cases
-----

Can I recover a deleted case ?
``````````````````````````````````
No. Cases are deleted from the database and changes are committed. 
There is no coming back unless you have made backups of the database (which we recommend).

Can I recover a deleted case object ?
``````````````````````````````````````
No. Every object such as IOCs, assets, events, notes, etc are immediately deleted from the database and changes are committed. 

Can I add a new asset type ?
`````````````````````````````
Yes. From a user with administrative rights, go to Advanced > Assets Types. 

Can I add a new IOC type ?
`````````````````````````````
No, not yet. But it might be possible in future versions. 
 
Can I create two cases with the same name for the same customer ?
``````````````````````````````````````````````````````````````````
Yes. Cases are identified with a unique number, so they can have the same name. 

Can I restrict the view of case to a set of users ?
````````````````````````````````````````````````````
No. Please see Security. 

Can I change the name or customer of an existing case ?
````````````````````````````````````````````````````````
These changes are not possible for now but it might be implemented in future versions. 


Operations
----------

What is the password policy ? Can it be changed ?
``````````````````````````````````````````````````
For now the password policy is hardcoded and cannot be changed.   
It should be 12 characters minimum and contains a capital letter and a number. 

Can I change my profile picture ?
``````````````````````````````````
No, not for now. This wasn't a priority for us, it will be release in future versions. 


I lost the administrator password, can I recover it ? 
``````````````````````````````````````````````````````
Passwords are hashed so they can't be recovered. But you can change it. 

**If you have another admin user**  

Being logged as this user, simply head to the Advanced > Users section, and change the administrator password. 

**If you don't have another admin user**  

You can't do the change via Iris, you need to update the DB manually. 


.. admonition:: **ATTENTION** 
   :class: warning

    Do not delete and recreate the user ! This will create inconsistencies in the relations and might corrupt everything. 

1. Generate the hash of the new password with Python BCrypt 
   
.. code:: python 

   import bcrypt
   print(bcrypt.hashpw(<new_password>, bcrypt.gensalt())

2. Connect to the Postgresql database `iris_db` and update the password 

.. code:: bash

    / # su postgres
    / # psql
    postgres=# \c iris_db 
    postgres=# UPDATE user SET password = '<hash>' WHERE "user".name == 'administrator';

Can I delete a user ? 
``````````````````````
No. To keep consistencies in the database, users unfortunately cannot be deleted if they have done some activities. 

Can I delete a customer ? 
``````````````````````````
No. To keep consistencies in the database, customers unfortunately cannot be deleted if they are linked to cases. 

Can I create organizations or groups ? 
````````````````````````````````````````
No. It might be possible in future versions but for now it is better to spin up a new instance for restricted cases. 

Can I create more roles ? 
``````````````````````````
No. It might be possible in future versions but for now it is better to spin up a new instance for restricted cases. 

Can I prevent backrefs of assets and IOCs ? 
`````````````````````````````````````````````
No. It might be possible in future versions but for now it is better to spin up a new instance for restricted cases. 

My report template is not generated and generates an error 
```````````````````````````````````````````````````````````
Please triple check typos in tags as there is no fault tolerance. 


Integration
-----------
Can I enrich IOCs with external sources ?
``````````````````````````````````````````
Some connectors were developed but they are not published yet. They might be added in future versions.   
There is a premise for MISP in app > iris_engine > connectors > misp4iris. 

Is there an API client ?
`````````````````````````
Not yet but it might be in the future. 

Security
--------
Can I restrict cases ?
``````````````````````
No. It might be possible in future versions but for now it is better to spin up a new instance for restricted cases. 

Can I expose IRIS on the Internet ?
````````````````````````````````````
NO ! Please don't. This platform should only be accessible in a restricted environment. 

I found a security issue, can I have a bounty ?
````````````````````````````````````````````````
No - IRIS is free and open source so there is no bounty. Please `report <mailto:contact@dfir-iris.org>`_ it as soon as possible so we can fix it. 


MISC
----
What does IRIS stands for ?
````````````````````````````
Originally Incident Response Investigation System. But it can be whatever you want really. 