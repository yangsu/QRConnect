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

@synthesize imageView;
@synthesize curlView;
@synthesize delegate;
@synthesize isCurled;

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
    
    CGRect r = CGRectZero;
    r.size = self.view.bounds.size;
    self.curlView = [[[XBCurlView alloc] initWithFrame:r] autorelease];
    [self.curlView drawViewOnFrontOfPage:self.view];
    self.curlView.opaque = NO;
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [(UIView *)self.curlView addGestureRecognizer:recognizer];
    [(UIView *)self.imageView addGestureRecognizer:recognizer];
    [(UIView *)self.view addGestureRecognizer:recognizer];




    [recognizer release];
    
    BackendConnecter *backEnd = [BackendConnecter sharedInstance];
    backEnd.delegate = self;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"DOWN_SWIPE");
    CGRect frame = self.view.frame;    
    [self.curlView curlView:self.imageView cylinderPosition:CGPointMake(frame.size.width, frame.size.height/2) cylinderAngle:M_PI_2 cylinderRadius:20 animatedWithDuration:4];
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
    
    [self.imageView setImage:barcode.qRBarcode];
    CGRect parentFrame = self.imageView.frame;
    
    //center the image
    CGFloat x = (parentFrame.size.width - IPHONE_QR_DIM) / 2.0;
    CGFloat y = (parentFrame.size.height - IPHONE_QR_DIM) / 2.0;
    CGRect qrcodeImageViewFrame = CGRectMake(x, y, IPHONE_QR_DIM, IPHONE_QR_DIM);
    [self.imageView setFrame:qrcodeImageViewFrame];
    
    [barcode release];
}

- (void)viewDidUnload
{
    self.imageView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction) doneAction:(id)sender
{
    //[self.delegate connectionEstablished:self];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction) settingsAction:(id)sender;
{
    
}

- (void)dealloc 
{
    [imageView release];
    [super dealloc];
}

@end
