//
//  JHMessageSubListController.h
//  TTjianbao
//  Description:消息中心分类列表
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHMessageSubListData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageSubListController : JHBaseViewController

//根据type区分请求数据
- (id)initWithTitle:(NSString*)title pageType:(NSString*)type;

@end

NS_ASSUME_NONNULL_END
