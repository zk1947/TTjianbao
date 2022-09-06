//
//  JHMsgSubListAnnounceModel.h
//  TTjianbao
//  Description:分类model：优惠活动&平台公告 共用
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMsgSubListAnnounceModel : JHMsgSubListModel

@property (nonatomic, copy) NSString* href;//  公告详情页面地址
@property (nonatomic, copy) NSString* mId;//  (integer, optional),公告ID
//TODO:mark>>两者区别：服务端暂定用image,忽略imageUrl
@property (nonatomic, copy) NSString* image;//  (string, optional),缩略图片地址
@property (nonatomic, copy) NSString* imageUrl;//  (string, optional),原始图片地址
@property (nonatomic, copy) NSString* iconUrl;//  new:图标路径
@property (nonatomic, copy) NSString* publishDate;//   new:发布时间
//thirdType 样式:announce_activity:活动公告=>优惠活动;announce_common:平台公告,
@end

NS_ASSUME_NONNULL_END
