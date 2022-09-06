//
//  JHHonnerCerDetailViewController.h
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
#import "JHLiveRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHonnerCerDetailViewController : JHBaseViewController
@property (nonatomic, assign) BOOL                           isAnchor; /// 是否是主播
@property (nonatomic, strong) JHCustomerCertificateListInfo *infoModel;
@property (nonatomic, strong) JHCustomerInfoShareDataModel  *shareData;
///删除成功
@property (nonatomic, copy) dispatch_block_t callbackMethod;

@end

NS_ASSUME_NONNULL_END
