//
//  PutViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "PutViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import "ZEBPutModel.h"
#import "ZEBLink.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PutCollectionViewCell.h"
#import "PutCollectionReusableView.h"
#import "VideoViewController.h"
#import "SearchDesViewController.h"
#import "NSString+Tools.h"
#import "JWCache.h"

@interface PutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,PutPlayVideo,PlayVideoTopDelagate> {
    NSMutableArray *_dataArray;
    NSMutableArray *_topDataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PutViewController

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
    _topDataArray = [NSMutableArray array];
    [self createCollectionView];
}
- (void)createCollectionView {
    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((width(self.view.frame)-30)/2, 130);
        layout.minimumInteritemSpacing = 1.f;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [layout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 190)];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bag"]];
        [self.view addSubview:self.collectionView];
        [_collectionView registerClass:[PutCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[PutCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
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
- (void)prepareLoadData:(BOOL)isMore {
   
    if (isMore) {
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
        !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
        return;
    }
    [self loadingData:LOLPutUrl isMore:isMore];
}
- (void)loadingData:(NSString *)url isMore:(BOOL)isMore{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
    if (cacheData) {
        ZEBPutModel *putModel = [[ZEBPutModel alloc] initWithData:cacheData error:nil];
        
        if (!isMore) {
            [_topDataArray removeAllObjects];
            [_dataArray removeAllObjects];
        }
        [_topDataArray addObjectsFromArray:putModel.focus];
        [_dataArray addObjectsFromArray:putModel.video];
        [_collectionView reloadData];
        !isMore?[_collectionView.header endRefreshing]:[_collectionView.footer endRefreshing];
    }else {
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        ZEBPutModel *putModel = [[ZEBPutModel alloc] initWithData:responseObject error:nil];
        
        if (!isMore) {
            [_topDataArray removeAllObjects];
            [_dataArray removeAllObjects];
        }
        [_topDataArray addObjectsFromArray:putModel.focus];
        [_dataArray addObjectsFromArray:putModel.video];
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        PutCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.topDelegate  = self;
        headerView.topDataArray = _topDataArray;
        reusableview = headerView;
    }
    return reusableview;
}
- (void)putPlayVideo:(PutCollectionViewCell *)cell flv:(NSString *)flv title:(NSString *)title{
    
    VideoViewController *videoViewController = [VideoViewController new];
    videoViewController.videoUrl = [NSURL URLWithString:flv];
    videoViewController.modalTransitionStyle = 0;
    [self presentViewController:videoViewController animated:YES completion:^{
        
    }];
    
}
- (void)playVideoTop:(PutCollectionReusableView *)reusableView title:(NSString *)title {
    SearchDesViewController *searchDesViewController = [SearchDesViewController new];
    searchDesViewController.searchText = URLEncodedString(title);
    searchDesViewController.title = @"详情";
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
