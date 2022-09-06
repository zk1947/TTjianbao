//
//  JHSQRcmdPlateCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQRcmdPlateCell.h"
#import "JHSQRcmdPlatePanel.h"
#import "YYControl.h"

@interface JHSQRcmdPlateCell ()
@property (nonatomic, strong) UILabel *titleLabel; //你可能感兴趣的人
@property (nonatomic, strong) JHSQRcmdPlatePanel *panel;
///查看更多相关
@property (nonatomic, strong) YYControl *morePanel;
@property (nonatomic, strong) UIImageView *moreImageView;
@end

@implementation JHSQRcmdPlateCell

+ (CGFloat)cellHeight {
//    return 134.0;
    return 97.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_panel) {
        _panel = [[JHSQRcmdPlatePanel alloc] initWithFrame:CGRectZero];
        _panel.pageType = self.pageType;
        [self.contentView addSubview:_panel];
    }
    
    if (!_morePanel) {
        _morePanel = [[YYControl alloc] init];
        _morePanel.backgroundColor = kColorF5F6FA;
        _morePanel.sd_cornerRadius = @(8.f);
        _morePanel.exclusiveTouch = YES;
        [self.contentView addSubview:_morePanel];
        @weakify(self);
        _morePanel.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_channel_more_enter" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    [JHNotificationCenter postNotificationName:kSQNeedSwitchToPlateTabNotication object:nil];
                }
            }
        };
        
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"community_icon_home_more"]];
        _moreImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_morePanel addSubview:_moreImageView];
        NSString *str = @"查看更多";
        CGFloat labelHeight = 11.f;
        for (int i = 0; i < str.length; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = [str substringWithRange:NSMakeRange(i, 1)];
            label.textColor = kColor333;
            label.font = [UIFont fontWithName:kFontNormal size:10.f];
            label.textAlignment = NSTextAlignmentCenter;
            [_morePanel addSubview:label];
            
            label.sd_layout
            .leftEqualToView(_morePanel)
            .rightEqualToView(_morePanel)
            .topSpaceToView(_moreImageView, 4+i*labelHeight)
            .heightIs(labelHeight);
        }
    }
    
    //布局
    _morePanel.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 10)
    .widthIs(30.f);
    
    _moreImageView.sd_layout
    .leftSpaceToView(_morePanel, 9)
    .rightSpaceToView(_morePanel, 9)
    .topSpaceToView(_morePanel, 9)
    .heightEqualToWidth();
    
    _panel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 10, 40));
}

- (void)setPlateList:(NSMutableArray<JHPlateListData *> *)plateList {
    if (!plateList) return;
    
    _plateList = plateList;
    _panel.plateList = plateList;
}

@end
