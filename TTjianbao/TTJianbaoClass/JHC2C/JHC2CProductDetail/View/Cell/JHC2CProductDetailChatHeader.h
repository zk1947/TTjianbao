//
//  JHC2CProductDetailChatHeader.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailChatHeader : UITableViewHeaderFooterView
@property(nonatomic, copy) void (^tapViewAction)(void);
@property(nonatomic, strong) UILabel * titlleLbl;

@end

NS_ASSUME_NONNULL_END
