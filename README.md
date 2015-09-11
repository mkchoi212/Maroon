# Setting up the project
```
pod install
```
If you don't have cocoapods installed on your machine, run this command in order to install the gem
```
sudo gem install cocoapods
```
*Please note when updating pods, `AFNetworking` may throw errors regarding dependencies/modules. Replace all import statements with warnings with `#import <AFNetworking/AFNetworking.h>` for now.

# Requirements
- iOS 8.0 or higher
- ARC

# Making changes
If you want to work on something, **PLEASE MAKE A NEW BRANCH or FORK THIS REPO** and make a pull request, which I will first review and then approve.

##Known Bugs
Please refer to the issues tab on the right.

##Improvements
- Slide show in the home view of all images from the RSS feed
- Scheduler in home screen via navgiation bar?
- Link for donwloading images from the RSS feed is currently being RegExed. Maybe use an HTML parser to do this in the future? The current RegEx can be found in the `StringExtension.swift`.

# Licence
TAMU Mobile is released under the MIT license. See LICENSE for details.
