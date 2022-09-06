//
//  JHChatImageCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatImageCell.h"
@interface JHChatImageCell()
@property (nonatomic, strong) UIImageView *bgIcon;
@property (nonatomic, strong) UIImageView *msgImageView;
@end
@implementation JHChatImageCell
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
    [[RACObserve(self.message, thumImage)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil || ![x isKindOfClass:[UIImage class]]) return;
        self.msgImageView.image = x;
        [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.message.width);
        }];
    }];
    [[RACObserve(self.message, thumUrl)
      takeUntil: self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return ;
        if ([x hasPrefix:@"http"]) {
            [self.msgImageView jh_setImageWithUrl:x];
        }else {
            NSURL *url = [NSURL fileURLWithPath:x];
            [self.msgImageView jhSetImageWithURL:url];
        }
        
        [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.message.width);
        }];
    }];
}
#pragma mark - UI
- (void)setupUI {
    
    [self.messageContent addSubview:self.bgIcon];
    [self.messageContent addSubview:self.msgImageView];
}
- (void)layoutViews {
    self.messageContent.backgroundColor = HEXCOLOR(0xf8f8f8);
    [self.bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(46, 37));
    }];
    [self.msgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - LAZY
- (UIImageView *)msgImageView {
    if (!_msgImageView) {
        _msgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _msgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_msgImageView jh_cornerRadius:8];
    }
    return _msgImageView;
}
- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgIcon.image = [UIImage imageNamed:@"IM_placeholder_icon"];
    }
    return _bgIcon;
}
@end
