# Processor modules

In this tutorial, we demonstrate the steps to write a basic processor module which subscribes to a hook, and log what it receives when the hook is triggered. We will also add a configuration setting to offer our users the ability disable this feature.  

We'll call it ``IrisDummyModule``.  


## Project structure overview 
As described in the [development module main page](/development/modules/), the module should have the following structure.  

```python
setup.py                # Setup configuration to build the module 
README.md               # README 
iris_dummy_module       # Name of the package 
    __init__.py              # Declaration of the package and main class
    IrisDummyConfig.py       # Configuration of the module to help keep the main file clean 
    IrisDummyInterface.py    # Main class of the module 
```

While the module could have only one main file ``IrisDummyInterface.py``, we recommend splitting its configuration into a new configuration file (here ``IrisDummyConfig.py``) to keep the code clear.   

There is no mandatory naming convention for the files or the class or the methods. We chose this one to keep things clear, and we recommend following the same. But it's up to you really. 

We will walk over these files one by one during this tutorial.  


## Creating the interface

The interface is the code that talks with IRIS. It implements methods that call and are called by the server. It needs to inherit [IrisModuleInterface class](https://github.com/dfir-iris/iris-module-interface/blob/master/iris_interface/IrisModuleInterface.py) from the [IrisModuleInterface package](https://github.com/dfir-iris/iris-module-interface).  This module handles most of the methods needed by IRIS to recognize, set up and call the module.  By inheriting this class in our interface, we avoid writing that part ourselves.  

Let's write our basic interface class.  The name of the file has to be the name of the main class, that's the only constraint. We'll see later on why.  

```python title="iris_dummy_module/IrisDummyInterface.py"
#!/usr/bin/env python3

# Import the IrisInterface class
from iris_interface.IrisModuleInterface import IrisModuleInterface

# Create our module class
class IrisDummyModule(IrisModuleInterface):
    pass 
```

That's it ! Actually this class is not doing anything right now. We'll need to add a few methods to register our hook later.  

But first we need to indicate to IRIS what is our main interface class. Remember, there is no convention restriction, so IRIS has no way to know which class it should instantiate to call our module.  

To do so, we need to set a specific variable in our `__init__.py`.  

```python title="iris_dummy_module/__init__.py"
# Set the __iris_module_interface variable to the name of our main class. 
# When IRIS instantiates the python module, it looks for "module.__iris_module_interface"
# And then tries to instantiate the class "__iris_module_interface.__iris_module_interface", here 'IrisDummyModule.IrisDummyModule'. 
# That's why the python file must have the same name as the class.  

__iris_module_interface = "IrisDummyModule"
```

Our module is now recognizable by IRIS :heart: Pretty simple right ? 


## Writing the configuration 

The next step is to describe what the module is doing, its name, its configuration, etc.   
This is done by overwriting predefined variables of the ``IrisModuleInterface`` class.   

Let's create our Python configuration file and go through each variables.  


```python title="iris_dummy_module/IrisDummyConfig.py"

# Import the module types list,  so we can indicate the type of our module 
from iris_interface.IrisModuleInterface import IrisModuleTypes 

# Human name displayed in the GUI Manage > Modules. This can be anything, 
# but try to put something meaningful, so users recognize your module. 
module_name = "IrisDummy"

# Description displayed when editing the module configuration in the UI. 
# This can be anything, 
module_description = "Provides a dummy module that replies to one hook"

# Set the interface version used. This needs to be the version of 
# the IrisModuleInterface package. This version is check by the server to
# to ensure our module can run on this specific server 
interface_version = 1.1

# The version of the module itself, it can be anything 
module_version = 1.0

# The type of the module, here processor 
module_type = IrisModuleTypes.module_processor

# Our module is a processor type, so it doesn't offer any pipeline 
pipeline_support = False

# Provide no pipeline information as our module don't implement any 
pipeline_info = {}

# The configuration of the module that will be displayed and configurable 
# by administrators on the UI. This describes every parameter that can 
# be set. 
module_configuration = [
    {
        "param_name": "log_received_hook",

        "param_human_name": "Log received hook",

        "param_description": "Logs a message upon hook receiving if set to true. Otherwise do nothing.",

        "default": True,

        "mandatory": True,

        "type": "bool"
    }
]
```

The module configuration parameters are the following :  

- ``param_name`` : The internal parameter name. This will be used by the module itself to fetch the value when needed.
- ``param_human_name`` : The name displayed on the UI for this specific parameter
- ``param_description``: A description explaining what this parameter is doing to help administrators
- ``default``: The default value of our parameter. Here we set to True, so after install our module is already configured and ready to log the hook. 
- ``mandatory``:  Indicates whether the parameter is mandatory or not. If set to True  and no value is provided (either by admin or by default), the module is automatically disabled by IRIS
- ``type``: The type of parameter. Here a boolean, which will be rendered under the form of a checkbox.  

A module can have as many parameters as it needs.  

We now need to update our main class to set this configuration.  


```python title="iris_dummy_module/IrisDummyInterface.py"

#!/usr/bin/env python3

# Import the IrisInterface class
from iris_interface.IrisModuleInterface import IrisModuleInterface

# Create our module class
class IrisDummyModule(IrisModuleInterface):
    # Set the configuration
    _module_name = interface_conf.module_name
    _module_description = interface_conf.module_description
    _interface_version = interface_conf.interface_version
    _module_version = interface_conf.module_version
    _pipeline_support = interface_conf.pipeline_support
    _pipeline_info = interface_conf.pipeline_info
    _module_configuration = interface_conf.module_configuration
    _module_type = interface_conf.module_type

    pass 
```

Done! The module is now providing enough information to IRIS, so it knows exactly what our module do and what needs to be called to run it.  

However, our module is still doing nothing. Let's make it subscribe to an IRIS hook.  



## Subscribing to a hook 
Hooks allow to be notified by IRIS when a specific event occurs (IOC creation, deletion, etc). For a comprehensive description of hooks, please see the [Hooks section](/development/hooks/) of this documentation.  

The registration (or subscription) to a hook occurs at two moments during the life of a module: 

- When the module is added to IRIS 
- When the configuration of the module is changed by an Admin. This allows dynamic subscription and deregistration of hooks depending on the config. 


These registration/deregistration events are triggered by IRIS, and are propagated to modules through the `IrisModuleInterface` method ``register_hooks`` [[ref]( https://github.com/dfir-iris/iris-module-interface/blob/d63b358b1861e4545e983b67d9530469e3a87918/iris_interface/IrisModuleInterface.py#L389)].  



To register to a hook, we need to override this method and register our hook within this method.  To do so, `IrisModuleInterface` offers us another method ``register_to_hook`` [[ref](https://github.com/dfir-iris/iris-module-interface/blob/d63b358b1861e4545e983b67d9530469e3a87918/iris_interface/IrisModuleInterface.py#L401)], which we can call for each hook we want to subscribe.  

Here is a summary of the events:   

1. IRIS calls ``register_hooks`` of our module. This indicates it is time for us to register our hooks.  
2. Within this method, we call ``register_to_hook`` for each hook we want to subscribe

Let's add this to our main class and register to the `on_postload_ioc_create`. This will notify use each time a new IOC is created and committed to the database. 


```python title="iris_dummy_module/IrisDummyInterface.py"
#!/usr/bin/env python3

# Import the IrisInterface class
from iris_interface.IrisModuleInterface import IrisModuleInterface


# Create our module class
class IrisDummyModule(IrisModuleInterface):
    # Set the configuration
    _module_name = interface_conf.module_name
    _module_description = interface_conf.module_description
    _interface_version = interface_conf.interface_version
    _module_version = interface_conf.module_version
    _pipeline_support = interface_conf.pipeline_support
    _pipeline_info = interface_conf.pipeline_info
    _module_configuration = interface_conf.module_configuration
    _module_type = interface_conf.module_type

    def register_hooks(self, module_id: int):
        """
        Called by IRIS indicating it's time to register hooks.  
        
        :param module_id: Module ID provided by IRIS.
        """

        # Call the hook registration method. We need to pass the 
        # the module_id to this method, otherwise IRIS won't know 
        # to whom associate the hook. 
        # The hook name needs to be a well known hook name by IRIS. 
        status = self.register_to_hook(module_id, iris_hook_name='on_postload_ioc_create')

        if status.is_failure():
            # If we have a failure, log something out 
            self.log.error(status.get_message())

        else:
            # Log that we successfully registered to the hook 
            self.log.info(f"Successfully subscribed to on_postload_ioc_create hook")
```

That's it! :partying_face: Our module has now officially subscribed to a hook and will be notified each time an IOC is created.  


So how the module is notified? Once again this is done by a method named ``hooks_handler`` [[ref](https://github.com/dfir-iris/iris-module-interface/blob/d63b358b1861e4545e983b67d9530469e3a87918/iris_interface/IrisModuleInterface.py#L373)] that `IrisModuleInterface` provides, and we need to overwrite.  

This method is called each time one of the event associated to the hook we subscribed is triggered. It provides the name of the hook and as well as the data associated to it.  By overwriting this method, we can process the hook and the data! 

We will add a condition in this method, that is if the administrator sets the module parameter ``log_received_hook`` to False, then the module won't log anything and simply return the data.    

!!! hint 
        The current configuration of the module can be accessed with the attribute ``self._dict_conf``.  


``` python title="iris_dummy_module/IrisDummyInterface.py"

#!/usr/bin/env python3

# Import the IrisInterface class
from iris_interface.IrisModuleInterface import IrisModuleInterface


# Create our module class
class IrisDummyModule(IrisModuleInterface):
    # Set the configuration
    _module_name = interface_conf.module_name
    _module_description = interface_conf.module_description
    _interface_version = interface_conf.interface_version
    _module_version = interface_conf.module_version
    _pipeline_support = interface_conf.pipeline_support
    _pipeline_info = interface_conf.pipeline_info
    _module_configuration = interface_conf.module_configuration
    _module_type = interface_conf.module_type

    def register_hooks(self, module_id: int):
        """
        Called by IRIS indicating it's time to register hooks.  
        
        :param module_id: Module ID provided by IRIS.
        """

        # Call the hook registration method. We need to pass the 
        # the module_id to this method, otherwise IRIS won't know 
        # to whom associate the hook. 
        # The hook name needs to be a well known hook name by IRIS. 
        status = self.register_to_hook(module_id, iris_hook_name='on_postload_ioc_create')

        if status.is_failure():
            # If we have a failure, log something out 
            self.log.error(status.get_message())

        else:
            # Log that we successfully registered to the hook 
            self.log.info(f"Successfully subscribed to on_postload_ioc_create hook")


def hooks_handler(self, hook_name: str, data):
    """
    Called by IRIS each time one of our hook is triggered. 
    """

    # read the current configuration and only log the call if 
    # our parameter is set to true 
    if self._dict_conf.get('log_received_hook') is True:
        self.log.info(f'Received {hook_name}')
        self.log.info(f'Received data of type {type(data)}')

    # Return a standardized message to IRIS saying that everything is ok. 
    # logs=list(self.message_queue) is needed, so the users can see the logs 
    # our module generated during its execution.  
    return InterfaceStatus.I2Success(data=data, logs=list(self.message_queue))
```

**We are done !** Our module is now fully ready to register, subscribe to a hook and act when notified.  
