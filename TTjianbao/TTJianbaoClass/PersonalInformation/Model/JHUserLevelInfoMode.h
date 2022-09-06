//
//  JHUserLevelInfoMode.h
//  TTjianbao
//
//  Created by jiang on 2019/8/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ShowRiskAlert @"ShowRiskAlert"
#define ShowRiskOverAlertToday @"ShowRiskOverAlertToday"
#define ShowRiskAlertToday @"ShowRiskAlertToday"

NS_ASSUME_NONNULL_BEGIN

@interface JHRiskDataModel : NSObject
@property (assign,nonatomic) CGFloat evaluate;//等级限制金额
@property (assign,nonatomic) CGFloat amount;//已消费金额
@property (strong,nonatomic) NSString  *rank;//风险类型
@property (assign,nonatomic) NSInteger  is_over;//用来判断是否超额， 0 未超 1 已超

@end


#pragma mark -
#pragma mark - 商户签约信息
@interface JHUserSignInfo : NSObject
@property (nonatomic, assign) NSInteger business_type; //0非商家 1老商家 2新商家
@property (nonatomic, assign) NSInteger real_type; //认证类型：0未认证 1个人认证 2商家认证
@property (nonatomic, assign) NSInteger status_real; //0未认证 1已认证 2企业认证中 3企业审核不通过
@property (nonatomic, assign) NSInteger sign_type; //签约类型：0未签约 1已签约
@property (nonatomic,   copy) NSString *tips; //提示文案
@property (nonatomic,   copy) NSString *title; //个人姓名/企业名称（**没用到）
@property (nonatomic, assign) BOOL is_need_sign; //是否强制签约：0否 1是
@end


@interface JHUserLevelInfoMode : NSObject

@property (assign,nonatomic) int  fans_num;                     //粉丝数
@property (assign,nonatomic) int  follow_num;                   //点赞数
@property (assign,nonatomic) int  like_num;                     //被赞数
@property (assign,nonatomic) int is_experience_new;             //是否有新增经验
@property (strong,nonatomic) NSString  *title_level;            //用户级别
@property (strong,nonatomic)NSString *title_level_icon_next;    //下一级图标
@property (strong,nonatomic)NSString *title_level_icon;         //等级称号
@property (strong,nonatomic)NSString *user_id;

@property (assign,nonatomic) int level_exp;                     //当前级别已得经验值
@property (assign,nonatomic) int level_exp_diff;                //升级差多少经验
@property (assign,nonatomic) int  experience_num;               //当前经验值
@property (assign,nonatomic) int  level_exp_next;               //达到下一等级的积分
@property (assign,nonatomic) NSInteger score;                   //当前积分值
@property (copy,nonatomic) NSString *level_next_name;           //升级为xxx
@property (copy,  nonatomic) NSString *level_prompt;            //等级升级提示 替代 level_exp_diff
@property (assign,nonatomic) CGFloat level_exp_percent;         //当前级别距下一级别百分比

@property (copy, nonatomic) NSString *game_level_icon;
@property (strong, nonatomic) JHRiskDataModel *risk;


/// 1 代表金色星辰  2代表七彩祥云  3代表七彩祥云末世主宰，没有特效的返回空串
@property (copy, nonatomic) NSString *enter_effect;
@property (assign, nonatomic) NSInteger enter_effect_expire;

@property (assign, nonatomic) NSInteger forbid_speak; //0禁言中 1未禁言
@property (strong, nonatomic) JHUserSignInfo *sign; //商家签约信息

@property (copy, nonatomic) NSString *userTycoonLevelIcon;

///发过
@property (nonatomic, assign) NSInteger publish_num;
///评过
@property (nonatomic, assign) NSInteger comment_num;
///赞过
@property (nonatomic, assign) NSInteger like_content_num;

@end
NS_ASSUME_NONNULL_END
