//
//  JHCustomizeAddProgramCompleteTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramCompleteTableViewCell.h"

@interface JHCustomizeAddProgramCompleteTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *completeLabel;
@end

@implementation JHCustomizeAddProgramCompleteTableViewCell

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
    _nameLabel.text          = @"完成说明";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _completeLabel               = [[UILabel alloc] init];
    _completeLabel.textColor     = HEXCOLOR(0x333333);
    _completeLabel.textAlignment = NSTextAlignmentLeft;
    _completeLabel.numberOfLines = 0;
    _completeLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_completeLabel];
    [_completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSString *string = [NSString cast:viewModel];
    self.completeLabel.text = string;
    CGSize size = [self calculationTextWidthWith:string font:[UIFont fontWithName:kFontNormal size:12.f]];
    double value = ceil(size.width/(ScreenWidth - 40.f));
    if (value == 1) {
        [self.completeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17.f);
        }];
    } else {
        [self.completeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(value*17.f);
        }];
    }
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    CGSize width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}

@end


