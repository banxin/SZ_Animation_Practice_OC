//
//  WeChatEyeViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WeChatEyeViewController.h"
#import "WeChatEyeView.h"

@interface WeChatEyeViewController ()

@property (nonatomic, strong) WeChatEyeView *eyeView;

@end

@implementation WeChatEyeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.title = @"微信下拉眼睛";
    
    [self setupUI];
}

- (void)setupUI
{
    [self.tableView addSubview:self.eyeView];
    
//    [self.view insertSubview:self.eyeView belowSubview:self.tableView];
//
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//
//    headView.backgroundColor = [UIColor clearColor];
    
//    self.tableView.tableHeaderView = self.eyeView;
}

#pragma - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"test";
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UIScrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.eyeView animationWith:scrollView.contentOffset.y];
}

- (WeChatEyeView *)eyeView
{
    if (!_eyeView) {
        
        _eyeView = [[WeChatEyeView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, -100, 100, 100)];
    }
    
    return _eyeView;
}

@end
