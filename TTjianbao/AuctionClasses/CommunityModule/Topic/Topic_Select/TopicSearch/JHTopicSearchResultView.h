//
//  JHTopicSearchResultView.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//  话题选择 - 搜索结果页
//

#import <UIKit/UIKit.h>
@class CTopicData;

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicSearchResultView : BaseView

@property (nonatomic, copy) void(^didSelectedBlock)(CTopicData *data);

@property (nonatomic, copy) NSString *keywordStr; //搜索关键字

@end

NS_ASSUME_NONNULL_END
