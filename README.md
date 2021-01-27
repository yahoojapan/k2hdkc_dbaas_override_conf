K2HDKC DBaaS Override Configuration(K2HDKC DBaaS Utilities)
-----
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yahoojapan/k2hdkc_dbaas_override_conf/blob/master/COPYING)
[![GitHub forks](https://img.shields.io/github/forks/yahoojapan/k2hdkc_dbaas_override_conf.svg)](https://github.com/yahoojapan/k2hdkc_dbaas_override_conf/network)
[![GitHub stars](https://img.shields.io/github/stars/yahoojapan/k2hdkc_dbaas_override_conf.svg)](https://github.com/yahoojapan/k2hdkc_dbaas_override_conf/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/yahoojapan/k2hdkc_dbaas_override_conf.svg)](https://github.com/yahoojapan/k2hdkc_dbaas_override_conf/issues)

## **K2HDKC** **DBaaS**
![K2HDKC DBaaS](https://dbaas.k2hdkc.antpick.ax/images/top_k2hdkc_dbaas.png)

## Overview
**K2HDKC DBaaS** (DataBase as a Service of K2HDKC) is a basic system that provides [K2HDKC(K2Hash based Distributed Kvs Cluster)](https://k2hdkc.antpick.ax/index.html) as a service.  
K2HDKC DBaaS works with OpenStack or the Trove component of OpenStack to provide database functionality as a service.  

Users can easily launch, scale, back up, and restore K2HDKC clusters using the Trove Dashboard(GUI) and the Trove-provided CLI(OpenStack CLI).  
And you can also easily launch and scale your K2HDKC cluster without using Trove.  

Detailed documentation for K2HDKC DBaaS can be found [here](https://dbaas.k2hdkc.antpick.ax/).

## K2HKDC DBaaS system
K2HDKC DBaaS provides its functionality through Trove as a panel(feature) of OpenStack.  
Similar functionality is also provided using the K2HR3 API CLI.  
And the [K2HR3](https://k2hr3.antpick.ax/) system is used as the back end as an RBAC(Role Base Access Control) system dedicated to K2HDKC DBaaS.  
Users typically do not need to use the K2HR3 system directly, and their functionality as DBaaS uses the Trove dashboard (or Trove CLI) or the CLI provided by the K2HR3 API.  

The overall system overview diagram is shown below.  
![K2HDKC DBaaS system](https://dbaas.k2hdkc.antpick.ax/images/overview.png)  

## K2HDKC DBaaS Override Configuration
**K2HDKC DBaaS Override Configuration** is a setting for connecting each component running on the Virtual Machine that enjoys the functions of K2HDKC DBaaS.  
This Configuration allows CHMPX and K2HDKC components to work together and exchange data with K2HR3.  

## Documents
[K2HDKC DBaaS Document](https://dbaas.k2hdkc.antpick.ax/index.html)  
[Github wiki page](https://github.com/yahoojapan/k2hdkc_dbaas_override_conf/wiki)

[About k2hdkc Document](https://k2hdkc.antpick.ax/index.html)  
[About chmpx Document](https://chmpx.antpick.ax/index.html)  
[About k2hr3 Document](https://k2hr3.antpick.ax/index.html)  

[About AntPickax](https://antpick.ax/)  

## Repositories
[k2hdkc](https://github.com/yahoojapan/k2hdkc)  
[chmpx](https://github.com/yahoojapan/chmpx)  
[k2hr3](https://github.com/yahoojapan/k2hr3)  
[k2hr3_app](https://github.com/yahoojapan/k2hr3_app)  
[k2hr3_api](https://github.com/yahoojapan/k2hr3_api)  

## Packages
[k2hdkc(packagecloud.io)](https://packagecloud.io/app/antpickax/stable/search?q=k2hdkc)  
[chmpx(packagecloud.io)](https://packagecloud.io/app/antpickax/stable/search?q=chmpx)  
[k2hr3-app(npm packages)](https://www.npmjs.com/package/k2hr3-app)  
[k2hr3-api(npm packages)](https://www.npmjs.com/package/k2hr3-api)  

### License
This software is released under the MIT License, see the license file.

### AntPickax
K2HDKC DBaaS Override Configuration is one of [AntPickax](https://antpick.ax/) products.

Copyright(C) 2021 Yahoo Japan Corporation.
