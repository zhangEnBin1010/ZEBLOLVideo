//
//  StarCollectionViewCell.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "StarCollectionViewCell.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation StarCollectionViewCell {
    UIImageView *_mainImageView;
    UILabel *_bgLable;
    UILabel *_titleLable;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}
- (void)createView {
    _mainImageView = [UIImageView new];
    _mainImageView.frame = CGRectMake(0, 0, width(self.frame), height(self.frame));
    _mainImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDes:)];
    [_mainImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_mainImageView];
    
    _bgLable = [UILabel new];
    _bgLable.frame = CGRectMake(0, maxY(_mainImageView)-20, width(_mainImageView.frame), 20);
    _bgLable.backgroundColor = [UIColor blackColor];
    _bgLable.alpha = 0.15;
    [_mainImageView addSubview:_bgLable];
    
    _titleLable = [UILabel new];
    _titleLable.frame = CGRectMake(0, maxY(_mainImageView)-20, width(_mainImageView.frame), 20);
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.font = [UIFont boldSystemFontOfSize:13];
    [_mainImageView addSubview:_titleLable];
}
- (void)setDataModel:(DataModel *)dataModel {
    _dataModel = dataModel;
    [self reloadCell];
}
- (void)tapDes:(UITapGestureRecognizer *)recognizer {
    if (_desDelegate && [_desDelegate respondsToSelector:@selector(tapDes:url:title:)]) {
        [_desDelegate tapDes:self url:_dataModel.url title:_dataModel.title];
    }
}
- (void)reloadCell {
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:[UIImage imageNamed:@"loading_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _titleLable.text = _dataModel.title;
}
- (void)layoutSubviews {

    [super layoutSubviews];
    
     _bgLable.frame = CGRectMake(0, maxY(_mainImageView)-20, width(_mainImageView.frame), 20);
    _titleLable.frame = CGRectMake(0, maxY(_mainImageView)-20, width(_mainImageView.frame), 20);
    
}
@end
