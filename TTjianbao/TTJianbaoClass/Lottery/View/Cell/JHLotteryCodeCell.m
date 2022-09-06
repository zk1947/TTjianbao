//
//  JHLotteryCodeCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryCodeCell.h"
#import "JHLotteryMyCodeModel.h"
#import "UIImageView+JHWebImage.h"

@interface JHLotteryCodeCell ()

@property (nonatomic, strong) UIImageView *backImageView;
///头像
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userLabel;
///显示状态
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *statusPlaceholder;

///存放展示号码的数组
@property (nonatomic, strong) NSArray <UILabel *>*codeImageArray;

@end

@implementation JHLotteryCodeCell

- (void)setCodeModel:(JHLotteryMyCodeModel *)codeModel {
    _codeModel = codeModel;
    if (codeModel) {
        [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_codeModel.img] placeholder:kDefaultAvatarImage];
        if (_codeModel.sourceUp.length > 3) {
            _codeModel.sourceUp = [NSString stringWithFormat:@"%@…%@", [_codeModel.sourceUp substringWithRange:NSMakeRange(0,1)], [_codeModel.sourceUp substringWithRange:NSMakeRange(_codeModel.sourceUp.length-1,1)]];
        }
        _userLabel.text = _codeModel.sourceUp?:@"我的";
        _statusLabel.text = _codeModel.sourceDown?:@"抽奖码";
        NSArray *codeArray = [self getcode:_codeModel.lotteryCode];
        for (int i = 0; i < codeArray.count; i ++) {
            UILabel *label = self.codeImageArray[i];
            if([codeArray[i] isKindOfClass:[NSString class]])
                label.text = codeArray[i];
            else
                label.text = [codeArray[i] stringValue]; //maybe crash
        }
        _statusPlaceholder.hidden = YES;
        _userLabel.hidden = NO;
        _statusLabel.hidden = NO;
    }
    else {
        _iconImageView.image = kDefaultAvatarImage;
        for (int i = 0; i < self.codeImageArray.count; i ++) {
            UILabel *label = self.codeImageArray[i];
            label.text = @"";
        }
        _statusPlaceholder.hidden = NO;
        _userLabel.hidden = YES;
        _statusLabel.hidden = YES;
    }
}

- (NSArray *)getcode:(NSString *)lotteryCode {
    NSMutableArray *temps = [NSMutableArray array];
    for(int i = 0; i < [lotteryCode length]; i++) {
        [temps addObject:[lotteryCode substringWithRange:NSMakeRange(i,1)]];
    }
    return temps.copy;
}


+ (CGFloat)cellHeight {
    return 72.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyleEnabled = NO;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat iconWidth = 30;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lottery_bg"]];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    _backImageView = backImageView;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView = iconImageView;
        
    UILabel *placeHolder = [[UILabel alloc] init];
    placeHolder.text = @"待激活";
    placeHolder.font = [UIFont fontWithName:kFontNormal size:10];
    placeHolder.textColor = kColor999;
    _statusPlaceholder = placeHolder;

    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.text = @"我的";
    userLabel.font = [UIFont fontWithName:kFontNormal size:10];
    userLabel.textColor = kColor333;
    _userLabel = userLabel;
    _userLabel.hidden = YES;

    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = @"待激活";
    statusLabel.font = [UIFont fontWithName:kFontNormal size:10];
    statusLabel.textColor = kColor333;
    _statusLabel = statusLabel;
    _statusLabel.hidden = YES;

    [self.contentView addSubview:backImageView];
    [_backImageView addSubview:iconImageView];
    [_backImageView addSubview:_statusPlaceholder];
    [_backImageView addSubview:_userLabel];
    [_backImageView addSubview:statusLabel];
    
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 19, 0, 14));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backImageView);
        make.left.equalTo(self.backImageView).offset(15);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    
    [_statusPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.centerY.equalTo(self.backImageView);
        make.width.lessThanOrEqualTo(@35);
    }];

    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.bottom.equalTo(self.backImageView.mas_centerY);
        make.width.lessThanOrEqualTo(@35);
    }];

    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7);
        make.top.equalTo(self.backImageView.mas_centerY);
        make.width.lessThanOrEqualTo(@35);
    }];
    
    [_statusLabel layoutIfNeeded];
    [_backImageView layoutIfNeeded];
    
    CGFloat space = 7;
    CGFloat scale = (23/35.f);
    CGFloat codeWidth = (ScreenW-iconWidth-_statusLabel.width-19-14-15-10-16-space*8)/8;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 8; i ++) {
        UIImageView *codeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lottery_border"]];
        codeImage.contentMode = UIViewContentModeScaleAspectFit;
        [_backImageView addSubview:codeImage];
        UILabel *codeLabel = [[UILabel alloc] init];
        codeLabel.text = @"0";
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.font = [UIFont fontWithName:kFontBoldDIN size:23];
        [codeImage addSubview:codeLabel];
        [tempArray addObject:codeLabel];
        
        [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backImageView).offset(-15-i*(space+codeWidth));
            make.centerY.equalTo(self.backImageView);
            make.size.mas_equalTo(CGSizeMake(codeWidth, codeWidth/scale));
        }];
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(codeImage);
        }];
    }
    
    self.codeImageArray = [[tempArray reverseObjectEnumerator] allObjects];
    
    [_iconImageView layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.height/2.f;
    _iconImageView.clipsToBounds = YES;
}

@end
