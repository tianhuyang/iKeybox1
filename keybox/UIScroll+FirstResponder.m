//
//  UILabel+FirstResponder.m
//  keybox
//
//  Created by Tianhu Yang on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIScrollView+FirstResponder.h"

@implementation UIScrollView (FirstResponder)

- (BOOL) canBecomeFirstResponder{
    return YES;
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self becomeFirstResponder];
}
@end
