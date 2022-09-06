//
//  JHTrackingPostDetailModel.h
//  TTjianbao
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTrackingBaseModel.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTrackingPostDetailModel : JHTrackingBaseModel
@property (nonatomic, copy) NSNumber *view_duration;    //浏览时长
@property (nonatomic, copy) NSString *operation_type; //操作类型
@property (nonatomic, copy) NSString *page_position; //所在页面
@property (nonatomic, copy) NSString *source_page;    //来源页面
@property (nonatomic, copy) NSString *source_module;   // 来源模块
@property (nonatomic, copy) NSString *content_id;    //内容ID
@property (nonatomic, copy) NSString *content_name;    //内容名称
@property (nonatomic, copy) NSString *content_type ;   //内容类型
@property (nonatomic, copy) NSMutableArray *theme_id;    //话题id
@property (nonatomic, copy) NSMutableArray *theme_name;    //话题名称
@property (nonatomic, copy) NSString *section_id ;   //版块id
@property (nonatomic, copy) NSString *section_name;   // 版块名称
@property (nonatomic, copy) NSString *author_id;    //作者id
@property (nonatomic, copy) NSString *author_name;    //作者名称
@property (nonatomic, copy) NSString *author_role;    //作者角色
@property (nonatomic, copy) NSString *author_points_level;    //作者积分等级
@property (nonatomic, copy) NSString *author_consumption_level;   // 作者消费等级

-(void)transitionWithModel:(JHPostDetailModel *)detailModel;
-(void)transitionWithPostData:(JHPostData *)postModel; //列表上报
@end

NS_ASSUME_NONNULL_END
