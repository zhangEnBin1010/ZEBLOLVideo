//
//  SearchCollectionViewCell.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "UIView+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SearchCollectionViewCell{
    UIImageView *_mainImageView;
    UILabel *_titleLable;
    UILabel *_lookLable;
    UILabel *_userNameLable;
    UILabel *_bgLable;
    UILabel *_buttomLable;
    UIImageView *_userImageView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self customView];
    }
    return self;
}
- (void)customView {
    _mainImageView = [UIImageView new];
    _mainImageView.frame = CGRectMake(0, 0, width(self.frame), 100);
    _mainImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayVideo:)];
    [_mainImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_mainImageView];
    
    _bgLable = [UILabel new];
    _bgLable.frame = CGRectMake(0, maxY(_mainImageView)-20, width(_mainImageView.frame), 20);
    _bgLable.backgroundColor = [UIColor blackColor];
    _bgLable.alpha = 0.15;
    [_mainImageView addSubview:_bgLable];
    
    _lookLable = [UILabel new];
    _lookLable.frame = CGRectMake(width(_mainImageView.frame)-30, height(_mainImageView.frame)-20, 30, 20);
    _lookLable.font = [UIFont boldSystemFontOfSize:12];
    _lookLable.textColor = [UIColor whiteColor];
    _lookLable.textAlignment = NSTextAlignmentRight;
    _lookLable.adjustsFontSizeToFitWidth = YES;
    [_mainImageView addSubview:_lookLable];
    
    _userImageView = [UIImageView new];
    _userImageView.frame = CGRectMake(minX(_lookLable)-15, minY(_lookLable)+3, 15, 15);
    [self.contentView addSubview:_userImageView];
    
    _titleLable = [UILabel new];
    _titleLable.font = [UIFont boldSystemFontOfSize:15];
    _titleLable.frame = CGRectMake(minX(_mainImageView), maxY(_mainImageView)+5, width(_mainImageView.frame), 20);
    [self.contentView addSubview:_titleLable];
    
    
    _userNameLable = [UILabel new];
    _userNameLable.font = [UIFont boldSystemFontOfSize:12];
    _userNameLable.frame = CGRectMake(5, maxY(_mainImageView)-20, width(_mainImageView.frame)-65, 20);
    _userNameLable.textColor = [UIColor whiteColor];
    [_mainImageView addSubview:_userNameLable];
    
    _buttomLable = [UILabel new];
    _buttomLable.frame = CGRectMake(0, height(self.frame)-1, width(self.frame), 1);
    _buttomLable.layer.borderWidth = 1;
    _buttomLable.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _buttomLable.alpha = 0.5;
    [self.contentView addSubview:_buttomLable];
    
}
- (void)tapPlayVideo:(UITapGestureRecognizer *)recognizer {
    if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(searchPlayVideo:flv:)]) {
        [_searchDelegate searchPlayVideo:self flv:_dataModel.flv];
    }
}
- (void)setDataModel:(SearchDataModel *)dataModel {
    _dataModel = dataModel;
    [self reloadCell];
}
- (void)reloadCell {
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.big] placeholderImage:[UIImage imageNamed:@"loading_3"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _userImageView.image = [UIImage imageNamed:@"user-0"];
    _lookLable.text = _dataModel.click;
    _titleLable.text = _dataModel.title;
    
    _userNameLable.text = _dataModel.nickname;
}


@end
