//
//  WaveLoadingListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WaveLoadingListViewController.h"
#import "MatchManViewController.h"
#import "WaveViewController.h"
#import "WaveLoadingViewController.h"

@interface WaveLoadingListViewController ()

@property (nonatomic, strong) NSArray *titleAry;

@end

@implementation WaveLoadingListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMainView];
}

- (void)setupMainView
{
    self.title = @"首次学习波浪动画";
}

#pragma - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
      
            [self pushMatchManView];
            
            break;
            
        case 1:
            
            [self pushWaveView];
            
            break;
            
        case 2:
            
            [self pushWaveLoadingView];
            
            break;
            
        default:
            
            break;
    }
}

- (void)pushMatchManView
{
    MatchManViewController *vc = [MatchManViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWaveView
{
    WaveViewController *vc = [WaveViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWaveLoadingView
{
    WaveLoadingViewController *vc = [WaveLoadingViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter / setter

- (NSArray *)titleAry
{
    if (!_titleAry) {
        
        _titleAry = @[@"使用BezierPath画火柴人", @"使用正弦和余弦做波浪动画", @"波浪loading动画"];
    }
    
    return _titleAry;
}



@end
