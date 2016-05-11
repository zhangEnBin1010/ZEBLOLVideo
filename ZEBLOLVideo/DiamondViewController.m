//
//  DiamondViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "DiamondViewController.h"
#import "ZEBLink.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import "UIView+Common.h"
#import "StarCollectionViewCell.h"
#import "AllModel.h"
#import "DesViewController.h"
#import "SearchDesViewController.h"
#import "NSString+Tools.h"
#import "JWCache.h"
@interface DiamondViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,DesDelegate> {
    NSMutableArray *_dataArray;
    UIScrollView *_scrollView;
    
}

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DiamondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initall];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.hidesBarsOnSwipe = YES;
}
- (void)initall {
    _dataArray = [NSMutableArray array];
    [self createCollectionView];
}
- (void)createCollectionView {
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((width(self.view.frame)-50)/4, (width(self.view.frame)-50)/4);
        layout.minimumInteritemSpacing = 1.f;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bag"]];
         self.collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.collectionView];
        [_collectionView registerClass:[StarCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self prepareLoadData:NO];
    }];
    
    self.collectionView.header = refreshHeader;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self prepareLoadData:YES];
    }];
    self.collectionView.footer = refreshFooter;
    
    [_collectionView.header beginRefreshing];
}
- (void)remind {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lable.center = CGPointMake(midX(self.view), height(self.view.frame)-100);
    lable.backgroundColor = [UIColor blackColor];
    lable.text = @"到底了";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.alpha = 0.8;
    lable.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:lable];
    [UIView animateWithDuration:1 animations:^{
        lable.alpha = 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            lable.alpha = 0.0;
        } completion:^(BOOL finished) {
            [lable removeFromSuperview];
        }];
    }];
}
- (void)prepareLoadData:(BOOL)isMore {
    
    NSString *url = @"";
    NSInteger page = 1;
    if (isMore) {
        if ([_type isEqualToString:StarType]) {
            page = _dataArray.count/25 + 1;
            if (_dataArray.count%25 != 0) {
                [self remind];
                !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
                return;
            }
        }else if ([_type isEqualToString:ProgrammeType]) {
            page = _dataArray.count/25 + 1;
            if (_dataArray.count%25 != 0) {
                [self remind];
                !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
                return;
            }
        }else {
            page = _dataArray.count/24 + 1;
            if (_dataArray.count%24 != 0) {
                [self remind];
                !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
                return;
            }
        }
    }
    if ([_type isEqualToString:StarType]) {
        url = [NSString stringWithFormat:LOLStarUrl,page];
    }else if ([_type isEqualToString:ProgrammeType]) {
        url = [NSString stringWithFormat:LOLProgrammeUrl,page];
    }else {
        url = [NSString stringWithFormat:LOLHeroUrl,page];
    }
    [self loadingData:url isMore:isMore];
}
- (void)loadingData:(NSString *)url isMore:(BOOL)isMore{
     NSInteger count = _dataArray.count;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        AllModel *allModel = [[AllModel alloc] initWithData:cacheData error:nil];
        
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:allModel.data];
        if (isMore) {
            if (_dataArray.count == count) {
                [self remind];
            }
        }
        [_collectionView reloadData];
        !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
    }else {
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AllModel *allModel = [[AllModel alloc] initWithData:responseObject error:nil];
        
        if (!isMore) {
        [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:allModel.data];
        if (isMore) {
            if (_dataArray.count == count) {
                [self remind];
            }
        }
        [_collectionView reloadData];
        !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [JWCache setObject:responseObject forKey:MD5Hash(url)];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[operation description]);
    }];
    
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.desDelegate = self;
    cell.dataModel = _dataArray[indexPath.item];
    return cell;
}
- (void)tapDes:(StarCollectionViewCell *)cell url:(NSString *)url title:(NSString *)title{
    
    if ([self.type isEqualToString:StarType] || [self.type isEqualToString:ProgrammeType]) {
        SearchDesViewController *searchDesViewController = [SearchDesViewController new];
        searchDesViewController.isSearch = NO;
        searchDesViewController.searchText = URLEncodedString(title);
        searchDesViewController.title = title;
        [self.navigationController pushViewController:searchDesViewController animated:YES];
    }else {
    DesViewController *desViewController = [DesViewController new];
    desViewController.type = self.type;
    NSArray *urlArray = [url componentsSeparatedByString:@"%s"];
    NSString *newUrl = [urlArray componentsJoinedByString:LOLVersion];
    desViewController.title = title;
    desViewController.url = newUrl;
        [self.navigationController pushViewController:desViewController animated:YES];
    }
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
