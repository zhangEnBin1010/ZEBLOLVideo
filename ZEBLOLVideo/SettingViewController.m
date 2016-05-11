//
//  SettingViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/17.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "SettingViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "JWCache.h"
#import <SDImageCache.h>
#import "OursViewController.h"
#import "UMSocial.h"
@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
    [self createTableView];
}
- (void)leftAction:(UIBarButtonItem *)barButtonItem {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)createTableView {
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    if (section == 0 && row == 0) {
        cell.textLabel.text = @"分享给好友";
        cell.imageView.image = [UIImage imageNamed:@"share"];
        
    }else if (section == 0 && row == 1) {
        cell.textLabel.text = @"清理缓存";
        cell.imageView.image = [UIImage imageNamed:@"laji"];
        
    }else if (section == 0 && row == 2) {
        cell.textLabel.text = @"关于我们";
        cell.imageView.image = [UIImage imageNamed:@"info"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES
     ];
    if (indexPath.row == 0) {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"56234f55e0f55aab0d009be2"
                                          shareText:@"请输入分享的内容..."
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                           delegate:nil];
    }else if (indexPath.row == 1) {
        
        CGFloat sdCacheSize = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0*10.0);
        CGFloat jwCacheSize = [JWCache folderSizeAtPath:[JWCache cacheDirectory]];
        CGFloat cacheSize = sdCacheSize + jwCacheSize;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"共有%.2fM缓存,是否需要清理?",cacheSize] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (![JWCache folderSizeAtPath:[JWCache cacheDirectory]] == 0) {
                [self clear];
            }
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else {
        OursViewController *ourViewController = [OursViewController new];
        ourViewController.title = @"关于我们";
        [self.navigationController pushViewController:ourViewController animated:YES];
    }
}
- (void)clear {
    [JWCache resetCache];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"清理成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"清理成功");
    }];
    [alert addAction:alertAction2];
    
    [self presentViewController:alert animated:YES completion:^{
        
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
