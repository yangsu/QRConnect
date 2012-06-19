//
//  DNBSwipyNavigationController.h
//  DNBSwipyNavigationController
//
//  Created by Aaron Alexander on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DNBSwipyNavigationControllerDelegate;

typedef enum {
    ControllerPositionRegular = 0,
    ControllerPositionLeft = 1,
    ControllerPositionRight = 2
} ControllerPosition;


@interface DNBSwipyNavigationController : UINavigationController <UIGestureRecognizerDelegate, UINavigationBarDelegate, UIScrollViewDelegate>


@property (nonatomic, assign, getter=nilSidesPopSides) BOOL nilSideControllersShouldPopCurrentControllers;
@property (nonatomic, assign) BOOL bounceEnabled;
@property (nonatomic, assign) ControllerPosition currentPosition;
@property (nonatomic, retain, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@end






@protocol DNBSwipyNavigationControllerDelegate <UINavigationControllerDelegate>
@optional
- (BOOL)leftControllerEnabled;
- (BOOL)rightControllerEnabled;
@end