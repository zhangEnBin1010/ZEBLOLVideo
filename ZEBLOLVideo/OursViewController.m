//
//  OursViewController.m
//  ZEBLOLVideo
//
//  Created by qianfeng001 on 15/10/17.
//  Copyright (c) 2015年 章恩斌. All rights reserved.
//

#import "OursViewController.h"
#import "UIView+Common.h"

@interface OursViewController ()

@end

@implementation OursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLabel];
}
- (void)createLabel {
    
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.frame = CGRectMake(0, 0, 130, 130);
    logoImageView.center = CGPointMake(width(self.view.frame)/2, 100);
    [self.view addSubview:logoImageView];
    
    UILabel *bLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    bLable.center = CGPointMake(width(self.view.frame)/2, maxY(logoImageView)+15);
    bLable.text = @"掌上联盟";
    bLable.textColor = [UIColor grayColor];
    bLable.font = [UIFont boldSystemFontOfSize:18];
    bLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bLable];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY(bLable)+20, width(self.view.frame) - 20, 130)];
    
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.numberOfLines = 0;
    lable.text = @"伊泽瑞尔：我每一次的升华，每一次的跳动，为了你，我必须比别人都优秀。\n\n掌上联盟：我们喜欢游戏，在游戏之余，提供优质的游戏视频。带给每位玩家最好的游戏视频，是我们的目的。不做最好，只做更好。";
    [self.view addSubview:lable];
    
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame) - 20, 1)];
    aLable.backgroundColor = [UIColor orangeColor];
    aLable.alpha = 0.4;
    [lable addSubview:aLable];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
