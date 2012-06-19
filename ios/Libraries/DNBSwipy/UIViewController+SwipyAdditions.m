//
//  UIViewController+SideBarAdditions.m
//  DeckControllerSample
//
//  Created by Aaron Alexander on 12/7/11.
//  Copyright (c) 2011 drunknbass. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+SwipyAdditions.h"


static const char *LeftControllerKey = "LeftControllerTag";
static const char *RightControllerKey = "RightControllerTag";


@interface UIViewController ()
- (void)setLeftController:(UIViewController *)controller;
- (void)setRightController:(UIViewController *)controller;
@end

@implementation UIViewController (SwipyAdditions)

@dynamic leftController;
- (UIViewController *)leftController {
    UIViewController *ret = objc_getAssociatedObject(self, LeftControllerKey);
    if (ret == nil) {
        // Do nothing
    }
    return ret;
}
- (void)setLeftController:(UIViewController *)controller {
    objc_setAssociatedObject(self, LeftControllerKey, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@dynamic rightController;
- (UIViewController *)rightController {
    UIViewController *ret = objc_getAssociatedObject(self, RightControllerKey);
    if (ret == nil) {
        // Do nothing
    }
    return ret;
}
- (void)setRightController:(UIViewController *)controller {
    objc_setAssociatedObject(self, RightControllerKey, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

