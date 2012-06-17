//
//  QRBaseViewControllerFactory.h
//  QRConnect
//
//  Created by Brandon Millman on 6/12/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewControllerFactory : NSObject
{
    NSMutableDictionary *controllers;
}

+ (ViewControllerFactory *)sharedInstance;
- (UIViewController *) makeController:(NSString *)key;

@property (nonatomic, retain) NSMutableDictionary *controllers;

@end
