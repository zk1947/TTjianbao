//
//  JHMyCompeteWantToView.h
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHMyCompeteWantToModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteWantToView : UIView

/// 设置底部想要的数据
/// @param wantToModel 数据
- (void)setMyCompeteWantToModel:(JHMyCompeteWantToModel *)wantToModel;

@end

NS_ASSUME_NONNULL_END
