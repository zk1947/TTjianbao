//
//  JHNewStoreSearchResultSortCell.m
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultSortCell.h"


@interface JHNewStoreSearchResultSortCell ()
@property (nonatomic, strong) UIImageView *selectIcon;

@end

@implementation JHNewStoreSearchResultSortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectIcon];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
    }];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 9));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        self.titleLabel.font = JHBoldFont(14);
        self.selectIcon.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(32);
        }];
        
    } else {
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.font = JHFont(14);
        self.selectIcon.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
        }];
    }

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = JHFont(14);
    }
    return _titleLabel;
}
- (UIImageView *)selectIcon {
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _selectIcon.image = [UIImage imageNamed:@"newStore_search_selected_icon"];
        _selectIcon.hidden = YES;
    }
    return _selectIcon;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
