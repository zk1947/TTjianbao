//
//  JHIdentyAccountViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSignBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHIdentyAccountSectionType) {
    JHIdentyAccountSectionTypeAlert = 0,
    JHIdentyAccountSectionTypeBank,
    JHIdentyAccountSectionTypePhoto,
    JHIdentyAccountSectionTypeStockhplder,
    JHIdentyAccountSectionTypeBeneficiary,
    JHIdentyAccountSectionTypeMessage,
};

@interface JHIdentyAccountViewController : JHSignBaseViewController
@property (nonatomic, assign) JHIdentyAccountSectionType sectionType;

@end

NS_ASSUME_NONNULL_END
