//
//  JHTopicListSearchResultView.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/10.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTopicData;

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicListSearchResultView : UIView

///点击回调
@property (nonatomic, copy) void(^didSelectedBlock)(CTopicData * _Nullable data);

@property (nonatomic, copy) NSString *keywordStr; //搜索关键字

@end

NS_ASSUME_NONNULL_END
