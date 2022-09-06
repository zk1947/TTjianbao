//
//  JHPublishTopicModel.h
//  TTjianbao
//  Description:发布话题-选择话题/搜索话题model
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCollectionItemModel.h"
#import "JHPublishTopicDetailModel.h"

@class JHPublishTopicRecordModel;

@interface JHPublishTopicModel : NSObject

@property (nonatomic, strong) NSMutableArray* selectedArray;
@property (nonatomic, strong) NSArray* recordArray;
@property (nonatomic, strong) NSArray* detailArray;

- (void)requestTopicDataResponse:(JHResponse)resp;
- (void)makeTopicRecordModel:(id)model;
@end

//选择话题-已选/历史记录
@interface JHPublishTopicRecordModel : JHCollectionItemModel <NSCoding>

@property (nonatomic, assign) BOOL isSelectedTopic; //区分是否已选话题

//获取话题详情:倒序
+ (NSMutableArray*)topicRecordSortArray;
//保存话题详情
+ (void)saveTopicRecordArray:(NSArray*)array;
//保存数据,去重处理
+ (NSMutableArray*)saveExistData:(NSMutableArray*)existArray NorepeatData:(NSArray*)array;
//删除所有记录
+ (void)deleteAllTopicRecord;
@end



