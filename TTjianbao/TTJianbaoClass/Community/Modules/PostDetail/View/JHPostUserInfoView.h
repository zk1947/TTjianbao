//
//  JHPostUserInfoView.h
//  TTjianbao
//
//  Created by lihui on 2020/9/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class User;

@class JHPostDetailModel;

@interface JHPostUserInfoView : UIView
///帖子信息
@property (nonatomic, strong) JHPostDetailModel *postInfo;
@property (nonatomic, copy) void (^followBlock)(BOOL isFollow);
@property (nonatomic, copy) void (^iconEnterBlock)(void);
- (void)setUserInfo:(User *)userInfo publishTime:(NSString *)publishTime;
@end

NS_ASSUME_NONNULL_END
