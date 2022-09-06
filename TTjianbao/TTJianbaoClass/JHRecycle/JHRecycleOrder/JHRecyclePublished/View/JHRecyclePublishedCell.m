//
//  JHRecyclePublishedCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePublishedCell.h"
#import "JHRecyclePriceView.h"
#import "JHRecyclePublishButtonView.h"
#import "JHRecyclePublishedModel.h"
#import "UIImageView+JHWebImage.h"
#import "NSString+AttributedString.h"
#import "JHRecycleOrderPursueViewController.h"
#import "CommAlertView.h"
#import "JHRecyclePriceController.h"
#import "JHRecyclePublishedViewModel.h"
#import "JHRecyleRowLabelView.h"
@interface JHRecyclePublishedCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 分类*/
@property (nonatomic, strong) UILabel *productTypeLabel;
/** 小贴士*/
@property (nonatomic, strong) JHRecyleRowLabelView *arrowTipsLabel;
/** 报价区域*/
@property (nonatomic, strong) JHRecyclePriceView *priceView;
/** 按钮区域*/
@property (nonatomic, strong) JHRecyclePublishButtonView *buttonsView;
/** 当前选择的报价模型id*/
@property (nonatomic, copy) NSString *bidId;
@end
@implementation JHRecyclePublishedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHRecyclePublishedModel *)model {
    _model = model;
    [self.buttonsView setStatusType:model.statusType fromIndex:0];
    [self.productImageView jh_setImageWithUrl:model.productImgUrl.small];
    self.productTitleLabel.text = [NSString stringWithFormat:@"回收说明: %@", model.productDesc];
    self.productTypeLabel.text = [NSString stringWithFormat:@"回收分类: %@", model.categoryName];
    
    self.priceView.listArray = [NSMutableArray arrayWithArray:model.bidVOs];
    if (model.bidCount > 3) {
        self.priceView.seeAllButton.hidden = NO;
    } else {
        self.priceView.seeAllButton.hidden = YES;
    }
    self.priceView.productId = model.productId;
    self.buttonsView.productId = model.productId;
    self.buttonsView.publishModel = model;
    
    [self setTipsUI];
    
}
// 刷新计时器UI
- (void)refreshTimerUI {
    if (self.model.timeDuring == 0) {
        if (self.reloadDataBlock) {
            self.reloadDataBlock();
        }
    }
    self.model.timeDuring --;
    [self setTipsUI];
}
- (void)setTipsUI {
    if (self.model.timeDuring >= 0) {
        NSArray *timeArray = [self updateTimeForRow:self.model.timeDuring];
        NSMutableArray *itemsArray = [NSMutableArray array];
        [itemsArray addObject:[self getAttrsWithName:@"小贴士: " color:HEXCOLOR(0x666666)]];
        if (self.model.bidCount > 0) {
            [itemsArray addObject:[self getAttrsWithName:[NSString stringWithFormat:@"%ld", (long)self.model.bidCount] color:HEXCOLOR(0xff4200)]];
            [itemsArray addObject:[self getAttrsWithName:@"人已出价, " color:HEXCOLOR(0x666666)]];
        }
        [itemsArray addObject:[self getAttrsWithName:timeArray[0] color:HEXCOLOR(0xff4200)]];
        [itemsArray addObject:[self getAttrsWithName:@"时" color:HEXCOLOR(0x666666)]];
        [itemsArray addObject:[self getAttrsWithName:timeArray[1] color:HEXCOLOR(0xff4200)]];
        [itemsArray addObject:[self getAttrsWithName:@"分" color:HEXCOLOR(0x666666)]];
        [itemsArray addObject:[self getAttrsWithName:timeArray[2] color:HEXCOLOR(0xff4200)]];
        [itemsArray addObject:[self getAttrsWithName:@"秒" color:HEXCOLOR(0x666666)]];
        [itemsArray addObject:[self getAttrsWithName:self.model.tipDesc color:HEXCOLOR(0x666666)]];
        self.arrowTipsLabel.tipsLabel.attributedText = [NSString mergeStrings:itemsArray];
    } else {
        self.arrowTipsLabel.tipsLabel.text = [NSString stringWithFormat:@"小贴士: %@", self.model.tipDesc];
    }
}

- (NSDictionary *)getAttrsWithName:(NSString *)nameString color:(UIColor *)color {
    return @{@"string":nameString, @"color":color, @"font":[UIFont fontWithName:kFontNormal size:12]};
}

- (NSArray *)updateTimeForRow:(NSInteger )timerDuring {
    NSString *hour = [NSString stringWithFormat:@"%02ld", timerDuring / 3600];
    NSString *minute = [NSString stringWithFormat:@"%02ld", (timerDuring % 3600) / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", timerDuring % 60];
    return @[hour, minute, second];
}
///// 确认报价
//- (void)confirmPrice:(NSString *)bidId {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"bidId"] = bidId;
//    [SVProgressHUD show];
//    [JHRecyclePublishedViewModel confirmPrice:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
//        [SVProgressHUD dismiss];
//        if (!error) {
//            JHRecycleOrderPursueViewController *orderPursueView = [[JHRecycleOrderPursueViewController alloc] init];
//            [self.viewController.navigationController pushViewController:orderPursueView animated:YES];
//        }
//    }];
//}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.productImageView];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.productTypeLabel];
    [self.backView addSubview:self.arrowTipsLabel];
    [self.backView addSubview:self.priceView];
    [self.backView addSubview:self.buttonsView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(12);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productTypeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];

    [self.arrowTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(3);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arrowTipsLabel.mas_bottom);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.layer.cornerRadius = 4;
        _productImageView.clipsToBounds = YES;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)productTypeLabel {
    if (_productTypeLabel == nil) {
        _productTypeLabel = [[UILabel alloc] init];
        _productTypeLabel.textColor = HEXCOLOR(0x333333);
        _productTypeLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _productTypeLabel.text = @"回收分类:";
    }
    return _productTypeLabel;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x666666);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}

- (JHRecyleRowLabelView *)arrowTipsLabel {
    if (_arrowTipsLabel == nil) {
        _arrowTipsLabel = [[JHRecyleRowLabelView alloc] init];
        [_arrowTipsLabel drawArrowWithPoint:25];
    }
    return _arrowTipsLabel;
}

- (JHRecyclePriceView *)priceView {
    if (_priceView == nil) {
        _priceView = [[JHRecyclePriceView alloc] init];
        @weakify(self);
        _priceView.bitIdBlock = ^(JHRecyclePriceModel * _Nonnull bidModel) {
            @strongify(self);
            self.buttonsView.bidModel = bidModel;
        };
    }
    return _priceView;
}

- (JHRecyclePublishButtonView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHRecyclePublishButtonView alloc] init];
        @weakify(self);
        //接收回调后 请求数据状态
        _buttonsView.refreshUIBlock = ^{
            @strongify(self);
            if (self.reloadDataBlock) {
                self.reloadDataBlock();
            }
        };
    }
    return _buttonsView;
}

@end
