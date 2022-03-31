# Introduction

In a nutshell, IRIS is a collaborative platform for incident response analysts allowing to share investigations at a technical level.  
It's web application, so it can be either installed on a fixed-server, or on a laptop for roaming investigations where internet might not be available. 

It is born following the struggle to share long and complex investigations among analysts. Most of the current similar platforms are either commercial or targeting the incident handling and triage steps, not the investigation itself. 

The project is available at [https://github.com/dfir-iris/iris-web](https://github.com/dfir-iris/iris-web)

!!! hint "I've read enough, I want to try it"

    Iris comes in dockers - you only need Docker Compose and you'll be set in a few minutes. 
    Follow [the guide](getting_started/). 


!!! danger "Disclaimer"

    Iris is in its early stage. It can already be used in production, but please set backups of the database and DO NOT expose the interface on the Internet.
    We highly recommended the use of a private dedicated and secured network. 

!!! warning "Upgrading to v1.4.0 ? Please please read the [upgrade documentation](operations/upgrades/#v140)"

![Timeline Example](_static/timeline_speed.gif){ align=center }


# Some questions you might have


## What can I do with Iris ? 

You can :   

- Run investigations with as many analysts as you want. Everyone has its own account   
- Run as many investigations as you want in parallel   
- For each investigation:  
    - Associate a customer    
    - Create a high level summary   
    - Create notes under the form of a Kanban board  
    - Create IOCs  
    - Create assets (computers, servers, accounts, firewalls, or anything you want)  
    - Associate IOCs with assets   
    - Obtain insights on assets and IOCs previously encountered in investigations   
    - Create a proper timeline referencing assets and IOCs  
    - Create an automated graph of the attack from the timeline   
    - Register evidences   
    - Upload and process of evidences through modular pipelines (eg: EVTX parsing and injection into a database or data visualizer)  
    - Enrich any mentioned case objects with external sources
    - Set and attribute tasks to people to keep track of everything   
    - Register every step of the investigation  
    - Generate a report based on templates, automatically filled with the elements registered in the investigation   
    - Generate a report of activity with every step registered as well as the auto-registered entries for each analyst   
- Search notes and IOCs across all investigations  
- Extend the mentioned case objects to fit your needs
- Integrates IRIS with your current infrastructure thanks to the API and the modules, which allows to extend the platform features. 

## What can I not do with Iris ?  
This is the part where we need you. Iris aims to be a collaborative project, so any idea is welcome.     
You can head to the Github of the project and create an issue with the idea.   

## What Iris is made of ?
Iris is mostly coded in Python 3. There is also some HTML, CSS and javascript for the interface. 

Under the hood, Iris relies on :

- Flask for the web engine 
- SQLAlchemy and PostgresSQL for the database 
- RabbitMQ for the jobs processing
- Nginx for the reverse proxy

## Can I be involved ?  
Absolutely. You can either [contact us](mailto:contact@dfir-iris.org>) directly or submit pull requests and ideas on the GitHub. 

## Who's behind Iris ? 
The idea was born in the French CSIRT of Airbus Cybersecurity, and created by a small group of friendly incident response analysts. Iris has been used since its early stage in 2020, on more than a hundred investigations including complex cyberattacks.

## Why was Iris published ? 
We felt a gap and we wanted to fill it. We believe open source tools driven by communities can only make them better. 