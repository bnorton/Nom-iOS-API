#Making Location Aware Applications
###NMClient includes bindings for easily asking for the device's current location

#####In it's current form you can just ask for the latitude and longitude simply:

``` ruby
latitude = [[NMUtil currentLocation] lat];
longitude = [[NMUtil currentLocation] lng];
```

#####You may want to start and stop updating the user's location for better battery..
``` ruby
[[NMUtil currentLocation] stopUpdating];

/** ..and later based on some user action such as intent to search */
[[NMUtil currentLocation] startUpdating];
```
