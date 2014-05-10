//
//  Application.m
//  keybox
//
//  Created by Tianhu Yang on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Application.h"

@implementation Application
@synthesize touchDelegate;
- (void)sendEvent:(UIEvent *)event
{
    if (event.type==UIEventTypeTouches&&touchDelegate) {
        [touchDelegate touchProcess];
    }
    [super sendEvent:event];
}


@end
