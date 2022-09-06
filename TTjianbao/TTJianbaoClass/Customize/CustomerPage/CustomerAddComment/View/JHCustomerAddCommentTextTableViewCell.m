//
//  JHCustomerAddCommentTextTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAddCommentTextTableViewCell.h"
#import "UITextView+PlaceHolder.h"
#import "UIView+Toast.h"

@interface JHCustomerAddCommentTextTableViewCell ()<UITextViewDelegate>

@end

@implementation JHCustomerAddCommentTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _textView               = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-30.f, 225.f)];
    _textView.delegate      = self;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font          = [UIFont fontWithName:kFontNormal size:16.f];
    _textView.placeholder   = @"为了服务流程更加顺利，清准确、清楚的描述您的问题";
    _textView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
//        make.height.mas_equalTo(48.f);
        make.height.mas_greaterThanOrEqualTo(48.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
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
    /// 只要前140个字
    if (textView.text.length > 140) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 140)];
    }    
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(ScreenW - 20.f, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                               NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                               NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16.5f]
                                           } context:nil].size;
    if (size.height >= 48.f) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(size.height);
        }];
    } else {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(48.f);
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

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        [self.contentView makeToast:@"请输入描述问题" duration:1.0 position:CSToastPositionCenter];
    }
    if (self.textBlock) {
        self.textBlock();
    }
}


@end
