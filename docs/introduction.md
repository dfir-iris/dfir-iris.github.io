# Introduction

In a nutshell, IRIS is a collaborative platform for incident response analysts allowing to share investigations at a technical level.  
It's web application, so it can be either installed on a fixed-server, or on a laptop for roaming investigations where internet might not be available. 

It is born following the struggle to share long and complex investigations among analysts. Most of the current similar platforms are either commercial or targeting the incident handling and triage steps, not the investigation itself. 

The project is available at [https://github.com/dfir-iris/iris-web](https://github.com/dfir-iris/iris-web)

!!! hint "I've read enough, I want to try it"

    Iris comes in dockers - you only need Docker Compose and you'll be set in a few minutes. 
    Follow [the guide](/getting_started/). 


!!! danger "Disclaimer"

    Iris is in its early stage. It can already be used in production, but please set backups of the database and DO NOT expose the interface on the Internet.
    We highly recommended the use of a private dedicated and secured network. 

!!! warning "Upgrading to v1.4.0 ? Please read the [upgrade documentation](/operations/upgrades/#v140)"

![Timeline Example](_static/timeline_speed.gif){ align=center }

