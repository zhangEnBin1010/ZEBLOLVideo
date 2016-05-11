//
//  PutCollectionReusableView.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PutCollectionReusableView;
@protocol PlayVideoTopDelagate <NSObject>

- (void)playVideoTop:(PutCollectionReusableView *)reusableView title:(NSString *)title;

@end
@interface PutCollectionReusableView : UICollectionReusableView<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *topDataArray;
@property (nonatomic, weak) id<PlayVideoTopDelagate> topDelegate;
@end
