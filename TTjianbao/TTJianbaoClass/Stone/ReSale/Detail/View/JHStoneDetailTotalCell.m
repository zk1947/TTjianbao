//
//  JHStoneDetailTotalCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailTotalCell.h"


@interface JHStoneDetailTotalView ()

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation JHStoneDetailTotalView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _priceLabel = [UILabel jh_labelWithBoldText:@"￥7000" font:18 textColor:UIColor.blackColor textAlignment:0 addToSuperView:self];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(12);
        }];
        
        _tipLabel = [UILabel jh_labelWithText:@"金额（元）" font:12 textColor:UIColor.blackColor textAlignment:0 addToSuperView:self];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-12);
        }];
        
        self.backgroundColor = RGB(248, 248, 248);
    }
    return self;
}


+(CGSize)viewSize
{
    return CGSizeMake((ScreenW - 35.f)/2.0, 66.0);
}

@end


@interface JHStoneDetailTotalCell ()

/// 原始价格
@property (nonatomic, strong) JHStoneDetailTotalView *originalView;

/// 预计价格
@property (nonatomic, strong) JHStoneDetailTotalView *predictView;

/// 回血价格
@property (nonatomic, strong) JHStoneDetailTotalView *saleView;

/// 寄回（块）
@property (nonatomic, strong) JHStoneDetailTotalView *backView;

@end

@implementation JHStoneDetailTotalCell

-(void)addSelfSubViews
{
    _originalView = [JHStoneDetailTotalView new];
    [self.contentView addSubview:_originalView];
    _originalView.tipLabel.text = @"原石初始成交价（元）";
    [_originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5.f);
        make.left.equalTo(self.contentView).offset(15.f);
        make.size.mas_equalTo([JHStoneDetailTotalView viewSize]);
    }];
    
    _predictView = [JHStoneDetailTotalView new];
    [self.contentView addSubview:_predictView];
    _predictView.tipLabel.text = @"预估回血总金额（元）";
    [_predictView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originalView);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.size.equalTo(self.originalView);
    }];
    
    _saleView = [JHStoneDetailTotalView new];
    [self.contentView addSubview:_saleView];
    _saleView.tipLabel.text = @"已回血金额（元）";
    [_saleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originalView.mas_bottom).offset(5.f);
        make.left.equalTo(self.originalView);
        make.size.equalTo(self.originalView);
    }];
    
    _backView = [JHStoneDetailTotalView new];
    _backView.tipLabel.text = @"寄回（块）";
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleView);
        make.right.equalTo(self.predictView);
        make.size.equalTo(self.originalView);
        make.bottom.equalTo(self.contentView).offset(-20.f);
    }];
}

-(void)setOriPrice:(CGFloat)oriPrice
       expectPrice:(CGFloat)expectPrice
       actualPrice:(CGFloat)actualPrice
         sendCount:(NSInteger)sendCount
{
    self.originalView.priceLabel.attributedText  = [self getAttributedString:oriPrice];
    self.predictView.priceLabel.attributedText   = [self getAttributedString:expectPrice];
    self.saleView.priceLabel.attributedText      = [self getAttributedString:actualPrice];
    self.backView.priceLabel.text      = [NSString stringWithFormat:@"%lu",sendCount];
}

-(NSMutableAttributedString *)getAttributedString:(CGFloat)price
{
    NSString *string = [NSString stringWithFormat:@"￥%@",@((NSInteger)price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(12), NSForegroundColorAttributeName: RGB(51, 51, 51)}];

    [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.000000]} range:NSMakeRange(0, 1)];
    
    [attributedString addAttributes:@{NSFontAttributeName: JHBoldFont(18), NSForegroundColorAttributeName:RGB(51, 51, 51)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}
+(CGFloat)cellHeight
{
    return 162.f;
}
@end
