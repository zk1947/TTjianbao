//
//  JHLotteryModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  0元抽奖活动数据模型
//

#import "YDBaseModel.h"

@class JHLotteryData;
@class JHLotteryActivityData;
@class JHLotteryMediaData;
@class JHLotteryDialog;

//活动类别
typedef NS_ENUM(NSInteger, JHLotteryType) {
    ///往期
    JHLotteryTypePast = 0,
    ///档期
    JHLotteryTypeCurrent = 1
};

NS_ASSUME_NONNULL_BEGIN


#pragma mark -
#pragma mark - 0元抽奖数据模型
@interface JHLotteryModel : YDBaseModel

/** 活动类型（默认为档期） */
@property (nonatomic, assign) JHLotteryType lotteryType;
@property (nonatomic, strong) JHLotteryDialog *dialog; //中奖弹窗
@property (nonatomic, strong) NSMutableArray<JHLotteryData *> *list; //活动内容 <data->content>

///活动列表接口
- (NSString *)toUrl;
- (void)configModel:(JHLotteryModel *)model;

@end

#pragma mark -
#pragma mark - 活动列表数据
@interface JHLotteryData : NSObject
@property (nonatomic, copy) NSString *date; //活动开始日期
@property (nonatomic, copy) NSString *desc; //进行中、即将开始 等状态提示信息
@property (nonatomic, copy) NSString *img; //活动图标url
@property (nonatomic, assign) BOOL isToday; //是否是当日活动
@property (nonatomic ,strong) NSMutableArray<JHLotteryActivityData *> *activityList; //活动列表<activities：暂时只有一项>
@end

#pragma mark -
#pragma mark - 活动内容
@interface JHLotteryActivityData : JHRespModel
@property (nonatomic,   copy) NSString *activityCode; //活动code（id）"20200702"
@property (nonatomic,   copy) NSString *activityDate; //活动期数
@property (nonatomic,   copy) NSString *prizeName; //奖品名称（轮播图下方显示）
@property (nonatomic,   copy) NSString *price; //奖品现价
@property (nonatomic,   copy) NSString *prizePrice; //奖品原价
@property (nonatomic,   copy) NSString *buttonTxt; //按钮文案："0元参与抽奖"、"开启提醒"
@property (nonatomic,   copy) NSString *subtitle; //分享提示："新人助力抽奖码+3，普通用户助力+1"，此字段不为空表示分享过
@property (nonatomic,   copy) NSString *ruleHtml; //活动规则地址
@property (nonatomic, assign) NSInteger state; //活动状态（1:进行中、2:已开奖、3:未开始）
@property (nonatomic, assign) NSInteger hit; //中奖状态(0:未参与、1:中奖、2:未中奖)
@property (nonatomic,   copy) NSString *hitCode; //中奖号码
@property (nonatomic,   copy) NSString *hitTxt;///未中奖~~
@property (nonatomic,   copy) NSString *hitUserImg; //中奖用户头像
@property (nonatomic, assign) NSInteger codeMax; //每人每期抽奖码个数最大值
@property (nonatomic, assign) BOOL remindSwitch; //是否开启提醒（0:否、1:是）
@property (nonatomic, assign) NSInteger surplusSecs; //剩余时间,单位秒
@property (nonatomic,   copy) NSString *surplusTxt; //倒计时文案（:"后开奖")
@property (nonatomic, assign) NSInteger currentTimestamp; //当前服务器时间戳，单位毫秒
@property (nonatomic, assign) NSInteger endTimestamp; //活动结束时间戳，单位毫秒（1595581244602）
@property (nonatomic,   copy) NSString *receiveEndTimeTxt; //领奖结束时间提示："2020-06-18 23:59:59领奖结束"
@property (nonatomic, strong) JHShareInfo *shareInfo; //分享信息 <share>
@property (nonatomic, strong) NSMutableArray<JHLotteryMediaData *> *mediaList; //奖品资源 <media>
//----------往期列表额外需要的字段
@property (nonatomic,   copy) NSString *titleImg; //列表左侧头图

///跑秒倒计时
@property (nonatomic, assign) long timeTotalNum;
@end


#pragma mark -
#pragma mark - 奖品资源(图片视频信息)
@interface JHLotteryMediaData : NSObject
@property (nonatomic,   copy) NSString *url; //视频或图片地址
@property (nonatomic,   copy) NSString *coverImg; //视频封面图(只有视频时使用)
@property (nonatomic, assign) NSInteger type; //资源类型：1表示视频
@end


#pragma mark -
#pragma mark - 中奖弹窗信息
@interface JHLotteryDialog : NSObject
@property (nonatomic,   copy) NSString *activityCode; //"2006094URFUgn" //活动code
@property (nonatomic,   copy) NSString *title; //"恭喜您！中奖啦！", //标题
@property (nonatomic,   copy) NSString *img; //奖品图片
@property (nonatomic,   copy) NSString *buttonTxt; //"去填写收货地址", //按钮文案
@property (nonatomic,   copy) NSString *prizeName; //"夜店小王子套餐", //奖品名称
@property (nonatomic,   copy) NSString *prizePrice; //"市场价 ￥1888", //奖品原价
@end

NS_ASSUME_NONNULL_END
