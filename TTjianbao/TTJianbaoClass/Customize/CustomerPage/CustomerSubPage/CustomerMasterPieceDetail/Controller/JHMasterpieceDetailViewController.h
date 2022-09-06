//
//  JHMasterpieceDetailViewController.h
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMasterpieceDetailViewController : UIViewController
@property (nonatomic, strong) UIImage             *userIcon;
@property (nonatomic,   copy) NSString            *userName;
@property (nonatomic,   copy) NSString            *userDesc;
@property (nonatomic, assign) NSInteger            ID;
@property (nonatomic, strong) NSArray<NSString *> *opusList;
@property (nonatomic,   copy) NSString            *titleText;
@property (nonatomic,   copy) NSString            *desc;
@property (nonatomic, assign) BOOL                 isAnchor; /// 是否是主播
/// 审核未通过的原因
@property (nonatomic,   copy) NSString  *reason;
/// 审核状态：0-待审核、1-通过、2-不通过
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, strong) JHCustomerInfoShareDataModel *shareData;

///删除成功
@property (nonatomic, copy) dispatch_block_t callbackMethod;
@end

NS_ASSUME_NONNULL_END
