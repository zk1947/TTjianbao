//
//  UITitleValueMoreCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITitleValueMoreCell.h"

@interface UITitleValueMoreCell ()
@property (nonatomic, strong) UILabel *titleLabel, *valueLabel;
@end

@implementation UITitleValueMoreCell

+ (CGFloat)cellHeight {
    return 44.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyleEnabled = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_arrow"]];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColor333];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_valueLabel) {
        _valueLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor333];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
    }
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .heightIs(30).autoWidthRatio(0);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _valueLabel.sd_layout
    .leftSpaceToView(_titleLabel, 0)
    .rightSpaceToView(self.accessoryView, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(44);
}

- (void)setTitle:(NSString *)title value:(NSString * _Nullable)value placeholder:(NSString * _Nullable)placeholder {
    _titleLabel.text = [title isNotBlank] ? title : @"";
    _valueLabel.text = [value isNotBlank] ? value : placeholder;
    _valueLabel.textColor = [value isNotBlank] ? kColor333 : kColor999;
}

@end
