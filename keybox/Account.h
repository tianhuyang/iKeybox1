//
//  Account.h
//  keybox
//
//  Created by Tianhu Yang on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Password;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *passwords;
@property (nonatomic, assign) NSString *plainKey;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addPasswordsObject:(Password *)value;
- (void)removePasswordsObject:(Password *)value;
- (void)addPasswords:(NSSet *)values;
- (void)removePasswords:(NSSet *)values;
- (NSString *)plainKey;
- (BOOL) authenticate:(NSString *)name key:(NSString *)key;
- (BOOL) change:(NSString *)aName key:(NSString *)aKey;

//validate methods
+ (BOOL) validateName:(NSString *)name result:(NSString **)res; 
+ (BOOL) validatePassword:(NSString *)pass result:(NSString **)res;
+ (BOOL) newAccount:(NSString *)name password:(NSString *)pass;
+ (Account *)getAccount;
+ (BOOL) save;
+ (NSArray *)getAccounts;
@end
