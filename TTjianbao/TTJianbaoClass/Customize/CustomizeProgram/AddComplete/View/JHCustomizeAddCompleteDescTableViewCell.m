//
//  JHCustomizeAddCompleteDescTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddCompleteDescTableViewCell.h"
//#import "UITextView+PlaceHolder.h"
//#import "UIView+Toast.h"
//#import "YYTextView.h"

@interface JHCustomizeAddCompleteDescTableViewCell ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel    *placeHolderLabel;
@end

@implementation JHCustomizeAddCompleteDescTableViewCell

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
    
    
    _textView                  = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-40.f, 20.f)];
    _textView.delegate         = self;
    _textView.textAlignment    = NSTextAlignmentLeft;
    _textView.font             = [UIFont fontWithName:kFontNormal size:12.f];
    _textView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);;
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
 
    _placeHolderLabel               = [[UILabel alloc] init];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _placeHolderLabel.textColor     = HEXCOLOR(0x999999);
    _placeHolderLabel.text          = @"在此输入完成说明";
    [self.contentView addSubview:_placeHolderLabel];
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left).offset(4.f);
        make.centerY.equalTo(self.textView.mas_centerY).offset(-1.f);
        make.height.mas_equalTo(20.f);
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0 ) {
        self.placeHolderLabel.text   =  @"请输入您的作品简述，便于用户了解";
        self.placeHolderLabel.hidden = NO;
        [_placeHolderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.textView.mas_centerY);
        }];
    } else {
        self.placeHolderLabel.text   = @"";
        self.placeHolderLabel.hidden = YES;
    }
    /// 只要前50个字
    if (textView.text.length > 100) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
    }
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(ScreenW - 40.f, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                               NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                               NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16.5f]
                                           } context:nil].size;
    if (size.height >= 20.f) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
    } else {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20.f);
        }];
    }
    [[self tableView] beginUpdates];
    [[self tableView] endUpdates];
}

- (UITableView *)tableView {
  UIView *tableView = self.superview;
  while (![tableView isKindOfClass:[UITableView class]] && tableView) {
    tableView = tableView.superview;
  }
  return (UITableView *)tableView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length == 100 && range.length == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)checkTextViewIsLegal {
    if (self.textView.text.length < 1) {
        return NO;
    }
    return YES;
}

- (NSString *)getDescString {
    return self.textView.text;
}


@end
