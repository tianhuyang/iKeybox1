//
//  AppDelegate.m
//  keybox
//
//  Created by Tianhu Yang on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Account.h"


AppDelegate *appDelegate;
@interface AppDelegate()
{
    UIActionSheet *actionSheet;
    BOOL isSignin;
}

@property(assign,nonatomic) NSString *dev;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIView *displayView;
@property (strong,nonatomic) Session *session;
@property (strong, nonatomic) MessageViewController *messageViewController;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;//lazy
@synthesize managedObjectModel = _managedObjectModel;//lazy
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;//lazy
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;//lazy
@synthesize mainViewController = _mainViewController;//lazy
@synthesize masterViewController = _masterViewController;//lazy
@synthesize detailViewController = _detailViewController;//lazy
@synthesize registerViewController = _registerViewController;//lazy
@synthesize verifyViewController=_verifyViewController;//lazy
@synthesize scrollView;
@synthesize displayView;


@synthesize isiPhone;
@synthesize dev=_dev;
@synthesize session;
@synthesize messageViewController;
@synthesize alert=_alert;
@synthesize sheet=_sheet;

#pragma mark - session

- (void) touchProcess
{
    [session reset];
    if (!isSignin) {
        return;
    }
    if (self.isiPhone) {
        [self.messageViewController dismissAnimated:YES];
    }
    else {
        UIViewController *vc=[self frontViewController];
        if (self.messageViewController==vc) {            
            [self.messageViewController dismissModalAnimated:YES];
        }
        
    }
    
}


- (void) cancel
{
    
}
- (void) expire
{
    
    [self toMainView];
    
}
- (void) tick:(int)count
{
    if (self.isiPhone) {
        if (!self.messageViewController.view.superview) {
            [self.messageViewController presentInParent:self.window animated:YES];
        }
    }
    else {
        UIViewController *vc=[self frontViewController];
        if(self.messageViewController!=vc)
        {
            [self.messageViewController  presentModalFrom:vc animated:YES];
        }
        
    }
    {
        NSString *left=NSLocalizedString(@"sessionleft", nil);
        NSString *right=NSLocalizedString(@"sessionright", nil);
        [self.messageViewController setDisplay:[NSString stringWithFormat:@"%@ %d %@",left,count,right]];
    }
}

- (UIViewController *)frontViewController
{
    UIViewController *vc=self.window.rootViewController;
    while (vc.modalViewController) {
        vc=vc.modalViewController;
    }
    return vc;
} 

- (NSString *) dev
{
    if (self.isiPhone) {
        return @"iPhone";
    }
    else {
        return @"iPad";
    }
}

