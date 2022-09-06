//
//  JHBusinessGoodAttributeCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHBusinessGoodsAttributeModel;
//箭头
@interface JHBusinessGoodAttributeArrowCell : UITableViewCell
- (void)setCellTitle:(NSString *)title andIsRequired:(int)required andShowStr:(NSString *)showStr;
@end

//文本框
@interface JHBusinessGoodAttributeCell : UITableViewCell
- (void)setDataModel:(JHBusinessGoodsAttributeModel *)model;
- (void)setCellTitle:(NSString *)title andIsRequired:(int)required andShowStr:(NSString *)showStr;
@end

NS_ASSUME_NONNULL_END
