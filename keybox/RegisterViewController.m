//
//  RegisterViewController.m
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "Account.h"


@interface RegisterViewController ()
{
    
}
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property (strong, nonatomic) IBOutlet UILabel *confirmErrorLabel;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UIView *floatView;

@end

@implementation RegisterViewController
@synthesize nameTextField;
@synthesize nameErrorLabel;
@synthesize passwordTextField;
@synthesize passwordErrorLabel;
@synthesize confirmErrorLabel;
@synthesize confirmTextField;
@synthesize floatView;
@synthesize account;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle=UIModalPresentationPageSheet;
        self.title=NSLocalizedString(@"Create an account",nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!appDelegate.isiPhone) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bkgrd.jpg"]];
        self.floatView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setNameErrorLabel:nil];
    [self setPasswordTextField:nil];
    [self setPasswordErrorLabel:nil];
    [self setConfirmErrorLabel:nil];
    [self setConfirmTextField:nil];
    [self setFloatView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (appDelegate.isiPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else {
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
    if (!self.navigationController&&!UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {//pagesheet
        point.x=self.view.center.x;
    }
    else {
        point.x=self.view.center.y;
    }
    point.y=self.view.center.x;
    self.floatView.center=point;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!appDelegate.isiPhone) {
        self.floatView.center=self.view.center;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.floatView.center=self.view.center;
}


- (void) setAccount:(Account *) aAccount
{
    account=aAccount;
    if (!aAccount) {
        self.title=NSLocalizedString(@"Create an account", nil);
    }
    else{
        self.title=NSLocalizedString(@"Change your account",nil);
    }
}

- (void) confirm
{
    if ([self validateName]&&[self validatePassword]&&[self validateConfirm])
    {
        NSString *title=NSLocalizedString(@"Congratulations", nil);
        
        NSString *confirm=NSLocalizedString(@"Confirm", nil);
        if (!self.account) {
            if([Account newAccount:self.nameTextField.text password:self.passwordTextField.text])
            {
                NSString *message=NSLocalizedString(@"AccountCreated", nil);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:confirm otherButtonTitles: nil];
                appDelegate.alert=alert;
                [alert show];
            }
        }
        else {
            if ([account change:self.nameTextField.text key:self.passwordTextField.text]) {
                NSString *message=NSLocalizedString(@"AccountChanged", nil);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:confirm otherButtonTitles: nil];
                appDelegate.alert=alert;
                [alert show];
            }
            
        }
        
    }
}

#pragma mark - alert action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (appDelegate.isiPhone) {
                [appDelegate.navigationController popViewControllerAnimated:YES];
            }
            else {
                if (self.account) {
                    [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
                }
                else {
                    [appDelegate.navigationController popViewControllerAnimated:YES];
                }
            }
                
            
            break;
            
        default:
            break;
    }
}
#pragma mark - actions

- (IBAction)cancelTouch:(UIButton *)sender {
    if (appDelegate.isiPhone||!self.account) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
    }
    
}


- (IBAction)confirmTouch:(UIButton *)sender {
    [self confirm];
}
         
- (BOOL) validateName
{
    NSString *res=nil;
    BOOL ret=[Account validateName:self.nameTextField.text result:&res];
    self.nameErrorLabel.text=res;
    return ret;
}
- (BOOL) validatePassword
{
    NSString *res=nil;
    BOOL ret=[Account validatePassword:self.passwordTextField.text result:&res];
    self.passwordErrorLabel.text=res;
    return ret;
}
- (BOOL) validateConfirm
{
    NSString *res=nil;
    BOOL ret=[self.passwordTextField.text compare:self.confirmTextField.text];
    if(ret)
        res=NSLocalizedString(@"keysnomatch",nil);
    else res=NSLocalizedString(@"Valid",nil);
    self.confirmErrorLabel.text=res;
    return !ret;
}


- (IBAction)nameChanged:(UITextField *)sender { 
    [self validateName];    
}

- (IBAction)passwordChanged:(UITextField *)sender {
    [self validatePassword];
}

- (IBAction)confirmChanged:(UITextField *)sender {
    [self validateConfirm];
}


#pragma mark - text field action

- (IBAction)textBeginEdit:(UITextField *)sender {
    UIView *display;
    if (sender==self.nameTextField) {
        display=self.nameErrorLabel;
    }
    else if(sender==self.passwordTextField){
        display=self.passwordErrorLabel;
    }
    else if(sender==self.confirmTextField){
        display=self.confirmErrorLabel;
    }
    [appDelegate setKeyInputView:(UIScrollView*)self.view display:display];
}

- (IBAction)textEndEdit:(UITextField *)sender {
    if (sender.isFirstResponder) {
        [sender resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.confirmTextField) {
        [textField resignFirstResponder];
        [appDelegate removeKeyInput];
        [self confirm]; 
        return YES;
    }
    [appDelegate removeKeyInput];//avoid moving up
    [textField resignFirstResponder];
    
    //next field 
    if (textField==self.nameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField==self.passwordTextField) {
        [self.confirmTextField becomeFirstResponder];
    }
    
    //
    return YES;
}

@end
 
