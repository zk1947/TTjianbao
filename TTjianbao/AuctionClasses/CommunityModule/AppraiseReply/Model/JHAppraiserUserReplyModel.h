//
//  JHAppraiserUserReplyModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/5/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  鉴定贴回复 - 宝友回复列表数据模型
//

#import "YDBaseModel.h"

@class JHAppraiserUserReplyData;

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - model
@interface JHAppraiserUserReplyModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray <JHAppraiserUserReplyData *> *list;

- (NSString *)toUrl;
- (void)configModel:(JHAppraiserUserReplyModel *)model;

@end


#pragma mark -
#pragma mark - data
@interface JHAppraiserUserReplyData : NSObject
@property (nonatomic,   copy) NSString *item_id;
@property (nonatomic, assign) JHSQItemType item_type; //item_id和item_type一起标识商品唯一性
@property (nonatomic, assign) JHSQLayoutType layout;
@property (nonatomic,   copy) NSString *title; //帖子标题
@property (nonatomic,   copy) NSString *reply_desc; //回复描述
@property (nonatomic,   copy) NSString *publish_time;
@property (nonatomic,   copy) NSString *image;
@property (nonatomic,   copy) NSString *comment_id; //用于跳转详情页 自动定位评论区

@end

NS_ASSUME_NONNULL_END
