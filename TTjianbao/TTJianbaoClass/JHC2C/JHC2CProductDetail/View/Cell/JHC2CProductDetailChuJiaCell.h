//
//  JHC2CProductDetailChuJiaCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailChuJiaCell : UITableViewCell
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UILabel * priceLbl;
@property(nonatomic, strong) UILabel * timeLbl;

@property(nonatomic, assign) NSInteger  indexRow;
@end

NS_ASSUME_NONNULL_END
