//
//  DiamondViewController.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "MainViewController.h"

@interface DiamondViewController : MainViewController
@property (nonatomic, copy) NSString *type;

- (void)loadingData:(NSString *)url isMore:(BOOL)isMore;
@end
