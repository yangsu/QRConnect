//
//  WaitingRoomtViewController.m
//  QRConnect
//
//  Created by Brandon Millman on 6/11/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "WaitingRoomViewController.h"
#import "FileManager.h"
#import "Barcode.h"
#import "ViewControllerFactory.h"
#import "BackendConnecter.h"
#import "XBCurlView.h"
#import "DNBSwipyNavigationController.h"
#import "ConnectListViewController.h"


@interface WaitingRoomViewController() <BackendDelegate, DNBSwipyNavigationControllerDelegate>
{
    BOOL isCurled;
}
@property (nonatomic, assign) BOOL isCurled;
@end

@implementation WaitingRoomViewController


@synthesize curlView;
@synthesize imageView;
@synthesize frontView;
@synthesize backView;
@synthesize spinnerView;
@synthesize delegate;
@synthesize isCurled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    
    [c.view addGestureRecognizer:c.panGestureRecognizer];
    
    c.leftController = [[UIViewController alloc] initWithNibName:@"ConnectListViewController" bundle:nil];
    c.rightController = [[UIViewController alloc] initWithNibName:@"ChatRoomViewController" bundle:nil];
    c.bounceEnabled = YES;
    if (self == [c.viewControllers objectAtIndex:0]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"friends"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftController)];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat"] style:UIBarButtonItemStylePlain target:self action:@selector(showRightController)];
    }
    
    self.navigationController.delegate = self;
    
    
    
//    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar-button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar"] forBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.frontView.frame;
    self.curlView = [[[XBCurlView alloc] initWithFrame:r] autorelease];
    
    [self.spinnerView startAnimating];
    
    BackendConnecter *backEnd = [BackendConnecter sharedInstance];
    backEnd.delegate = self;
}



- (void)showLeftController {
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    if (c.currentPosition != ControllerPositionRight) {
        c.currentPosition = ControllerPositionRight;
    } else {
        c.currentPosition = ControllerPositionRegular;
    }
}
- (void)showRightController {
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    if (c.currentPosition != ControllerPositionLeft) {
        c.currentPosition = ControllerPositionLeft;
    } else {
        c.currentPosition = ControllerPositionRegular;
    }
}

- (BOOL)rightControllerEnabled {
    return YES;
}

- (void) receiveQR:(NSString *)qrCode
{
    [self setQRImage:@"ssdfsdf"];
}

- (void) requestQRFailed:(NSError *)error
{
}

- (void) receiveMessage:(id)message
{
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    [((ConnectListViewController *)c.leftController).users addObject:@"YOLOLO"];
}

- (void) setQRImage:(NSString *)qrCode
{
    Barcode *barcode = [[Barcode alloc] init];
    [barcode setupQRCode:qrCode];
    [self.spinnerView stopAnimating]; 
    [self.imageView setImage:barcode.qRBarcode];
    [barcode release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // After a rotation we have to recreate the XBCurlView because the page mesh must be recreated in the right dimensions.
    CGRect r = self.frontView.frame;
    self.curlView = [[[XBCurlView alloc] initWithFrame:r] autorelease];
}


- (IBAction) doneAction:(id)sender
{
    //[self.delegate connectionEstablished:self];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction) curlAction:(id)sender
{
    CGRect r = self.frontView.frame;
    [self.curlView drawViewOnFrontOfPage:self.frontView];
    self.curlView.opaque = NO; //Transparency on the next page (so that the view behind curlView will appear)
    self.curlView.pageOpaque = YES; //The page to be curled has no transparency
    [self.curlView curlView:self.frontView cylinderPosition:CGPointMake(r.size.width*0.5, r.size.height*0.67) cylinderAngle:M_PI/8 cylinderRadius:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad? 160: 80 animatedWithDuration:0.6];
    self.isCurled = YES;   
    
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    [c.view removeGestureRecognizer:c.panGestureRecognizer];

}

- (IBAction) uncurlAction:(id)sender
{
    [self.curlView uncurlAnimatedWithDuration:0.6];
    self.isCurled = NO;
   
    DNBSwipyNavigationController *c = (DNBSwipyNavigationController*)self.navigationController;
    [c.view addGestureRecognizer:c.panGestureRecognizer];
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.curlView = nil;
    self.frontView = nil;
    self.backView = nil;
    self.spinnerView = nil;
    [super viewDidUnload];
}

- (void)dealloc 
{
    [imageView release];
    [curlView release];
    [frontView release];
    [backView release];
    [spinnerView release];
    [delegate release];
    [super dealloc];
}

@end
