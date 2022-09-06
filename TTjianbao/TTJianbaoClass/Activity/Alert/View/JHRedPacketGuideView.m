//
//  JHRedPacketGuideView.m
//  TTjianbao
//
//  Created by apple on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHRedPacketGuideView.h"
#import "JHGrowingIO.h"
#import "UserInfoRequestManager.h"
#import "JHAppAlertViewManger.h"
#import "UIView+Genie.h"

@interface JHRedPacketGuideView ()

@property (nonatomic, weak) UIImageView *avatorView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, strong) JHRedPacketGuideModel *model;

@property (nonatomic, weak) UIImageView *redPacketBg;

///移除红包
@property (nonatomic, copy) dispatch_block_t removeBlock;

@end

@implementation JHRedPacketGuideView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0,0,0,0.5);
        [self addSelfViews];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jhEndEditing)]];
    }
    return self;
}
-(void)jhEndEditing
{
    [[JHRouterManager jh_getViewController].view endEditing:YES];
}

-(void)addSelfViews
{
    UIImageView *imageViewBg = [UIImageView jh_imageViewWithImage:@"red_packet_guide_bg" addToSuperview:self];
    imageViewBg.userInteractionEnabled = YES;
    _redPacketBg = imageViewBg;
    [imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(270, 322));
    }];
    
    UIButton *closeBtn = [UIButton jh_buttonWithImage:@"hud_icon_close" target:self action:@selector(closeMethod:) addToSuperView:self];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageViewBg.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.equalTo(imageViewBg).offset(10);
    }];
    
    /// 直播间头像
    _avatorView = [UIImageView jh_imageViewAddToSuperview:imageViewBg];
    [_avatorView jh_cornerRadius:22];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageViewBg);
        make.top.equalTo(imageViewBg).offset(38.f);
        make.width.height.mas_equalTo(44);
    }];
    
    /// 直播间名字
    _nameLabel = [UILabel jh_labelWithText:@"" font:13 textColor:RGB(255, 233, 191) textAlignment:1 addToSuperView:imageViewBg];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageViewBg);
        make.width.mas_equalTo(240);
        make.top.equalTo(self.avatorView.mas_bottom).offset(6);
    }];

    ///提示标签
    UILabel *label1 = [UILabel jh_labelWithText:@"直播间超级红包" font:25 textColor:RGB(255, 233, 191) textAlignment:1 addToSuperView:imageViewBg];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
        make.centerX.equalTo(imageViewBg);
        make.width.mas_equalTo(240);
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"去直播间抢红包" fontSize:16 textColor:RGB(112, 68, 34) target:self action:@selector(intoRoomVCMethod) addToSuperView:imageViewBg];
    [button jh_cornerRadius:4];
    button.backgroundColor = RGB(247, 213, 148);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageViewBg).offset(-45);
        make.centerX.equalTo(imageViewBg);
        make.size.mas_equalTo(CGSizeMake(193, 44));
    }];
    
    ///提示标签
    UILabel *label2 = [UILabel jh_labelWithText:@"红包由商家提供，金额随机" font:11 textColor:RGBA(255, 255, 255, 0.69) textAlignment:1 addToSuperView:imageViewBg];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageViewBg).offset(-17);
        make.centerX.equalTo(imageViewBg);
        make.width.mas_equalTo(240);
    }];
}

- (void)closeMethod:(UIButton *)sender
{
    sender.hidden = YES;
    [JHAppAlertViewManger switchSuperRedPacketAppear:NO];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.channelLocalId forKey:@"channel_local_id"];
    [params setValue:@"0" forKey:@"is_next"];
    [JHGrowingIO trackEventId:@"super_red_packet_click" variables:params];
    
    [self animalWithType:1];
}

-(void)setModel:(JHRedPacketGuideModel *)model
{
    if(!model)
    {
        return;
    }
    _model = model;
    [_avatorView jh_setAvatorWithUrl:_model.sendCustomerImg];
    _nameLabel.text = _model.channelName;
}

-(void)intoRoomVCMethod
{
    [JHAppAlertViewManger publishChangeTimeIntervalStatus];
    [JHAppAlertViewManger switchSuperRedPacketAppear:YES];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.channelLocalId forKey:@"channel_local_id"];
    [params setValue:@"1" forKey:@"is_next"];
    [JHGrowingIO trackEventId:@"super_red_packet_click" variables:params];
    
    [JHRootController EnterLiveRoom:self.model.channelLocalId fromString:@"redPacketDrainage"];
    if(_removeBlock)
    {
        _removeBlock();
    }
    [self removeFromSuperview];
}

+ (void)showRedPacketGuideWithModel:(JHRedPacketGuideModel *)model removeBlock:(dispatch_block_t)removeBlock
{
    [JHAppAlertViewManger addRedPacketWithId:model.redPacketId];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JHRedPacketGuideView *view = [[JHRedPacketGuideView alloc]initWithFrame:window.bounds];
    [window addSubview:view];
    view.model = model;
    [view animalWithType:2];
    view.removeBlock = removeBlock;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:model.channelLocalId forKey:@"channel_local_id"];
    [JHGrowingIO trackEventId:@"super_red_packet" variables:params];
}


/// 主播不显示
+ (BOOL)isAnchor
{

     User *user = [UserInfoRequestManager sharedInstance].user;
    if((user.blRole_appraiseAnchor)||
       (user.blRole_saleAnchor)||
       user.blRole_communityAndSaleAnchor||
       user.blRole_restoreAnchor ||
       user.blRole_customize ||
       user.blRole_recycle)
    {//这几种主播不显示
        return YES;
    }
    return NO;
}

/// 动画  1-进  2-出
- (void)animalWithType:(NSInteger)type
{
    if(type == 1)
    {
        CGRect frame = [JHAppAlertViewManger getShowSuperRedPacketEnterRect];
        @weakify(self);
        [self.redPacketBg genieInTransitionWithDuration:0.35 destinationRect:frame destinationEdge:BCRectEdgeTop completion:^{
            @strongify(self);
            [self removeFromSuperview];
        }];
        [UIView animateWithDuration:0.34 animations:^{
            self.backgroundColor = RGBA(0, 0, 0, 0);
        }];
    }
    else
    {
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self genieOutTransitionWithDuration:0.35 startRect:[JHAppAlertViewManger getShowSuperRedPacketEnterRect] startEdge:BCRectEdgeTop completion:^{
            
            [UIView animateWithDuration:0.2 animations:^{
                self.backgroundColor = RGBA(0, 0, 0, 0.5);
            }];
        }];
        
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
