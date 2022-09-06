//
//  CTopicModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//  发布页 - 话题搜索 数据模型
//

#import "YDBaseModel.h"

//1:热、2:新、3:推荐、4:有奖
typedef NS_ENUM(NSUInteger, JHTopicTagType) {
    JHTopicTagTypeDefault,
    JHTopicTagTypeHot,
    JHTopicTagTypeNew,
    JHTopicTagTypeRecommand,
    JHTopicTagTypeAward,
    JHTopicTagTypeCount
};

NS_ASSUME_NONNULL_BEGIN

@interface CTopicModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray *list;

- (NSString *)toUrl; //获取全部话题列表的url
- (NSString *)toSearchUrlWithKey:(NSString *)key; //全部话题列表页 搜索
- (void)configModel:(CTopicModel *)model;

@end


@interface CTopicData : NSObject
@property (nonatomic,   copy) NSString *item_id; //话题id
@property (nonatomic,   copy) NSString *title; //标题
@property (nonatomic,   copy) NSString *preview_image; //话题图片
@property (nonatomic,   copy) NSString *content; //话题描述
@property (nonatomic,   copy) NSString *tag_url; //话题描述
@property (nonatomic, assign) JHTopicTagType tag_type; //话题描述

@property (nonatomic, assign) BOOL needCreate; //是否需要创建话题 - 自定义字段

@end


NS_ASSUME_NONNULL_END
