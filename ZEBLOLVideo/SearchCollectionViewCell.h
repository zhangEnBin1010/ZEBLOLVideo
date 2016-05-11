//
//  SearchCollectionViewCell.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@class SearchCollectionViewCell;
@protocol SearchPlayVideo <NSObject>

- (void)searchPlayVideo:(SearchCollectionViewCell *)cell flv:(NSString *)flv;

@end

@interface SearchCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SearchDataModel *dataModel;
@property (nonatomic, weak) id<SearchPlayVideo> searchDelegate;
@end
