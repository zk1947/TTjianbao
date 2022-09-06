//
//  JHStoreHomeRcmdCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  add by wuyd - 不要随意修改！！
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeRcmdCell.h"
#import "YYControl.h"
#import "CStoreHomeListModel.h"


@interface JHStoreHomeRcmdCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) JHStoreHomeRcmdPanel *panel;

@end


@implementation JHStoreHomeRcmdCell

@synthesize indexPath = _indexPath;

+ (CGFloat)cellHeight {
    CGFloat cellH = ceilf((ScreenWidth-20) / bgRatio) + 10;
    return cellH;
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
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.backgroundColor = [UIColor whiteColor];
        _contentControl.layer.cornerRadius = 4;
        _contentControl.clipsToBounds = YES;
        _contentControl.contentMode = UIViewContentModeScaleAspectFill;
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
    }
    
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        [_contentControl addSubview:_bgImgView];
    }
    
    if (!_panel) {
        _panel = [[JHStoreHomeRcmdPanel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_panel];
    }
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 10, 10));
    
    _bgImgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _panel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(JHScaleToiPhone6(98), 10, 10, 10));
}

- (void)setCurData:(CStoreHomeListData *)curData {
    if (!curData) return;
    _curData = curData;
    [_bgImgView jhSetImageWithURL:[NSURL URLWithString:_curData.head_img] placeholder:nil];
    
    _panel.curData = curData;
}

- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, isLastCell?0:10, 10));
    _panel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(JHScaleToiPhone6(98), 10, isLastCell?0:10, 10));
    
    [_contentControl updateLayout];
    [_panel updateLayout];
}

//Fix：横向滑动ccView联动问题
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _panel.indexPath = indexPath;
}

@end
