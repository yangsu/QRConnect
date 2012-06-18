//
//  JoinWaitingRoomViewController.m
//  QRConnect
//
//  Created by Brandon Millman on 6/15/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import "JoinWaitingRoomViewController.h"
#import "BackendConnecter.h"

@interface JoinWaitingRoomViewController () <ZBarReaderDelegate>
{
    BOOL scanFinished;
}

@property (nonatomic, assign) BOOL scanFinished;
@end

@implementation JoinWaitingRoomViewController

@synthesize scanFinished;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.scanFinished = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.scanFinished)
    {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
        ZBarImageScanner *scanner = reader.scanner;
        // TODO: (optional) additional reader configuration here
    
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    
    
        CGFloat cameraTransformX = 1.0;
        CGFloat cameraTransformY = 1.12412;
    
        reader.cameraViewTransform = CGAffineTransformScale(reader.cameraViewTransform, cameraTransformX, cameraTransformY);
    
        // present and release the controller
        [self presentViewController:reader animated:NO completion:nil];
    
        [reader release];
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    if(symbol != nil) {
        [self setQRImage:symbol.data];
        self.scanFinished = YES;
        [reader dismissModalViewControllerAnimated:YES];
    }
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    self.scanFinished = YES;
    [self.delegate connectionFailed:self];
    [self dismissModalViewControllerAnimated:YES];
}


@end
