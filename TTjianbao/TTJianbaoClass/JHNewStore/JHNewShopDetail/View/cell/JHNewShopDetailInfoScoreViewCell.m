//
//  JHNewShopDetailInfoScoreViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailInfoScoreViewCell.h"
#import "UIView+JHGradient.h"
#import "JHNewShopDetailInfoModel.h"

@interface JHNewShopDetailInfoScoreView : UIView
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UIView  *scoreGrayView;
@property (nonatomic, strong) UIView  *scoreColorView;
@property (nonatomic, strong) UILabel *scoreCountLabel;
@property (nonatomic, strong) UILabel *infoLabel;
- (void)setInfo:(NSString *)name score:(NSString *)score info:(NSString *)info;
@end

@implementation JHNewShopDetailInfoScoreView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleNameLabel           = [[UILabel alloc] init];
    _titleNameLabel.textColor = kColor222;
    _titleNameLabel.font      = [UIFont fontWithName:kFontNormal size:14.f];
    [self addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(4.f);
        make.height.mas_equalTo(20.f);
    }];
    
    _scoreGrayView = [[UIView alloc] init];
    _scoreGrayView.backgroundColor = HEXCOLOR(0xF0F0F0);
    _scoreGrayView.layer.cornerRadius  = 4.f;
    _scoreGrayView.layer.masksToBounds = YES;
    [self addSubview:_scoreGrayView];
    [_scoreGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleNameLabel.mas_right).offset(10.f);
        make.centerY.equalTo(self.titleNameLabel.mas_centerY);
        make.width.mas_equalTo(166.f);
        make.height.mas_equalTo(8.f);
    }];
    
    _scoreColorView = [[UIView alloc] init];
    _scoreColorView.backgroundColor = HEXCOLOR(0xF0F0F0);
    _scoreColorView.layer.cornerRadius  = 4.f;
    _scoreColorView.layer.masksToBounds = YES;
    [self addSubview:_scoreColorView];
    [_scoreColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreGrayView);
        make.centerY.equalTo(self.scoreGrayView.mas_centerY);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(8.f);
    }];
    
    _scoreCountLabel           = [[UILabel alloc] init];
    _scoreCountLabel.textColor = HEXCOLOR(0xFFA319);
    _scoreCountLabel.font      = [UIFont fontWithName:kFontNormal size:14.f];
    [self addSubview:_scoreCountLabel];
    [_scoreCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreGrayView.mas_right).offset(15.f);
        make.centerY.equalTo(self.scoreGrayView.mas_centerY);
        make.height.mas_equalTo(20.f);
    }];
    
    _infoLabel           = [[UILabel alloc] init];
    _infoLabel.textColor = HEXCOLOR(0x999999);
    _infoLabel.font      = [UIFont fontWithName:kFontNormal size:14.f];
//    _infoLabel.text      = @"非常好";
    [self addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreCountLabel.mas_right).offset(10.f);
        make.centerY.equalTo(self.scoreGrayView.mas_centerY);
        make.height.mas_equalTo(18.f);
    }];
}

- (void)setInfo:(NSString *)name score:(NSString *)score info:(NSString *)info {
    self.titleNameLabel.text  = name;
    self.scoreCountLabel.text = isEmpty(score)?@"0.0":score;
    self.infoLabel.text = info;
    CGFloat scoreColorWidth = [score floatValue] / 5.f * 166.f;
    [self.scoreColorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scoreColorWidth);
    }];
    [self.scoreColorView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

@end





@interface JHNewShopDetailInfoScoreViewCell ()
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UILabel *titleValueLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) NSMutableArray *viewArr;
@end

@implementation JHNewShopDetailInfoScoreViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)viewArr {
    if (!_viewArr) {
        _viewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _viewArr;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.contentView.layer.cornerRadius = 6.f;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;

    _titleNameLabel           = [[UILabel alloc] init];
    _titleNameLabel.textColor = kColor333;
    _titleNameLabel.font      = [UIFont fontWithName:kFontMedium size:16.f];
    _titleNameLabel.text      = @"店铺综合评分：";
    [self.contentView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.height.mas_equalTo(22.f);
    }];
    
    _titleValueLabel           = [[UILabel alloc] init];
    _titleValueLabel.textColor = HEXCOLOR(0xFFA319);
    _titleValueLabel.font      = [UIFont fontWithName:kFontMedium size:16.f];
    [self.contentView addSubview:_titleValueLabel];
    [_titleValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleNameLabel.mas_right);
        make.centerY.equalTo(self.titleNameLabel.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    
    _scoreLabel           = [[UILabel alloc] init];
    _scoreLabel.textColor = HEXCOLOR(0xFFA319);
    _scoreLabel.font      = [UIFont fontWithName:kFontMedium size:16.f];
    [self.contentView addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleNameLabel.mas_right).offset(1.f);
        make.centerY.equalTo(self.titleNameLabel.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    
    for (int i = 0; i<3; i++) {
        JHNewShopDetailInfoScoreView *view = [[JHNewShopDetailInfoScoreView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleNameLabel.mas_left);
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(6.f +(28.f +4)*i);
            make.right.equalTo(self.contentView.mas_right).offset(-10.f);
            make.height.mas_equalTo(28.f);
            if (i == 2) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
            }
        }];
        [self.viewArr addObject:view];
    }
}

- (void)setShopHeaderInfoModel:(JHNewShopDetailInfoModel *)shopHeaderInfoModel {
    _shopHeaderInfoModel = shopHeaderInfoModel;
    _titleValueLabel.text = isEmpty(shopHeaderInfoModel.comprehensiveScore)?@"0.0":shopHeaderInfoModel.comprehensiveScore;
    NSArray *aaa = @[@"商品相符度",@"客服满意度",@"物流满意度"];
    self.scoreLabel.text = NONNULL_STR(shopHeaderInfoModel.comprehensiveScore);
    NSArray *dataArr = @[
        NONNULL_STR(shopHeaderInfoModel.goodsScore),
        NONNULL_STR(shopHeaderInfoModel.customerServiceScore),
        NONNULL_STR(shopHeaderInfoModel.logisticsScore)
    ];
    
    NSArray *descArr = @[
        [self descStr:shopHeaderInfoModel.goodsScore],
        [self descStr:shopHeaderInfoModel.customerServiceScore],
        [self descStr:shopHeaderInfoModel.logisticsScore]
    ];
    for (int i = 0; i< self.viewArr.count; i++) {
        JHNewShopDetailInfoScoreView *view = self.viewArr[i];
        [view setInfo:aaa[i] score:dataArr[i] info:descArr[i]];
    }
}

- (NSString *)descStr:(NSString *)score {
    if ([score floatValue] >= 4.f) {
        return @"非常好";
    } else if ([score floatValue] >= 3.f) {
        return @"好";
    } else if ([score floatValue] >= 2.f) {
        return @"一般";
    } else if ([score floatValue] >= 1.f) {
        return @"差";
    } else {
        return @"非常差";
    }
}

@end
