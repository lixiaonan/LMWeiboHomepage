

//
//  LMRightTableViewController.m
//  微博个人主页
//
//  Created by 李小南 on 2017/6/14.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMRightTableViewController.h"

@interface LMRightTableViewController ()

@end

@implementation LMRightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"相册 %zd", indexPath.row];
    
    return cell;
}


@end
