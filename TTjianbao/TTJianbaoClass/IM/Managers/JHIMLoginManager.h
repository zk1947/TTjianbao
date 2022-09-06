//
//  JHIMLoginManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHIMHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHIMLoginManager : NSObject

+ (instancetype)sharedManager;
/// 登录
- (void)imLogin;
@end

NS_ASSUME_NONNULL_END
