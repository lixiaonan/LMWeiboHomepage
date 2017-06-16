//
//  CommonHeaderView.h
//  WeiboHomePage
//
//  Created by Maple on 16/10/16.
//  Copyright © 2016年 Maple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@class HMSegmentedControl;
/// 个人主页的头部View
@interface CommonHeaderView : UIView

+ (instancetype)viewFromXib;

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentControl;

@end
