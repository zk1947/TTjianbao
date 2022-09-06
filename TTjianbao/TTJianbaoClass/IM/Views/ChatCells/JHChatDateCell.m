//
//  JHChatDateCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatDateCell.h"
@interface JHChatDateCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHChatDateCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
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
    [[RACObserve(self.message, dateStr)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.titleLabel.text = x;
    }];
}
#pragma mark - UI
- (void)setupUI {
    self.contentView.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEXCOLOR(0xf5f6fa);
    [self addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
}
#pragma mark - LAZY
- (void)setMessage:(JHMessage *)message {
    _message = message;
    [self setupData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _titleLabel;
}
@end
