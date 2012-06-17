//
//  BackendConnecter.m
//  QRConnect
//
//  Created by Brandon Millman on 6/13/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "BackendConnecter.h"
#import "ASIHTTPRequest.h"
#import "SRWebSocket.h"

@interface BackendConnecter () <SRWebSocketDelegate> 
@end

@implementation BackendConnecter

@synthesize delegate;
@synthesize webSocket;

static BackendConnecter *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (BackendConnecter *)sharedInstance {
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

    }
    
    return self;
}

- (void) requestQR
{
    NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        [self.delegate receiveQR:[request responseString]];
        //[self connectQR:[request responseString]];
        [self connectQR:@"Blah"];
    }];
    [request setFailedBlock:^{
        [self.delegate requestQRFailed:[request error]];
    }];
    [request startAsynchronous];
}

- (void) connectQR:(NSString *)qrCode;
{
    [self closeQR];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:9000/chat"]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)closeQR;
{
    if (self.webSocket != nil) {
        [self.webSocket close];
        self.webSocket = nil;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    [self.delegate receiveMessage:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Error");
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Closed"); 
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
