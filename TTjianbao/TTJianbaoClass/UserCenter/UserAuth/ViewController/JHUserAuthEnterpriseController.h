//
//  JHUserAuthEnterpriseController.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHEnterpriseSectionType) {
    JHEnterpriseSectionTypeAuthState = 0,
    JHEnterpriseSectionTypeSelectAuthType,
    JHEnterpriseSectionTypeBusiness,
    JHEnterpriseSectionTypeOthers,
};

@interface JHUserAuthEnterpriseController : JHBaseViewController
///审核状态
@property (nonatomic, strong) JHUserAuthModel *authModel;
@property (nonatomic, assign) JHEnterpriseSectionType sectionType;
@end

NS_ASSUME_NONNULL_END
