//
//  StarCollectionViewCell.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllModel.h"
@class StarCollectionViewCell;
@protocol DesDelegate <NSObject>

- (void)tapDes:(StarCollectionViewCell *)cell url:(NSString *)url title:(NSString *)title;

@end

@interface StarCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) DataModel *dataModel;
@property (nonatomic, weak) id<DesDelegate> desDelegate;
@end
