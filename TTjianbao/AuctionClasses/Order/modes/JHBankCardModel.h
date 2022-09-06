//
//  JHBankCardModel.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBankCardModel : NSObject
@property (strong,nonatomic) NSString * ID; /// id
@property (strong,nonatomic) NSString * bankName; /// 银行名
@property (strong,nonatomic) NSString * bankType; /// 银行卡类型
@property (strong,nonatomic) NSString * bankBranch; /// 支行名
@property (strong,nonatomic) NSString * editBankBranch; /// 编辑支行名
@property (strong,nonatomic) NSString * accountNo; /// 银行卡号
@property (strong,nonatomic) NSString * iconUrl; /// 图标地址
@end


NS_ASSUME_NONNULL_END
