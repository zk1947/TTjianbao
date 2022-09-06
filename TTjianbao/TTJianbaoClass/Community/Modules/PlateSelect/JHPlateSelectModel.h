//
//  JHPlateSelectModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  版块选择列表数据模型
//

#import "YDBaseModel.h"

@class JHPlateSelectData;
@class JHPlateSelectDataItem;
@class JHPlateSelectDataStats;

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateSelectModel : YDBaseModel
@property (nonatomic, strong) NSMutableArray <JHPlateSelectData *> *list;
- (NSString *)toUrl;
@end


#pragma mark - 版块数据
@interface JHPlateSelectData : NSObject
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, copy) NSString *channel_image;
@property (nonatomic, assign) BOOL is_default; //不知道干嘛的，没用
@property (nonatomic, strong) JHPlateSelectDataStats *channel_stats; //<channel_stats>
@property (nonatomic, strong) NSMutableArray<JHPlateSelectDataItem *> *items;
@end


#pragma mark - 统计数据 <浏览量、评论数等>
@interface JHPlateSelectDataStats : NSObject
@property (nonatomic, assign) NSInteger comment_num; //评论数
@property (nonatomic, assign) NSInteger content_num; //包含帖子数
@property (nonatomic, assign) NSInteger liked_num; //点赞数
@property (nonatomic, assign) NSInteger scan_num; //浏览量
@property (nonatomic, assign) NSInteger share_num; //分享数
@end


#pragma mark - 版块下的子类
@interface JHPlateSelectDataItem : NSObject
@property (nonatomic, copy) NSString *item_id; //<id>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *channel_id;
@end

NS_ASSUME_NONNULL_END
