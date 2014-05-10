//
//  SessionDelegate.h
//  keybox
//
//  Created by Tianhu Yang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SessionDelegate <NSObject>
- (void) expire;
- (void) tick:(int)count;
- (void) cancel;
@end
