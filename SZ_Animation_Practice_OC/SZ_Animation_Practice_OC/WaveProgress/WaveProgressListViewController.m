//
//  WaveProgressListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/27.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "WaveProgressListViewController.h"
#import "WaveProgressViewController.h"
#import "TieBaLoadingViewController.h"

@interface WaveProgressListViewController ()

@property (nonatomic, strong) NSArray *titleAry;

@end

/*
 http://blog.csdn.net/u013282507/article/details/53121556
 */
@implementation WaveProgressListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"波浪进度动画";
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
            
            [self pushProgress];
            
            break;
            
        case 1:
            
            [self pushTieba];
            
            break;
            
        default:
            
            break;
    }
}

- (void)pushProgress
{
    WaveProgressViewController *vc = [WaveProgressViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTieba
{
    TieBaLoadingViewController *vc = [TieBaLoadingViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter / setter

- (NSArray *)titleAry
{
    if (!_titleAry) {
        
        _titleAry = @[@"波浪进度动画", @"仿百度贴吧动画"];
    }
    
    return _titleAry;
}





























@end
