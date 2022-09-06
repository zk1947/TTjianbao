//
//  JHSQRcmdPlatePanelCCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQRcmdPlatePanelCCell.h"
#import "JHPlateListModel.h"
#import "YYControl.h"
#import "JHSQManager.h"

@interface JHSQRcmdPlatePanelCCell ()

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHSQRcmdPlatePanelCCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //1
        _contentControl = [YYControl new];
        _contentControl.backgroundColor = [UIColor whiteColor];
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    //进入版块主页
                    [JHRouterManager pushPlateDetailWithPlateId:self.curData.channel_id pageType:self.pageType];
                    [JHGrowingIO trackPublicEventId:@"recommend_channel_enter" paramDict:self.curData.mj_keyValues];
                }
            }
        };
        
        //2
        _iconView = [UIImageView new];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.sd_cornerRadius = @8;
        [_contentControl addSubview:_iconView];
        
        //3
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor333];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentControl addSubview:_titleLabel];
        
        //布局
        _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        _iconView.sd_layout
        .topSpaceToView(_contentControl, 10)
        .centerXEqualToView(_contentControl)
        .widthRatioToView(_contentControl, 1)
        .heightEqualToWidth();
        
        _titleLabel.sd_layout
        .topSpaceToView(_iconView, 5)
        .centerXEqualToView(_contentControl)
        .widthRatioToView(_contentControl, 1)
        .bottomEqualToView(_contentControl);
    }
    return self;
}

- (void)setCurData:(JHPlateListData *)curData {
    if (!curData) return;
    _curData = curData;
    
    [_iconView jhSetImageWithURL:[NSURL URLWithString:curData.image] placeholder:kDefaultCoverImage];
    
    _titleLabel.text = curData.channel_name;
}

@end
