//
//  Password.m
//  keybox
//
//  Created by Tianhu Yang on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Password.h"
#import "Account.h"
#import "Rijndael.h"
#include <iostream>
using namespace std;

static NSFetchRequest *__fetchRequest;
static CRijndael oRijndael;


@implementation Password

@dynamic account;
@dynamic display;
@dynamic email;
@dynamic note;
@dynamic password;
@dynamic source;
@dynamic owner;

// reset key
-(void) resetKey:(NSString *)newKey
{
    CRijndael cRijndael;
    try
	{   
        cRijndael.MakeKey(newKey, CRijndael::sm_chain1,32,32);
        NSString *temp=nil;
        oRijndael.Decrypt(self.account,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.account=temp;
        
        oRijndael.Decrypt(self.display,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.display=temp;
        
        oRijndael.Decrypt(self.email,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.email=temp;
        
        oRijndael.Decrypt(self.note,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.note=temp;
        
        oRijndael.Decrypt(self.password,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.password=temp;
        
        oRijndael.Decrypt(self.source,&temp,CRijndael::CBC);
        cRijndael.Encrypt(temp,&temp,CRijndael::CBC);
        self.source=temp;
	}
	catch(exception& roException)
	{
		cout << roException.what() << endl;
	}
    
}

- (NSString *)plainPassword
{  
    
    return [self decrypt:self.password];
}
- (NSString *)plainDisplay
{
   // NSLog(@"plain%@",[self decrypt:self.display]);
    return [self decrypt:self.display];
}
- (NSString *)plainEmail
{
    return [self decrypt:self.email];
}
- (NSString *)plainNote
{
    return [self decrypt:self.note];
}
- (NSString *)plainSource
{
    return [self decrypt:self.source];
}
- (NSString *)plainAccount
{
    return [self decrypt:self.account];
}
//cipher
- (void)cipherDisplay:(NSString*) plain
{
    self.display=[self encrypt:plain];
    //NSLog(@"cipher%@",self.display);
}
- (void)cipherEmail:(NSString*) plain
{
    self.email=[self encrypt:plain];
}
- (void)cipherNote:(NSString*) plain
{
    self.note=[self encrypt:plain];
}
- (void)cipherPassword:(NSString*) plain
{
    self.password=[self encrypt:plain];
}
- (void)cipherSource:(NSString*) plain
{
    self.source=[self encrypt:plain];
}
- (void)cipherAccount:(NSString*) plain
{
    self.account=[self encrypt:plain];
}

-(NSString *)encrypt:(NSString *)plain
{
    NSString *ret=nil;
    if (!plain) {
        return ret;
    }
    
    try
	{
        oRijndael.Encrypt(plain,&ret,CRijndael::CBC);
	}
	catch(exception& roException)
	{
		cout << roException.what() << endl;
	}
    return ret;
}

-(NSString *)decrypt:(NSString *)cipher
{
    NSString *ret=nil;
    if (!cipher) {
        return ret;
    }
    
    try
	{
        oRijndael.Decrypt(cipher,&ret,CRijndael::CBC);
	}
	catch(exception& roException)
	{
		cout << roException.what() << endl;
	}
    return ret;
}


//delete
+ (BOOL) delete:(Password*)pass
{
    NSError *error = nil;
    [appDelegate.managedObjectContext deleteObject:pass];
    if (![appDelegate.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        return NO;
    }
    return YES;
}

+ (void) makeKey:(NSString*)key
{
    oRijndael.MakeKey(key, CRijndael::sm_chain1,32,32);
}

//new
+ (Password *) newPassword:(NSArray *)array account:(Account *)aAccount
{
    Password * password=(Password *)[NSEntityDescription insertNewObjectForEntityForName:@"Password" inManagedObjectContext:appDelegate.managedObjectContext];
    [password cipherDisplay:[array objectAtIndex:0]];
    [password cipherAccount:[array objectAtIndex:1]];
    [password cipherPassword:[array objectAtIndex:2]];
    [password cipherEmail:[array objectAtIndex:3]];
    [password cipherSource:[array objectAtIndex:4]];
    [password cipherNote:[array objectAtIndex:5]];
    //[aAccount addPasswordsObject:password];
    password.owner=aAccount;
    NSError *error=nil;
    if (![appDelegate.managedObjectContext save:&error]) 
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    return password;
}
+ (NSFetchRequest *)fetchRequest
{
    if (__fetchRequest!= nil) {
        return __fetchRequest;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Password" inManagedObjectContext:appDelegate.managedObjectContext];
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

+ (NSArray *)getPasswords
{
    NSError *error = nil;
    NSArray *array=[appDelegate.managedObjectContext executeFetchRequest:[Password fetchRequest] error:&error];
	if (!array) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    return array;
}

@end
