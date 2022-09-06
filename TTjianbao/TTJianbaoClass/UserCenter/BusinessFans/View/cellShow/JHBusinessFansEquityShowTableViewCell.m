//
//  JHBusinessFansEquityShowTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansEquityShowTableViewCell.h"
#import "TTjianbao.h"

@interface JHBusinessFansEquityShowTableViewCell ()
@property (nonatomic, strong) UILabel        *titleNameLabel;
@property (nonatomic, strong) UIView         *lineView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *textLableArray;
@end

@implementation JHBusinessFansEquityShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArray;
}

- (NSMutableArray *)textLableArray {
    if (!_textLableArray) {
        _textLableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _textLableArray;
}

- (void)setupViews {
    _titleNameLabel                          = [[UILabel alloc] init];
    _titleNameLabel.textColor                = HEXCOLOR(0x333333);
    _titleNameLabel.textAlignment            = NSTextAlignmentLeft;
    _titleNameLabel.font                     = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    CGFloat btnLeft                = 12.f;
    CGFloat btnWidth               = 19.f + 44.f;
    CGFloat btnSpace               = (ScreenW - btnLeft*2 - btnWidth*3)/2.f;
    NSArray *names                 = @[@"",@"专属商品",@""];
    for (int i = 0; i < 3; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font     = [UIFont fontWithName:kFontNormal size:12.f];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(10.f);
            make.left.equalTo(self.contentView.mas_left).offset(btnLeft+(btnSpace + btnWidth)*i);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(17.f);
        }];
        [self.btnArray addObject:button];
        
        if (i<2) {
            UILabel *textLabel        = [[UILabel alloc] init];
            textLabel.textAlignment   = NSTextAlignmentLeft;
            textLabel.textColor       = HEXCOLOR(0x999999);
            textLabel.font            = [UIFont fontWithName:kFontNormal size:12.f];
            [self.contentView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left);
                make.top.equalTo(button.mas_bottom).offset(9.f);
                make.width.mas_equalTo(116.f);
                make.height.mas_equalTo(30.f);
            }];
            [self.textLableArray addObject:textLabel];
        }
    }

    _lineView                    = [[UIView alloc] init];
    _lineView.backgroundColor    = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(81.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setIsLastLine:(BOOL)isLastLine {
    _isLastLine = isLastLine;
    _lineView.hidden = isLastLine;
}

- (void)setShowModel:(JHBusinessFansSettinglevelRewardDTOListModel *)showModel {
    _showModel = showModel;
    _titleNameLabel.text = [NSString stringWithFormat:@"粉丝等级Lv.%@",NONNULL_STR(showModel.levelType)];
    if (showModel.rewardVos.count >0) {
        for (int i = 0; i <showModel.rewardVos.count; i++) {
            JHBusinessFansSettinglevelRewardVosModel *vosModel = showModel.rewardVos[i];
            if ([vosModel.rewardType integerValue] == 0) {
                UIButton *btn = self.btnArray[0];
                [btn setTitle:@"代金券" forState:UIControlStateNormal];
                UILabel *textLabel = self.textLableArray[0];
                textLabel.text = isEmpty(vosModel.rewardName)?@"":vosModel.rewardName;
            } else if ([vosModel.rewardType integerValue] == 1) {
                UILabel *textLabel = self.textLableArray[1];
                textLabel.text = isEmpty(vosModel.rewardName)?@"":vosModel.rewardName;
            } else if ([vosModel.rewardType integerValue] == 2) {
                UIButton *btn = self.btnArray[2];
                [btn setTitle:@"进场特效" forState:UIControlStateNormal];
            } else {
                UILabel *textLabel0 = self.textLableArray[0];
                UILabel *textLabel1 = self.textLableArray[1];
                textLabel0.text = @"";
                textLabel1.text = @"";
            }
        }
        
        CGFloat lineViewTop = 81.f;
        for (JHBusinessFansSettinglevelRewardVosModel *vosModel in showModel.rewardVos) {
            if (!isEmpty(vosModel.rewardName)) {
                lineViewTop = 81.f;
                break;
            }
            lineViewTop = 41.f;
        }
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(lineViewTop);
        }];
    } else {
        for (int i = 0; i<self.textLableArray.count; i++) {
            UILabel *textLabel = self.textLableArray[i];
            textLabel.text = @"";
        }
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(41.f);
        }];
    }
}


@end
