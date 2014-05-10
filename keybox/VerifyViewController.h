//
//  VerifyViewController.h
//  keybox
//
//  Created by Tianhu Yang on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController
- (void) presentInParent:(UIView*)parentView animated:(BOOL)animated;
- (void) dismissAnimated:(BOOL)animated;
@property (strong, nonatomic) IBOutlet UIView *floatView;
- (void) presentModalFrom: (UIViewController *)parent animated:(BOOL)animated;
- (void) dismissModalAnimated:(BOOL)animated;
@end
