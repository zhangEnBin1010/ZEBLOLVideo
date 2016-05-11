//
//  SearchModel.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/15.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "JSONModel.h"


@protocol SearchDataModel


@end
@interface SearchDataModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *bid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *big;
@property (nonatomic, copy) NSString<Optional> *flv;
@property (nonatomic, copy) NSString<Optional> *click;
@property (nonatomic, copy) NSString<Optional> *nickname;
@end

@interface SearchModel : JSONModel
@property (nonatomic, strong) NSArray<SearchDataModel> *data;
@property (nonatomic, copy) NSString<Optional> *total;
@end
