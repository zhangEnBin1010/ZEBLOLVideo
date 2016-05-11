//
//  LeftViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "LeftViewController.h"
#import "PutViewController.h"
#import "StarViewController.h"
#import "ProgrammeViewController.h"
#import "HeroViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "AppDelegate.h"
#import "ZEBLink.h"
#import "UIView+Common.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"掌上联盟";
    [self initall];
    
}
- (void)initall {
    [self createTableView];
    [self createSetting];
    [self createSearchBarButton];
}
- (void)createSearchBarButton {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    imageView.alpha = 0.6;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 20, 180, 30);
    imageView.frame = CGRectMake(4, 2, 25, 25);
    [button addSubview:imageView];
    button.backgroundColor = [UIColor lightGrayColor];
    button.layer.cornerRadius = 3;
    [button setTitle:@"请输关键字" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonBarClick:(UIButton *)button {
    SearchViewController *searchViewController = [SearchViewController new];
    UINavigationController *putNav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.title = @"搜索";
    [self.mm_drawerController setCenterViewController:putNav];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)createSetting {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, maxY(_tableView)+8, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(set:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)set:(UIButton *)button {
    SettingViewController *setViewController = [SettingViewController new];
    UINavigationController *putNav = [[UINavigationController alloc] initWithRootViewController:setViewController];
    setViewController.title = @"我的设置";
    [self.mm_drawerController setCenterViewController:putNav];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)createTableView {
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-160) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    NSArray *titleArray = @[@"推荐",@"明星",@"节目",@"英雄"];
    NSArray *imageArray = @[@"jian",@"xing",@"jiemu",@"hero"];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES
     ];
    if (indexPath.row == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *putNav = [[UINavigationController alloc] initWithRootViewController:appDelegate.putViewController];
        [appDelegate.putViewController.mm_drawerController closeDrawerGestureModeMask];
        [self.mm_drawerController setCenterViewController:putNav];
       
    }else if (indexPath.row == 1) {
        StarViewController *starViewController = [StarViewController new];
        UINavigationController *starNav = [[UINavigationController alloc] initWithRootViewController:starViewController];
        starViewController.title = @"明星";
        starViewController.type = StarType;
        [self.mm_drawerController setCenterViewController:starNav];
       
    }else if (indexPath.row == 2) {
        ProgrammeViewController *programmeViewController = [ProgrammeViewController new];
        UINavigationController *programmeNav = [[UINavigationController alloc] initWithRootViewController:programmeViewController];
        programmeViewController.title = @"节目";
        programmeViewController.type = ProgrammeType;
        [self.mm_drawerController setCenterViewController:programmeNav];
        
    }else if (indexPath.row == 3) {
        HeroViewController *heroViewController = [HeroViewController new];
        UINavigationController *heroNav = [[UINavigationController alloc] initWithRootViewController:heroViewController];
        heroViewController.title = @"英雄";
        heroViewController.type = HeroType;
        [self.mm_drawerController setCenterViewController:heroNav];
        
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
