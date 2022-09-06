//
//  JHMsgSubListModel.h
//  TTjianbao
//  Description:分类model公共部分
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHMessageHeader.h"
#import "JHRouterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMsgSubListModel : JHRespModel

@property (nonatomic, copy) NSString* showType;//  显示样式及接收数据model
@property (nonatomic, copy) NSString* createDate;//  (string, optional),v公告创建时间
@property (nonatomic, copy) NSString* title;//  (string, optional),v公告标题
@property (nonatomic, copy) NSString* body;//  (string, optional),v公告内容
@property (nonatomic, strong) JHRouterModel* target;//iOS透传落地页
@property (nonatomic, assign) NSInteger type;//  v(integer, optional): 暂时废弃【公告类型：2个Announce】 0 活动公告=>优惠活动 1 平台公告
@property (nonatomic, copy) NSString* thirdType;//  (string, optional): 消息三级级类型  bountyUse 津贴使用,bountyGet 津贴获得,bountyWillExpire 津贴即将过期, couponWillExpire 红包即将过期,couponGet 红包获得,stonePublish 原石已上架,stoneAddPrice 宝友出价,stoneSell 原石已售出,stoneAccountIn 入账,stoneAcceptPrice 出价接受,stoneRejectPrice 出价被拒,stoneBuyFail 出价失败,stoneWaitPublish 待上架,bountyAllClean 红包被抢完,bountyOverdueReturn 红包到期退回,bountyGrab 抢到红包,orderStatusChange 订单状态变化,sellerCouponWillExpire 代金券即将过期,sellerCouponGet 代金券获得, settleYesterday 结算【？？】
/*透传字段*///
@property (nonatomic, assign) NSInteger titleRowLimit; //标题行数:  -1不限制，0表示没有，大于0为实际行数
@property (nonatomic, assign) NSInteger textRowLimit; //描述行数：-1不限制，0表示没有，大于0为实际行数

@end

//  按时间排序分组后的dataModel,其中groupArray内包含JHMsgSubListModel子类数据
@interface JHMsgSubListShowModel : JHRespModel

@property (nonatomic, copy) NSString* dateTime;//  显示时间
@property (nonatomic, strong) NSMutableArray<JHMsgSubListModel*>* groupArray;
@end


@interface JHMsgSubListReqModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, assign) NSUInteger pageSize;

//新增类别设置subPath
- (void)setRequestSubpath:(NSString*)type;
@end

 //社区互动消息-点赞列表-清除
@interface JHMsgSubListClearLikeModel : JHReqModel
@end

 //社区互动消息-评论列表-清除
@interface JHMsgSubListClearCommentModel : JHReqModel
@end

NS_ASSUME_NONNULL_END
