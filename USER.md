###Having Persistent Application State
#####NMCLient provides faculties for storing persistent application state into the NSUserDefaults without the any hassle with sync inline

######Use `currentUser` as a key-value store in your app
Set an arbitrary string
``` ruby
NSString *_key = @"the-key-for-this";
[[NMUtil currentUser] setString:@"some value that should persist" forKey:_key];
```

######Get it back later
``` ruby
NSString *importantValue = [[NMUtil currentUser] getStringForKey:_key];
```

######Store the date of the last update of some item to NOW
``` ruby
NSString *dateKey = @"some-date-key-name";
[[NMUtil currentUser] setDate:[NSDate date] forKey:dateKey];
```

######Get that date back later.
``` ruby
NSDate *last_update = [[NMUtil currentUser] getDateForKey:dateKey];
```

######Store boolean values and test for certain states at app launch
``` ruby
NSString *yesKey = @"yes";
[[NMUtil currentUser] setBoolean:YES forKey:yesKey];
```

``` ruby
BOOL yesOrNo = [[NMUtil currentUser] getBooleanForKey:yesKey];
```
