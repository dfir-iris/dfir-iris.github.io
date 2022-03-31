# Modules 

## Introduction 

A DFIR-IRIS Module (DIM) is a Python package allowing to extend IRIS features.  DIMs are not running constantly and are only called following specific actions done by users. 

We distinct two types of modules: 

- ``Pipeline modules``: Allow uploading and processing of evidences through modular pipelines (eg: EVTX parsing and injection into a database or data visualiser). These are called when a user queries ``Update case`` and select evidences to process. 
- ``Processor modules``: Allow processing of IRIS data upon predefined actions / hooks. (eg: be notified when a new IOC is created and get VT/MISP insights for it). These are either called automatically upon specific events, or if a user manually triggers them. 


Except for some triggers for processor modules, all tasks provided by DIMs are run asynchronously in RabbitMQ tasks, so they don't impact the UI.  

Both types of DIMs have the same structure, they only differ in their configurations and how they handle the data they receive. For that purpose, every DIM inherit from a common class named ``IrisModuleInterface`` - available [here](https://github.com/dfir-iris/iris-module-interface) - which provides the basic structure and methods of a module. 

!!! hint 
    To quickly start writing a new module, one can follow [these tutorials](/development/quick_start/processor/).

## Overview
Modules are instantiated upon actions (hooks, triggers, user actions) and this occurs each time the said actions occur. It implies the initiation of a module has to be very quick. In most of the case, the ``__init__`` method should not even be overwritten.   


They can live either in the worker or the web-app, depending on their type and action they are handling. They can also live in both. This implies multiple instances of the same module can run at the same time.  

The graph below shows two modules of different types running in the worker and interacting with external elements.  

![](../_static/mods_overview.png)

Modules don't have to handle the task creations or resource locks. This is handled by IRIS. They just need to process the data they received and return results in a predefined manner.   

## Common structure

The section below describes the common structure of modules. 

### Directory structure

```
setup.py                # Setup configuration to build the module 
README.md               # README 
iris_example_name       # Name of the package 
    __init__.py              # Declaration of the package and main class
    IrisExampleConfig.py     # Configuration of the module to help keep the main file clean 
    IrisExampleInterface.py  # Main class of the module 
    module_helper            # Sub module containing the helper functions of the module 
      helper.py              # for instance access to ext resource, manipulation of data 
      helper2.py             # etc. 
```

### The __init__.py file

Iris loads the modules dynamically. To do so, it needs to know the name of the main class of the module and relies on ``__init__.py`` to find this information.  

```python
__iris_module_interface = "IrisEXAMPLEInterface"
```

Where ``IrisEXAMPLEInterface`` is the main class of the module and inherits of the base class ``IrisModuleInterface``. 

!!! Caution
    Failing to provide the main class in ``__init__.py`` or having the main class inherit from ``IrisModuleInterface`` will make IRIS fail each time 
    it attempts to load the module. 


## The module configuration

Iris needs to know what the module is doing and what services it is providing. This is done via the attributes of the main class (let's say ``IrisEXAMPLEInterface``). The attributes are :

- ``_module_name`` : string - "human" name presented to users. 
- ``_interface_version`` : float - version of ``IrisModuleInterface`` used. If the version is not supported, the server will refuse to register the module. 
- ``_module_version`` : float - version of the module itself to help users keep tracks of evolutions. 
- ``_module_type``: string - Type of module. The available modules types are listed in ``IrisModuleInterface.IrisModuleTypes``
- ``_pipeline_support`` : bool - should be set to True if it implements a pipeline process (aka module of type ``pipeline_module``).
- ``_pipeline_info`` : dict - contains the configuration of the pipeline. The following structure must be followed:

```python
pipeline_info = {

    # Name of the pipeline used for internal tracking. This 
    # must be unique among all modules so pick something really unique 
    "pipeline_internal_name": "example_pipeline",

    # The name of the pipeline presented to the user. Use something 
    # that will help the users to identify the right pipeline
    "pipeline_human_name": "Example Pipeline",

    # Arguments presented to the users when they select the pipeline
    "pipeline_args": [
        ['some_index', 'required'],
        ['example_argument', 'optional']
    ]
}
```

- ``_module_configuration`` : A list of dict. The list contains each field needed by the module. This list is shown in the Iris webpage of the module configuration. Each field in an entry is mandatory. 

```python
_module_configuration = [
  {
      "param_name": "vt_api_key",
      "param_human_name": "VT API Key",
      "param_description": "Virus total API key",
      "default": None,
      "mandatory": True,
      "type": "sensitive_string"
  },
  {
    "param_name": "vt_key_is_premium",
    "param_human_name": "VT Key is premium",
    "param_description": "Set to True if the VT key is premium",
    "default": False,
    "mandatory": True,
    "type": "bool"
  },
  {
      "param_name": "vt_ip_assign_asn_as_tag",
      "param_human_name": "Assign ASN tag to IP",
      "param_description": "Assign a new tag to IOC IPs with the ASN fetched from VT",
      "default": True,
      "mandatory": True,
      "type": "bool"
  }
]
```

The above example results in the following.  

![](../_static/Modules_config_example.png)
