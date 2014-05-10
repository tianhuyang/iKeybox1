//
//  Session.h
//  keybox
//
//  Created by Tianhu Yang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionDelegate.h"

@interface Session : NSObject
- (void) reset;
- (void) startTimer;
- (void) end;
@property id <SessionDelegate> delegate;
@end
