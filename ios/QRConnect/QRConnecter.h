//
//  QRConnecter.h
//  QRConnect
//
//  Created by Brandon Millman on 6/12/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QRConnecterDelegate <NSObject>

+(void) connectionEstablished:(UIViewController *) controller;
+(void) connectionFailed:(UIViewController *) controller;


@end

@interface QRConnecter : NSObject 
{
    id<QRConnecterDelegate> delegate;
    UINavigationController *navigationController;
}

-(UIViewController *) createQRCode;
-(UIViewController *) joinQRCode;

@property (nonatomic, retain) id<QRConnecterDelegate> delegate;
@property (nonatomic, retain) UINavigationController *navigationController;



@end
