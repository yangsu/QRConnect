//
//  QRConnecter.m
//  QRConnect
//
//  Created by Brandon Millman on 6/12/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "QRConnecter.h"
#import "ViewControllerFactory.h"
#import "WaitingRoomViewController.h"
#import "BackendConnecter.h"

@interface QRConnecter () <WaitingRoomDelegate, BackendDelegate>

@end

@implementation QRConnecter

@synthesize delegate;
@synthesize navigationController;


-(UIViewController *) createQRCode;
{
    return [self setUpViewController:CREATE_WAITING_ROOM];
}

-(UIViewController *) joinQRCode;
{
    return [self setUpViewController:JOIN_WAITING_ROOM];

}

-(UIViewController *) setUpViewController:(NSString *) identifier
{
    UIViewController *first = [[ViewControllerFactory sharedInstance] makeController:identifier];
    ((WaitingRoomViewController *)first).delegate = self;
    return first;
}

- (void) connectionEstablished: (WaitingRoomViewController *) controller
{
    [BackendConnecter sharedInstance].delegate = self;
    [self.delegate connectionEstablished:controller];
}

- (void) connectionFailed:(WaitingRoomViewController *)controller
{
    //[self.delegate connectionFailed:controller];
}

-(void) receiveQR:(NSString *) qrCode
{
    
}

-(void) requestQRFailed:(NSError *) error
{
    
}


- (void)dealloc 
{
    [delegate release];
    [navigationController release];
    [super dealloc];
}

@end
