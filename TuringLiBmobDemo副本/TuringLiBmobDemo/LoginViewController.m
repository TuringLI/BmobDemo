//
//  LoginViewController.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "LoginViewController.h"
#import "ReigsterViewController.h"
#import "Tool.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController
- (IBAction)regiternew:(id)sender {
    ReigsterViewController *reigsterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReigsterViewController"];
    UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
    [self.sideMenuViewController hideMenuViewController];
    [nav pushViewController:reigsterVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkText];
   
    // Do any additional setup after loading the view.
}

- (IBAction)passwordChange:(UITextField *)sender {
    [self checkText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginClicked:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"loging..." maskType:SVProgressHUDMaskTypeClear];
    //maskType:SVProgressHUDMaskTypeClear 一个遮盖,在登录中不能重复点击
    NSString *pwdMDTStr = [Tool MD5StringFromString:self.passwordTF.text];
    [BmobUser loginWithUsernameInBackground:self.userNameTF.text password:pwdMDTStr block:^(BmobUser *user, NSError *error) {
        if (user) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }else
        {
            NSString *msg = nil;
            if (error.code==101) {
                msg = @"密码或者账号错误";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}
- (IBAction)userNameChange2:(UITextField *)sender {
    [self checkText];
}

- (void)checkText
{
    if (self.userNameTF.text.length > 0 && self.passwordTF.text.length > 0) {
        self.loginButton.enabled = YES;
    }else
    {
        self.loginButton.enabled = NO;
    }

}
@end
