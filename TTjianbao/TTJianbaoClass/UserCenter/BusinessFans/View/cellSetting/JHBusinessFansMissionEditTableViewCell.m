//
//  JHBusinessFansMissionEditTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansMissionEditTableViewCell.h"
#import "TTjianbao.h"

@interface JHBusinessFansMissionEditTableViewCell ()
@property (nonatomic, strong) UIButton *missonBtn;
@property (nonatomic, strong) UILabel  *missonLabel;
@property (nonatomic, strong) UIView   *lineView;
@end

@implementation JHBusinessFansMissionEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _missonBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_missonBtn];
    [_missonBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _missonBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    [_missonBtn addTarget:self action:@selector(settingBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_normal"] forState:UIControlStateNormal];
    [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
    [_missonBtn setImageInsetStyle:MRImageInsetStyleLeft spacing:5.f];
    [_missonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(17.f);
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.width.height.mas_equalTo(14.f);
    }];

    _missonLabel               = [[UILabel alloc] init];
    _missonLabel.textColor     = HEXCOLOR(0x333333);
    _missonLabel.textAlignment = NSTextAlignmentLeft;
    _missonLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _missonLabel.numberOfLines = 0;
    _missonLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_missonLabel];
    [_missonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.missonBtn.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnClickAction)];
//    [_missonLabel addGestureRecognizer:tap];
    

    _lineView                  = [[UIView alloc] init];
    _lineView.backgroundColor  = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.top.equalTo(self.missonLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)settingBtnClickAction {
    self.missonBtn.selected = !self.missonBtn.selected;
    [self.missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
    _model.check = self.missonBtn.selected;
    if (self.changeBlock) {
        self.changeBlock();
    }
}

- (void)setIsLastLine:(BOOL)isLastLine {
    _isLastLine = isLastLine;
    _lineView.hidden = isLastLine;
}

- (void)setModel:(JHBusinessFansSettingTaskCheckListModel *)model {
    _model            = model;
    _missonLabel.text = model.taskDes;
    if([model.defaultFlag isEqualToString:@"1"]){
        _missonBtn.enabled = NO;
        _missonBtn.selected = YES;
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_gray"] forState:UIControlStateSelected];
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_gray"] forState:UIControlStateNormal];
        if (self.changeBlock) {
            self.changeBlock();
        }
    }else if (model.check) {
        _missonBtn.selected = YES;
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_normal"] forState:UIControlStateNormal];
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
        if (self.changeBlock) {
            self.changeBlock();
        }
    } else {
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_normal"] forState:UIControlStateNormal];
        [_missonBtn setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
        _missonBtn.selected = NO;
    }
}

@end
