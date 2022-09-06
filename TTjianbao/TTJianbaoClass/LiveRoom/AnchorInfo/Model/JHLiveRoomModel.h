//
//  JHLiveRoomModel.h
//  TTjianbao
//
//  Created by lihui on 2020/7/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAnchorInfoSectionHeader.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHAnchorLiveState)
{//0:停播 1:直播
    JHAnchorLiveStatePause,
    JHAnchorLiveStatePlaying = 1,
};

@class JHAnchorInfo;
@class JHCustomerFeesInfo;
@class JHCustomerOpusListInfo;
@class JHCustomerCertificateListInfo;
@class JHCustomerWorksListInfo;
@class JHCustomerInfoShareDataModel;
@class JHCustomerMaterialsInfo;

@interface JHLiveRoomModel : NSObject

///直播间头像
@property (nonatomic, copy) NSString *avatar;
///直播间id
@property (nonatomic, copy) NSString *channelLocalId;
///主播名称
@property (nonatomic, copy) NSString *name;
///直播间介绍
@property (nonatomic, copy) NSString *roomDes;
@property (nonatomic, strong) NSMutableAttributedString *descAttriText;

///直播间名称
@property (nonatomic, copy) NSString *commentGrade;
///评价数
@property (nonatomic, assign) NSInteger commentNum;
///粉丝数
@property (nonatomic, assign) NSInteger fansNum;
///点赞数
@property (nonatomic, assign) NSInteger thumbsUpNum;
///是否需要显示编辑按钮
@property (nonatomic, assign) BOOL showButton;
///是否关注
@property (nonatomic, assign) BOOL isFollow;
///主播介绍
@property (nonatomic, copy) NSArray <JHAnchorInfo *>*anchorList;
///直播间主播id 用于请求动态
@property (nonatomic, copy) NSString *anchorId;

///直播间介绍是否需要展开 默认为NO
@property (nonatomic, assign) BOOL isOpen;
///自定义字段 直播间描述高度
@property (nonatomic, assign) CGFloat roomDesHeight;
/// 直播间描述信息cell高度
@property (nonatomic, assign) CGFloat roomDesAllHeight;
///定制师费用说明
@property (nonatomic, copy) NSArray <JHCustomerFeesInfo*>*fees;
/** 直播间状态：0：禁用； 1：空闲； 2：直播中； 3：直播录制 4:假频道 */
@property (nonatomic, assign) NSInteger channelStatus;
@property (nonatomic, copy) NSString *rtmpPullUrl; //拉流地址
///自定义字段
@property (nonatomic, copy) NSString *placeholderString;
///是否展示全部定制师介绍
@property (nonatomic, assign) BOOL showAllInfo;
///定制师描述显示的行数
@property (nonatomic, assign) NSInteger descNumberOfLines;

///350新增字段
///原料直播间头像
@property (nonatomic, copy) NSString *materialChannelImg;
///原料直播间名称
@property (nonatomic, copy) NSString *materialChannelName;
///原料直播间id
@property (nonatomic, assign) NSInteger materialChannelId;
/// 原料直播间观看人数
@property (nonatomic, assign) NSInteger materialChannelViewCount;
/// 原料直播间直播状态：0：禁用； 1：空闲； 2：直播中； 3：直播录制 ,
@property (nonatomic, assign) NSInteger materialChannelStatus;

///店铺头像
@property (nonatomic, copy) NSString *shopImg;
///店铺商品数量
@property (nonatomic, assign) NSInteger shopCount;
///店铺id
@property (nonatomic, assign) NSInteger shopId;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;


/// by新增
/// 定制师个人介绍
@property (nonatomic,   copy) NSString *customizeIntro;
@property (nonatomic, strong) NSMutableAttributedString *customizeDescAttriText;

/// 定制师个人介绍不通过的原因
@property (nonatomic,   copy) NSString *reason;
/// 定制师个人介绍审核状态：0-待审核、1-通过、2-不通过 ,
@property (nonatomic, assign) NSInteger introStatus;
/// 定制师职称
@property (nonatomic,   copy) NSString *customizeTitle;
/// 定制师别名
@property (nonatomic,   copy) NSString *alias;
/// 证书列表
@property (nonatomic, strong) NSArray<JHCustomerCertificateListInfo *>  *certificateList;
/// 代表作列表
@property (nonatomic, strong) NSArray<JHCustomerOpusListInfo *>  *opusList;
/// 作品数目
@property (nonatomic, assign) NSInteger worksCount;
/// 作品列表
@property (nonatomic, strong) NSArray<JHCustomerWorksListInfo *>  *worksList;
/// 分享
@property (nonatomic, strong) JHCustomerInfoShareDataModel *shareData;
/// 定制材质
@property (nonatomic, strong) NSArray<JHCustomerMaterialsInfo *>  *materials;
///372小版本新增
/**用户类型:1 企业用户 2 个人用户*/
@property (nonatomic, assign) JHUserAuthType authType;
/**认证状态：1 已认证 0 未认证*/
@property (nonatomic, assign) JHUserAuthState authState;

//粉丝团id -1为未开通
@property (nonatomic,   copy) NSString *fansClubId;
/// 粉丝数量
@property (nonatomic,   copy) NSString *fansCount;

///是否加入粉丝团
@property (nonatomic, assign) BOOL isJoin;
/// 回收新增
@property (nonatomic, strong) NSArray<NSString *>* cateNames; /// 回收类别
@end


