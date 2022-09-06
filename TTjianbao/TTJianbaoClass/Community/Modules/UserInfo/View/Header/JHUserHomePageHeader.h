//
//  JHUserHomePageHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 个人主页头部

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kSpecialHeaderHeight = 475.f;
static const CGFloat kCommonHeaderHeight = (475.f-58-15);

typedef NS_ENUM(NSUInteger, JHDetailBlockType) {
    ///关注
    JHDetailBlockTypeFollow = 1,
    ///粉丝
    JHDetailBlockTypeFans = 2,
    ///获赞
    JHDetailBlockTypeLike,
    ///经验
    JHDetailBlockTypeExp,
};

@class JHUserInfoModel;

@interface JHUserHomePageHeader : UIView

@property (nonatomic, strong) JHUserInfoModel *userInfo;
//关注 粉丝 点赞 经验值点击事件
@property (nonatomic, copy) void(^userDetailEventBlock)(JHDetailBlockType type);
///粉丝数量
@property (nonatomic, copy) NSString *fansCount;
///关注数量
@property (nonatomic, copy) NSString *followCount;

///关注按钮点击时间回调 isUser:判断是否为本人
@property (nonatomic, copy) void(^followBlock)(BOOL isUser, BOOL isFollow);
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;




@end

NS_ASSUME_NONNULL_END
