//
//  DynamicBasicListViewController.m
//  WaveDemo
//
//  Created by yanl on 2017/12/8.
//  Copyright © 2017年 yanl. All rights reserved.
//

#import "DynamicBasicListViewController.h"
#import "SZPushViewController.h"
#import "SZPropertyViewController.h"
#import "SZGravityViewController.h"
#import "SZCollisionViewController.h"
#import "MenuEffectViewController.h"
#import "SZAttachmentViewController.h"
#import "SZSnapViewController.h"
#import "SZComprehensiveViewController.h"
#import "SZFieldViewController.h"
#import "SZSpringsViewController.h"

@interface DynamicBasicListViewController ()

@property (nonatomic, strong) NSArray *functionList;
@property (nonatomic, strong) NSArray *functionListChinese;

@end

@implementation DynamicBasicListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.functionList[indexPath.row];
    cell.detailTextLabel.text = self.functionListChinese[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.重力测试
    if (0 == indexPath.row) {
    
        [self push:@"SZGravityViewController"];
    }
    
    // 2.碰撞测试
    if (1 == indexPath.row) {
    
        [self push:@"SZCollisionViewController"];
    }
    
    // 3.连接测试
    if (2 == indexPath.row) {
        
        [self push:@"SZAttachmentViewController"];
    }
    
    // 4.弹簧效果测试
    if (3 == indexPath.row) {
        
        [self push:@"SZSpringsViewController"];
    }
    
    // 5.吸附测试
    if (4 == indexPath.row) {
        
        [self push:@"SZSnapViewController"];
    }
    
    // 6.推力测试
    if (5 == indexPath.row) {

        [self push:@"SZPushViewController"];
    }
    
    // 7.属性测试
    if (6 == indexPath.row) {
        
        [self push:@"SZPropertyViewController"];
    }
    
    // 8.菜单效果
    if (7 == indexPath.row) {
        
        [self push:@"MenuEffectViewController"];
    }
    
    // 9.小综合使用
    if (8 == indexPath.row) {
        
        [self push:@"SZComprehensiveViewController"];
    }
    
    if (9 == indexPath.row) {
        
        [self push:@"SZFieldViewController"];
    }
}

- (void)push:(NSString *)className
{
    Class class = NSClassFromString(className);
    
    [self.navigationController pushViewController:[class new] animated:YES];
}

#pragma mark - lazy load

- (NSArray *)functionList
{
    if (nil == _functionList) {
        
        _functionList = [NSArray array];
        _functionList = @[@"Gravity", @"Collisions", @"Attachments", @"Springs", @"Snap", @"Forces", @"Properties", @"MenuEffect", @"Comprehensive", @"Field"];
    }
    
    return _functionList;
}

- (NSArray *)functionListChinese
{
    if (nil == _functionListChinese) {
        
        _functionListChinese = [NSArray array];
        _functionListChinese = @[@"重力", @"碰撞", @"连接", @"弹簧效果", @"吸附", @"推力", @"物体属性", @"菜单效果", @"小综合使用", @"场行为"];
    }
    return _functionListChinese;
}


@end
