//
//  JHContactListViewController.h
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHContactUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^_Nullable SelectRowBlock)(JHContactUserInfoModel *model);

@interface JHContactListViewController : JHBaseViewController

@property (copy, nonatomic) SelectRowBlock block;

@end

NS_ASSUME_NONNULL_END
