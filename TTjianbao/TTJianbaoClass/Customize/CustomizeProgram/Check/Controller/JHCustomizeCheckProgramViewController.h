//
//  JHCustomizeCheckProgramViewController.h
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCheckProgramViewController : JHBaseViewController
/// 定制方案id
@property (nonatomic, strong) NSString *customizePlanId;
/// 定制订单id
@property (nonatomic, strong) NSString *customizeOrderId;
/// 主播id
@property (nonatomic, strong) NSString *anchorId;

//是否是定制师端
@property(assign,nonatomic) BOOL  isSeller;
@end

NS_ASSUME_NONNULL_END
