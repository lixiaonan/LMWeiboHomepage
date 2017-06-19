//
//  LMBaseTableViewController.m
//  微博个人主页
//
//  Created by 李小南 on 2017/6/14.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMBaseTableViewController.h"

@interface LMBaseTableViewController ()
/** 记录tableView offsetY偏移量 */
@property (nonatomic, assign) CGFloat offsetY;
/** isInit */
@property (nonatomic, assign) BOOL isInit;
@end

@implementation LMBaseTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isInit = NO;
        self.offsetY = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@初始化", self);
    
    self.tableView.showsHorizontalScrollIndicator  = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerImgHeight + switchBarHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)dealloc {
    NSLog(@"%@销毁", self);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!self.isInit) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.offsetY);
        self.isInit = YES;
    }
}

/* 更新Y轴方向偏移量 */
- (void)updateOffsetY:(CGFloat)offsetY {
    
    CGFloat originalOffsetY = 0;
    CGFloat headerTopHeight = headerImgHeight - topBarHeight;
    
    if (offsetY < originalOffsetY) { // 底部下拉时
        self.offsetY = originalOffsetY;
    } else if(offsetY <= headerTopHeight && offsetY >= originalOffsetY) {
        self.offsetY = offsetY;
    } else { // 标题栏固定在顶部时
        
        // tableView可能动
        self.offsetY = headerTopHeight;
        if (self.tableView) {
            
            if (self.tableView.contentOffset.y > headerTopHeight) {
                self.offsetY = self.tableView.contentOffset.y;
            } else {
                self.offsetY = headerTopHeight;
            }
        }
    }
    
    // 1.view没有加载,  offsetY记录, viewDidLoad时加载
    
    // 2.view已经加载
    if (self.isViewLoaded) {
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.offsetY);
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(tableViewDidScroll:)])
    {
        [self.delegate tableViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:willDecelerate:)])
    {
        [self.delegate tableViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:)])
    {
        [self.delegate tableViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(tableViewDidScrollToTop:)])
    {
        [self.delegate tableViewDidScrollToTop:scrollView];
    }
}

@end
