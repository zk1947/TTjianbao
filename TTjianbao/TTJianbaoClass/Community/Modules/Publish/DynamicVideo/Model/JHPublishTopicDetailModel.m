//
//  JHPublishTopicDetailModel.m
//  TTjianbao
//
//  Created by jesee on 27/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishTopicDetailModel.h"
#import "NSString+Common.h"

@interface JHPublishTopicDetailModel ()

@property (nonatomic, copy) NSString* keyword; //搜索关键字
@end

@implementation JHPublishTopicDetailModel

- (void)requestTopicKeyword:(NSString*)keyword response:(JHResponse)resp
{
    self.keyword = keyword;
    JHPublishTopicDetailReqModel* req = [JHPublishTopicDetailReqModel new];
    req.keyword = keyword;
    [JH_REQUEST asynGet:req success:^(id respData) {
        NSMutableArray* array = [JHPublishTopicDetailModel convertData:respData];
        [self makeTopicDetailSearchData:&array];
        resp(array, nil);
    } failure:^(NSString *errorMsg) {
        resp(nil, errorMsg);
    }];
}
//组装搜索话题页数据
- (void)makeTopicDetailSearchData:(NSMutableArray**)array
{
    if(![NSString isEmpty:self.keyword])
    {
        if (*array)
        { //搜索到了
            __block BOOL isExist = NO;
            [*array enumerateObjectsUsingBlock:^(JHPublishTopicDetailModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.keyword isEqualToString:obj.title])
                {
                    isExist = YES;
                    *stop = YES;
                }
            }];
            //搜索到类似,但没有完全匹配
            if (!isExist)
            {
                [*array insertObject:[self makeNewTopic] atIndex:0];
            }
        }
        else
        { //未搜索到
            *array = [NSMutableArray arrayWithObject:[self makeNewTopic]];
        }
    }
}

- (JHPublishTopicDetailModel*)makeNewTopic
{
    JHPublishTopicDetailModel* topic = [JHPublishTopicDetailModel new];
    topic.isNewTopic = YES;
    topic.title = self.keyword;
    return topic;
}

//字段映射
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"image":@"preview_image",
        @"subtitle":@"content",
        @"itemId":@"item_id"
    };
}

@end

@implementation JHPublishTopicDetailReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        [self setRequestSourceType:JHRequestHostTypeSocial];
    }
    return self;
}

- (NSString*)uriPath
{//GET:http://39.97.164.118:8080/v1/topic/list?q=%E9%AB%98&page=1  搜索
    if([NSString isEmpty: self.keyword])
    {
        return @"/v1/topic/list?page=1";
    }
    else
    {
        NSString* url = [NSString stringWithFormat:@"/v1/topic/list?page=1&q=%@", self.keyword];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return url;
    }
}

//- (NSString*)uriPath
//{//POST:http://39.97.164.118:8080/v1/topic/search
//    return @"/v1/topic/search";
//}

@end
