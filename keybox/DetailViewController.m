//
//  DetailViewController.m
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    SEL toggleAction;
}

@property (strong, nonatomic) IBOutlet UITextField *displayTextField;
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *sourceTextField;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (assign, nonatomic) int status;

@property (strong, nonatomic) IBOutlet UIView *floatView;

- (void)configureView;

@end

@implementation DetailViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize displayTextField = _displayTextField;
@synthesize accountTextField = _accountTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize emailTextField = _emailTextField;
@synthesize sourceTextField = _sourceTextField;
@synthesize noteTextView = _noteTextView;
@synthesize errorLabel = _errorLabel;
@synthesize password;
@synthesize status;
@synthesize floatView = _floatView;
@synthesize masterViewController;


#pragma mark - Managing the detail item

- (void)setPassword:(Password *)pass
{
    password = pass;
    if (pass) {
        self.status=2;
        self.editing=NO;
    }
    else {
        self.status=1;
        self.editing=YES;        
    }   
    // Update the view.
    [self configureView];

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}
- (void) disSelect
{
    self.status=0;
    password=nil;
    self.editing=NO;
    [self configureView];
}

- (void) clearView
{
    self.displayTextField.text=nil;
    self.accountTextField.text=nil;
    self.emailTextField.text=nil;
    self.sourceTextField.text=nil;
    self.noteTextView.text=nil;
    self.passwordTextField.text=nil;
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.status==0) {
        self.errorLabel.text=NSLocalizedString(@"selectitem", nil);
    }
    else self.errorLabel.text=NSLocalizedString(@"touchdisplay",nil);
    if (self.password) {
        self.displayTextField.text=self.password.plainDisplay;
        self.accountTextField.text=self.password.plainAccount;
        self.emailTextField.text=self.password.plainEmail;
        self.sourceTextField.text=self.password.plainSource;
        self.noteTextView.text=self.password.plainNote;
        self.passwordTextField.text=self.password.plainPassword;
        self.passwordTextField.secureTextEntry=YES;
    }
    else {
        [self clearView];
    }
}
- (void) configureEnabled:(BOOL)enabled
{
    self.displayTextField.enabled=enabled;
    self.accountTextField.enabled=enabled;
    //self.passwordTextField.enabled=enabled;
    self.emailTextField.enabled=enabled;
    self.sourceTextField.enabled=enabled;
    [self.noteTextView resignFirstResponder];
    self.noteTextView.editable=enabled;

}

- (void) loadView
{
    [super loadView];
    [[self.noteTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.noteTextView layer] setBorderWidth:1.0];
    [[self.noteTextView layer] setCornerRadius:5];
    [self.noteTextView setClipsToBounds: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self configureEnabled:self.editing];
}

- (void)viewDidUnload
{
    [self setDisplayTextField:nil];
    [self setDisplayTextField:nil];
    [self setAccountTextField:nil];
    [self setPasswordTextField:nil];
    [self setEmailTextField:nil];
    [self setSourceTextField:nil];
    [self setNoteTextView:nil];
    [self setErrorLabel:nil];
    [self setFloatView:nil];
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

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (appDelegate.isiPhone||!(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)^UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) {
        return;
    }
    CGPoint point;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        point.x=self.view.center.y-200.0;
        point.y=self.view.center.x;
    }
    else {
        point.x=self.view.center.y;
        point.y=500.0;
    }
    
    self.floatView.center=point;
}*/

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.floatView.center=self.view.center;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.floatView.center=self.view.center;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"No selection", @"No selection");
        self.navigationItem.rightBarButtonItem=self.editButtonItem; 
        toggleAction=self.editButtonItem.action;
        self.editButtonItem.action=@selector(buttonTouch:animated:);
        self.status=0;
        
    }
    return self;
}

