//
//  JHAccountFlowModel.h
//  TTjianbao
//  Description:零钱4tab信息,根据type区分
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHAccountReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAccountFlowReqModel : JHAccountReqModel

@property (nonatomic, assign) NSUInteger accountType;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) NSUInteger pageSize;

@end

@interface JHAccountFlowModel : JHRespModel

@property (nonatomic, strong) NSString* beforeChangeMoney;// (number, optional): 变动前金额 ,[未用到]
@property (nonatomic, strong) NSString* titleName;//
@property (nonatomic, strong) NSString* titleDesc;//
@property (nonatomic, strong) NSString* remark;//
@property (nonatomic, strong) NSString* changeMoney;// (number, optional): 变动金额 ,
@property (nonatomic, strong) NSString* flowDate;// (string, optional): 流水产生时间 ,
@property (nonatomic, strong) NSString* goodsTitle;// (string, optional): 商品标题 ,
@property (nonatomic, assign) NSInteger serialNum;// (integer, optional): 流水号 ,[未用到]
@property (nonatomic, strong) NSString* sign;// (string, optional): 金额正负标志
@property (nonatomic, assign) BOOL multiLine;// 多行

@end

NS_ASSUME_NONNULL_END
