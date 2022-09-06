//
//  JHPublishTopicDetailModel.h
//  TTjianbao
//  Description:发布话题-选择话题/搜索话题-话题详细
//  Created by jesee on 27/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"

//全部话题下-model(话题详情)
@interface JHPublishTopicDetailModel : JHRespModel 

@property (nonatomic, assign) BOOL isNewTopic; //区分是否重新创建话题
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* itemId;
@property (nonatomic, copy) NSString* tag_type;
@property (nonatomic, copy) NSString* tag_url; 

- (void)requestTopicKeyword:(NSString*)keyword response:(JHResponse)resp;
@end

//全部话题下,仅(话题详情)需要请求
@interface JHPublishTopicDetailReqModel : JHReqModel

@property (nonatomic, copy) NSString* keyword; //搜索关键字
@end
