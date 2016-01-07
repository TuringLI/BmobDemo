//
//  MyImageView.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setRedius:(CGFloat)redius
{
    self.layer.cornerRadius = redius;
}
@end
