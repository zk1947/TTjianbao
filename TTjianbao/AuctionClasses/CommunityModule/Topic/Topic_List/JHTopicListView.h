//
//  JHTopicListView.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/10.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  显示话题列表
//

#import <UIKit/UIKit.h>
@class CTopicData;

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicListView : UIView

///点击回调
@property (nonatomic, copy) void(^didSelectedBlock)(CTopicData * _Nullable data);

@end

NS_ASSUME_NONNULL_END
