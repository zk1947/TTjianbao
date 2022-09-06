//
//  JHVButton.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHVButton : UIButton
@property(nonatomic, strong, readonly) UIImageView * vImageView;

@property(nonatomic, strong, readonly) UILabel * vTextLbl;
@property(nonatomic, copy) NSString * normalText;
@property(nonatomic, copy) NSString * seleteText;

@property(nonatomic, strong) UIImage * seleImage;
@property(nonatomic, strong) UIImage * unseleImage;

- (instancetype)initWithImageTop:(CGFloat)imageTop textBottom:(CGFloat)textBottom;

@end

NS_ASSUME_NONNULL_END
