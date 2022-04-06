# Reports

Iris has the ability to generate reports based on the data of an investigation.    
The reports templates can be managed in ``Advanced`` > ``Templates``.

!!! info
    This section is only available for users with the Admin role.

## Structure of templates
Reports templates are made of tags, which are then processed and filed by the template engine of Iris.   
The templates can have any forms as soon as they respect the tags. An example of report is available in the source code of Iris, ``source > app > templates > docx_reports``.  

The following tags are available. None are mandatory. If a tag is mistyped, the generation step will produce an error message.   

!!! hint 
    Standard objects are accessible with ``{{ objectname }}``.
    List objects can be looped:

    ```
      {% for object in object_list %}
        {{ object.attribute }}
      {% endfor %} 
    ```


- ``case.name``: Name of the case
- ``case.description``: Description of the case
- ``case.open_date``: Case open date 
- ``case.close_date``: Case close date 
- ``case.opened_by``: User that initially opened the case 
- ``case.for_customer``: Customer linked to the case 
- ``case.soc_id``: SOC ID number linked to the case 
- ``evidences``: List of evidence objects (see below - given ``evidence`` as loop variable)
    - ``evidence.filename``: File name of the evidence 
    - ``evidence.date_added``: Date of registration 
    - ``evidence.file_hash``: Hash of the evidence 
    - ``evidence.added_by``: User who added the evidence
    - ``evidence.custom_attributes``: Custom attributes of the evidence

- ``iocs``: List of IOCs objects (see below - given ``ioc`` as loop variable)
    - ``ioc.ioc_value``: Value of the IOC 
    - ``ioc.ioc_description``: Description of the IOC
    - ``ioc.ioc_type``: Type of IOC 
    - ``ioc.ioc_tags``: Tags linked to the IOC 
    - ``ioc.custom_attributes``: Custom attributes of the IOC

- ``notes``: List of notes objects (see below - given ``note`` as loop variable)
    - ``note.note_title``: Title of the note 
    - ``note.note_content``: Content of the note 
    - ``note.note_creationdate``: Creation date of the note 
    - ``note.note_lastupdate``: Date of last update 
    - ``note.custom_attributes``: Custom attributes of the note

- ``tasks``: List of tasks objects (see below - given ``task`` as loop variable)

    - ``task.task_title``: Title of the task 
    - ``task.task_description``: Description of the task 
    - ``task.task_open_date``: Open date of the task 
    - ``task.task_last_update``: Last update of the task 
    - ``task.task_close_date``: Date of closure 
    - ``task.task_status``: Status of the task 
    - ``task.task_tags``: Task for the tags 
    - ``task.custom_attributes``: Custom attributes of the task

- `timeline`: List of events objects (see below - given ``event`` as loop variable)

    - ``event.event_title``: Title of the event 
    - ``event.event_content``: Content of the event 
    - ``event.event_raw``: Raw content of the event 
    - ``event.event_date``: Date when the event happened 
    - ``event.event_source``: Source of the event 
    - ``event.category``: Category of the event 
    - ``event.event_tags``: Tags of the events 
    - ``event.last_edited_by``: User who last edited the event 
    - ``event.assets``: List of assets names linked to the event
    - ``event.custom_attributes``: Custom attributes of the event