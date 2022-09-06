//
//  YDActionSheetCell.m
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/29.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "YDActionSheetCell.h"
#import "YDActionSheetUtil.h"
#import "TTjianbaoHeader.h"

@interface YDActionSheetCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIVisualEffectView *blurBgView;;
@property (nonatomic, strong) UIVisualEffectView *blurSelectedView;

@end


@implementation YDActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景高亮模糊
        if (!_blurBgView) {
            _blurBgView = [YDActionSheetUtil yd_blurWithFrame:CGRectMake(0, 0, ScreenWidth, YD_ASCellH) style:UIBlurEffectStyleExtraLight];
            [self.contentView addSubview:_blurBgView];
        }
        
        //选中模糊效果
        if (!_blurSelectedView) {
            _blurSelectedView = [YDActionSheetUtil yd_blurWithFrame:CGRectMake(0, 1, ScreenWidth, YD_ASCellH-2) style:UIBlurEffectStyleLight];
            _blurSelectedView.backgroundColor = [UIColor colorWithHexStr:@"999999" alpha:0.5];
            self.selectedBackgroundView = _blurSelectedView;
        }
        
        if (!_titleLabel) {
            _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:17.0] textColor:[UIColor blackColor]];
            _titleLabel.frame = CGRectMake(0, 5, ScreenWidth, YD_ASCellH-10);
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_titleLabel];
        }
        
        if (!_topLine) {
            _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            UIVisualEffectView *blur = [YDActionSheetUtil yd_blurWithFrame:_topLine.bounds style:UIBlurEffectStyleLight];
            blur.backgroundColor = kColor666;
            [_topLine addSubview:blur];
            [self.contentView addSubview:_topLine];
        }
    }
    return self;
}

- (void)setTitleStr:(NSString *)title isDestructive:(BOOL)isDestructive showTopLine:(BOOL)isShow {
    _titleLabel.text = title;
    _topLine.hidden = !isShow;
    _titleLabel.textColor = isDestructive ? [UIColor colorWithHexString:@"f10040"] : [UIColor blackColor];
}

- (void)setIsCancel:(BOOL)isCancel {
    _isCancel = isCancel;
    if (isCancel) {
        _blurBgView.height = YD_ASCellH + UI.bottomSafeAreaHeight;
        _blurSelectedView.height = YD_ASCellH + UI.bottomSafeAreaHeight - 2;
    } else {
        _blurBgView.height = YD_ASCellH;
        _blurSelectedView.height = YD_ASCellH - 2;
    }
}

@end
