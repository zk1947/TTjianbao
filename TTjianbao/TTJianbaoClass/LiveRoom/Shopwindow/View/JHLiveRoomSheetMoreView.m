//
//  JHLiveRoomSheetMoreView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomSheetMoreView.h"

@interface JHLiveRoomSheetButtonView : UIView

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation JHLiveRoomSheetButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _imageView = [UIImageView jh_imageViewAddToSuperview:self];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
            make.height.mas_equalTo(28);
        }];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
         
        _titleLabel = [UILabel jh_labelWithText:@"" font:11 textColor:RGB102102102 textAlignment:1 addToSuperView:self];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(15);
            make.centerX.equalTo(self.imageView);
        }];
    }
    return self;
}

+ (JHLiveRoomSheetButtonView *)creatButtonViewWithTitle:(NSString *)title icon:(NSString *)icon ToSuperview:(UIView *)sender {
    
    JHLiveRoomSheetButtonView *view = [JHLiveRoomSheetButtonView new];
    [sender addSubview:view];
    view.titleLabel.text = title;
    view.imageView.image = JHImageNamed(icon);
    return view;
}

@end


@implementation JHLiveRoomSheetMoreView

- (void)dealloc {
    NSLog(@"🔥 JHLiveRoomSheetMoreView");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        @weakify(self);
        [self jh_addTapGesture:^{
            @strongify(self);
            [self dissmiss];
        }];
    }
    return self;
}

-(void)setAuctionHidden:(BOOL)auctionHidden
{
    _auctionHidden = auctionHidden;

    self.bottomAnimationViewHeight = 135 + UI.bottomSafeAreaHeight;
    if (self.audienceType == CurrentAudienceTypeRecycle){
        self.bottomAnimationViewHeight = 206 + UI.bottomSafeAreaHeight;
    }
    
    UIView *whiteView = self.bottomAnimationView;
    [whiteView jh_cornerRadius:12 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:CGRectMake(0, 0, ScreenW, self.bottomAnimationViewHeight)];
    
    UILabel *tipLabel = [UILabel jh_labelWithText:@"更多功能" font:15 textColor:UIColor.blackColor textAlignment:1 addToSuperView:whiteView];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(15);
        make.centerX.equalTo(whiteView);
    }];
    
    @weakify(self);
    JHLiveRoomSheetButtonView *adviseView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"投诉建议" icon:@"live_room_advice" ToSuperview:self];
    adviseView.hidden = YES;
    [adviseView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:2];
    }];
    
    JHLiveRoomSheetButtonView *helperView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"平台电话客服" icon:@"live_room_helper" ToSuperview:self];
    helperView.hidden = YES;
    [helperView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:4];
    }];
    
    JHLiveRoomSheetButtonView *sendRedPacketView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"发红包" icon:@"live_room_redpacket" ToSuperview:self];
    sendRedPacketView.hidden = YES;
    [sendRedPacketView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:1];
    }];
    JHLiveRoomSheetButtonView *auctionView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"竞拍" icon:@"live_room_buy" ToSuperview:self];
    auctionView.hidden = YES;
    [auctionView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:0];
    }];
    JHLiveRoomSheetButtonView *contactPlatformView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"在线客服" icon:@"live_room_contactPlatform" ToSuperview:self];
    contactPlatformView.hidden = YES;
    [contactPlatformView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:3];
    }];
    JHLiveRoomSheetButtonView *shareView = [JHLiveRoomSheetButtonView creatButtonViewWithTitle:@"分享" icon:@"live_room_sheetshare" ToSuperview:self];
    shareView.hidden = YES;
    [shareView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:5];
    }];
    NSArray *array = nil;
    NSInteger num = 1;
    
    if (self.audienceType == CurrentAudienceTypeCustom)
    {//定制
        contactPlatformView.hidden = NO;
        helperView.hidden = NO;
        sendRedPacketView.hidden = NO;
        adviseView.hidden = NO;
        array = @[contactPlatformView,helperView,sendRedPacketView, adviseView];
        num = 20;
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(60);
            make.height.mas_equalTo(50);
        }];
        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:num tailSpacing:num];
    }else if (self.audienceType == CurrentAudienceTypeRecycle){
        NSArray *array = nil;
        NSArray *array2 = nil;
        contactPlatformView.hidden = NO;
        helperView.hidden = NO;
        sendRedPacketView.hidden = NO;
        adviseView.hidden = NO;
        UIView * view = [[UIView alloc] init];
        [self addSubview:view];
        UIView * view1 = [[UIView alloc] init];
        [self addSubview:view1];
        
        if(_auctionHidden){
            UIView * view2 = [[UIView alloc] init];
            [self addSubview:view2];
            array = @[contactPlatformView, helperView, adviseView,sendRedPacketView];
            array2 = @[shareView,view,view1,view2];
        }else{
            auctionView.hidden = NO;
            shareView.hidden = NO;
            array = @[auctionView,contactPlatformView, helperView, adviseView];
            array2 = @[sendRedPacketView,shareView,view,view1];
        }
        
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(60);
            make.height.mas_equalTo(50);
        }];
        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:num tailSpacing:num];
        
        [array2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(130);
            make.height.mas_equalTo(50);
        }];
        [array2 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:num tailSpacing:num];
    }
    else
    {
        if(_auctionHidden)
        {
            helperView.hidden = NO;
            sendRedPacketView.hidden = NO;
            adviseView.hidden = NO;
            array = @[sendRedPacketView, helperView, adviseView];
            num = 20;
        }
        else
        {
            auctionView.hidden = NO;
            helperView.hidden = NO;
            sendRedPacketView.hidden = NO;
            adviseView.hidden = NO;
            array = @[auctionView, sendRedPacketView, helperView, adviseView];
        }
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(60);
            make.height.mas_equalTo(50);
        }];
        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:num tailSpacing:num];
    }
    
}

- (void)didSelected:(NSUInteger)index
{
    if(IS_LOGIN){
       if(_clickBlock)
       {
           _clickBlock(index);
       }
    }
    [self dissmiss];
}

+ (void)showSheetViewWithAuctionHidden:(BOOL)hidden isCustomizeAudience:(CurrentAudienceType)audienceType text:(NSString *)text block:(void (^)(NSInteger))clickBlock
{
    JHLiveRoomSheetMoreView *sheetView = [[JHLiveRoomSheetMoreView alloc] initWithFrame:JHKeyWindow.bounds];
    sheetView.clickBlock = clickBlock;
    sheetView.audienceType = audienceType;
    sheetView.auctionHidden = hidden;
    [JHKeyWindow addSubview:sheetView];
    [sheetView show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
