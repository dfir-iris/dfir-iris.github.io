# Module IRIS MISP 

!!! tip "*Introduced in IRIS v1.4.0*"  


This module offers an interface with MISP and IRIS to automatically enrich IOCs with MISP insight.   


The source code is available [here](https://github.com/dfir-iris/iris-misp-module). It is installed by default but needs to be configured to be enabled.  

!!! info "Note" 
    The module is in its early stage and new features will be added over time.


## Features 
Two types of enrichement mecanism are proposed : 

- **Manual** : right-click on one or more IOCs and select ``Get MISP insight``. This sends the targets IOCs to the module and insights will be fetched and applied. 
- **Automatic**:
    - On create : This automatically fetch MISP insight for newly created IOC 
    - On update : This automatically  fetch MISP insight upon updates of an IOC 


The following types of IOCs are handled by the module : 

- [x] ip-\*
- [x] domain
- [x] hashes of types md5, sha224, sha256, sha512

The insight request on an IOC not handled is simply ignored.  

The insights take the form of attributes added to the IOC. They are based on configurable templates.  

## Configuration 
The behavior of the module can be configured as needed. Head to the `Advanced` > `Modules` > `IrisMISP` to change it.   

- **MISP configuration** : A JSON describing the MISP access. See below for the structure.  
- **Add MISP report as new IOC attribute** : If set to true, the module adds a new attribute with the MISP insight. 
- **Domain report template** : Provides a right-click menu option on IOCs to trigger the MISP module on selected elements. 
- **Triggers automatically on IOC create**: If set to true, the module runs each time an IOC is created. Disabled by default. 
- **Triggers automatically on IOC update**: If set to true, the module runs each time an IOC is updated. Disabled by default. 
- **Domain report template**: Jinja2 report template for domain IOCs. Refers to the raw report to assess which fields are available. 
- **IP report template**: Jinja2 report template for IP IOCs. Refers to the raw report to assess which fields are available. 
- **Hash report template**: Jinja2 report template for hash IOCs. Refers to the raw report to assess which fields are available. 

### MISP configuration 
At the time, only one MISP can be added. Future version might handled more than one MISP.    
The expected structure is the following :  

```json
{
    "name": "Public_MISP", 
    "type":"public", 
    "url":["https://testmisp"],
    "key":["<apikey>"], 
    "ssl":[false]
}
```