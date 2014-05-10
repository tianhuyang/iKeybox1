//
//  DetailViewController.h
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Password.h"
#import "MasterViewController.h"
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>


@property (strong, nonatomic) Password *password;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong,nonatomic) MasterViewController *masterViewController;
- (void) disSelect;
@end
