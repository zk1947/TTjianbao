//
//  JHPublishReportTrueOtherCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportTrueOtherCell : JHWBaseTableViewCell

///输入估价
@property (nonatomic, weak) UITextField *priceTf;

///选择其他时输入报告
@property (nonatomic, weak) UITextField *descTf;

@property (nonatomic, copy) void (^priceBlock) (NSString *price);

@property (nonatomic, copy) void (^descBlock) (NSString *desc);

+ (UITextField *)creatTextFieldWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder top:(CGFloat)top addSupView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
