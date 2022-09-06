//
//  JHMyUserInfoDraftHeader.h
//  TTjianbao
//
//  Created by wangjianios on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyUserInfoDraftHeader : UIView

///有数据就刷新
- (void)refresh;

/// 没数据不展示
+ (BOOL)isShowDraft;

+ (NSInteger)draftCount;

@end

NS_ASSUME_NONNULL_END
