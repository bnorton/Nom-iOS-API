#Nom-iOS-API via [justnom.it](http://justnom.it)

### Quick (live) Examples of the userless API
- http://justnom.it/locations/here.json?lat=37.79693&lng=-122.399559
- http://justnom.it/activities.json?user_nid=4eccc0fbeef0a64dcf000001
- http://justnom.it/locations/search.json?lng=-122.3898&lat=37.81273&query=sushi

##Dependencies / Setup / Integration

###Assumptions:
- XCode 4.3+
- git
- current or new iOS app
- ARC based project (simple modifications can be made to make this a manually reference counted)
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
- Submit an Issue @ [https://github.com/bnorton/Nom-iOS-API/issues](https://github.com/bnorton/Nom-iOS-API/issues) or send mail to [support@justnom.it](support@justnom.it) if you have any issues.

###Design Choices:
1. Block based callbacks
  - This style of thinking and development keeps the post request handling in-line. All of your other code that helps bring 'data' to the user is there way not the post-request code as well. 
  - Blocks makes certain things more tightly coupled and more specific to a certain instance of a call. This can lead to loss of generality. However, in most cases you will not have this problem.
  - If the code that you find yourself duplicating is with the use of NMClient then you may need to consider how to abstract other parts of your MVC structure.
2. AFNetworking
  - It's a more lightweight and 'new' version of ASIHTTPRequest. I found the latter to be tough to wrangle due to the specific callback structure among other factors where the former seemed more grownup (and not deprecated).

#Example Usage for `current{User, Location}`:
####The user object holds the values for:
```
auth_token, user_nid, email, name, screen_name, image_url, created_at, updated_at, city and follower_count
```
``` ruby
NSDictionary *user = [[NMUtil currentUser] user];
[self setName:[user objectForKey:@"name"]];
[self setFollowersCount:[user objectForKey:@"follower_count"]];
...
```

#Example Usage:
 
####Note:
- {user,location}_nid is the internal `nom_id` of an item
- any variables in the examples that are of the form **_nid are simply variables.

##Locations:
####Here:
``` ruby
    [NMClient here:current_distance categories:nil cost:@"$$" limit:20
     success:^(NSDictionary *response) {
         filtered = [self filterResults:[response objectForKey:@"results"]];
         [ViewHelper showErrorInView:self.view message:@"Failed to parse locations around here"];
         [self updateComplete];
     }
     failure:^(NSDictionary *response) {
       [ViewHelper showErrorInView:self.view message:@"Failed to load items around here"];
       [self updateComplete];
     }];
```

####Location Search:
``` ruby
    [NMClient searchLocation:query location:where success:^(NSDictionary *response) {
        items = [response objectForKey:@"results"];
        [self updateComplete];
     } failure:^(NSDictionary *response) {
     }];
```

##Users:
####Register:
``` ruby
    [NMClient registerUserEmail:email.text password:password.text screen_name:nil success:^(NSDictionary *response) {
        NSDictionary *user = [[response objectForKey:@"results"] objectAtIndex:0];

        /** The next line should setup the user into currentUser for everything to work right*/

        [self setUpUser:user];
        [ViewHelper showInformationInView:self.view message:@"Successfully registered!"];
        [spinner hide:YES];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Failed to register"];
        [spinner hide:YES]; 
     }];
```

####Detail:
``` ruby
    [NMClient userDetail:user_nid success:^(NSDictionary *response) {
        [self setupUserContent:[[response objectForKey:@"results"] objectAtIndex:0]];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Failed to fetch user detail"];
     }];
```

####User Search (by name, screen_name, or email):
``` ruby
    [NMClient searchUser:query success:^(NSDictionary *response) {
        items = [response objectForKey:@"results"];
        [self updateComplete];
    } failure:^(NSDictionary *response) {
    }];
```

##Following:
####Follow another Nommer:
``` ruby
    [NMClient follow:user_nid success:^(NSDictionary *response) {
        [ViewHelper showInfoInView:self.view message:[NSString stringWithFormat:@"Now Following %@", user_name]];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:[NSString stringWithFormat:@"Cound not Follow %@", user_name]];
     }];
```

####A user's followers:
``` ruby
    [NMClient followersFor:user_nid withSuccess:^(NSDictionary *_response) {
        followers = [response objectForKey:@"results"];
        [self updateComplete];
     } failure:^(NSDictionary *_response) {
        followers = nil; [self updateComplete];
        [ViewHelper showErrorInView:self.view message:@"Couldn't load followers"];
     }];
```

##Timeline:
####Fetch the currentUser's Timeline:
``` ruby
    [NMClient activitiesWithSuccess:^(NSDictionary *response) {
        recommends = [response objectForKey:@"recommends"];
        thumbs = [response objectForKey:@"thumbs"];
        [self updateAndMerge];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Timeline fetch failed"];
        [self updateAndMerge];
     }];
```

##Rankings:
####Rank a Location `the best`:
######If this location_nid has a rank or the user has ranked another location at this level then it will be replaced by this one.
``` ruby
    #define RANK_BEST @"1"
    #define RANK_SECOND @"2"
    #define RANK_THIRD @"3"
    ...
    [NMClient rank:location_nid value:rank_value facebook:NO
     success:^(NSDictionary *response) {
        [ViewHelper showInfoInView:self.view message:@"Rank was successful"];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Rank was not added successfully"];
     }];
```

####Remove a rank:
######Rank will simply be removed and its value can be used on another location_nid:
``` ruby
    [NMClient removeRank:rank_nid
     success:^(NSDictionary *response) {
        [ViewHelper showInfoInView:self.view message:@"Rank was removed successful"];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Rank was not removed successfully"];
     }];
```

##Recommendations:
####Recommend a location to followers:
``` ruby
    [NMClient recommend:location_nid imageNid:image_nid text:text facebook:NO token:nil
     success:^(NSDictionary *response) {
        [ViewHelper showInfoInView:self.view message:@"Recommend was successful"];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"Nom publication failed :("];
     }];
```

##Thumbs:
####Thumb a Location with meh:
``` ruby
    #define THUMB_UP @"1"
    #define THUMB_MEH @"2"
    ...
    [NMClient thumbLocation:location_nid value:MEH success:^(NSDictionary *response) {
        [ViewHelper showInfoInView:self.view message:@"Saved your thumb."];
     } failure:^(NSDictionary *response) {
        [ViewHelper showErrorInView:self.view message:@"There was an issue saving your thumb."];
     }];
```

##Images:
####Image Fetch (to pre-cache an image for later use):
``` ruby
    NSString *url = nil;
    @try { url = [[[l objectForKey:@"images"] objectAtIndex:0] objectForKey:@"url"]; }
    @catch(NSException *ex) {}
    if(url) { [NMClient imageFetch:url]; }
    
    /** ...then later just use */
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5 ,90, 90)];
    [image setImageWithURL:[NSURL urlWithString:url]];
```
