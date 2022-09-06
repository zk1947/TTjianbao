//
//  JHStoneSearchConditionView.h
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSearchConditionView : UIView

@property (nonatomic, copy) void(^selectedBlock)(NSDictionary *paramDic);

/// 反传已经选中 参数
@property (nonatomic, copy) NSDictionary *selectDic;
@end

NS_ASSUME_NONNULL_END
