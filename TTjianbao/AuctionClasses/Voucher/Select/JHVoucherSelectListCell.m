//
//  JHVoucherSelectListCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherSelectListCell.h"
#import "YYControl.h"

@interface JHVoucherSelectListCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *checkedIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JHVoucherSelectListCell

+ (CGFloat)cellHeight {
    return 38;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyleEnabled = NO;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    @weakify(self);
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    [self __handleClickEvent];
                }
            }
        };
    }
    
    if (!_checkedIcon) {
        _checkedIcon = [UIImageView new];
        _checkedIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_contentControl addSubview:_checkedIcon];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14] textColor:kColor333];
        [_contentControl addSubview:_titleLabel];
    }
    
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = kColorCellLine;
        [_contentControl addSubview:_bottomLine];
    }
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _checkedIcon.sd_layout
    .centerYEqualToView(_contentControl)
    .leftSpaceToView(_contentControl, 15)
    .widthIs(13).heightEqualToWidth();
    
    _titleLabel.sd_layout
    .centerYEqualToView(_contentControl)
    .leftSpaceToView(_checkedIcon, 10)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(30);
    
    _bottomLine.sd_layout
    .leftSpaceToView(_contentControl, 15)
    .rightSpaceToView(_contentControl, 15)
    .bottomEqualToView(_contentControl)
    .heightIs(0.5);
}

- (void)setCurData:(JHVoucherListData *)curData {
    _curData = curData;
    [self __updateCheckedIcon];
    _titleLabel.text = curData.name;
}

#pragma mark -
#pragma mark - 点击事件
- (void)__handleClickEvent {
    _curData.checkedStatus = !_curData.checkedStatus;
    [self __updateCheckedIcon];
    
    if (self.cellClickBlock) {
        self.cellClickBlock(self, _curData);
    }
}

- (void)__updateCheckedIcon {
    UIImage *icon = [UIImage imageNamed:(_curData.checkedStatus ? @"voucher_icon_checked_selected" : @"voucher_icon_checked_normal")];
    _checkedIcon.image = icon;
}

@end
