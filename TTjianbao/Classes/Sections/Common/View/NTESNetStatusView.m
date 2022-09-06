//
//  NTESNetStatusView.m
//  TTjianbao
//
//  Created by chris on 2016/11/16.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESNetStatusView.h"
#import "UIView+NTES.h"
#import "NTESLiveManager.h"

@interface NTESNetStatusView()

@property (nonatomic,copy)   NSDictionary *netcallInfo;

@property (nonatomic,strong) UIImageView  *statusImageView;

@property (nonatomic,strong) UILabel *statusTextLabel;

@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation NTESNetStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 13)];
        [self addSubview:_statusImageView];
        
        _statusTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusTextLabel.font = [UIFont systemFontOfSize:13.f];
        _statusTextLabel.textColor = [UIColor whiteColor];
        [self addSubview:_statusTextLabel];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:12.f];
        _tipLabel.textColor = [UIColor whiteColor];
        [self addSubview:_tipLabel];

        
//        _netcallInfo = @{
//                         @(NIMNetCallNetStatusVeryGood) : @{@"icon":@"icon_netstatus_verygood",@"status":@"网络通畅:"},
//                         @(NIMNetCallNetStatusGood)     : @{@"icon":@"icon_netstatus_good",    @"status":@"网络正常:"},
//                         @(NIMNetCallNetStatusBad)      : @{@"icon":@"icon_netstatus_bad",     @"status":@"网络较差:"},
//                         @(NIMNetCallNetStatusVeryBad)  : @{@"icon":@"icon_netstatus_verybad", @"status":@"网络极差:"},
//                        };
        
    }
    return self;
}

- (void)refresh:(NIMNetCallNetStatus)status
{
//    NSDictionary *netcall = _netcallInfo[@(status)];
//    NSString *icon   = netcall[@"icon"];
//    NSString *statusTip = netcall[@"status"];
//    self.statusImageView.image = [UIImage imageNamed:icon];
//    self.statusTextLabel.text = statusTip;
//    
//    self.tipLabel.text = [self showTip:status];
}


static NSInteger statusAndIconGap = 2.f;

- (CGSize)sizeThatFits:(CGSize)size
{
    [self.tipLabel sizeToFit];
    [self.statusTextLabel sizeToFit];
    CGFloat width = self.statusTextLabel.width + statusAndIconGap + self.statusImageView.width;
    width = width < self.tipLabel.width? : self.tipLabel.width;
    
    CGFloat statusAndTipGap = 8.f;
    CGFloat height = self.statusTextLabel.height + statusAndTipGap + self.tipLabel.height;
    
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.statusTextLabel.width + statusAndIconGap + self.statusImageView.width;
    self.statusTextLabel.left   = (self.width - width) * .5f;
    self.statusImageView.right  = (self.width + width) * .5f;
    self.statusImageView.centerY = self.statusTextLabel.centerY;
    
    self.tipLabel.centerX = self.width * 5.f;
    self.tipLabel.bottom  = self.height;
}


- (NSString *)showTip:(NIMNetCallNetStatus)status
{
    if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeVideo) {
        switch (status) {
            case NIMNetCallNetStatusBad:
                if ([NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityHigh) {
                    return @"建议降低直播清晰度";
                }
                break;
//            case NIMNetCallNetStatusVeryBad:
//                return @"建议切换为音频直播";
            default:
                break;
        }
    }
    return nil;
}

@end
