//
//  JHArbitramentListCell.m
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHArbitramentListCell.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHArbitramentListCell ()
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation JHArbitramentListCell

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = [title isNotBlank] ? title : @"";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    /// ※号
    _starLabel = [UILabel jh_labelWithFont:13. textColor:HEXCOLOR(0xFF4200) addToSuperView:self.contentView];
    _starLabel.text = @"*";
    ///左侧标题
    _titleLabel = [UILabel jh_labelWithFont:13. textColor:HEXCOLOR(0x222222) addToSuperView:self.contentView];
    
    _selectButton = [UIButton jh_buttonWithImage:[UIImage imageNamed:@"goods_collect_list_icon_shop_arrow"] target:self action:@selector(selectActionEvent) addToSuperView:self.contentView];
    [_selectButton setTitle:@"请选择" forState:UIControlStateNormal];
    [_selectButton setTitleColor:kColor333 forState:UIControlStateNormal];
    _selectButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
    
    [_starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starLabel.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_selectButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];

    [_selectButton layoutIfNeeded];
    [_selectButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
}

+ (CGFloat)cellHeight {
    return 39.f;
}

- (void)selectActionEvent {
    !self.actionBlock ?: self.actionBlock();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
