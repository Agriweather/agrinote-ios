//
//  loginViewController.m
//  agrinote
//
//  Created by VimyHsieh on 2017/10/20.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "loginViewController.h"
#import "ACFloatingTextField.h"

@interface loginViewController () <UITextFieldDelegate>

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setDefault];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefault {
    //account: agri note
    bLoginAG.layer.cornerRadius = 10;
    bLoginAG.layer.shadowColor = [UIColor blackColor].CGColor;
    bLoginAG.layer.shadowOffset = CGSizeMake(5, 5);
    bLoginAG.layer.shadowOpacity = 0.8;
    [bLoginAG addTarget:self action:@selector(loginWithAgriNote) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonRegistry setTitle:@"我要註冊" forState:UIControlStateNormal];
    [buttonForgetPassword setTitle:@"忘記密碼？" forState:UIControlStateNormal];
    
    textFieldPassword.secureTextEntry = YES;
    
    //account: facebook
    vLoginFacebook.layer.cornerRadius = 10;
    vLoginFacebook.layer.shadowColor = [UIColor blackColor].CGColor;
    vLoginFacebook.layer.shadowOffset = CGSizeMake(5, 5);
    vLoginFacebook.layer.shadowOpacity = 0.8;
    //[bLoginFacebook addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    
    //account: google
    vLoginGoogle.layer.cornerRadius = 10;
    vLoginGoogle.layer.shadowColor = [UIColor blackColor].CGColor;
    vLoginGoogle.layer.shadowOffset = CGSizeMake(5, 5);
    vLoginGoogle.layer.shadowOpacity = 0.8;
    //[bLoginGoogle addTarget:self action:@selector(loginWithGoogle) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)loginWithAgriNote {
    NSLog(@"loginWithAgriNote");
    [self segueIn];
}

- (void)loginWithGoogle {
    NSLog(@"loginWithGoogle");
    
}

- (void)loginWithFacebook {
    NSLog(@"loginWithFacebook");
    
}

-(void)segueIn{
    [self performSegueWithIdentifier:@"segue-in" sender:self];
}

#pragma mark UITextfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

//點擊旁邊即縮小鍵盤
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
}

@end
