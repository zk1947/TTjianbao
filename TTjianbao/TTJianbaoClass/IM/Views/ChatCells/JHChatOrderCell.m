//
//  JHChatOrderCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderCell.h"
#import "JHChatUserManager.h"

@interface JHChatOrderCell()
@property (nonatomic, strong) UILabel *orderIDLabel;
@property (nonatomic, strong) UILabel *orderStateLabel;
@property (nonatomic, strong) UIImageView *goodsIcon;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *orderDateLabel;
/// 商品金额
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation JHChatOrderCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"IM释放-%@ 释放", [self class]);
}
- (void)setupOrderInfo {
    self.messageContent.backgroundColor = HEXCOLOR(0xffffff);
    JHChatOrderInfoModel *model = self.message.orderInfo;
    
    self.goodsTitleLabel.text = model.title;
    self.orderDateLabel.text = model.orderDate;
    self.priceLabel.attributedText = [self getPrice: model.price];
    [self.goodsIcon jh_setImageWithUrl:model.iconUrl placeHolder:@""];
    self.orderIDLabel.text = [@"订单号: " stringByAppendingString: model.orderCode ?: @""];
  
    // 买家
    NSString *userId = [JHChatUserManager sharedManager].userId;
    if ([userId isEqualToString:model.customerId]) {
        self.orderStateLabel.text = model.orderStatusDescBuyer;
    }else {
        // 卖家
        self.orderStateLabel.text = model.orderStatusDescSeller;
    }
    
    [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentMaxWidth);
    }];
}
- (NSAttributedString *)getPrice : (NSString *)price {
    if (price.length <= 0) return nil;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"¥"
                                                                              attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:9],
                                                                                           NSForegroundColorAttributeName : HEXCOLOR(0x333333)}];
    
    NSAttributedString *pri = [[NSAttributedString alloc] initWithString:price
                                                              attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:14],
                                                                           NSForegroundColorAttributeName : HEXCOLOR(0x333333)}];
    [title appendAttributedString:pri];
    return title;
    
}
- (void)setupData {
    @weakify(self)
    [[RACObserve(self.message, orderInfo)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self setupOrderInfo];
    }];
}
#pragma mark - UI
- (void)setupUI {
//    [self.messageContent addSubview:self.orderIDLabel];
//    [self.messageContent addSubview:self.orderStateLabel];
    [self.messageContent addSubview:self.stackView];
    [self.messageContent addSubview:self.goodsIcon];
    [self.messageContent addSubview:self.goodsTitleLabel];
    [self.messageContent addSubview:self.orderDateLabel];
    [self.messageContent addSubview:self.priceLabel];
}
- (void)layoutViews {
//    [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(10);
////        make.right.mas_equalTo(self.orderStateLabel.mas_left).offset(-10);
//    }];
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.orderIDLabel);
//        make.right.mas_equalTo(-10);
//        make.left.mas_lessThanOrEqualTo(self.orderIDLabel.mas_right).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(self.orderIDLabel);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(2);
        make.left.mas_equalTo(self.goodsIcon.mas_right).offset(8);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-10);
    }];
    [self.orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(self.goodsTitleLabel);
        make.right.mas_equalTo(self.goodsTitleLabel);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(4);
        make.right.mas_equalTo(self.orderStateLabel);
    }];
}
#pragma mark - LAZY

- (UILabel *)orderIDLabel {
    if (!_orderIDLabel) {
        _orderIDLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderIDLabel.textColor = HEXCOLOR(0x999999);
        _orderIDLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _orderIDLabel.textAlignment = NSTextAlignmentLeft;
        [_orderIDLabel sizeToFit];
    }
    return _orderIDLabel;
}
- (UILabel *)orderStateLabel {
    if (!_orderStateLabel) {
        _orderStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderStateLabel.textColor = HEXCOLOR(0xf23730);
        _orderStateLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _orderStateLabel.textAlignment = NSTextAlignmentRight;
        _orderStateLabel.adjustsFontSizeToFitWidth = true;
    }
    return _orderStateLabel;
}
- (UIImageView *)goodsIcon {
    if (!_goodsIcon) {
        _goodsIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsIcon.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
        _goodsIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_goodsIcon jh_cornerRadius:5];
    }
    return _goodsIcon;
}
- (UILabel *)goodsTitleLabel {
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTitleLabel.numberOfLines = 2;
        _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
        _goodsTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsTitleLabel;
}
- (UILabel *)orderDateLabel {
    if (!_orderDateLabel) {
        _orderDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderDateLabel.textColor = HEXCOLOR(0x999999);
        _orderDateLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _orderDateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderDateLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.orderIDLabel, self.orderStateLabel]];
        _stackView.spacing = 5;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _stackView;
}
@end
