//
//  JHSelectbankBranchViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/6/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///银联签约 - 选择支行vc

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCityModel;
@class JHUnionPaySubBankModel;

@interface JHSelectbankBranchViewController : JHBaseViewExtController

///选择地区的二级城市
@property (nonatomic, strong) JHCityModel *cityModel;

@property (nonatomic, copy) void(^bankBranchBlock)(JHUnionPaySubBankModel * branchInfo);



@end

NS_ASSUME_NONNULL_END
