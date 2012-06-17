//
//  SettingsViewController.m
//  QRConnect
//
//  Created by Brandon Millman on 6/13/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewControllerFactory.h"

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) doneAction:(id) sender
{
    UIViewController *next = [[ViewControllerFactory sharedInstance] makeController:WAITING_ROOM];
    [self.navigationController pushViewController:next animated:YES];  
}

-(IBAction) cancelAction:(id) sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
