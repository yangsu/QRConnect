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

@interface WaitingRoomViewController() <BackendDelegate>
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    
    UISwipeGestureRecognizer *leftRecognizer;
    
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [(UIView *)self.view addGestureRecognizer:leftRecognizer];
    [leftRecognizer release];
    
    UISwipeGestureRecognizer *rightRecognizer;

    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [(UIView *)self.view addGestureRecognizer:rightRecognizer];
    [rightRecognizer release];
    
    [self.spinnerView startAnimating];
    
    BackendConnecter *backEnd = [BackendConnecter sharedInstance];
    backEnd.delegate = self;
}

-(void)handleLeftSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (!isCurled)
    {
        CGRect r = self.frontView.frame;
        [self.curlView drawViewOnFrontOfPage:self.frontView];
        self.curlView.opaque = NO; //Transparency on the next page (so that the view behind curlView will appear)
        self.curlView.pageOpaque = YES; //The page to be curled has no transparency
        [self.curlView curlView:self.frontView cylinderPosition:CGPointMake(r.size.width*0.5, r.size.height*0.67) cylinderAngle:M_PI/8 cylinderRadius:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad? 160: 80 animatedWithDuration:0.6];
        isCurled = YES;        
    }
}

-(void)handleRightSwipe:(UISwipeGestureRecognizer *)recognizer {
    if(isCurled)
    {
        [self uncurlAction:nil];
    }
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
    NSLog(@"message");
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
    return !isCurled;
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

- (IBAction) uncurlAction:(id)sender
{
    [self.curlView uncurlAnimatedWithDuration:0.6];
    isCurled = NO;
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
