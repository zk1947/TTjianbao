//
//  JHCustomizeApplyProcessFirst.h
//  TTjianbao
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyProcessBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeApplyProcessFirst : JHCustomizeApplyProcessBaseView
- (instancetype)initWithFrame:(CGRect)frame andCustomizeId:(NSString *)customizeId;
@property (nonatomic,copy)NSString *channelId;
@end

NS_ASSUME_NONNULL_END
