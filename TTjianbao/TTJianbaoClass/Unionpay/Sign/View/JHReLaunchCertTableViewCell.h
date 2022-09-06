//
//  JHReLaunchCertTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///重新发起认证 cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kReLanuchCertIdentifer = @"kReLanuchCertIdentifer";


@interface JHReLaunchCertTableViewCell : UITableViewCell


@property (nonatomic, copy) void(^rangeStringAction)(void);


- (void)setMessage:(NSString *)message rangeString:(NSString *)rangeString;

@end

NS_ASSUME_NONNULL_END
