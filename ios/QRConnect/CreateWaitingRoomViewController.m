//
//  CreateWaitingRoomViewController.m
//  QRConnect
//
//  Created by Brandon Millman on 6/15/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "CreateWaitingRoomViewController.h"
#import "BackendConnecter.h"

@implementation CreateWaitingRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BackendConnecter  sharedInstance] requestQR];
}

@end
