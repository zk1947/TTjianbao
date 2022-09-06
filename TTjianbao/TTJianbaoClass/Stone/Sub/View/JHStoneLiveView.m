//
//  JHStoneLiveView.m
//  TTjianbao
//
//  Created by jiang on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
#import "JHStoneLiveView.h"

@interface JHStoneLiveView ()
@property(nonatomic, strong)  UIView * titleView;
@property(nonatomic, strong)  UILabel * title;
@property(nonatomic, strong)  UIView * bottomBar;
@property(nonatomic, strong)  UILabel * resaleNum;
@property(nonatomic, strong) UILabel * waitNum;
@property(nonatomic, strong)  UIView * contentView;
@end

@implementation JHStoneLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 2;
        self.layer.masksToBounds=YES;
        self.layer.borderColor = [[CommHelp toUIColorByStr:@"#ffffff"] colorWithAlphaComponent:1].CGColor;
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
        [self addGestureRecognizer:tap];
        
        [self setupSubviews];
        
    }
    return self;
}
-(void)setupSubviews{
    
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _titleView = [[UIView alloc]init];
    _titleView.backgroundColor = kColorMain;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 66, 22) byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    _titleView.layer.mask = maskLayer;
    
    [self addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 22));
        make.top.left.offset(0);
    }];
    
    _title = [[UILabel alloc] init];
    _title.numberOfLines =1;
    _title.textAlignment = NSTextAlignmentCenter;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    _title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    _title.text = @"回血直播间";
    _title.font=[UIFont systemFontOfSize:11];
    [_titleView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_titleView);
    }];
    
    _bottomBar = [[UIView alloc]init];
    _bottomBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self addSubview:_bottomBar];
    [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.bottom.left.right.offset(0);
    }];
    
    _resaleNum= [[UILabel alloc] init];
    _resaleNum.numberOfLines =1;
    _resaleNum.textAlignment = NSTextAlignmentCenter;
    _resaleNum.lineBreakMode = NSLineBreakByWordWrapping;
    _resaleNum.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    _resaleNum.text = @"13件寄售";
    _resaleNum.font=[UIFont systemFontOfSize:10];
    [_bottomBar addSubview:_resaleNum];
    [_resaleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomBar);
        make.left.offset(0);
        make.width.offset(110/2.);
    }];
    
    _waitNum= [[UILabel alloc] init];
    _waitNum.numberOfLines =1;
    _waitNum.textAlignment = NSTextAlignmentCenter;
    _waitNum.lineBreakMode = NSLineBreakByWordWrapping;
    _waitNum.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    _waitNum.text = @"8人排队";
    _waitNum.font=[UIFont systemFontOfSize:10];
    [_bottomBar addSubview:_waitNum];
    [_waitNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomBar);
        make.right.offset(0);
        make.width.offset(110/2.);
    }];
}
-(void)setStoneChannel:(StoneChannelMode *)stoneChannel{
    _stoneChannel=stoneChannel;
    [[JHLivePlayerManager sharedInstance] startPlay:_stoneChannel.rtmpPullUrl inView:self.contentView andTimeEndBlock:^{
    }];
    _resaleNum.text =[NSString stringWithFormat:@"%zd件寄售",_stoneChannel.saleCount];
    _waitNum.text =[NSString stringWithFormat:@"%zd人排队",_stoneChannel.seekCount];
    if ([_stoneChannel.channelCategory isEqualToString:@"roughOrder"]) {
        _title.text = @"原石直播间";
        _titleView.backgroundColor = kColorMain;
        _bottomBar.hidden=YES;
         _title.textColor=kColor333;
    }
    else{
        _title.text = @"回血直播间";
        _titleView.backgroundColor = kColorMainRed;
        _bottomBar.hidden=NO;
        _title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    }
    
}
-(void)onTapView:(UITapGestureRecognizer*)tap{
    
    [JHRootController EnterLiveRoom:self.stoneChannel.channelId fromString:@""];
}
@end
