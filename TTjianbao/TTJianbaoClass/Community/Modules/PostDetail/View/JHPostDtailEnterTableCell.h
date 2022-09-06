//
//  JHPostDtailEnterTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区帖子详情页 - 店铺/直播间入口的cell

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"
#import "JHLiveRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

typedef NS_ENUM(NSInteger, JHDetailEnterType) {
    ///店铺
    JHDetailEnterTypeShop,
    ///直播间
    JHDetailEnterTypeLiveRoom,
};

static NSString * const kPostDetailEnterIdentifer = @"JHPostDtailEnterTableCellIdentifer";

@interface JHPostDtailEnterTableCell : UITableViewCell


- (void)setDetailModel:(JHPostDetailModel * _Nonnull)detailModel SectionType:(JHPostDetailSectionType)type;


/// 根据数据给cell赋值
/// @param icon 头像
/// @param name 名称
/// @param desc 描述信息
/// @param state 直播状态
/// @param type cell类型

- (void)setIcon:(NSString *)icon
           name:(NSString *)name
           desc:(NSString *)desc
      liveState:(JHAnchorLiveState)state
type:(JHDetailEnterType)type;

@end

NS_ASSUME_NONNULL_END
