//
//  RegisterViewController.h
//  keybox
//
//  Created by Tianhu Yang on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,assign) Account* account;
@end

