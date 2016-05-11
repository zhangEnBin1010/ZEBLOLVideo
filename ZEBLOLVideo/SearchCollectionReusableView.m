//
//  SearchCollectionReusableView.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "SearchCollectionReusableView.h"
#import "UIView+Common.h"

@implementation SearchCollectionReusableView {
    UILabel *_totalLable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createLable];
    }
    return self;
}
- (void)createLable {
    _totalLable = [UILabel new];
    _totalLable.frame = CGRectMake(10, 10, width(self.frame), 30);
    _totalLable.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_totalLable];
}
- (void)setTotal:(NSString *)total {
    _total = total;
    _totalLable.text = [NSString stringWithFormat:@"共有%@个结果.",_total];
}
@end
