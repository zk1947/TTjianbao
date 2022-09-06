//
//  UITitleInputCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITitleInputCell.h"

@interface UITitleInputCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIInputTextField *textField;
@end

@implementation UITitleInputCell

+ (CGFloat)cellHeight {
    return 44.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyleEnabled = NO;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColor333];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_textField) {
        _textField = [UIInputTextField new];
        [_textField setFont:[UIFont fontWithName:kFontNormal size:12]];
        [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_textField];
    }
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .heightIs(30).autoWidthRatio(0);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _textField.sd_layout
    .leftSpaceToView(_titleLabel, 0)
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .heightIs(44);
}

- (void)setTitle:(NSString *)title value:(NSString * _Nullable)value placeholder:(NSString * _Nullable)placeholder {
    _titleLabel.text = title;
    
    _textField.attributedText = [[NSAttributedString alloc] initWithString:([value isNotBlank]?value:@"") attributes:@{NSForegroundColorAttributeName:kColor333}];
    
    _textField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:(placeholder?placeholder:@"")
                                    attributes:@{NSForegroundColorAttributeName:kColor999,
                                                 NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12]}];
}


#pragma mark -
#pragma mark - TextField
- (void)textValueChanged:(id)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(_textField.text);
    }
}

@end
