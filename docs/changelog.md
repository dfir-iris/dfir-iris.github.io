# Changelog

For upgrades instructions, please see the [Upgrades page](/operations/upgrades). 

## [v1.4.2](https://github.com/dfir-iris/iris-web/releases/tag/v1.4.2) <small>_ April 22, 2022 _</small> 
!!! danger "Please read [upgrades instructions](https://dfir-iris.github.io/operations/upgrades/#v142) if you are upgrading from v1.3.1 or lower." 

**Improvements** :   

* Possibility to duplicates events in timeline - [#91](https://github.com/dfir-iris/iris-web/pull/91)  
* Possibility to filter timeline with basic query - [#94](https://github.com/dfir-iris/iris-web/issues/94)   

**Fixes** :   

* Integer limit on file size in evidences - [#89](https://github.com/dfir-iris/iris-web/issues/89)  
* Gradient in closed cases   
* on-preload hooks list handling - [#92](https://github.com/dfir-iris/iris-web/issues/92)   
* tags issue - [#88](https://github.com/dfir-iris/iris-web/pull/88)   
* Case info modal from case - [#93](https://github.com/dfir-iris/iris-web/issues/93)   
* Multiple UI issues   

## [v1.4.1](https://github.com/dfir-iris/iris-web/releases/tag/v1.4.1) <small>_ April 8, 2022 _</small> 
 
!!! danger "Please read [upgrades instructions](https://dfir-iris.github.io/operations/upgrades/#v141) if you are upgrading from v1.3.1 or lower." 

* Fixes a [scrolling issue](https://github.com/dfir-iris/iris-web/pull/86) of the timeline when events are being popped 

## [v1.4.0](https://github.com/dfir-iris/iris-web/releases/tag/v1.4.0) <small>_ April 6, 2022 _</small> 
*A bug fixe exists for this version. See v1.4.1* 

!!! danger "Please read [upgrades instructions](https://dfir-iris.github.io/operations/upgrades/#v141) if you are upgrading from v1.3.1 or lower." 

* Hooks, adding the ability for modules to react on almost anything happening on the plateform in [#75](https://github.com/dfir-iris/iris-web/pull/75)
* New type of modules that can handles hooks 
* VirusTotal beta integration as a processor module 
* MISP beta integration as a processor module 
* Custom attributes on all case objects allowing to extend the default fields 
* A compact timeline view for better visbility 
* Premises of a dark theme
* Resiliency of docker volume in [#80](https://github.com/dfir-iris/iris-web/pull/80)
* Minor improvements in [#69](https://github.com/dfir-iris/iris-web/pull/69), [#79](https://github.com/dfir-iris/iris-web/pull/79)
* Bug fixes in [#70](https://github.com/dfir-iris/iris-web/pull/70), [#73](https://github.com/dfir-iris/iris-web/pull/73), [#77](https://github.com/dfir-iris/iris-web/pull/77)
* Security fixes 


## [v1.3.1](https://github.com/dfir-iris/iris-web/releases/tag/v1.3.1) <small>_ March 19, 2022 _</small> 

- Fixes wheel issue preventing proper build of the docker, as described in [#83](https://github.com/dfir-iris/iris-web/pull/83)

## [v1.3.0](https://github.com/dfir-iris/iris-web/releases/tag/v1.3.0) <small>_ January 24, 2022 _</small> 

* Added the ability to batch upload IOC from a CSV file in  [#26](https://github.com/dfir-iris/iris-web/pull/26)
* Added the ability to batch upload assets from a CSV
* Screenshot - Export contents of any case pages as PNG in [#35](https://github.com/dfir-iris/iris-web/pull/35)
* Export timeline as CSV in [#47](https://github.com/dfir-iris/iris-web/pull/47)
* Improved timeline loading time by x10 - loads thousands of events in a sec 
* New auto parsing of dates in events addition/updates
* Brand new timeline visualisations 
* Improved assets loading time 
* Shared links - easily share any case objects with your collaborators
* Right panel now offers last activities for user's current case
* Added assets tags in [#37](https://github.com/dfir-iris/iris-web/pull/37)
* New API endpoints in [#53](https://github.com/dfir-iris/iris-web/pull/53)
* Auto migration of database for next releases
* Indication of mandatory fields in forms 
* General bug fixes, stability and UI improvement 

## [v1.2.1](https://github.com/dfir-iris/iris-web/releases/tag/v1.2.1) <small>_ December 31, 2021 _</small> 

* Added ATT&CK tactics by @ecapuano in [#9](https://github.com/dfir-iris/iris-web/pull/9)
* Added screenshot and video link in readme in [#12](https://github.com/dfir-iris/iris-web/pull/12)
* Fixed duplicated path to add customer in [#4](https://github.com/dfir-iris/iris-web/pull/4)
* Fixed asset description data validation client side in [#7](https://github.com/dfir-iris/iris-web/pull/7)
* Fixed tooltip in [#10](https://github.com/dfir-iris/iris-web/pull/10)
* Add a per-column filtering field in the case view by in [#15](https://github.com/dfir-iris/iris-web/pull/15)