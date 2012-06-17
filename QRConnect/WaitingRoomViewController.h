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


@protocol WaitingRoomDelegate <NSObject>

- (void) connectionEstablished:(WaitingRoomViewController *) controller;
- (void) connectionFailed:(WaitingRoomViewController *)controller;

@end

@interface WaitingRoomViewController : UIViewController 
{
    IBOutlet UIImageView *imageView;
    id<WaitingRoomDelegate> delegate;
}

- (void) setQRImage:(NSString *) qrCode;
- (IBAction) doneAction:(id)sender;
- (IBAction) settingsAction:(id)sender;

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) id<WaitingRoomDelegate> delegate;

@end
