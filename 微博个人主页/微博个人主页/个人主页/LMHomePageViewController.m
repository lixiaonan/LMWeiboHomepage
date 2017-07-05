//
//  LMHomePageViewController.m
//  微博个人主页
//
//  Created by 李小南 on 2017/6/14.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMHomePageViewController.h"
#import "LMBaseTableViewController.h"
#import "LMLeftTableViewController.h"
#import "LMMiddleTableViewController.h"
#import "LMRightTableViewController.h"
#import "CommonHeaderView.h"
#import "HMSegmentedControl.h"

@interface LMHomePageViewController ()<TableViewScrollingProtocol,UIScrollViewDelegate>
@property (nonatomic, weak) UIView *navView;

@property (nonatomic, strong) HMSegmentedControl *segCtrl;

@property (nonatomic, strong) CommonHeaderView *headerView;

@property (nonatomic, strong) NSArray  *titleList;

@property (nonatomic, weak) LMBaseTableViewController *showingVC;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleList = @[@"主页", @"微博", @"相册"];
    
    [self creatMainScrollView];
    [self addController];
    [self setupHeaderView];
    [self configNav];
    [self segmentedControlChangedValue:_segCtrl];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏背景为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    // 隐藏导航栏底部黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 当都设置为nil的时候，导航栏会使用默认的样式，即还原导航栏样式
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - Private
- (void)configNav {
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor redColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
    titleLabel.text = @"李小南";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    navView.alpha = 0;
    [self.view addSubview:navView];
    self.navView = navView;
}

#pragma mark 创建主滚动试图
-(void)creatMainScrollView{
    _scrollview = [[UIScrollView alloc]init];
    _scrollview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.scrollEnabled = YES;
    _scrollview.contentOffset = CGPointMake(0, 0);
    _scrollview.delegate = self;
    _scrollview.pagingEnabled = YES;
    _scrollview.bounces = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    [self.view addSubview:_scrollview];
}

- (void)addController {
    LMLeftTableViewController *vc1 = [[LMLeftTableViewController alloc] init];
    LMMiddleTableViewController *vc2 = [[LMMiddleTableViewController alloc] init];
    LMRightTableViewController *vc3 = [[LMRightTableViewController alloc] init];
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
}

- (void)setupHeaderView {
    // 设置样式
    self.segCtrl = self.headerView.segmentControl;
    
    _segCtrl.sectionTitles = _titleList;
    _segCtrl.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];;
    _segCtrl.selectionIndicatorHeight = 2.0f;
    _segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:15]};
    _segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    _segCtrl.selectionIndicatorColor = [UIColor blackColor];
    _segCtrl.selectedSegmentIndex = 0;
    _segCtrl.borderType = HMSegmentedControlBorderTypeBottom;
    _segCtrl.borderColor = [UIColor lightGrayColor];
    
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    
    [self.scrollview setContentOffset:CGPointMake(self.view.frame.size.width *sender.selectedSegmentIndex, 0) animated:NO];
    [self showChildVCViewsAtIndex:sender.selectedSegmentIndex];
}

/// 设置导航栏
- (void)setupBarWihtOffsetY:(CGFloat)offsetY {
    CGFloat alpha = 0;
    CGFloat originalOffsetY = 0;
    
    // 控制个人信息的显示
    if (offsetY < originalOffsetY) {
        alpha = 0;
    } else if(offsetY <= (headerImgHeight - topBarHeight) && offsetY >= originalOffsetY) {
        alpha = offsetY / (headerImgHeight - topBarHeight);
    } else { // 标题栏固定在顶部时
        alpha = 1;
    }
    
    self.navView.alpha = alpha;
    
}

// 通知其他tableView偏移
- (void)updateChildVCOffsetY:(CGFloat)offsetY {
    
    for (LMBaseTableViewController *childVC in self.childViewControllers) {
        if ([childVC isMemberOfClass:[self.showingVC class]]) {
            continue;
        }
        
        [childVC updateOffsetY:offsetY];
    }
}


#pragma mark - BaseTabelView Delegate

/// 滚动ing
- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果showing没有初始化, 那么就return
    if (!self.showingVC.isInit) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 分页栏到达顶部时,固定分页栏
    if (offsetY >= headerImgHeight - topBarHeight) {
        if (![_headerView.superview isEqual:self.view]) {
            [self.view insertSubview:_headerView aboveSubview:self.scrollview];
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
        
    } else {
        if (![_headerView.superview isEqual:scrollView]) {
            for (UIView *view in scrollView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [scrollView insertSubview:_headerView belowSubview:view];
                    break;
                }
            }
        }
        
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
    }
    
    [self setupBarWihtOffsetY:offsetY];
    
    // 通知其他子控制器偏移
    [self updateChildVCOffsetY:offsetY];
}

/// 停止拖拽
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (!decelerate) { // 不减速
        // 通知其他子控制器偏移
        [self updateChildVCOffsetY:offsetY];
    }
}

/// 结束滚动
- (void)tableViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    [self setupBarWihtOffsetY:offsetY];
    
    // 通知其他子控制器偏移
    [self updateChildVCOffsetY:offsetY];
}

/// 滚动到顶部
- (void)tableViewDidScrollToTop:(UIScrollView *)scrollView {
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollview) {
        LMBaseTableViewController *newVC = self.childViewControllers[_currentIndex];
        
        [self updateChildVCOffsetY:newVC.tableView.contentOffset.y];
        
        if ([_headerView.superview isEqual:newVC.tableView ]) {
            [self.view insertSubview:_headerView aboveSubview:self.scrollview];
        }
        if (newVC.tableView.contentOffset.y > headerImgHeight - topBarHeight) {
            _headerView.frame = CGRectMake(0, - (headerImgHeight - topBarHeight), kScreenWidth, headerImgHeight + switchBarHeight);
        }else{
            _headerView.frame = CGRectMake(0, - newVC.tableView.contentOffset.y, kScreenWidth, headerImgHeight + switchBarHeight);
        }
    }
}

- (void)showChildVCViewsAtIndex:(NSInteger)index {
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    self.showingVC.delegate = nil;
    
    _currentIndex = index;
    LMBaseTableViewController *vc = self.childViewControllers[index];
    
    
    vc.delegate = self;
    
    
    
    vc.view.frame = CGRectMake(self.view.frame.size.width * index, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
    
    [self.scrollview insertSubview:vc.view belowSubview:self.navView];
    
    CGFloat offsetY = vc.tableView.contentOffset.y;
    
    if (offsetY <= headerImgHeight - topBarHeight) {
        [vc.view addSubview:_headerView];
        for (UIView *view in vc.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [vc.view insertSubview:_headerView belowSubview:view];
                break;
            }
        }
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0;
        self.headerView.frame = rect;
        
    }  else {
        [self.view insertSubview:_headerView aboveSubview:self.scrollview];
        CGRect rect = self.headerView.frame;
        rect.origin.y = topBarHeight - headerImgHeight;
        self.headerView.frame = rect;
    }
    _showingVC = vc;
}

#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollview) {
        NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
        [self.segCtrl setSelectedSegmentIndex:index animated:YES];;
        [self showChildVCViewsAtIndex:index];
    }
}

#pragma mark - Getter/Setter
- (CommonHeaderView *)headerView
{
    if(_headerView == nil)
    {
        _headerView = [CommonHeaderView viewFromXib];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, headerImgHeight+switchBarHeight);
    }
    return _headerView;
}

@end
