//
//  JHMsgSubListNormalForumModel.h
//  TTjianbao
//  Description:分类model：社区互动
//  Created by Jesse on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListNormalModel.h"

@class JHMsgSubListNormalForumExtModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHMsgSubListNormalForumModel : JHMsgSubListNormalModel

@property (nonatomic, strong) JHMsgSubListNormalForumExtModel* ext;//ext=> 扩展模型,用于展示或跳转参数
@property (nonatomic, copy) NSString* extStr; // 扩展字段,用于展示或跳转参数字符串形式 ,
@property (nonatomic, copy) NSString* fromIcon;//   (string, optional): 来源用户头像 ,
@property (nonatomic, copy) NSString* fromId;//   (integer, optional),来源用户ID
@property (nonatomic, copy) NSString* fromName;//   (string, optional): 来源用户名 ,
@property (nonatomic, copy) NSString* isFollow;//   (string, 取值[1, 0]),是否关注消息触发者

//thirdType (string, optional)样式: forumPost 社区帖子,forumFollow 有人关注 ,
//type (string, optional) //基类中type值在此模型中无效

@end

@interface JHMsgSubListNormalForumExtModel : NSObject

@property (nonatomic, copy) NSString* coverImg; //目前仅使用图片
@property (nonatomic, copy) NSString* item_id;
@property (nonatomic, copy) NSString* item_type;
@property (nonatomic, copy) NSString* comment_id;
@property (nonatomic, copy) NSString* postTitle;
@property (nonatomic, copy) NSString* mark; //"评论了你"
@property (nonatomic, copy) NSString* content;
@end

NS_ASSUME_NONNULL_END
