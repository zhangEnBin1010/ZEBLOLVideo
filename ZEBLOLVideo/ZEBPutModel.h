//
//  ZEBPutModel.h
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/14.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "JSONModel.h"


@protocol FocusModel

@end
@protocol VideoModel

@end

@interface VideoModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *bid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *big;
@property (nonatomic, copy) NSString<Optional> *flv;
@property (nonatomic, copy) NSString<Optional> *click;
@property (nonatomic, copy) NSString<Optional> *nickname;
@property (nonatomic, copy) NSString<Optional> *url;
@end

@interface FocusModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *info;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *pic;
@end

@interface ZEBPutModel : JSONModel
@property (nonatomic, strong) NSArray<FocusModel,Optional> *focus;
@property (nonatomic, strong) NSArray<VideoModel> *video;
@end
