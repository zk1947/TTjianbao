//
//  JHAnchorInfoSectionHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomModel;

typedef NS_ENUM(NSInteger, JHArchorSectionType) {
    ///直播间
    JHArchorSectionTypeLiveRoom = 0,
    ///添加
    JHArchorSectionTypeAddInfo = 1,
    ///主播
    JHArchorSectionTypeArchor = 2,
};

@interface JHAnchorInfoSectionHeader : UIView

- (void)setTitle:(NSString *)title HeaderIcon:(NSString *)headerIcon;

///直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;

@property (nonatomic, copy) NSString *headerIcon;
@property (nonatomic, copy) NSString *title;
///根据是否有直播间介绍判断是否显示编辑按钮
//@property (nonatomic, assign) BOOL isArchor;
@property (nonatomic, assign) JHArchorSectionType type;

@property (nonatomic, copy) void(^editBlock)(JHArchorSectionType type);
@property (nonatomic, copy) void(^deleteBlock)(JHArchorSectionType type);

@end

NS_ASSUME_NONNULL_END
