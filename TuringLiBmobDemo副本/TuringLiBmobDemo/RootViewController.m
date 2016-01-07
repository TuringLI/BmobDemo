//
//  RootViewController.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "RootViewController.h"
#import "LeftViewController.h"
#import "MainViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

// 一个类只会在第一次使用到的时候调用，后面再使用这个类不会调用
+ (void)initialize
{
    
}


-(void)awakeFromNib
{
    LeftViewController *leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.leftMenuViewController = leftVC;
    self.contentViewController = [[UINavigationController alloc] initWithRootViewController:MainVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSideMenu];
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

- (void)setupSideMenu
{
    self.scaleContentView = NO;//是否缩小
    self.scaleMenuView = NO;// 左视图是否可以缩小
    self.contentViewShadowEnabled = YES;//是否显示阴影
}
@end
