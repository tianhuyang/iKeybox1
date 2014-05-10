//
//  MasterViewController.m
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
@property(strong,nonatomic) NSMutableArray *passwords;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic,assign) int selectedRow;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentControl;
//@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;


@property (strong, nonatomic) NSIndexPath *deletingIndexPath;

@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize account;
@synthesize passwords;
@synthesize selectedRow;
@synthesize rightSegmentControl;
//@synthesize titleImageView;
@synthesize cellImageView;
@synthesize deletingIndexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"List",nil);//NSLocalizedString(@"Master", @"Master");
        if (!appDelegate.isiPhone) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem;        
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightSegmentControl];
    self.navigationItem.rightBarButtonItem = rightButton;
    //self.navigationItem.titleView=self.titleImageView;
    UITableView *tableView=(UITableView *)self.view;
    [tableView reloadData];
}

- (void)viewDidUnload
{
    [self setRightSegmentControl:nil];
    //[self setTitleImageView:nil];    
    [self setCellImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (appDelegate.isiPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}


- (void) setAccount:(Account *)arg
{
    account=arg;
    if (arg) {
        self.passwords=[[arg.passwords allObjects] mutableCopy];
        UITableView *tableView=(UITableView *)self.view;
        [tableView reloadData];
    }
    else {
        self.passwords=nil;
    }
    
}

- (void)insertNewObject:(id)sender
{ 
    self.detailViewController.password=nil;
    self.selectedRow=0;
    if (appDelegate.isiPhone) {
        [appDelegate.navigationController pushViewController:self.detailViewController animated:YES]; 
    }
    else {
        //[appDelegate.splitViewController 
    }
       
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    return self.passwords.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.imageView.image=self.cellImageView.image;
        if (appDelegate.isiPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
// ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableView *tableView=(UITableView *)self.view;
    Password *pass;
    switch (buttonIndex) {
        case 0:            
            if ([Password delete:pass=[self.passwords objectAtIndex:deletingIndexPath.row]]) {
                [self.passwords removeObjectAtIndex:[deletingIndexPath row]];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletingIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (pass==self.detailViewController.password) {
                    [self.detailViewController disSelect];
                }
                UITableView *tableView=(UITableView *)self.view;
                [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
                //[tableView reloadData];
                
            }
            break;            
        default:
            break;
    }
    self.deletingIndexPath=nil;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *title=NSLocalizedString(@"deleteconfirm", nil);
        NSString *cancel=NSLocalizedString(@"Cancel", nil);
        NSString *ok=NSLocalizedString(@"OK", nil);
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self cancelButtonTitle:cancel destructiveButtonTitle:ok otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        CGRect rect=CGRectMake(140.0f,0.0f,40.0f, 40.0f);
        self.deletingIndexPath=[indexPath copy];
        UITableView *tableView=(UITableView *)self.view;
        UIView *view=[tableView cellForRowAtIndexPath:indexPath];
        appDelegate.sheet=actionSheet;
        CGRect windowsRect = [view convertRect:rect toView:tableView.window];
        [actionSheet showFromRect:windowsRect inView:tableView.window animated:YES];
        //[actionSheet showFromRect:rect inView:[tableView cellForRowAtIndexPath:indexPath] animated:YES];    
        
        
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.textLabel.textColor=[UIColor whiteColor];
    //cell.detailTextLabel.textColor=[UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:245/255.];
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:216/255.0 green:190/255. blue:236/255. alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else {
        UIColor *altCellColor = [UIColor colorWithRed:200/255.0 green:216/255. blue:230/255. alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Password *object = [self.passwords objectAtIndex:[indexPath row]];
    self.selectedRow=[indexPath row];
    self.detailViewController.password = object;
    if (appDelegate.isiPhone) {        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        
    }
    
    
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Password *password=(Password *)[self.passwords objectAtIndex:indexPath.row];
    NSString *source=password.plainSource;
    NSString *cnt=password.plainAccount;
    cell.textLabel.text =[NSString stringWithFormat:@"%@ : %@",password.plainDisplay,cnt?cnt:@" "];
    cell.detailTextLabel.text=source?source: @" ";
}

//password operations
- (Password *) newPassword:(NSArray *)array
{
    Password *pass=[Password newPassword:array account:self.account];
    if(!pass)
        return pass;
    //NSLog(@"%@",pass.owner.name);
    [self.passwords insertObject:pass atIndex:0];
    UITableView *tableView=(UITableView *)self.view;
    [tableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade]; 
    [tableView reloadData];
    
    return pass;
}

- (BOOL) changePassword
{
    if (![Account save]) {
        return NO;
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:selectedRow inSection:0];
    UITableView *tableView=(UITableView *)self.view;
    [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
    return YES;
}

- (void) updateSelecteRow
{
    UITableView *tableView=(UITableView *)self.view;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.selectedRow inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationRight];
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [appDelegate toVerifyView];
            break;
        case 1:
            [self insertNewObject:nil];
            break;    
        default:
            break;
    }
}

@end
