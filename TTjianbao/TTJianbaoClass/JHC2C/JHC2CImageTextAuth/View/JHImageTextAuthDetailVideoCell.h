//
//  JHImageTextAuthDetailVideoCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHImageTextWaitAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHImageTextAuthDetailVideoCell : UITableViewCell

@property (nonatomic, strong) JHImageTextWaitAuthDetailVideoModel *model;
@property (nonatomic, strong) RACSubject *delegateSignal;

@end

NS_ASSUME_NONNULL_END
