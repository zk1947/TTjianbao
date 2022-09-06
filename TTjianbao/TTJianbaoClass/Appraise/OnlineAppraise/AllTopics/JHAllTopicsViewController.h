//
//  JHAllTopicsViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///在线鉴定首页 - 全部鉴定师列表 （点击查看全部按钮跳转的页面）

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class JHOnlineAppraiseModel;

@interface JHAllTopicsViewController : JHBaseViewController

@property (nonatomic, strong) NSMutableArray <JHOnlineAppraiseModel *>*topicInfo;


@end

NS_ASSUME_NONNULL_END
