//
//  JHAddBankcardReqModel.h
//  TTjianbao
//  Description:添加银行卡
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAddBankcardReqModel : JHReqModel

@property (nonatomic, strong) NSString* accountName; //name
@property (nonatomic, strong) NSString* accountNo; //code
@property (nonatomic, strong) NSString* bankName; //bankName

@end

NS_ASSUME_NONNULL_END
