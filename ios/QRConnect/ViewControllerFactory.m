//
//  ViewControllerFactory.m
//  QRConnect
//
//  Created by Brandon Millman on 6/12/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "ViewControllerFactory.h"
#import "WaitingRoomViewController.h"
#import "SettingsViewController.h"

@implementation ViewControllerFactory

@synthesize controllers;

static ViewControllerFactory *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (ViewControllerFactory *)sharedInstance {
if (sharedInstance == nil) {
    sharedInstance = [[super allocWithZone:NULL] init];
}

return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        controllers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(UIViewController *) makeController:(NSString *)key
{
    UIViewController *result = [controllers objectForKey:key];
    
    if (result == nil) {
        Class className = NSClassFromString(key);
        result = [[className alloc] initWithNibName:key bundle:nil];
        [controllers setObject:result forKey:key];
    }
    
    return result;

}



// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}



@end
