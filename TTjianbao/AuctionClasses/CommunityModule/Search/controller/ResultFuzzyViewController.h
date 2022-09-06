//
//  ResultFuzzyViewController.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/28.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"

@interface ResultFuzzyViewController : JHBaseViewExtController <JXCategoryListContentViewDelegate>

@property(nonatomic, strong) NSString *q;
@property(nonatomic, assign) NSInteger channelId;
@property(nonatomic, strong) NSString *type;

@property(nonatomic, assign) BOOL hasTopic;

@end