#pragma mark - initialization
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Application * app=(Application *)application;
    app.touchDelegate=self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.isiPhone=YES;
    } else {
        self.isiPhone=NO;
        
    }   
    appDelegate=self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController]; 
    if (self.isiPhone) {
        self.window.rootViewController = self.navigationController;
    }
    else {
        self.window.rootViewController=self.splitViewController;
    }
        
    
    //For count down
    self.messageViewController=[[MessageViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@", @"MessageViewController_",self.dev] bundle:nil];
    session=[[Session alloc] init];
    session.delegate=self;    
    //For count down
    [self registerForKeyboardNotifications];    
    [self.window makeKeyAndVisible];    
    if (!self.isiPhone) {        
        [self performSelector:@selector(firstDisplay) withObject:nil afterDelay:0.2];
    }
    return YES;
}

- (void) firstDisplay
{
    [self.window.rootViewController presentModalViewController:self.navigationController animated:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [session end];    
    [self toMainView];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
           // abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"keybox" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"keybox.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (UISplitViewController *)splitViewController
{
    if (_splitViewController!=nil) {
        return _splitViewController;
    }
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:self.masterViewController];        
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
    _splitViewController = [[UISplitViewController alloc] init];
    _splitViewController.delegate = self.detailViewController;
    _splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
    return _splitViewController;
}
- (MainViewController *)mainViewController
{
    if(_mainViewController!=nil){
        return _mainViewController;
    }
    _mainViewController=[[MainViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@", @"MainViewController_",self.dev] bundle:nil];
    return _mainViewController;
}
- (MasterViewController *)masterViewController
{
    if (_masterViewController!=nil) {
        return _masterViewController;
    }
    _masterViewController = [[MasterViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@",@"MasterViewController_",self.dev] bundle:nil];
    _masterViewController.detailViewController=[self detailViewController];
    return _masterViewController;
}
   - (DetailViewController *)detailViewController
{
    if (_detailViewController!=nil) {
        return _detailViewController;
    }
    _detailViewController = [[DetailViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@",@"DetailViewController_",self.dev] bundle:nil];
    _detailViewController.masterViewController=_masterViewController;
    return _detailViewController;
}
- (RegisterViewController *)registerViewController
{
    if (_registerViewController!=nil) {
        return _registerViewController;
    }
    _registerViewController = [[RegisterViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@",@"RegisterViewController_",self.dev] bundle:nil];
    return _registerViewController;
}
-(VerifyViewController *)verifyViewController
{
    if (_verifyViewController!=nil) {
        return _verifyViewController;
    }
    _verifyViewController = [[VerifyViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@",@"VerifyViewController_",self.dev] bundle:nil];
    return _verifyViewController;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - process session
// ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:            
            break;            
        default:
            break;
    }
}


#pragma mark - navigate processes
- (void) toMainView
{
    if (!isSignin) {
        return;
    }
    isSignin=NO;
    if (self.alert) {
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (self.sheet) {
        [self.sheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    /*if (self.navigationController.modalViewController) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }*/
    
    [self.mainViewController clear];
    self.masterViewController.account=nil;
    [self.detailViewController disSelect];
    if (self.isiPhone) {
        [self.messageViewController dismissAnimated:YES];
        [self.verifyViewController dismissAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{  
        UIViewController *vc=self.window.rootViewController;
        [vc dismissModalViewControllerAnimated:NO];
        if (self.detailViewController.masterPopoverController) {
            [self.detailViewController.masterPopoverController dismissPopoverAnimated:NO];
        }
        
        [vc presentModalViewController:self.navigationController animated:YES];
    }
    
    
}

- (void) toMasterView:(Account*)account
{
    isSignin=YES;
    self.masterViewController.account=account;
    if (self.isiPhone) {
        [self.navigationController pushViewController:self.masterViewController animated:YES ];
    }
    else{
        [self.window.rootViewController dismissModalViewControllerAnimated:YES];
    }
     
    [session startTimer];
}

- (void) toRegisterView:(Account*)account
{
    self.registerViewController.account=account;
    if (self.isiPhone) {
        [self.navigationController pushViewController:self.registerViewController animated:YES ];
    }
    else{
        if (isSignin) {
            [self.window.rootViewController presentModalViewController:self.registerViewController animated:YES];
        }
        else {
            [self.navigationController pushViewController:self.registerViewController animated:YES];
        }
        
    }
    
}

- (void) toVerifyView
{
    if (self.isiPhone) {
        [self.verifyViewController presentInParent:self.window.rootViewController.view animated:YES];
    }
    else {
        [self.verifyViewController presentModalFrom:self.window.rootViewController animated:YES];
    }
   
}

#pragma mark - key notifications
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [notificationCenter addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self
                           selector:@selector (handle_TextFieldTextChanged:)
                               name:UITextFieldTextDidChangeNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector (handle_TextFieldTextChanged:)
                               name:UITextViewTextDidChangeNotification
                             object:nil];
    
}

- (void) handle_TextFieldTextChanged:(id)notification
{
    [session reset];
    [self.messageViewController dismissAnimated:YES];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(self.displayView&&self.scrollView)
    {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat height;        
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        UIView *view=self.displayView.superview;
        CGPoint point=self.displayView.frame.origin;
        while (view!=self.scrollView) {
            point.x+=view.frame.origin.x;
            point.y+=view.frame.origin.y;
            view=view.superview;
        }
        CGRect aRect = self.scrollView.frame;
        UIInterfaceOrientation io;
        if (self.window.rootViewController.modalViewController) {
            io=self.window.rootViewController.modalViewController.interfaceOrientation;
        }
        else {
            io=self.window.rootViewController.interfaceOrientation;
        }
        if (UIInterfaceOrientationIsPortrait(io)) {
            aRect.size.height -= (height=kbSize.height);
            
        }
        else {
            aRect.size.height -= (height=kbSize.width);
            //point.y+=self.displayView.bounds.size.width;
        }        
        point.y+=self.displayView.bounds.size.height;
        if (height>self.scrollView.scrollIndicatorInsets.bottom) {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,height, 0.0);                
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
        }
        
        if (!CGRectContainsPoint(aRect, point) ) {
                         
            CGPoint scrollPoint = CGPointMake(0.0, point.y-aRect.size.height+6);
            [self.scrollView setContentOffset:scrollPoint animated:YES];
             //printf("test\n");
        }
       
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(self.displayView&&self.scrollView)
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = contentInsets;
            self.scrollView.scrollIndicatorInsets = contentInsets;
        }];
        
        
    }
}
- (void) setKeyInputView:(UIScrollView*)view display:(UIView *) display
{
    self.scrollView=view;
    self.displayView=display;   
}
- (void) removeKeyInput
{
    self.scrollView=nil;
    self.displayView=nil;
    
}

@end
