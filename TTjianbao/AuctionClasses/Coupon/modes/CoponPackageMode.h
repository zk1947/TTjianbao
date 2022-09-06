//
//  CoponPackageMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoponPackageMode : NSObject
@property (assign,nonatomic)int  code;
@property (strong,nonatomic)NSString * Id;
@property (strong,nonatomic)NSString * name;
@property (strong,nonatomic)NSString * totalFrPrice;
@property (strong,nonatomic)NSString * remark;
@property (copy,nonatomic)NSString * ruleType;
@property (strong,nonatomic)NSString * price;



@end

@interface CoponMode : NSObject
@property (strong,nonatomic)NSString * price;
//
@property (strong,nonatomic)NSString * viewValue;
@property (strong,nonatomic)NSString * Id;
@property (strong,nonatomic)NSString * endUseTime;

@property (strong,nonatomic)NSString * name;
@property (strong,nonatomic)NSString * remark;
@property (strong,nonatomic)NSString * ruleFrCondition;
 //  "OD":折扣券  "FR":满减券
@property (strong,nonatomic)NSString * ruleType;
@property (strong,nonatomic)NSString * status;
@property (strong,nonatomic)NSString * img;  //卖家头像
@property (strong,nonatomic)NSString * channelId;  //卖家频道id
@property (strong,nonatomic)NSString * shopId;  //店铺id
@property (assign,nonatomic)int couponUseCategory;  //优惠券使用分类（1:直播间、2:新商城、3: C2C 宝贝集市首页）


@property (strong,nonatomic)NSString * usefulLife;  //期限

@property (strong,nonatomic)NSString * discountEndTime;
@property (strong,nonatomic)NSString * discountStartTime;
@property (assign,nonatomic)  BOOL unableUsed; //不能用置灰 不可点
@property (assign,nonatomic)int  joinSellerType;

+ (void)requestEnableUsedSeller:(NSString *)coponId completion:(JHApiRequestHandler)completion;

@end

@interface CoponCountMode : NSObject
//红包未使用 数量
@property (strong,nonatomic)NSString * enUse;
//红包已使用 数量
@property (strong,nonatomic)NSString * used;
//红包已过期 数量
@property (strong,nonatomic)NSString * unUse;


//代金券未使用 数量
@property (strong,nonatomic)NSString * getCount;
//代金券已使用 数量
@property (strong,nonatomic)NSString * usedCount;
//代金券已过期 数量
@property (strong,nonatomic)NSString * invalidCount;
//("红包已失效，展示最近七天文案提示")
@property (strong,nonatomic)NSString * invalidCaseRemark;
//("红包已使用，展示最近七天文案提示")
@property (strong,nonatomic)NSString * usedCaseRemark;



@end
