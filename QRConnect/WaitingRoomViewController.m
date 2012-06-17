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

@interface WaitingRoomViewController() <BackendDelegate>

@end

@implementation WaitingRoomViewController

@synthesize imageView;
@synthesize delegate;

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
    BackendConnecter *backEnd = [BackendConnecter sharedInstance];
    backEnd.delegate = self;
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
    NSLog(message);
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
    [self.delegate connectionEstablished:self];
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