@interface JHCustomerMaterialsInfo : NSObject
///
@property (nonatomic,   copy) NSString *ID;
///
@property (nonatomic,   copy) NSString *name;
///
@property (nonatomic,   copy) NSString *img;

@end


/*
 * 定制费用说明
 */
@interface JHCustomerFeesInfo : NSObject
/// 定制费用ID
@property (nonatomic,   copy) NSString     *ID;
/// 定制类别名称
@property (nonatomic,   copy) NSString     *name;
/// 图片地址
@property (nonatomic,   copy) NSString     *img;
/// 价格最小值
@property (nonatomic, strong) NSNumber     *minPrice;
/// 价格最大值
@property (nonatomic, strong) NSNumber     *maxPrice;
/// 最大价格包装类
@property (nonatomic, strong) NSDictionary *maxPriceWrapper;
/// 最小价格包装类
@property (nonatomic, strong) NSDictionary *minPriceWrapper;
@end


/*
 * 主播介绍
 */
@interface JHAnchorInfo : JHRespModel
/// 主播头像
@property (nonatomic,   copy) NSString          *avatar;
/// 主播介绍id
@property (nonatomic,   copy) NSString          *broadId;
/// 主播昵称
@property (nonatomic,   copy) NSString          *nick;
/// 主播描述
@property (nonatomic,   copy) NSString          *des;
/// 主播直播状态0:停播 1:直播  -11:(左滑介绍无数据时)展示用,无其他意思
@property (nonatomic, assign) JHAnchorLiveState  liveState;
/// 主播cell的高度
@property (nonatomic, assign) CGFloat            cellHeight;


///身份证人像
@property (nonatomic, copy) NSString *idCardFrontImg;

///身份证国徽
@property (nonatomic, copy) NSString *idCardBackImg;

/// -1:未上传资质 0:审核中 1:审核通过 2:审核未通过
@property (nonatomic, assign) NSInteger authState;

@property (nonatomic, copy) NSString *rejectReason;

@end


/*
 * 进入编辑或添加页面需要传此模型
 */
@interface JHAnchorRoomInfo : JHAnchorInfo
@property (nonatomic, assign) JHArchorSectionType  pageType;
@property (nonatomic,   copy) NSString            *channelLocalId;// 直播间ID
@property (nonatomic,   copy) NSString            *roomInfoId;// 直播间介绍ID
@property (nonatomic,   copy) NSString            *roomDes;// 直播间介绍
@end


/*
 * 代表作实体
 */
@interface JHCustomerOpusListInfo : NSObject
/// 封面
@property (nonatomic,   copy) NSString  *coverUrl;
/// 定制师ID
@property (nonatomic, assign) NSInteger  customerId;
/// 描述
@property (nonatomic,   copy) NSString  *desc;
/// 代表作ID
@property (nonatomic,   copy) NSString    *ID;
/// 代表作附件地址
@property (nonatomic, strong) NSArray   *images;
/// 审核未通过的原因
@property (nonatomic,   copy) NSString  *reason;
/// 审核状态：0-待审核、1-通过、2-不通过
@property (nonatomic, assign) NSInteger  status;
/// 标题
@property (nonatomic,   copy) NSString  *title;
@property (nonatomic, strong) JHCustomerInfoShareDataModel *shareData;
@end


/*
 * 证书实体
 */
@interface JHCustomerCertificateListInfo : NSObject
/// 奖项
@property (nonatomic,   copy) NSString  *awards;
/// 持证日期
@property (nonatomic,   copy) NSString  *date;
/// 持证人
@property (nonatomic,   copy) NSString  *holder;
/// 证书ID
@property (nonatomic,   copy) NSString  *ID;
/// 证书图片
@property (nonatomic,   copy) NSString  *img;
/// 证书名称
@property (nonatomic,   copy) NSString  *name;
/// 发证机构
@property (nonatomic,   copy) NSString  *organization;
/// 审核未通过的原因
@property (nonatomic,   copy) NSString  *reason;
/// 审核状态：0-待审核、1-通过、2-不通过
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, strong) JHCustomerInfoShareDataModel *shareData;
@end



/*
 * 作品实体
 */
typedef NS_ENUM(NSUInteger, JHCustomerWorksListInfoStatus) {
    /// 已申请
    JHCustomerWorksListInfoStatus_HasApplicationed = 0,
    /// 进行中
    JHCustomerWorksListInfoStatus_Processing,
    /// 已完成
    JHCustomerWorksListInfoStatus_completed
};
@interface JHCustomerWorksListInfo : NSObject
/// 定制师名称(废弃)
@property (nonatomic,   copy) NSString                      *title;
/// 封面
@property (nonatomic,   copy) NSString                      *cover;
/// 作品ID
@property (nonatomic,   copy) NSString                      *ID;
/// 状态 0 已申请 1 进行中 2 已完成
@property (nonatomic, assign) JHCustomerWorksListInfoStatus  status;
/// 作品名称
@property (nonatomic,   copy) NSString                      *worksName;

@property (nonatomic,   copy) NSString                      *feeName; /// 定制分类名称
@property (nonatomic,   copy) NSString                      *anchorName; /// 定制师名称
@property (nonatomic,   copy) NSString                      *customerId;
@property (nonatomic,   copy) NSString                      *customizeOrderId;
@end




@interface JHCustomerInfoShareDataModel : NSObject
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *url;
@property (nonatomic,   copy) NSString *img;
@property (nonatomic,   copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END

