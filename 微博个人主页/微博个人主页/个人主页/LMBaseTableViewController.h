//
//  LMBaseTableViewController.h
//  微博个人主页
//
//  Created by 李小南 on 2017/6/14.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define headerImgHeight 200 // 头部图片刚开始显示的高度（实际高度并不是200）
#define topBarHeight 64  // 导航栏加状态栏高度
#define switchBarHeight 40
@protocol TableViewScrollingProtocol <NSObject>

/// 滚动ing
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
/// 停止拖拽
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/// 结束滚动
- (void)tableViewDidEndDecelerating:(UIScrollView *)scrollView;
/// 滚动到顶部
- (void)tableViewDidScrollToTop:(UIScrollView *)scrollView;

@end

@interface LMBaseTableViewController : UITableViewController
@property (nonatomic, weak) id<TableViewScrollingProtocol> delegate;

/** isInit */
@property (nonatomic, assign, readonly) BOOL isInit;

/** 更新Y轴方向偏移量 */
- (void)updateOffsetY:(CGFloat)offsetY;

@end
