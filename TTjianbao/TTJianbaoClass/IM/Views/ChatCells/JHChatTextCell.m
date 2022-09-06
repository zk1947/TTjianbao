//
//  JHChatTextCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatTextCell.h"
#import "YYLabel.h"

@interface JHChatTextCell()
@property (nonatomic, strong) YYLabel *msgLabel;
@end

@implementation JHChatTextCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"IM释放-%@ 释放", [self class]);
}

- (void)setupData {
    @weakify(self)
    [[RACObserve(self.message, attText)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.msgLabel.attributedText = x;
    }];
}
#pragma mark - UI
- (void)setupSubUI {
    [self.messageContent addSubview:self.msgLabel];
}
- (void)layoutViews {
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(contentInset, contentInset, contentInset, contentInset));
    }];
}
- (void)layoutLeftViews {
    
}
- (void)layoutRightViews {
    
}

#pragma mark - LAZY
- (YYLabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[YYLabel alloc] initWithFrame: CGRectZero];
        _msgLabel.numberOfLines = 0;
        _msgLabel.textColor = HEXCOLOR(0x333333);
        _msgLabel.font = [UIFont fontWithName:kFontNormal size:msgLabelFontSize];
        _msgLabel.textAlignment = NSTextAlignmentJustified;
        _msgLabel.userInteractionEnabled = true;
    }
    return _msgLabel;
}
@end
