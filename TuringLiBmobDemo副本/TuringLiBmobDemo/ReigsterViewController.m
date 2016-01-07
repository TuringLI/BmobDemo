//
//  ReigsterViewController.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "ReigsterViewController.h"
#import "Tool.h"
@interface ReigsterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reightButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *paswordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ReigsterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkText];
}
- (IBAction)registerClicked:(UIButton *)sender {
   
    NSLog(@"NNNNNNNN");
    BmobUser *user = [[BmobUser alloc] init];
    user.username = self.userNameTF.text;
    
    NSString *pwdMD5Str = [Tool MD5StringFromString:self.paswordTF.text];
    
    
    user.password = pwdMD5Str;
    // 应该用正则表达式
    if (self.emailTextField.text.length > 0) {
        user.email = self.emailTextField.text;
    }
    // 如果填写有邮箱会自动给邮箱发送一条验证邮件
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful== YES) {
            [SVProgressHUD showSuccessWithStatus:@"恭喜您，注册成功@!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }
    }];
}
- (IBAction)userNameChange:(UITextField *)sender {
    [self checkText];
}
- (IBAction)passwordChange:(UITextField *)sender {
    [self checkText];
}

- (void)checkText
{
    if (self.userNameTF.text.length > 0 && self.paswordTF.text.length > 0) {
        self.reightButton.enabled = YES;
    }else
    {
        self.reightButton.enabled = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
