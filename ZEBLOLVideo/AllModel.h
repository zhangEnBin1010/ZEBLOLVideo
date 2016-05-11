//
//  AllModel.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "JSONModel.h"


@protocol DataModel


@end
@interface DataModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *url;
@end

@interface AllModel : JSONModel
@property (nonatomic, strong) NSArray<DataModel> *data;
@end
