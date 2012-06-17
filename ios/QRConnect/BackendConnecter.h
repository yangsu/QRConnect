//
//  BackendConnecter.h
//  QRConnect
//
//  Created by Brandon Millman on 6/13/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRWebSocket;

@protocol BackendDelegate <NSObject>

-(void) receiveQR:(NSString *) qrCode;
-(void) requestQRFailed:(NSError *) error;
-(void) receiveMessage:(id) message;

@end

@interface BackendConnecter : NSObject
{
    id <BackendDelegate> delegate;
    SRWebSocket *webSocket;
}

+ (BackendConnecter *)sharedInstance;
- (void)requestQR;
- (void)connectQR:(NSString *)qrCode;
- (void)closeQR;

@property (nonatomic, assign) id <BackendDelegate> delegate;
@property (nonatomic, retain) SRWebSocket *webSocket;



@end