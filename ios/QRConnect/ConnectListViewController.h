//
//  ConnectListViewController.h
//  QRConnect
//
//  Created by Brandon Millman on 6/17/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *users;
}

@property (nonatomic, retain) NSMutableArray *users;

@end
