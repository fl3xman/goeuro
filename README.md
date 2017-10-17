# goeuro 

## Overview

Minimum deployment target iOS version is 8 (XCode 8+ supports 8+ only).

## Install

Install DM for xcode projects `gem install cocoapods`, then clone this repository and run following.

```
cd /to/your/template/path
pod install
```

Then use `GoeuroApp.xcworkspace` instead of project.

## Used libs & frameworks

### Networking

Alamofire - data model request
AlamofireImage - image request
AlamofireObjectMapper - map response directly to data model with object mapper
ObjectMapper - map json to model and vice-versa

### Data-binding

ReactiveSwift - deliver data from service to view 
ReactiveCocoa - bind data to view
ReactiveObjCBridge - bridge between objc and swift reactive api

### Scafolding (registration/resolving)
 
Swinject - scafold models & viewmodels
SwinjectStoryboard - scafold storyboards with above
SwinjectAutoregistration - autoregistration from constructor