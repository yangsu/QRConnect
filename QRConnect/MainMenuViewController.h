//
//  MainMenuViewController.h
//  QRConnect
//
//  Created by Brandon Millman on 6/11/12.
//  Copyright (c) 2012 Duke University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRConnecter;

@interface MainMenuViewController : UIViewController 
{
    QRConnecter *connecter;
}

- (IBAction) startButtonPressed:(id)sender;
- (IBAction) joinButtonPressed:(id)sender;

@property (nonatomic, retain) QRConnecter *connecter;


@end
