//
//  JHMarketPublishCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPublishCell.h"
#import "JHMarketPublishButtonsView.h"
@interface JHMarketPublishCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 真假标签*/
@property (nonatomic, strong) UILabel *tagLabel;
/** 鉴定中*/
@property (nonatomic, strong) UIImageView *tagImageView;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 拍卖中*/
@property (nonatomic, strong) UILabel *auctionLabel;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 当前价*/
@property (nonatomic, strong) UILabel *nowPriceLabel;
/** 价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 起拍价*/
@property (nonatomic, strong) UILabel *desLabel;
/** 浏览数*/
@property (nonatomic, strong) UILabel *wantLabel;
/** 按钮区域*/
@property (nonatomic, strong) JHMarketPublishButtonsView *buttonsView;
///
@property (nonatomic, strong) UILabel *violationDescLabel;
@end
@implementation JHMarketPublishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

// 刷新计时器UI
- (void)refreshTimerUI {
    
    if (self.publishModel.timeDuring == 0) {  //倒计时结束直接刷新
        if (self.reloadCellDataBlock) {
            self.reloadCellDataBlock(YES);
        }
    }
    
//    self.publishModel.timeDuring --;
    if (self.publishModel.timeDuring > 0) {
        if (self.publishModel.auctionStartRemainTime > 0) {  //未开始
            self.timeLabel.text = [NSString stringWithFormat:@"距开始还有%@", [self updateTimeForRow:self.publishModel.timeDuring]];
        } else if(self.publishModel.auctionRemainTime > 0) {  //已开始未结束
            self.timeLabel.text = [NSString stringWithFormat:@"距结束还有%@", [self updateTimeForRow:self.publishModel.timeDuring]];
        } else {  //没了
            self.timeLabel.text = @"";
        }
    }else {
         self.timeLabel.text = @"";
    }
}
- (NSString *)updateTimeForRow:(NSInteger )timerDuring {
    NSString *hour = [NSString stringWithFormat:@"%02ld", timerDuring / 3600];
    NSString *minute = [NSString stringWithFormat:@"%02ld", (timerDuring % 3600) / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", timerDuring % 60];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
}

- (void)setPublishModel:(JHMarketPublishModel *)publishModel {
    _publishModel = publishModel;
    self.buttonsView.publishModel = publishModel;
    [self.productImageView jh_setImageWithUrl:publishModel.coverImage.url];
    
    
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:publishModel.productDesc];
    if (publishModel.productType == 1) { //拍卖
        self.auctionLabel.hidden = NO;
        self.nowPriceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", publishModel.currentPrice.doubleValue > 0 ? publishModel.currentPrice : NONNULL_NUM(publishModel.startPrice)];
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"c2c_class_publish_logo"];
        attch.bounds = CGRectMake(0, -4, 30, 16);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
        
        [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22);
        }];
        self.desLabel.text = [NSString stringWithFormat:@"起拍价¥%@·加价幅度¥%@·已出价%@次", NONNULL_NUM(publishModel.startPrice), NONNULL_NUM(publishModel.bidIncrement), NONNULL_NUM(publishModel.num)];
        /** 商品状态 0-上架 1-下架 2违规禁售 3预告中 4已售出 5流拍 6交易取消 （3，5，6是拍卖商品特有的状态）*/
        switch (publishModel.productStatus) {
            case 0:
            {
                self.auctionLabel.backgroundColor = HEXCOLOR(0xf23730);
                self.auctionLabel.text = @"拍卖中";
            }
                break;
            case 1:
            {
                self.auctionLabel.backgroundColor = HEXCOLOR(0xc8c8c8);
                self.auctionLabel.text = @"下拍";
            }
                break;
            case 2:
            {
                self.auctionLabel.backgroundColor = HEXCOLOR(0xf23730);
                self.auctionLabel.text = @"违规商品";
            }
                break;
            case 3:
            {
                self.auctionLabel.backgroundColor = HEXCOLOR(0xff9900);
                self.auctionLabel.text = @"待上拍";
            }
                break;
            case 5:
            {
                self.auctionLabel.backgroundColor = HEXCOLOR(0xc8c8c8);
                self.auctionLabel.text = @"流拍";
            }
                break;
                
            default:
            {
                self.auctionLabel.backgroundColor = [UIColor clearColor];
                self.auctionLabel.text = @"";
            }
                break;
        }
        
    } else {
        if (publishModel.productStatus == 2) {
            self.auctionLabel.backgroundColor = HEXCOLOR(0xf23730);
            self.auctionLabel.text = @"违规商品";
            self.auctionLabel.hidden = false;
        }else {
            self.auctionLabel.hidden = YES;
        }
        
        self.nowPriceLabel.hidden = YES;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", publishModel.price];
        [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    _productTitleLabel.attributedText = attri;
    
    self.wantLabel.text = [NSString stringWithFormat:@"%@次浏览·%@人想要", publishModel.productExt.viewCount, publishModel.productExt.wantCount];
    
    //标签  鉴定报告结果类型 0 真 1 仿品 2 存疑 3 现代工艺品 4 鉴定中 5 未鉴定（没有人买鉴定服务） 6 未鉴定（买家买了鉴定服务）",
    
    self.tagLabel.hidden = YES;
    switch (publishModel.authResult) {
        case 0:
            self.tagImageView.image = [UIImage imageNamed:@"c2c_class_apprise_true"];
            self.tagImageView.hidden = NO;
            break;
        case 2:
            self.tagImageView.image = [UIImage imageNamed:@"c2c_class_apprise_question"];
            self.tagImageView.hidden = NO;
            break;
        case 3:
            self.tagImageView.image = [UIImage imageNamed:@"c2c_class_apprise_art"];
            self.tagImageView.hidden = NO;
            break;
        case 4:
            self.tagLabel.hidden = NO;
            self.tagImageView.hidden = YES;
            break;
        default:
            self.tagImageView.hidden = YES;
            break;
    }
    
    //未鉴定+不是拍卖中 上面一行空间不要
    if(publishModel.auctionStartRemainTime > 0 || publishModel.auctionRemainTime > 0 || publishModel.authResult < 5) {
        [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tagImageView.mas_bottom).offset(15);
            make.left.mas_equalTo(self.backView).offset(10);
            make.width.height.mas_equalTo(75);
        }];
    } else {
        self.timeLabel.text = @"";
        [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView).offset(15);
            make.left.mas_equalTo(self.backView).offset(10);
            make.width.height.mas_equalTo(75);
        }];
    }
    
    if (self.buttonsView.dataSource.count == 0) {
        self.buttonsView.hidden = true;
        [self.buttonsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.violationDescLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
    }else {
        self.buttonsView.hidden = false;
        [self.buttonsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.violationDescLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(30);
        }];
    }
    
    // 违规原因
    if (publishModel.forbidSellReason.length > 0) {
        self.violationDescLabel.text = [NSString stringWithFormat:@"违规原因: %@", publishModel.forbidSellReason ];
        [self.violationDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.wantLabel.mas_bottom).offset(8);
        }];
    }else {
        self.violationDescLabel.text = @"";
        [self.violationDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.wantLabel.mas_bottom).offset(0);
        }];
    }
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.tagLabel];
    [self.backView addSubview:self.tagImageView];
    [self.backView addSubview:self.productImageView];
    [self.productImageView addSubview:self.auctionLabel];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.nowPriceLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.desLabel];
    [self.backView addSubview:self.wantLabel];
    [self.backView addSubview:self.buttonsView];
    [self.backView addSubview:self.violationDescLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView).offset(-10);
        make.top.mas_equalTo(self.backView).offset(9);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.top.mas_equalTo(self.backView);
        make.height.mas_equalTo(29);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.backView);
        make.height.mas_equalTo(29);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.auctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView);
        make.right.mas_equalTo(self.productImageView);
        make.height.mas_equalTo(17);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.productImageView);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceLabel.mas_top).offset(-4);
        make.right.mas_equalTo(self.priceLabel);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-10);
    }];

    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(-17);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
    }];
    
    [self.wantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desLabel.mas_bottom);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.violationDescLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
    [self.violationDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wantLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.left.mas_equalTo(self.backView).offset(10);
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

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEXCOLOR(0xff4200);
        _tagLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _tagLabel.text = @"鉴定中···";
    }
    return _tagLabel;
}

