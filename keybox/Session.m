//
//  Session.m
//  keybox
//
//  Created by Tianhu Yang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Session.h"

static const int timeInterval=30;
static const int count=10;

@interface UserInfo : NSObject
@property(nonatomic, assign) int count;
- (id) initWithCount:(int) aCount;
@end


@implementation UserInfo

@synthesize count;
- (id) initWithCount:(int) aCount
{
    self=[super init];
    if (self) {
        self.count=aCount;
    }
    return self;
}
@end

@interface Session()
{
    volatile BOOL shouldCount; 
    NSTimer *totalTimer;
    NSTimer *countTimer;
    NSRunLoop *runloop;
}
@end

@implementation Session

@synthesize delegate;

- (id) init
{
    self=[super init];
    if (self) {
        //runloop=[[NSRunLoop alloc] init];
    }
    return self;
}
- (void) countDown:(NSTimer*)theTimer
{
    //printf("tick\n");
    if (!shouldCount) {
        [theTimer invalidate];
        if (totalTimer) {
            [self startTimer];
        }
        if (delegate) {
            [delegate cancel];
        }
        return;
    }
    UserInfo *userInfo=(UserInfo *)theTimer.userInfo;
    if (userInfo.count==0) {
        [theTimer invalidate];
        if (delegate) {
            [delegate expire];
        }
        
    }
    else{
        if (delegate) {
            [delegate tick:userInfo.count];
        }        
    }
    --userInfo.count;
    
}
- (void) end
{
    if(countTimer){
        [countTimer invalidate];
        countTimer=nil;
    }
    if (totalTimer) {
        [totalTimer invalidate];
        totalTimer=nil;
    }
    
}
- (void) reset
{
    shouldCount=NO;
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    if (shouldCount) {
        [theTimer invalidate];
        UserInfo *userInfo=[[UserInfo alloc] initWithCount:count];
        countTimer=[NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(countDown:) userInfo:userInfo repeats:YES];
    }
    else
    {
        shouldCount=YES;
    }
}
- (void) startTimer
{
    shouldCount=YES;
    if (totalTimer&&totalTimer.isValid) {
        [totalTimer invalidate];
    }
    totalTimer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target: self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

@end
