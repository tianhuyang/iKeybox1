//
//  Password.h
//  keybox
//
//  Created by Tianhu Yang on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Password : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * display;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) Account *owner;
- (NSString *)plainDisplay;
- (NSString *)plainEmail;
- (NSString *)plainNote;
- (NSString *)plainPassword;
- (NSString *)plainSource;
- (NSString *)plainAccount;

- (void)cipherDisplay:(NSString*) plain;
- (void)cipherEmail:(NSString*) plain;
- (void)cipherNote:(NSString*) plain;
- (void)cipherPassword:(NSString*) plain;
- (void)cipherSource:(NSString*) plain;
- (void)cipherAccount:(NSString*) plain;
- (void) resetKey:(NSString *)newKey;

+ (void) makeKey:(NSString*)key;
+ (BOOL) delete:(Password*)pass;
+ (Password *) newPassword:(NSArray *)array account:(Account *)aAccount;
+ (NSArray *)getPasswords;
@end
