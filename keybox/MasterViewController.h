//
//  MasterViewController.h
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "Password.h"

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) Account *account;

- (Password *) newPassword:(NSArray *)array;
- (BOOL) changePassword;
- (void) updateSelecteRow;
@end
