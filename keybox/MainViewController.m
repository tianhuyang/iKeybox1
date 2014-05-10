//
//  MainViewController.m
//  keybox
//
//  Created by Tianhu Yang on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "Account.h"

@interface MainViewController ()
//@property(nonatomic,assign) Account *account;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *keyTextField;
@property (strong, nonatomic) IBOutlet UIView *floatView;


@end

@implementation MainViewController
//@synthesize account;
@synthesize errorLabel;
@synthesize nameTextField;
@synthesize keyTextField;
@synthesize floatView;

- (void) testData
{
    NSArray *array=[Account getAccounts];
    int count=0;
    if (array) {
        count=array.count;
    }
    NSLog(@"Account.count=%d",count);
    array=[Password getPasswords];
    count=0;
    if (array) {
        count=array.count;
    }
    NSLog(@"Password.count=%d",count);
}

- (void) clear
{
    self.errorLabel.text=nil;
    self.nameTextField.text=nil;
    self.keyTextField.text=nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"Sign in",nil);
        self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        
        //*** test ***//
        //[self testData];
        //*** test ***//
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!appDelegate.isiPhone) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bkgrd.jpg"]];
    }
    
    if (!appDelegate.isiPhone) {
        self.floatView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
        [[self.floatView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[self.floatView layer] setBorderWidth:2.3];
        [[self.floatView layer] setCornerRadius:15];
        [self.floatView setClipsToBounds: YES];
    }
    //self.account=[Account getAccount];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setErrorLabel:nil];
    [self setNameTextField:nil];
    [self setKeyTextField:nil];
    [self setFloatView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.account=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (appDelegate.isiPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {        
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (appDelegate.isiPhone||!(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)^UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) {
        return;
    }
    CGPoint point;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        point.x=self.view.center.y;
    }
    else {
        point.x=self.view.center.y;
    }
    
    
    point.y=self.view.center.x;
    self.floatView.center=point;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.floatView.center=self.view.center;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.floatView.center=self.view.center;
}

- (void) confirm
{
    Account *account=[Account getAccount];
    if ([account authenticate:self.nameTextField.text key:self.keyTextField.text]) {
        self.errorLabel.text=nil;
        [appDelegate toMasterView:account];
    }
    else{
        self.errorLabel.text=NSLocalizedString(@"Signin incorrect",nil);
    }
}

#pragma mark - alert action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [appDelegate toRegisterView:nil];
            break;
            
        default:
            break;
    }
}
#pragma mark - confirm button action

- (IBAction)confirmTouch:(UIButton *)sender {
    [self confirm];
}
- (IBAction)newAccountTouch:(UIButton *)sender {
    Account *account=[Account getAccount];
    if(account)
    {
        NSString *title=NSLocalizedString(@"Warning", nil);
        NSString *message=NSLocalizedString(@"CreateWarning", nil);
        NSString *no=NSLocalizedString(@"NO", nil);
        NSString *yes=NSLocalizedString(@"YES", nil);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:no otherButtonTitles:yes, nil];
        appDelegate.alert=alert;
        [alert show];
    }
    else{
       [appDelegate toRegisterView:nil]; 
    }
}
#pragma mark - text field action

- (IBAction)textBeginEdit:(UITextField *)sender {
    [appDelegate setKeyInputView:(UIScrollView*)self.view display:sender];
}

- (IBAction)textEndEdit:(UITextField *)sender {
    if (sender.isFirstResponder) {
        [sender resignFirstResponder];
    }
    //[appDelegate removeKeyInput];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.keyTextField) {        
        [textField resignFirstResponder];
        [appDelegate removeKeyInput];
        [self confirm];
        return YES;
    }
    [appDelegate removeKeyInput];//avoid moving up
    [textField resignFirstResponder];
    //next field 
    if (textField==self.nameTextField) {
        [self.keyTextField becomeFirstResponder];
    }
    //
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}
@end
