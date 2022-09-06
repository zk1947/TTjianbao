//
//  JHIdentificationDetailsSubView.h
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsSubView : UIView

/// 鉴定的title
@property (nonatomic, strong) UILabel *identificationTitleLabel;
/// 鉴定的结果
@property (nonatomic, strong) UILabel *identificationResultsLabel;

@end

NS_ASSUME_NONNULL_END
