//
//  LeftViewController.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "LeftViewController.h"
#import "MyImageView.h"
#import "LoginViewController.h"
#import "userInfoViewController.h"
#import <UIImageView+WebCache.h>
@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MyImageView *IconImageView;

@property (weak, nonatomic) IBOutlet UITableView *userTable;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image012.jpg"]];
    // 启动的时候手动调用刷新用户数据
    [self userRefresh:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefresh:) name:USER_REFRESH_NOTICE object:nil];
}
/**
 *  刷新用户信息
 */
- (void)userRefresh:(NSNotification *)notice
{
    // 获取到用户的用户名,Bmob已经把用户信息存到沙盒
    BmobUser *user = [BmobUser getCurrentUser];
    
    if (user) {
        self.label.text = user.username;
        NSString *urlStr = [user objectForKey:@"userIconUrl"];
        [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }else
    {
        self.label.text = @"点击登录";
        self.IconImageView.image = [UIImage imageNamed:@"ALLENIVERSON3.jpg"];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_REFRESH_NOTICE object:nil];
}
- (IBAction)userClicked:(UITapGestureRecognizer *)sender {
    UIViewController *vc = nil;
    if ([BmobUser getCurrentUser]) {
        userInfoViewController *userInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"];
        vc = userInfo;
    }else
    {
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        vc = loginVC;
    }
    
    
    // 登录
    UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
    [self.sideMenuViewController hideMenuViewController];
    [nav pushViewController:vc animated:YES];
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
