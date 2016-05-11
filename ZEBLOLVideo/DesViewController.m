//
//  DesViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "DesViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "PutCollectionViewCell.h"
#import "ZEBLink.h"
#import "VideoViewController.h"
#import "SearchDesViewController.h"
#import "NSString+Tools.h"
#import "JWCache.h"
@interface DesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,PutPlayVideo> {
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.hidesBarsOnSwipe = YES;
}
- (void)setUrl:(NSString *)url {
    _url = url;
    [self initall];
}
- (void)initall {
    _dataArray = [NSMutableArray array];
    [self createCollectionView];
}
- (void)createCollectionView {
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((width(self.view.frame)-30)/2, 130);
        layout.minimumInteritemSpacing = 1.f;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bag"]];
        [self.view addSubview:self.collectionView];
        [_collectionView registerClass:[PutCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
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
    NSInteger page = 1;
    NSString *url = nil;
    if (isMore) {
        page = _dataArray.count/20 + 1;
        if (_dataArray.count%20 != 0) {
            [self remind];
            !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
            return;
        }
    }
    NSArray *urlArray = [_url componentsSeparatedByString:@"%d"];
    url = [urlArray componentsJoinedByString:[NSString stringWithFormat:@"%ld",page]];
    [self loadingData:url isMore:isMore];
    NSLog(@"%@",url);
}
- (void)loadingData:(NSString *)url isMore:(BOOL)isMore{
    NSInteger count = _dataArray.count;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        ZEBPutModel *putModel = [[ZEBPutModel alloc] initWithData:cacheData error:nil];
        
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:putModel.video];
        if (isMore) {
            if (_dataArray.count == count) {
                [self remind];
            }
        }
        [_collectionView reloadData];
        !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
    }else {
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ZEBPutModel *putModel = [[ZEBPutModel alloc] initWithData:responseObject error:nil];
        
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:putModel.video];
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
    PutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.putDelegate = self;
    cell.videoModel = _dataArray[indexPath.item];
    return cell;
}
- (void)putPlayVideo:(PutCollectionViewCell *)cell flv:(NSString *)flv title:(NSString *)title{
    
    VideoViewController *videoViewController = [VideoViewController new];
    videoViewController.videoUrl = [NSURL URLWithString:flv];
    videoViewController.modalTransitionStyle = 0;
    [self presentViewController:videoViewController animated:YES completion:^{
        
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
