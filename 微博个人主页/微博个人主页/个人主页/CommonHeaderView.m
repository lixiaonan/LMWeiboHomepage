//
//  CommonHeaderView.m
//  WeiboHomePage
//
//  Created by Maple on 16/10/16.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "CommonHeaderView.h"
//#import "HomePageViewController.h"

@interface CommonHeaderView ()


@end

@implementation CommonHeaderView

+ (instancetype)viewFromXib
{
  return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}



@end
