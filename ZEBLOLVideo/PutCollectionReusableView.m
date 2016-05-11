//
//  PutCollectionReusableView.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "PutCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "ZEBPutModel.h"
@implementation PutCollectionReusableView {
    UIScrollView *_scrollView;
    NSInteger _count;
    NSTimer *_timer;
    NSMutableArray *_buttonArray;
    NSMutableArray *_labelArray;
    UILabel *_lable;
    UIImageView *_titleImageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _buttonArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
        [self createTimer];
        [self createScrollView];
    }
    return self;
}
- (void)setTopDataArray:(NSMutableArray *)topDataArray {
    for (UILabel *lable in _labelArray) {
        [lable removeFromSuperview];
        
    }
    for (UIImageView *imageView in _buttonArray) {
        [imageView removeFromSuperview];
        
    }
    [_buttonArray removeAllObjects];
    [_labelArray removeAllObjects];
    _topDataArray = topDataArray;
    [self addImages];
}
- (void)timerButton:(NSTimer *)timer {
    static NSInteger index = 0;
    if (index++ == _count - 2) {
        index = 0;
    }
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame)*(index+1), 0) animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self timerOff];
}
- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerButton:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timerOff {
    [_timer invalidate];
    _timer = nil;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self createTimer];
}
- (void)createScrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width(self.frame), 160)];
        _scrollView.delegate = self;
        _scrollView.directionalLockEnabled = YES;
        [self addSubview:_scrollView];
    }
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zan"]];
        _titleImageView.frame = CGRectMake(0, maxY(_scrollView)+10, 25, 25);
        [self addSubview:_titleImageView];
    }

    if (_lable == nil) {
        _lable = [UILabel new];
        _lable.frame = CGRectMake(maxX(_titleImageView), maxY(_scrollView)+10, 100, 25);
        _lable.text = @"精彩推荐";
        _lable.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_lable];
    }
}
- (void)addImages {
    if (_topDataArray.count == 0) {
        return;
    }
    _count = _topDataArray.count + 2;
    for (int i = 0; i < _count; i++) {
        NSString *imageName = nil;
        NSString *imageTitle = nil;
        if (i == 0) {
            
            imageName = [_topDataArray[_count - 3] pic];
            imageTitle = [_topDataArray[_count - 3] title];
        }else if (i == _count - 1) {
            imageName = [_topDataArray[_count - 1 - i] pic];
            imageTitle = [_topDataArray[_count - 1 - i] title];
        }else{
            imageName = [_topDataArray[i - 1] pic];
            imageTitle = [_topDataArray[i - 1] title];
        }
        
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loading_2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        imageView.frame = CGRectMake(i*_scrollView.frame.size.width, 0, CGRectGetWidth(self.frame), _scrollView.frame.size.height);
        imageView.tag = 10000+i;
        UILabel *bgLablel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageView.frame) - 20, width(self.frame), 20)];
        bgLablel.backgroundColor = [UIColor blackColor];
        bgLablel.alpha = 0.15;
        [imageView addSubview:bgLablel];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(imageView.frame) - 25, CGRectGetWidth(imageView.frame), 25)];
        lable.text = imageTitle;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont boldSystemFontOfSize:15];
        [imageView addSubview:lable];
        imageView.userInteractionEnabled = YES;
        if (i >= 1 && i <= 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [imageView addGestureRecognizer:tap];
        }
        [_buttonArray addObject:imageView];
        [_labelArray addObject:lable];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(_count*CGRectGetWidth(_scrollView.frame), _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        CGPoint offest = scrollView.contentOffset;
        if (offest.x == 0) {
            scrollView.contentOffset = CGPointMake((_count - 2)*_scrollView.bounds.size.width, 0);
        }else if (offest.x == (_count - 1)*_scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
        }
    }
}
- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    
    NSInteger index = [[recognizer view] tag]-10000;
    if (_topDelegate && [_topDelegate respondsToSelector:@selector(playVideoTop:title:)]) {
        [_topDelegate playVideoTop:self title:[_topDataArray[index-1] title]];
    }
}

@end
