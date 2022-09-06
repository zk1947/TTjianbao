//
//  JHCheckBoxProtocolView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
typedef void (^JHCheckBoxProtocolClickBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface JHCheckBoxProtocolView : BaseView
@property(nonatomic, copy) JHCheckBoxProtocolClickBlock checkBoxProtocolClickBlock;
@property(nonatomic, assign) BOOL isC2cConfirm;
/**
 初始化checkbox
 */
- (instancetype)initWithSelImageName:(NSString *)selImageNameStr normalImageName:(NSString *)normalImageNameStr tipStr:(NSString *)tipStr protocolStr:(NSString *)protocolStr;
/**
 获取当前checkBox的选中状态
 */
- (Boolean)getCheckBoxSelectStatus;
@end

NS_ASSUME_NONNULL_END
