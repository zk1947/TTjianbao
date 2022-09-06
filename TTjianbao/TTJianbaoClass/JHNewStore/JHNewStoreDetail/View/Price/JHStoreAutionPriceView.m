//
//  JHStoreAutionPriceView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreAutionPriceView.h"

static const CGFloat CountdownSpace = 3;

@interface JHStoreAutionPriceView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property(nonatomic, strong) UILabel * bigLbl;

@end

@implementation JHStoreAutionPriceView
#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    NSLog(@"商品详情-%@ 释放", [self class]);
}


- (void)changeAuctionStatus:(StoreDetailAuctionStatus)status{
    NSString *bgName = @"newStore_price_bg";
    self.detailLabel.hidden = false;
    self.countdownView.hidden = true;
    self.noticeLbl.hidden = true;
    self.bigLbl.hidden = YES;
    self.titleLabel.text = @"起拍价";
    self.backgroundColor = [UIColor colorWithHexString:@"FDF0C8"];
    NSString* detailStr  =  @"距拍卖结束";
    switch (status) {
        case StoreDetailAuctionStatus_YuGao: // 预告
        {
            self.noticeLbl.hidden = false;
             bgName = @"newStore_price_aution_bg";
            detailStr= self.auStarStr;
        }
            break;
        case StoreDetailAuctionStatus_InSelling_noBuyer: // 拍卖中无出价
        {
            self.countdownView.hidden = false;
        }
            break;
        case StoreDetailAuctionStatus_InSelling: // 拍卖中
        {
            self.countdownView.hidden = false;
            self.titleLabel.text = @"当前价";
        }
            break;
        case StoreDetailAuctionStatus_Finish_noBuyer: // 拍卖结束无出价
        {
             bgName = @"newStore_price_aution_end_bg";
            self.detailLabel.hidden = true;
            self.bigLbl.text = @"已结束";
            self.bigLbl.hidden = NO;
            self.backgroundColor = [UIColor colorWithHexString:@"E0E0E0"];
        }
            break;
        case StoreDetailAuctionStatus_Finish: // 拍卖结束
        {
            self.detailLabel.hidden = true;
            self.titleLabel.text = @"成交价";
            self.bigLbl.text = @"已成交";
            self.bigLbl.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.detailLabel.text = detailStr;
    self.bgImageView.image = [UIImage imageNamed:bgName];
}

#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"FDF0C8"];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.countdownView];
    [self addSubview:self.noticeLbl];
    [self addSubview:self.bigLbl];

    
}

- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@261);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(PriceTitleTopSpace);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-CountdownSpace);
        make.left.equalTo(self.bgImageView.mas_right).offset(-4);
        make.right.equalTo(self);
    }];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(CountdownSpace);
        make.centerX.equalTo(self.detailLabel.mas_centerX);
    }];
    [self.noticeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.bgImageView.mas_right);
        make.bottom.equalTo(self).offset(-9);
    }];

    [self.bigLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.bgImageView.mas_right);
        make.bottom.top.equalTo(self);
    }];

    
}

#pragma mark - Lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"起拍价";
        _titleLabel.font = JHFont(12);
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.text = @"距拍卖结束";
        _detailLabel.font = JHFont(12);
        _detailLabel.textColor = [UIColor colorWithHexString:@"9B541F"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UILabel *)noticeLbl {
    if (!_noticeLbl) {
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _noticeLbl.text = @"xx人已设置提醒";
        _noticeLbl.font = JHFont(12);
        _noticeLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _noticeLbl.adjustsFontSizeToFitWidth = YES;
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _noticeLbl;
}

- (UILabel *)bigLbl {
    if (!_bigLbl) {
        _bigLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _bigLbl.text = @"已结束";
        _bigLbl.font = JHFont(15);
        _bigLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _bigLbl;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newStore_price_bg"]];
    }
    return _bgImageView;
}
- (JHStoreDetailCountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[JHStoreDetailCountdownView alloc]initWithFrame:CGRectZero];
    }
    return _countdownView;
}
@end
