//
//  JHMsgSubListLikeCommentModel.h
//  TTjianbao
//  Descripiton:点赞&评论model
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHMsgSubListModel.h"
#import "JHUserInfoModel.h"

@interface JHMsgSubListArticlePublisherModel : NSObject

@property (nonatomic, copy) NSString* avatar; //发布者头像
@property (nonatomic, copy) NSString* name; //发布者名称
@property (nonatomic, copy) NSString* user_id;
@property (nonatomic, copy) NSString* user_name;
@property (nonatomic, copy) NSString* roleIcon; //发布者角色icon
@property (nonatomic, strong) JHUserMedalInfo* levelInfo; //用户等级or勋章信息<角色>icon
@property (nonatomic, strong) NSArray* levelIcons;
@end

@interface JHMsgSubListArticleModel : JHRespModel

@property (nonatomic, assign) BOOL isLike; //是否已点赞
@property (nonatomic, assign) NSInteger itemType;
@property (nonatomic, copy) NSString* sortTime; //聚合分组使用的时间
@property (nonatomic, copy) NSString* time; //时间
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* itemId; //帖子id
@property (nonatomic, copy) NSString* commentId;  //本条评论/回复id
@property (nonatomic, copy) NSString* content; //内容
@property (nonatomic, copy) NSString* commentNum;  //评论数
@property (nonatomic, copy) NSString* replyCount; //回复数
@property (nonatomic, copy) NSString* likeNum;  //点赞数
@property (nonatomic, copy) NSString* parent_id;
@property (nonatomic, strong) NSArray* originImages; //原始图片
@property (nonatomic, strong) NSArray* thumbImages; //缩略图片
@property (nonatomic, strong) JHMsgSubListArticlePublisherModel* publisher; //缩略图片
@property (nonatomic, strong) NSArray *content_ad; //富文本展示返回的数组
@property (nonatomic, strong) NSArray *resource_data; //富文本展示返回的数组
@property (nonatomic, strong) NSMutableAttributedString *contentAttributedString; //富文本展示返回的数组换算成富文本

///355新增 评论图片
@property (nonatomic, copy) NSArray <NSString *>*comment_images;
@property (nonatomic, copy) NSArray <NSString *>*comment_images_thumb;
@property (nonatomic, copy) NSArray <NSString *>*comment_images_medium;
///图片类型
@property (nonatomic, copy) NSString *img_type;

///自定义属性 评论内容
@property (nonatomic, strong) NSMutableAttributedString *commentAttrString;
///是否有评论图片  默认没有
@property (nonatomic, assign) BOOL hasPicture;
///评论内容高度
@property (nonatomic,strong) YYTextLayout *textLayout;
///主评论内容高度
@property (nonatomic,strong) YYTextLayout *mainTextLayout;
///查看图片的回调block
@property (nonatomic, copy) void(^seePicBlock)(void);
///100 是c2c商品
@property (nonatomic, assign) NSInteger item_type;
 ///c2c商品id
@property (nonatomic, copy) NSString *origin_id;

@end

@interface JHMsgSubListLikeCommentModel : JHMsgSubListModel
@property (nonatomic, copy) NSString* pageType; //区分页面显示类型
///评论或者对评论的回复「main」
@property (nonatomic, strong) JHMsgSubListArticleModel *article;
///对文章的评论「base_comment」
@property (nonatomic, strong) JHMsgSubListArticleModel *replyArticle;
///文章内容「content」
@property (nonatomic, strong) JHMsgSubListArticleModel *articleContent;
@end

@interface JHMsgSubListLikeCommentReqModel : JHMsgSubListReqModel
//1评过 2发过 3赞过
@property (nonatomic, assign) NSInteger type; //区分请求类型
@property (nonatomic, strong) NSString* last_id; // main.comment_id
@end
