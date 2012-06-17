//
//  MainMenuViewController.m
//  QRConnect
//
//  Created by Brandon Millman on 6/11/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "MainMenuViewController.h"
#import "QRConnecter.h"

@interface MainMenuViewController () <QRConnecterDelegate>

@end

@implementation MainMenuViewController

@synthesize connecter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    connecter = [[QRConnecter alloc] init];
    connecter.delegate = self;

}

- (void)viewDidUnload
{
    self.connecter = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) startButtonPressed:(id)sender
{
    [self presentModalViewController:[self.connecter createQRCode] animated:YES];
}

- (IBAction) joinButtonPressed:(id)sender
{
    [self presentModalViewController:[self.connecter joinQRCode] animated:YES];
}

-(void)connectionEstablished:(UIViewController *)controller
{
    //[controller dismissModalViewControllerAnimated:YES];
}

-(void) connectionFailed:(UIViewController *)controller
{
    //[controller dismissModalViewControllerAnimated:YES];
}

- (void)dealloc 
{
    [connecter release];
    [super dealloc];
}

@end
