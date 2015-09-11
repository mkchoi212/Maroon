#Maroon
A replacement for the old, antiquated, horrible, sluggish, and ugly app called TAMUMobile.

## Setting up the project
```
pod install
```
If you don't have cocoapods installed on your machine, run this command in order to install the gem
```
sudo gem install cocoapods
```
*Please note when updating pods, `AFNetworking` may throw errors regarding dependencies/modules. Replace all import statements with warnings with `#import <AFNetworking/AFNetworking.h>`. Will replace `AFNetworking` with `Alamofire` soon though so yeah..*
 
##Future Improvements
- Slide show in the home view of all images from the RSS feed
- Scheduler in home screen via navgiation bar?
- Link for donwloading images from the RSS feed is currently being RegExed. Maybe use an HTML parser to do this in the future? The current RegEx can be found in the `StringExtension.swift`.

## Pull Requests
I actively welcome your pull requests.

1. Fork the repo and create your branch from `master` (or not, it's up to you ***but please don't merge your own PRs!!!***)
2. If you've added code that should be tested, add tests.
3. Please make your PR's small, manageable and most importantly, understandable as I will only be able to check on them every once in awhile.
4. Oh also, good commit/PR messages pls

## Issues  
I'm using GitHub issues to track public bugs. Please ensure your description is
clear and has sufficient instructions to be able to reproduce the issue.

## Requirements
- iOS 8.0 or higher
- ARC

# Licence
TAMU Mobile is released under the MIT license. See LICENSE for details.
