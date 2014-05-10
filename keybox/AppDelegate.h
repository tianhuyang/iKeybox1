//
//  AppDelegate.h
//  keybox
//
//  Created by Tianhu Yang on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "MasterViewController.h"
#import "RegisterViewController.h"
#import "DetailViewController.h"
#import "VerifyViewController.h"
#import "Account.h"
#import "Session.h"
#import "MessageViewController.h"
#import "Application.h"
#import "AidViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate, SessionDelegate,TouchDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) toMasterView:(Account*)account;
- (void) toRegisterView:(Account*)account;
- (void) toVerifyView;
- (void) setKeyInputView:(UIScrollView*)view display:(UIView *) display; 
- (void) removeKeyInput;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) MasterViewController *masterViewController;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong,nonatomic) RegisterViewController *registerViewController;
@property (strong, nonatomic) VerifyViewController *verifyViewController;

@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UIActionSheet *sheet;
@property(assign,nonatomic) BOOL isiPhone;

@end
