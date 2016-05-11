//
//  PutCollectionViewCell.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEBPutModel.h"

@class PutCollectionViewCell;
@protocol PutPlayVideo <NSObject>

- (void)putPlayVideo:(PutCollectionViewCell *)cell flv:(NSString *)flv title:(NSString *)title;

@end
@interface PutCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) VideoModel *videoModel;
@property (nonatomic, weak) id<PutPlayVideo> putDelegate;
@end
