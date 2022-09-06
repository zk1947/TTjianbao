//
//  JHPostCellHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/9/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHPostCellHeader_h
#define JHPostCellHeader_h

//当前所属控制器类型
typedef NS_ENUM(NSInteger, JHPageType) {
    JHPageTypeNone = 0,
    /**社区首页*/
    JHPageTypeSQHome,
    /**用户个人主页-赞过*/
    JHPageTypeUserInfoLikeTab,
    /**用户个人主页-发过*/
    JHPageTypeUserInfoPublishTab,
    /**用户个人主页*/
    JHPageTypeUserInfo,
    /**收藏列表*/
    JHPageTypeCollect,
    /**搜索页(帖子的搜索，不是社区首页搜索)*/
    JHPageTypePostSearch,
    /**社区首页搜索*/
    JHPageTypeSQHomePostSearch,
    /**社区话题主页*/
    JHPageTypeSQTopicList,
    /**社区版块主页*/
    JHPageTypeSQPlateList,
    /**h5跳转*/
    JHPageTypeWeb5,
};

#endif /* JHPostCellHeader_h */