- (UIImageView *)tagImageView {
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"c2c_class_apprise_question"];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _tagImageView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0xff4200);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _timeLabel.text = @"";
    }
    return _timeLabel;
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

- (UILabel *)auctionLabel {
    if (_auctionLabel == nil) {
        _auctionLabel = [[UILabel alloc] init];
        _auctionLabel.textColor = HEXCOLOR(0xffffff);
        _auctionLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _auctionLabel.backgroundColor = HEXCOLOR(0xf23730);
        _auctionLabel.text = @"拍卖中";
        _auctionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _auctionLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:20];
        _priceLabel.text = @"";
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [_priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _priceLabel;
}

- (UILabel *)nowPriceLabel {
    if (_nowPriceLabel == nil) {
        _nowPriceLabel = [[UILabel alloc] init];
        _nowPriceLabel.textColor = HEXCOLOR(0xff4200);
        _nowPriceLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _nowPriceLabel.text = @"当前价";
    }
    return _nowPriceLabel;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x333333);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = HEXCOLOR(0x999999);
        _desLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _desLabel.text = @"";
    }
    return _desLabel;
}

- (UILabel *)wantLabel {
    if (_wantLabel == nil) {
        _wantLabel = [[UILabel alloc] init];
        _wantLabel.textColor = HEXCOLOR(0x999999);
        _wantLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _wantLabel.text = @"";
    }
    return _wantLabel;
}

- (JHMarketPublishButtonsView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHMarketPublishButtonsView alloc] init];
        @weakify(self);
        _buttonsView.reloadDataBlock = ^(BOOL iSdelete) {
            @strongify(self);
            if (self.reloadCellDataBlock) {
                self.reloadCellDataBlock(iSdelete);
            }
        };
        
        _buttonsView.issueEditBlock = ^(JHIssueGoodsEditModel * _Nonnull model) {
            @strongify(self);
            if (self.issueEditBlock) {
                self.issueEditBlock(model);
            }
        };
        
    }
    return _buttonsView;
}
- (UILabel *)violationDescLabel {
    if (!_violationDescLabel) {
        _violationDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _violationDescLabel.numberOfLines = 0;
        _violationDescLabel.textColor = HEXCOLOR(0xb9855d);
        _violationDescLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _violationDescLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _violationDescLabel;
}

@end
