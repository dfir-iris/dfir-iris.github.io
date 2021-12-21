Modules
========
Iris has the ability to upload and process evidences through modular pipelines (eg: EVTX parsing and injection into a database or data visualiser). The modular pipelines are actually Python modules which must be installed in the Python environment of iriswebapp and the worker (see Quick Start).
Once installed in the Python environment, the modules can be managed in ``Advanced`` > ``Modules``.

.. image:: ../_static/Manage_module.png

.. admonition::  Note
  :class: info

  This section is only available for users with the Admin role.

We provided a module called IrisEVTXModule, as an example for the community. Let's take this one to explain how you can add and use a new module.

Module management
------------------

To add a module, the user can click on the "+" button:

.. image:: ../_static/Modules_management.png


Then the user must enter the name of the pre-installed module. The name of the pip package must be used.

.. image:: ../_static/Modules_management_add.png


If everything is ok, the module will appear on the list. It is currently disabled, and needs configuration before it can be enabled. To do so, the user can click on the module's name:

.. image:: ../_static/Modules_management_summary.png


A new text box appears, showing information about the module, and a list of parameters to configure. Each mandatory parameter must be configured to enable the module.

.. image:: ../_static/Modules_management_info.png


After configuring all the mandatory parameters, the "Enable button" is revealed and the user can finally enable the module.

.. image:: ../_static/Modules_management_enable.png


That's all! The user can confirm in the summary that the module is indeed enabled and ready to use.

.. image:: ../_static/Modules_management_enabled.png


Finally, the user can either disable or remove the module by clicking on the according buttons.

.. image:: ../_static/Modules_management_remdis.png

Now that the module is configured and enabled, let's see how we can use it!

**NB: As a temporary fix, after adding and configuring a module, you must restart the IRIS services (dockers) else the worker won't have the module installed properly.**

How to use the module
---------------------

As stated in the beginning, a module extends the capabilities of IRIS. For now, it allows to import evidences of your needs into what we call a pipeline, where data will be handled in the module (checking, parsing, ingestion...).
In our provided module, IrisEVTXModule ingest EVTX files, parse them as JSON, and send the results to a Splunk instance using its HTTP event collector (HEC) endpoint.

In IRIS, the files are always imported in the context of a case. To import a file, the user can click on ``Manage cases`` then ``Update`` tab.

.. image:: ../_static/Modules_management_import.png

In ``Processing pipeline``, the user can pick a pipeline that will send the files to the wanted module. In our example, ``EVTX pipeline`` refers to the IrisEVTXModule module.
Below, the user can fill the arguments needed by the according pipeline. Arguments can be optional. Finally, the user can import one or several files and click ``Update`` to start their processing by the module.

You can see in the picture below that the user will import four EVTX files.

.. image:: ../_static/Modules_management_evtxup.png

The user can follow the upload of the different files with their respective progress bars.

.. image:: ../_static/Modules_management_import_progress.png

Once uploaded, the status of the task can be observed in the Dashboard, in the ``Last automated tasks`` log.

.. image:: ../_static/Modules_management_task.png

Clicking on "Details" shows information on the task processing.

.. image:: ../_static/Modules_management_import_taskinfo.png

After the treatment of the files by the module, the list of the imported files is stored in the ``Evidences`` tab of the according case.

.. image:: ../_static/Modules_management_import_evidences.png

