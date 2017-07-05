//
//  CommonHeaderView.m
//  WeiboHomePage
//
//  Created by Maple on 16/10/16.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import "CommonHeaderView.h"
//#import "HomePageViewController.h"

@interface CommonHeaderView ()<UIGestureRecognizerDelegate>


@end

@implementation CommonHeaderView

+ (instancetype)viewFromXib
{
    CommonHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:headerView action:@selector(panAction)];
    [headerView addGestureRecognizer:pan];
    pan.delegate = headerView;
    
    return headerView;
}

- (void)panAction {
    NSLog(@"-----");
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 使用绝对值来判断移动的方向
    CGFloat x = fabs(veloctyPoint.x);
    CGFloat y = fabs(veloctyPoint.y);
    if (x > y) { // 水平移动
        return YES;
    } else {
        return NO;
    }
}




@end
