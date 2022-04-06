# Module IRIS VT 

!!! tip "*Introduced in IRIS v1.4.0*"

This module offers an interface with VirusTotal and IRIS to automatically enrich IOCs with VT insight.   
The source code is available [here](https://github.com/dfir-iris/iris-vt-module). It is installed by default but needs to be configured to be enabled.  

## Features
Two types of enrichement mecanism are proposed : 

- **Manual** : right-click on one or more IOCs and select ``Get VT insight``. This sends the targets IOCs to the module and insights will be fetched and applied. 
- **Automatic**:
    - On create : This automatically fetch VT insight for newly created IOC 
    - On update : This automatically  fetch VT insight upon updates of an IOC 

The following types of IOCs are handled by the module : 

- [x] ip-\*
- [x] domain
- [x] hashes of types md5, sha224, sha256, sha512

The insight request on an IOC not handled is simply ignored.  

Two types of insights are proposed : 

- **tags** : This adds a ``vt:malicious`` or ``vt:suspicious`` tag if the detection thresholds are met (configurable). For domains, an ASN tag can also be added. 
- **new attribute** : This adds a new attribute to the IOC with the VT insight. It is based on a configurable template.   


## Configuration 
The behavior of the module can be configured as needed. Head to the `Advanced` > `Modules` > `IrisVT` to change it.   

- **VT API Key** : API key used by the module to connect to VT 
- **VT Key is premium** : Set to True to indicate the provided API Key is premium.
- **Manual triggers on IOCs** : Provides a right-click menu option on IOCs to trigger the VT module on selected elements. 
- **Triggers automatically on IOC create**: If set to true, the module runs each time an IOC is created. Disabled by default. 
- **Triggers automatically on IOC update**: If set to true, the module runs each time an IOC is updated. Disabled by default. 
- **Assign ASN tag to IP** : If set to true, creates a new tag with ASN info on the target IP IOC. 
- **IOC tag malicious threshold** : Float detection ratio above which the module adds a ``vt:malicious``. To disable, add a value > 100. 
- **IOC tag suspicious threshold**: Float detection ratio above which the module adds a ``vt:suspicious``. To disable, add a value > 100. 
- **Add VT report as new IOC attribute**: Creates a new attribute on the IOC, base on the VT report. Templates define on this configuration are used. 
- **Domain report template**: Jinja2 report template for domain IOCs. Refers to the raw report to assess which fields are available. 
- **IP report template**: Jinja2 report template for IP IOCs. Refers to the raw report to assess which fields are available. 
- **Hash report template**: Jinja2 report template for hash IOCs. Refers to the raw report to assess which fields are available. 
