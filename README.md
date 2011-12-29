# Nom-iOS-API http://justnom.it

### Quick Examples of the userless API
- https://justnom.it/locations/here.json?lat=37.7969398498535&lng=-122.399559020996
- https://justnom.it/activities.json?user_nid=4eccc0fbeef0a64dcf000001
- https://justnom.it/locations/search.json?lng=-122.3898&lat=37.81273&query=sushi

## Dependencies / Setup / Integration

###Assumptions:
- XCode 4.3+
- git
- current or new iOS app
- ARC based project (simple modifications can be made to make this a manually managed memory library)
- common sense

###Dependencies:
- AFNetworking (https://github.com/AFNetworking/AFNetworking) ==> follow directions to integrate this
- Make to change the build flags to include `-fno-objc-arc` for the files of AFNetworking

###Setup:

####Copy Files:
1.  `git clone git@github.com:bnorton/Nom-iOS-API.git`
2.  Open your iOS project and navigate to the top level folder of the project
3.  Right-click and select `Add files to "project_name"`
4.  In the file select window navigate to where you checked out the repo (`Nom-iOS-API`) to.
5.  NOTE: For the next step check the boxes that say `Copy items into destination folder if needed` AND `Create groups for any added folders`.
5a. Feel free to link the folders and not copy to dest folder if you have done so in the past.
6.  You add the `Nom-iOS-API` folder to your project 

####Test:
1.  Build your project to make sure you have no errors `CMD + b`
2.  In the files were calls to the API will be made simply add `#import "NMClient.h"` to the top.

####For Help:
- Submit an Issue @ <https://github.com/bnorton/Nom-iOS-API/issues> or send mail to <support@justnom.it> if you have any issues.

#Example Usage:
## Locations
    [NMClient here:current_distance categories:nil cost:@"$$"  limit:20
     success:^(NSDictionary *response) {
           @try {
               filtered = [self filterResults:[response objectForKey:@"results"]];
           } @catch (NSException *ex) {
               [ViewHelper showErrorInView:self.view message:@"Failed to parse locations around here"];
           }
           [self updateComplete];
     }
     failure:^(NSDictionary *response) {
       [ViewHelper showErrorInView:self.view message:@"Failed to load items around here"];
       [self updateComplete];
     }];

## Users
    [NMHTTPClient registerUserEmail:email.text password:password.text screen_name:nil success:^(NSDictionary *response) {
        @try {
            NSDictionary *user = [[response objectForKey:@"results"] objectAtIndex:0];
            [self setUpUser:user];
            [self setUpdateDate:[NSDate date]];
            [ViewHelper showInformationInView:self.view message:@"Successfully registered!"];
        } @catch (NSException *ex) { }
        [spinner hide:YES];
    } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Failed to register"];
        [spinner hide:YES]; 
    }];

## Following

## Rankings

## Recommendations

## Thumbs
