//
//  JHPreTitleLabel.h
//  TTjianbao
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPreTitleLabel : UILabel
@property (nonatomic, copy)NSString *preTitle;
- (void)setJHAttributedText:(NSString *)attributedText font:(UIFont *)font color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