- (void) buttonTouch:(BOOL)editing animated:(BOOL)animated
{
        [self performSelector:toggleAction withObject:[NSNumber numberWithBool:editing]  withObject:[NSNumber numberWithBool:animated]];
    
    if(status==0||self.editing)
    {
        
    }
    else if(![self validateValues]){
        self.editing=YES;
    }
    else if (self.status==1) {
        password=[self.masterViewController newPassword:
                  [NSArray arrayWithObjects:
                   self.displayTextField.text==nil?@"":self.displayTextField.text,
                   self.accountTextField.text==nil?@"":self.accountTextField.text,
                   self.passwordTextField.text==nil?@"":self.passwordTextField.text,
                   self.emailTextField.text==nil?@"":self.emailTextField.text,
                   self.sourceTextField.text==nil?@"":self.sourceTextField.text,
                   self.noteTextView.text==nil?@"":self.noteTextView.text
                   ,nil]];
        if(password)
        {
            self.errorLabel.text=NSLocalizedString(@"Created sucessfully",nil);
            self.status=2;            
        }
        else{
            self.errorLabel.text=NSLocalizedString(@"Create failed",nil);
            self.editing=YES;
        }
        
        
    }
    else{
        [self.password cipherDisplay:self.displayTextField.text];
        [self.password cipherAccount:self.accountTextField.text];
        [self.password cipherPassword:self.passwordTextField.text];
        [self.password cipherEmail:self.emailTextField.text];
        [self.password cipherSource:self.sourceTextField.text];
        [self.password cipherNote:self.noteTextView.text];
        if ([self.masterViewController changePassword]) {
            self.errorLabel.text=NSLocalizedString(@"Saved sucessfully",nil);
            [self.masterViewController updateSelecteRow];
        }
        else{
            self.errorLabel.text=NSLocalizedString(@"Save failed",nil);
            self.editing=YES;
        }
        
        
    }
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self configureEnabled:editing];
    if (status==0) {
        self.title=NSLocalizedString(@"No selection",nil); 
    }
    
    else if (editing)
    {
        if (self.status==1) {
            self.title=NSLocalizedString(@"Create",nil); 
            
        }
        else self.title=NSLocalizedString(@"Edit",nil);
    }
    else{
        self.title=NSLocalizedString(@"View",nil);
    }
    
}
         
//validate values  
         
- (BOOL) validateValues
{
        if(self.displayTextField.text.length==0)
        {
            self.errorLabel.text=NSLocalizedString(@"Notempty",nil);
            return NO;
        }
         else {
             self.errorLabel.text=nil;
             return YES;
         }
             
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"List", @"List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - text field action

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   
    if (textField==self.passwordTextField) {  
        if (self.editing) {
            self.passwordTextField.secureTextEntry=NO;
        }        
        else{
            self.passwordTextField.secureTextEntry=!self.passwordTextField.secureTextEntry;
            return NO;
        }
    }
    
    
    return YES;
}


- (IBAction)textBeginEdit:(UITextField *)sender
{

    [appDelegate setKeyInputView:(UIScrollView*)self.view display:sender];    
}

- (IBAction)textEndEdit:(UITextField *)sender {
    //[appDelegate removeKeyInput];
    if (sender==self.passwordTextField) {
        self.passwordTextField.secureTextEntry=YES;
    }
    if (sender.isFirstResponder) {
        [sender resignFirstResponder];
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [appDelegate removeKeyInput];
    
    [textField resignFirstResponder];
    //next field 
    if (textField==self.displayTextField) {
        [self.accountTextField becomeFirstResponder];
    }
    else if(textField==self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField==self.passwordTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    else if(textField==self.emailTextField) {
        [self.sourceTextField becomeFirstResponder];
    }
    else if(textField==self.sourceTextField) {
        [self.noteTextView becomeFirstResponder];
    }
    
    
    //
    return YES;
}
#pragma mark - text view action

- (BOOL) textViewShouldBeginEditing:(UITextView *)sender
{
    [appDelegate setKeyInputView:(UIScrollView*)self.view display:sender];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{    
    [textView resignFirstResponder];
}



@end
