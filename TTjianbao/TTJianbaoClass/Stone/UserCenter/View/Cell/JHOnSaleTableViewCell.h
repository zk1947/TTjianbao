//
//  JHOnSaleTableViewCell.h
//  TTjianbao
//  Description:在售原石基类（UC+MR+RR）
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCornerTableViewCell.h"
#import "JHUIFactory.h"
#import "JHUCOnSaleListModel.h"

//个人中心样式cell高度
#define kUCOnSaleTableCellHeight (201+10)

NS_ASSUME_NONNULL_BEGIN

@interface JHOnSaleTableViewCell : JHCornerTableViewCell

@property (nonatomic, strong) UIImageView* headImage;
@property (nonatomic, strong) UIImageView* ctxImage;  //内容，左边image
@property (nonatomic, strong) UIImageView* playImage; //ctxImage上面的播放图标，表示视频
@property (nonatomic, strong) UIImageView* moneyImage; //第n次交易前 ￥图标
@property (nonatomic, strong) UIImageView* headerIcon1; //有几个显示几个用户头像
@property (nonatomic, strong) UIImageView* headerIcon2;
@property (nonatomic, strong) UIImageView* headerIcon3;
@property (nonatomic, strong) UIImageView* headerIcon4;
@property (nonatomic, strong) UILabel* seeLabel; //超过4个显示
@property (nonatomic, strong) UILabel* idLabel;
@property (nonatomic, strong) UILabel* descpLabel;
@property (nonatomic, strong) UILabel* saleLabel;
@property (nonatomic, strong) UILabel* finalPriceLabel;

- (void)setCellDataModel:(JHGoodsExtModel*)model;
@end

NS_ASSUME_NONNULL_END
