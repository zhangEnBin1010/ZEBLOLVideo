//
//  SearchViewController.m
//  ZEBFood
//
//  Created by qianfeng001 on 15/10/4.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "SearchViewController.h"
#import "UIView+Common.h"
#import "NSString+Tools.h"
#import "ZEBLink.h"
#import "SearchDesViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
@interface SearchViewController ()<UISearchBarDelegate> {
    UISearchBar *_searchBar;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
    [self createSearchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    
}
- (void)leftAction:(UIBarButtonItem *)barButtonItem {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnTap = NO;
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)searchButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame), 40)];
    _searchBar.backgroundImage = [UIImage imageNamed:@"tab"];
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    SearchDesViewController *searchDesViewController = [SearchDesViewController new];
    searchDesViewController.isSearch = YES;
    searchDesViewController.searchText = URLEncodedString(searchBar.text);
    searchDesViewController.title = @"搜索结果";
    [self.navigationController pushViewController:searchDesViewController animated:YES];
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
