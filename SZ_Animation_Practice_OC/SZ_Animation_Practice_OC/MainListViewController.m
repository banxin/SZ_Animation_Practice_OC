//
//  MainListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/11/24.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "MainListViewController.h"
#import "WaveLoadingListViewController.h"
#import "CASharpLayerListViewController.h"
#import "WaveProgressListViewController.h"
#import "DynamicBasicListViewController.h"
#import "CoreAnimationListViewController.h"

@interface MainListViewController ()

@property (nonatomic, strong) NSArray *titleAry;

@end

@implementation MainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"动画列表";
}

#pragma - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
            
            [self push:@"WaveLoadingListViewController"];
            
            break;
        
        case 1:
            
            [self push:@"CASharpLayerListViewController"];
            
            break;
            
        case 2:
            
            [self push:@"WaveProgressListViewController"];
            
            break;
            
        case 3:
            
            [self push:@"DynamicBasicListViewController"];
            
            break;
            
        case 4:
            
            [self push:@"CoreAnimationListViewController"];
            
            break;
            
        default:
            
            break;
    }
}

- (void)push:(NSString *)className
{
    Class class = NSClassFromString(className);
    
    [self.navigationController pushViewController:[class new] animated:YES];
}

#pragma mark - getter / setter

- (NSArray *)titleAry
{
    if (!_titleAry) {
        
        _titleAry = @[@"首次学习波浪动画记录", @"CAShape简单使用", @"波浪Progress动画", @"力学动画基础", @"核心动画"];
    }
    
    return _titleAry;
}

@end
