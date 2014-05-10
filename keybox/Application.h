//
//  Application.h
//  keybox
//
//  Created by Tianhu Yang on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchDelegate.h"

@interface Application : UIApplication
@property(strong, nonatomic) id<TouchDelegate> touchDelegate;
@end
