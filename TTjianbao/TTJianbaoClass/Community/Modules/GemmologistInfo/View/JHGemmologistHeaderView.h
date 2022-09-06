//
//  JHGemmologistHeaderView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHAnchorInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ///关注
    JHDetailBlockTypeFollow,
    ///粉丝
    JHDetailBlockTypeFans,
    ///获赞
    JHDetailBlockTypeLike,
    ///经验
    JHDetailBlockTypeLevel,
    
} JHDetailBlockType;

@interface JHGemmologistHeaderView : BaseView
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;
@property (nonatomic, strong) JHAnchorHomeModel *model;

/** 动态刷新高度*/
@property (nonatomic, copy) void(^changeHeightBlock)(CGFloat viewHeight);
/** 点击关注后回调*/
@property (nonatomic, copy) void(^followClickBlock)(BOOL follow);
/** 判断是否是从直播页面进来的*/
@property (nonatomic, assign) BOOL isFromLivingRoom;
@end

NS_ASSUME_NONNULL_END
