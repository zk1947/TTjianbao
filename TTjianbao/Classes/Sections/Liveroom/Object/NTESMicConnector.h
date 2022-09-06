//
//  NTESMicConnector.h
//  TTjianbao
//
//  Created by chris on 16/7/22.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESLiveViewDefine.h"

@interface NTESMicConnector : NSObject

@property (nonatomic,copy)   NSString *uid;

@property (nonatomic,copy)   NSString *Id;

@property (nonatomic,assign) NIMNetCallMediaType type;

@property (nonatomic,assign) NTESLiveMicState state;

@property (nonatomic,assign) NTESLiveMicOnlineState onlineState;

@property (nonatomic,copy)   NSString *avatar;

@property (nonatomic,copy)   NSString *nick;

@property (nonatomic,copy)   NSArray *imgList;

@property (nonatomic,assign) BOOL isSelected;

//是否买过商品
@property (nonatomic,assign) BOOL bought;
//买过商品是否大于5000
@property (nonatomic,assign) BOOL isBiggerThen;

@property (nonatomic, copy) NSString *appraiseRecordId;

@property (nonatomic, copy) NSString *customizeRecordId;

@property (nonatomic, copy) NSString *applyId;


//定制 订单相关
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *goodsUrl;
@property (nonatomic, copy) NSString *statusDesc;

@property (nonatomic,copy)   NSString *goodsCateId;
@property (nonatomic,copy)   NSString *goodsCateName;
@property (nonatomic,copy)   NSString *customizeFeeId;
@property (nonatomic,copy)   NSString *customizeFeeName;
@property (nonatomic,copy)   NSString *orderCategory;

@property (nonatomic,assign) NSInteger connectType;  //1 反向连麦  0正常连麦

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)me:(NSString *)roomId;

@end
