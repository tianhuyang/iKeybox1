//
//  Account.m
//  keybox
//
//  Created by Tianhu Yang on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "Password.h"
#include "md5.h"

static NSFetchRequest *__fetchRequest;
@interface Account()
{
}
@end
@implementation Account

@synthesize plainKey;
@dynamic key;
@dynamic name;
@dynamic passwords;

-(void) setPlainKey:(NSString *)aPlainKey
{
    plainKey=aPlainKey;
    [Password makeKey:aPlainKey];
}
- (BOOL) change:(NSString *)aName key:(NSString *)aKey
{
    [self digest:aName key:aKey];
    for (Password *password in self.passwords) {
        [password resetKey:aKey];
    }
    self.plainKey=aKey;
    return [Account save];
}
- (BOOL) authenticate:(NSString *)aName key:(NSString *)aKey
{
    CMD5 md5;
    if ([self.name compare:md5.MDString(aName)]==0&&[self.key compare:md5.MDString(aKey)]==0) {
        self.plainKey=aKey;
        return YES;
    }
    return NO;
}

//**validate methods**//

//must be at least 2 characters;
+ (BOOL) validateName:(NSString *)name result:(NSString **)res
{
    /*NSPredicate *firstPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES '.*[^A-Za-z0-9_]+.*'"];
    if ([firstPredicate evaluateWithObject:name]==YES) {
        *res=@"Should be uppercases,lowercases,digitals or _";
        return NO;
    }*/
    if (name.length<2) {
        *res=NSLocalizedString(@"over2chars",nil);
        return NO;
    }
    *res=NSLocalizedString(@"Valid",nil);
    return YES;
}
//must be at least 1 letter, 1 digital, 1 other character
+ (BOOL) validatePassword:(NSString *)pass result:(NSString **)res
{
    NSPredicate *firstPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES '(.*[A-Za-z].*){1,}'"];
    if(![firstPredicate evaluateWithObject:pass])
    {
        *res=NSLocalizedString(@"needletters",nil);
        return NO;
    }
    /*firstPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES '(.*[a-z].*){2,}'"];
    if(![firstPredicate evaluateWithObject:pass])
    {
        *res=NSLocalizedString(@"Invalid key format",nil);
        return NO;
    }*/
    firstPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES '(.*[0-9].*){1,}'"];
    if(![firstPredicate evaluateWithObject:pass])
    {
        *res=NSLocalizedString(@"needdigitals",nil);
        return NO;
    }
    firstPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES '(.*[^A-Za-z0-9].*){1,}'"];
    if(![firstPredicate evaluateWithObject:pass])
    {
        *res=NSLocalizedString(@"needothers",nil);
        return NO;
    }
    if (pass.length<8) {
        *res=NSLocalizedString(@"over8chars",nil);
        return NO;
    }
    *res=NSLocalizedString(@"Valid",nil);
    return YES;
}

+ (BOOL) newAccount:(NSString *)name password:(NSString *)pass
{
    [appDelegate.managedObjectContext reset];
    NSArray *accounts=[Account getAccounts];
    NSError *error = nil;
    if(accounts){
        for(int i=0;i<accounts.count;++i)
        {
           [appDelegate.managedObjectContext deleteObject:[accounts objectAtIndex:i]]; 
        }
        
        if (![appDelegate.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            return NO;
        }
    }
    [appDelegate.managedObjectContext reset];
    Account *account = (Account*)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:appDelegate.managedObjectContext];
    [account digest:name key:pass];
    
    if (![appDelegate.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        return NO;
    }
    return YES;
}

- (void) digest:(NSString *)aName key:(NSString *)aKey
{
    CMD5 md5;
    self.name=md5.MDString(aName);
    self.key=md5.MDString(aKey);
}

+ (NSFetchRequest *)fetchRequest
{
    if (__fetchRequest!= nil) {
        return __fetchRequest;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:1];
    
    // Edit the sort key as appropriate.
   // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
   // NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    //[fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    //aFetchedResultsController.delegate = self;
    //__fetchedResultsController = aFetchedResultsController;
    __fetchRequest=fetchRequest;
    
    return __fetchRequest;
} 

+ (NSArray *)getAccounts
{
    NSError *error = nil;
    NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:[Account fetchRequest] error:&error];
	if (!array) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    return array;
}

+ (Account *)getAccount
{
    Account *account=nil;
    NSError *error = nil;
    NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:[Account fetchRequest] error:&error];
	if (!array) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    else if ([array count]==1) {
        account=(Account *)[array objectAtIndex:0];
    }
    return account;
}
+ (BOOL) save
{
    NSError *error;
    if (![appDelegate.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        return NO;
    }
    return YES;
}
@end
