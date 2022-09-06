//
//  JHPublishTopicModel.m
//  TTjianbao
//  
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishTopicModel.h"
#import "JHPersistData.h"

#define kMaxPublishTopicRecordCount 10
#define kPublishTopicRecordArrayPath @"JH_PublishTopicRecordArrayPath"

@implementation JHPublishTopicModel

- (void)requestTopicDataResponse:(JHResponse)resp
{
    JHPublishTopicDetailModel* detail = [JHPublishTopicDetailModel new];
    [detail requestTopicKeyword:nil response:^(NSArray* array, NSString *errorMsg) {
        if(errorMsg)
        {
            self.recordArray = [JHPublishTopicRecordModel topicRecordSortArray];
            resp(nil, errorMsg);
        }
        else
        {
            self.detailArray = [NSArray arrayWithArray:array];
            self.recordArray = [JHPublishTopicRecordModel topicRecordSortArray];
            resp(self.detailArray, nil);
        }
    }];
}

- (void)makeTopicRecordModel:(id)model
{
    JHPublishTopicRecordModel* topic = [JHPublishTopicRecordModel new];
    topic.isSelectedTopic = YES;
    
    if([model isKindOfClass:[JHPublishTopicDetailModel class]])
    {
        JHPublishTopicDetailModel* detail = (JHPublishTopicDetailModel*)model;
        topic.itemId = detail.itemId;
        topic.title = detail.title;
        topic.image = detail.image;
    }
    else if([model isKindOfClass:[JHPublishTopicRecordModel class]])
    {
        JHPublishTopicRecordModel* record = (JHPublishTopicRecordModel*)model;
        topic.itemId = record.itemId;
        topic.title = record.title;
        topic.image = record.image;
    }
    if(self.selectedArray)
    {
        self.selectedArray = [JHPublishTopicRecordModel saveExistData:self.selectedArray NorepeatData:[NSArray arrayWithObject:topic]];
    }
    else
    {
        self.selectedArray = [NSMutableArray arrayWithObject:topic];
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
                    @"newArray": [JHPublishTopicRecordModel class],
                    @"recordArray": [JHPublishTopicRecordModel class],
                    @"detailArray": [JHPublishTopicDetailModel class]
                };
}

@end

@implementation JHPublishTopicRecordModel

//获取话题详情:倒序
+ (NSMutableArray*)topicRecordSortArray
{
    NSArray* arr = [self topicDetailArray]; //倒序
    NSMutableArray* existArr = (NSMutableArray*)[[arr reverseObjectEnumerator] allObjects];
    return existArr;
}

+ (NSMutableArray*)topicDetailArray
{
    NSMutableArray* existArr = [JHPersistData persistDataByPath:kPublishTopicRecordArrayPath];
    return existArr;
}
//保存话题记录
+ (void)saveTopicRecordArray:(NSArray*)array
{
    NSMutableArray* existArr = [self topicDetailArray];
    if(!existArr)
        existArr = [NSMutableArray array];
    //保存数据,去重处理
    existArr = [self saveExistData:existArr NorepeatData:array];
    for (JHPublishTopicRecordModel* model in existArr) {
        model.style = JHCollectionItemStyleDefault;
    }
    [JHPersistData savePersistData:existArr savePath:kPublishTopicRecordArrayPath];
}
//删除所有记录
+ (void)deleteAllTopicRecord
{
    NSMutableArray* emptyArr = [NSMutableArray array];
    [JHPersistData savePersistData:emptyArr savePath:kPublishTopicRecordArrayPath];
}
//保存数据,去重处理
+ (NSMutableArray*)saveExistData:(NSMutableArray*)existArray NorepeatData:(NSArray*)senderArray
{
    NSMutableArray *array2 = [NSMutableArray new];
    
    for (id model in senderArray) {
        if([model isKindOfClass:[JHPublishTopicDetailModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicDetailModel* detail = (JHPublishTopicDetailModel*)model;
            m.itemId = detail.itemId;
            m.title = detail.title;
            m.image = detail.image;
            [array2 addObject:m];
        }
        else if([model isKindOfClass:[JHPublishTopicRecordModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicRecordModel* record = (JHPublishTopicRecordModel*)model;
            m.itemId = record.itemId;
            m.title = record.title;
            m.image = record.image;
            [array2 addObject:m];
        }
    }
    
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:existArray];
    for (JHPublishTopicRecordModel* oldModel in existArray)
    {
        for (JHPublishTopicRecordModel* model in array2)
        {
            if(model.itemId && [model.itemId isKindOfClass:[NSNumber class]]) {
                model.itemId = OBJ_TO_STRING(model.itemId);
            }
            
            if(oldModel.itemId && [oldModel.itemId isKindOfClass:[NSNumber class]]) {
                oldModel.itemId = OBJ_TO_STRING(oldModel.itemId);
            }
            
            //如果有重复,则remove
            if((model.itemId && [model.itemId isEqualToString:oldModel.itemId]) ||
              (!model.itemId && [model.title isEqualToString:oldModel.title]))
            {
                [newArr removeObject:oldModel]; //旧的去掉,保留新的
            }
               
            
        }
    }
    //去重完成后,添加新数据
    [newArr addObjectsFromArray:array2];
    NSInteger len = [newArr count] - kMaxPublishTopicRecordCount;
    //再次检查是否超出最大个数
    if(len > 0)
    {
        [newArr removeObjectsInRange:NSMakeRange(0, len)];
    }
    return newArr;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if(self = [super initWithCoder:coder])
    {
        _isSelectedTopic = [coder decodeBoolForKey:@"jh_isSelectedTopic"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeBool:_isSelectedTopic forKey:@"jh_isSelectedTopic"];
}

@end


