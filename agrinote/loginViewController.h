//
//  loginViewController.h
//  agrinote
//
//  Created by VimyHsieh on 2017/10/20.
//  Copyright © 2017年 agri. All rights reserved.
//  REF: https://github.com/ErAbhishekChandani/ACFloatingTextField

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface loginViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    IBOutlet UIButton *bLoginAG;
    IBOutlet UIButton *bLoginGoogle;
    IBOutlet UIButton *bLoginFacebook;
    IBOutlet UIView *vLoginGoogle;
    IBOutlet UIView *vLoginFacebook;
    IBOutlet ACFloatingTextField *textFieldUsername;
    IBOutlet ACFloatingTextField *textFieldPassword;
    IBOutlet UIButton *buttonRegistry;
    IBOutlet UIButton *buttonForgetPassword;
    
}


@end

