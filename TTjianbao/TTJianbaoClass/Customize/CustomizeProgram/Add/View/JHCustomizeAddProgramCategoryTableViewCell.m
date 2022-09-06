//
//  JHCustomizeAddProgramCategoryTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramCategoryTableViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHMeterialsCategoryModel.h"

@interface JHCustomizeAddProgramCategoryTableViewCell ()
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, assign) BOOL      isCagetoryValue;
@end

@implementation JHCustomizeAddProgramCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text          = @"定制类别";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.width.mas_equalTo(60.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    [_chooseBtn setTitle:@"请选择" forState:UIControlStateNormal];
    _chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_chooseBtn setImage:[UIImage imageNamed:@"customize_addProgramm_next"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseBtn];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.width.mas_equalTo(56.f);
        make.height.mas_equalTo(17.f);
    }];
    [_chooseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
    _isCagetoryValue = NO;
}

- (void)chooseBtnAction:(UIButton *)sender {
    if (self.cagetoryChooseBlock) {
        self.cagetoryChooseBlock();
    }
}

- (void)setViewModel:(id)viewModel {
    [JHDispatch ui:^{
        NSString *string = [NSString cast:viewModel];
        if (!isEmpty(string)) {
            self.isCagetoryValue = YES;
            [self.chooseBtn setTitle:string forState:UIControlStateNormal];
            if (self.cagetoryHasString) {
                self.cagetoryHasString(YES);
            }
            [self.chooseBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
//            [self.chooseBtn setImage:nil forState:UIControlStateNormal];
            [self.chooseBtn setImage:[UIImage imageNamed:@"customize_addProgramm_next"] forState:UIControlStateNormal];
            [_chooseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
        } else {
            self.isCagetoryValue = NO;
            [self.chooseBtn setTitle:@"请选择" forState:UIControlStateNormal];
            if (self.cagetoryHasString) {
                self.cagetoryHasString(NO);
            }
            [self.chooseBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
            [self.chooseBtn setImage:[UIImage imageNamed:@"customize_addProgramm_next"] forState:UIControlStateNormal];
            [_chooseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
        }
    }];
}

- (BOOL)checkValue {
    return self.isCagetoryValue;
}

- (NSString *)getCagetoryValue {
    return self.chooseBtn.titleLabel.text;
}

@end
