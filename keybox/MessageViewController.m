//
//  PopOverViewController.m
//  keybox
//
//  Created by Tianhu Yang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIView *floatView;
@property (strong,nonatomic) UIViewController *aidViewController;
@property (strong, nonatomic) UIViewController *parent;
@end

@implementation MessageViewController
@synthesize messageTextView;
@synthesize borderView;
@synthesize floatView;
@synthesize aidViewController;
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization   
        self.modalPresentationStyle=UIModalPresentationFormSheet;
        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        self.aidViewController=[[AidViewController alloc] initWithNibName:@"AidViewController" bundle:nil];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    if (appDelegate.isiPhone) {
        [[self.borderView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self.borderView layer] setBorderWidth:2.3];
        [[self.borderView layer] setCornerRadius:15];
        [self.borderView setClipsToBounds: YES];
    }
    }
    

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMessageTextView:nil];
    [self setBorderView:nil];
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




- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!appDelegate.isiPhone) {
        CGRect rect=self.view.superview.bounds;
        CGRect rect1=self.view.superview.frame;//242 84
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            rect1.origin.x=242;
            rect1.origin.y=84;
        }
        else {
            rect1.origin.x=114;
            rect1.origin.y=212;
        }
        
        rect.size=self.floatView.bounds.size;
        
        self.view.superview.frame=rect1;
        self.view.superview.bounds=rect;
        self.floatView.frame=rect;
    }
}


- (void) setDisplay:(NSString *)message
{
    self.messageTextView.text=message;
}

- (void) presentInParent:(UIView*)parentView animated:(BOOL)animated
{
    // Setup frame of alert view we're about to display to just off the bottom of the view
    [self.view setFrame:CGRectMake(0, parentView.frame.size.height, parentView.frame.size.width, parentView.frame.size.height)];
    
    // Add new view to our view stack
    [parentView addSubview:self.view];
    
    // animate into position
    [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^{
        [self.view setFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    }];      
}

- (void) dismissAnimated:(BOOL)animated
{    
    // animate out of position
    if (!self.view.superview) {
        return;
    }
    [UIView animateWithDuration:(animated ? 0.5 : 0.0) animations:^{
        [self.view setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished){ [self.view removeFromSuperview];
    }];      
}  

/*** for iPad ***/
- (void) presentModalFrom: (UIViewController *)aParent animated:(BOOL)animated
{
    self.parent=aParent;
    [aParent presentModalViewController:self.aidViewController animated:NO];
    [self.aidViewController presentModalViewController:self animated:animated];
}
- (void) dismissModalAnimated:(BOOL)animated
{
    [self.parent dismissModalViewControllerAnimated:animated];
}
/*** for iPad ***/

@end
