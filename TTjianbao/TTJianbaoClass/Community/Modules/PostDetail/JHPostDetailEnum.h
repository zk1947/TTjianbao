//
//  JHPostDetailEnum.h
//  TTjianbao
//
//  Created by lihui on 2020/8/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHPostDetailEnum_h
#define JHPostDetailEnum_h

typedef NS_ENUM(NSInteger, JHPostDetailSectionType) {
    ///用户信息描述
    JHPostDetailSectionTypeUserDesc = 0,
    ///板块入口
    JHPostDetailSectionTypePlate,
    ///店铺入口
    JHPostDetailSectionTypeShop,
    ///直播间入口
    JHPostDetailSectionTypeLivingRoom,
    ///评论输入框
    JHPostDetailSectionTypeInput,
    ///评论列表
    JHPostDetailSectionTypeComment,
};

typedef NS_ENUM(NSInteger, JHPostDetailCellType) {
    ///用户信息描述
    JHPostDetailCellTypeTitle ,
    ///描述信息
    JHPostDetailCellTypeContent = 0,
    ///图片展示
    JHPostDetailCellTypeImage,
    ///话题标签
    JHPostDetailCellTypeTopic,
    ///板块
    JHPostDetailCellTypePlate,
    ///店铺
    JHPostDetailCellTypeShop,
    ///直播间
    JHPostDetailCellTypeLiveRoom,
};

typedef NS_ENUM(NSInteger, JHPostDetailActionType) {
    ///输入框
    JHPostDetailActionTypeInput = 1,
    ///分享
    JHPostDetailActionTypeShare,
    ///评论
    JHPostDetailActionTypeComment,
    ///点赞
    JHPostDetailActionTypeLike,
    ///单击
    JHPostDetailActionTypeSingleTap,
    ///长按
    JHPostDetailActionTypeLongPress,
    ///进入个人主页
    JHPostDetailActionTypeEnterPersonPage,
    ///未知
    JHPostDetailActionTypeUnKnown,
    
};

typedef NS_ENUM(NSInteger, JHFullScreenControlActionType) {
    JHFullScreenControlActionTypeIcon = 1,
    JHFullScreenControlActionTypeFollow,
    JHFullScreenControlActionTypeLike,
    JHFullScreenControlActionTypeComment,
    JHFullScreenControlActionTypeShare,
    JHFullScreenControlActionTypeFastComment,
    JHFullScreenControlActionTypeBack,
    JHFullScreenControlActionTypePop,
    JHFullScreenControlActionTypeAllInfo,
};


#endif /* JHPostDetailEnum_h */
