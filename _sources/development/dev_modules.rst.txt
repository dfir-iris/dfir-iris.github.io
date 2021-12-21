Modules development
-------------------

A Module is a Python package. Some mandatory rules must be followed in order to have a valid IRIS Module.

The __init__.py file
^^^^^^^^^^^^^^^^^^^^

Iris loads the modules dynamically. To do so, it needs to know the name of the main class that inherits from IrisModuleInterface. Therefore, the module requires a ``__init__.py`` file containing the following contents:

.. code:: python

  __iris_module_interface = "IrisEXAMPLEInterface"


Where ``IrisEXAMPLEInterface`` is the main class which inherits from IrisModuleInterface.


The main class
^^^^^^^^^^^^^^

In order to have a standard way to develop IRIS Modules, a Python interface - named IrisModuleInterface - has been developed. The module must have a main class which inherits from IrisModuleInterface (see UlrRepoIrisModuleInterface).


The module configuration
^^^^^^^^^^^^^^^^^^^^^^^^

Iris needs to access to the configuration of the module in order to interact properly with it. It fetches the configuration by accessing the attributes of the main class (let's say ``IrisEXAMPLEInterface``). The attributes are :

- name : A string. The human name of the module appearing on the Modules page of Iris.
- _module_name : A string. The name of the module appearing on the pipeline list.
- _interface_version : A float. The version of IrisModuleInterface.
- _module_version : A float. The version of the module.
- _pipeline_support : A boolean (True/False). Should be set to True if it implements a pipeline process.
- _pipeline_info : A dict. It contains the configuration of the pipeline. The following structure must be followed:

  .. code:: python

    pipeline_info = {
        "pipeline_internal_name": "example_pipeline",
        "pipeline_human_name": "Example Pipeline",
        "pipeline_args": [
            ['some_index', 'required'],
            ['example_argument', 'optional']
        ],
        "pipeline_update_support": True,
        "pipeline_import_support": True
    }

  The pipeline arguments, described in "pipeline_args" list, are shown in the Iris webpage when the according pipeline is selected.

- _module_configuration : A list of dict. The list contains each field you would need for your module. This list is shown in the Iris webpage of the module configuration. Each entry must follow the structure below:

  .. code:: python

    {
        "param_name": "some_url",
        "param_human_name": "URL Some",
        "param_description": "Domain or IP where something is running",
        "default": None,
        "mandatory": True,
        "type": "string"
    }


