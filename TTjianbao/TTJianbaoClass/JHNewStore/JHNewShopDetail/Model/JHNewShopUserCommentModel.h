//
//  JHNewShopUserCommentModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopUserCommentListModel : NSObject
/** 评价ID */
@property (nonatomic, copy) NSString *commentID;
/** 买家用户ID */
@property (nonatomic, copy) NSString *customerId;
/** 买家用户昵称 */
@property (nonatomic, copy) NSString *customerName;
/** 买家用户头像 */
@property (nonatomic, copy) NSString *customerImg;
/** 卖家用户ID */
@property (nonatomic, copy) NSString *sellerCustomerId;
/** 订单ID */
@property (nonatomic, copy) NSString *orderId;
/** 评价内容 */
@property (nonatomic, copy) NSString *commentContent;
/** 评价标签-集合 */
@property (nonatomic, strong) NSArray *commentTagsList;
/** 评价图片-集合 */
@property (nonatomic, strong) NSArray *commentImgsList;
/** 商品满意度，默认5颗星（评分） */
@property (nonatomic, copy) NSString *pass;
/** 商家回复 */
@property (nonatomic, copy) NSString *shopReply;
/** 是否回复 */
@property (nonatomic, copy) NSString *isReply;
/** 评论时间 */
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL isShowMore;

@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface JHNewShopUserCommentModel : NSObject
/** 评论列表 */
@property (nonatomic, strong) NSArray<JHNewShopUserCommentListModel *> *commentList;
/** 总评论数 */
@property (nonatomic, copy) NSString *commentCount;
/** 店铺好评度 */
@property (nonatomic, copy) NSString *orderGrade;
/** 有图的评论数 */
@property (nonatomic, copy) NSString *countCommentsWithImg;


@end

NS_ASSUME_NONNULL_END
