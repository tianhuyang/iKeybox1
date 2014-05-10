//
//  PopOverViewController.h
//  keybox
//
//  Created by Tianhu Yang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
- (void) presentInParent:(UIView*)parentView animated:(BOOL)animated;
- (void) dismissAnimated:(BOOL)animated;
- (void) setDisplay:(NSString *)message;
- (void) presentModalFrom: (UIViewController *)parent animated:(BOOL)animated;
- (void) dismissModalAnimated:(BOOL)animated;
@end
