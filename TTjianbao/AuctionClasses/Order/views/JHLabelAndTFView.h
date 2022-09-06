//
//  JHLabelAndTFView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AlignmentStyleTypeDefault = 0,  // 默认左对齐
    AlignmentStyleTypeRight = 1,
} AlignmentStyleType;

@interface JHLabelAndTFView : BaseView
@property (nonatomic, assign) Boolean TFEnabled; /// TF是否可以点击，默认可以点击;
@property (nonatomic, assign) Boolean isShowLine; /// 是否要显示line, 1：显示,默认显示;
@property(nonatomic) UIKeyboardType keyboardType; /// 设置键盘弹出的类型

- (instancetype)initWithLabel:(NSString *)lbStr TFPlaceHolder:(NSString *)tfPlaceHoldStr TFText:(NSString *)tfStr;
- (void)setLabelAlignmentStyle:(AlignmentStyleType)alignmentStyleType;
- (NSString *)getTFText;
@end

NS_ASSUME_NONNULL_END
