//
//  JHLaunchModel.h
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHDiscoverChannelType) {
    JHDiscoverChannelTypeAppraise = -3,  //求鉴定
    JHDiscoverChannelTypeRecommend = -2,  //推荐
    JHDiscoverChannelTypeFocus, //关注
    JHDiscoverChannelTypeNone,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHDiscoverChannelModel : NSObject
//@property(nonatomic, strong) NSString *intrestId;
//@property(nonatomic, strong) NSString *picUrl;
//@property(nonatomic, strong) NSString *intrestDes;
//是否被关注
//@property (nonatomic, assign) BOOL isFocus;


/*
 is_show
 // 是否在编辑页显示，0-默认隐藏（固定类别不在编辑页显示，如推荐、关注），1-显示
 is_selected
 // 是否为选中状态，0-默认未选，1-选中，
 is_default
 // 进入社区是否默认请求此类别（切换到此），0-默认不是，1-是，固定类别才有效
 
 is_show为0隐藏 都不用判断is_selected
 is_show为1显示 再去判断is_selected ，如果是2固定类型不给选择按钮
 */

@property (nonatomic, assign) NSInteger channel_id;
@property (nonatomic,   copy) NSString  *channel_name;
@property (nonatomic,   copy) NSString  *image;
@property (nonatomic,   copy) NSString  *create_time;
@property (nonatomic, assign) NSInteger is_selected;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, assign) NSInteger is_show;
@property (nonatomic,   copy) NSString  *tag_image_url; //new标签图标url
@property (nonatomic, assign) BOOL      tag_type; //是否new标签频道，1是 0否

@property (nonatomic, assign) JHDiscoverChannelType channelType; ///频道类型
@end

NS_ASSUME_NONNULL_END
