//
//  JHUserAuthEnterpriseHeader.h
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthEnterpriseHeader : JHWBaseTableViewCell

@property (nonatomic, copy) void (^actionBlock)(JHUserAuthType authType);
+ (CGFloat)headerHeight;

@end

NS_ASSUME_NONNULL_END
