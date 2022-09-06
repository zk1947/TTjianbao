//
//  JHTopicSelectListView.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//  热门话题列表
//

#import <UIKit/UIKit.h>
@class CTopicData;

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicSelectListView : UIView

// data传nil 表示取消选择
@property (nonatomic, copy) void(^didSelectedBlock)(CTopicData * _Nullable data);

@end

NS_ASSUME_NONNULL_END
