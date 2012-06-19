//
//  WaitingRoomViewController.h
//  QRConnect
//
//  Created by Brandon Millman on 6/11/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SidebarViewController;
@class WaitingRoomViewController;
@class XBCurlView;


@protocol WaitingRoomDelegate <NSObject>

- (void) connectionEstablished:(WaitingRoomViewController *) controller;
- (void) connectionFailed:(WaitingRoomViewController *)controller;

@end

@interface WaitingRoomViewController : UIViewController 
{
    XBCurlView *curlView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *frontView;
    IBOutlet UIView *backView;
    IBOutlet UIActivityIndicatorView *spinnerView;
    
    id<WaitingRoomDelegate> delegate;

}

- (void) setQRImage:(NSString *) qrCode;
- (IBAction) doneAction:(id)sender;
- (IBAction) curlAction:(id)sender;
- (IBAction) uncurlAction:(id)sender;

@property (nonatomic,retain) XBCurlView *curlView;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *frontView;
@property (nonatomic, retain) IBOutlet UIView *backView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;

@property (nonatomic, assign) id<WaitingRoomDelegate> delegate;

@end
