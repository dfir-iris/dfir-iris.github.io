# Server settings
Some basic settings can be set in the section `Advanced` > `Server settings`.  

- **Proxy** : These settings can be inherited by modules. This avoid setting proxy for each modules. This is not enforced and is up to the module to use it or not.  
- **Behavior** : 
    - ``Prevent post-init step to register default modules again during boot``: By default if a module is deleted and the server is restart, the module will be registered again. Setting this will prevent this behavior.  