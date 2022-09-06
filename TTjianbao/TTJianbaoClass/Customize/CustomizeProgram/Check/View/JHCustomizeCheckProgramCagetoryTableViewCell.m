//
//  JHCustomizeCheckProgramCagetoryTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramCagetoryTableViewCell.h"

@interface JHCustomizeCheckProgramCagetoryTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@end

@implementation JHCustomizeCheckProgramCagetoryTableViewCell

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
    
    _subNameLabel               = [[UILabel alloc] init];
    _subNameLabel.textColor     = HEXCOLOR(0x333333);
    _subNameLabel.textAlignment = NSTextAlignmentRight;
    _subNameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_subNameLabel];
    [_subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(17.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSString *string = [NSString cast:viewModel];
    self.subNameLabel.text = string;
}



@end
