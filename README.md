# How to install
```
pod install
```
If you don't have cocoapods installed on your machine, run this command in order to install the gem
```
sudo gem install cocoapods
```
# Requirements
- iOS 8.0 or higher
- ARC

# Structure
The app is divided into four parts
- Home
- Maps
- Food
- Settings

# Making changes
If you want to work on something, PLEASE MAKE A NEW BRNAHC and make a pull request, which I will first review and then approve.

#Known Bugs
## Reverse-geocoding
Currently, Apple and Google's reverse-geocoding service is used in order to get the cooridnates of buildings on campus. Maybe because campus buidlings within A&M's campus is not well indexed within mapping servers, some locations produce inaccurate coordinates. This maybe could be solved by tweaking with the structure of the address fed into the server?

##Contacts
Animations for tapping and holding onto contact tableview cells is slightly unnatural.

#Future Features
- Slide show in the home view of all images from the RSS feed
- Scheduler in home screen via navgiation bar?

# Licence
TAMU Mobile is released under the MIT license. See LICENSE for details.
