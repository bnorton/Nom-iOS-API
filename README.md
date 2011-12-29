# Nom-iOS-API http://justnom.it

### Quick Examples of the userless API
- https://justnom.it/locations/here.json?lat=37.7969398498535&lng=-122.399559020996
- https://justnom.it/activities.json?user_nid=4eccc0fbeef0a64dcf000001
- https://justnom.it/locations/search.json?lng=-122.3898&lat=37.81273&query=sushi

## Dependencies / Setup / Integration

####Assumptions:
- > XCode 4.2.x
- git
- current or new iOS app
- ARC based project (simple modifications can be made to make this a manually managed memory library)
- common sense

####Dependencies:
- AFNetworking (https://github.com/AFNetworking/AFNetworking) ==> follow directions to integrate this
- Make to change the build flags to include `-fno-objc-arc` for the files of AFNetworking

####Setup:
#####Copy Files:
1.  `git clone git@github.com:bnorton/Nom-iOS-API.git`
2.  Open your iOS project and from the top level folder of the project in the 'list of files and folders' view, right-click and select `Add files to "project_name"`
3.  In the file select window that comes up navigate to where you checked out the repo (`Nom-iOS-API`) to.
4.  You add the `src` folder to your project (NOTE: check the boxes that say `Copy items into destination folder if needed` AND `Create groups for any added folders`. This makes things easier but feel free to link the folders and not copy if you have done so in the past).

#####Test:
5.  Build your project to make sure you have no errors `CMD + b`
6.  In the files were calls to the API will be made simply add `#import "NMClient.h"` to the top.
7.  .

#####For Help:
- Submit an Issue @ <https://github.com/bnorton/Nom-iOS-API/issues> or send mail to <support@justnom.it> if you have any issues.

#Examples:
## Locations

## Users

## Following

## Rankings

## Recommendations

## Thumbs
