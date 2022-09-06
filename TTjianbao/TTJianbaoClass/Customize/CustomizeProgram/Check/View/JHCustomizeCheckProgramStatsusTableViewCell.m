//
//  JHCustomizeCheckProgramStatsusTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramStatsusTableViewCell.h"

@interface JHCustomizeCheckProgramStatsusTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation JHCustomizeCheckProgramStatsusTableViewCell

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
    _nameLabel.text          = @"方案状态";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.width.mas_equalTo(60.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    _statusLabel               = [[UILabel alloc] init];
    _statusLabel.textColor     = HEXCOLOR(0x333333);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.mas_equalTo(17.f);
        make.width.mas_equalTo(60.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSString *str = [NSString cast:viewModel];
    /// 状态 0 待提交 1 待确认 2 已确认 3 拒绝 ,
    if ([str isEqualToString:@"0"]) {
        self.statusLabel.text = @"待提交";
    } else if ([str isEqualToString:@"1"]) {
        self.statusLabel.text = @"待确认";
    } else if ([str isEqualToString:@"2"]) {
        self.statusLabel.text = @"已确认";
    } else {
        self.statusLabel.text = @"拒绝";
    }
}

@end
