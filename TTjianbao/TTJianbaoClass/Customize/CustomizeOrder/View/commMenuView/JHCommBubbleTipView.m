//
//  JHCommBubbleTipView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommBubbleTipView.h"
#import "JHCommMenuCell.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"
#import "UIImage+JHColor.h"
@interface JHCommBubbleTipView ()

@property(nonatomic,strong)UIView *shadeView;
@end

@implementation JHCommBubbleTipView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
       // self.backgroundColor = HEXCOLORA(0xffffff, 0);
          self.backgroundColor = [UIColor clearColor];
        
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    [JHKeyWindow insertSubview:self.shadeView belowSubview:self];
    
    [self addSubview:self.bgImageView];
   // _bgImageView.backgroundColor = [UIColor redColor];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@216);
        make.height.equalTo(@73);
    }];
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).offset(5);;
        make.right.equalTo(_bgImageView).offset(-5);
        make.centerY.equalTo(_bgImageView).offset(-5);
    }];
}
-(void)creatSendOrderBubble{
    
     //TODO jiang  时间太紧 待优化整合
    _bgImageView.image =[UIImage imageNamed:@"sendorder_customize_bubble"];
    [_bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@216);
        make.height.equalTo(@73);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).offset(10);;
        make.right.equalTo(_bgImageView).offset(-5);
        make.centerY.equalTo(_bgImageView).offset(-5);
    }];
    self.titleLabel.text = @"选择‘是’：①宝友支付后，会绑定定制轻加工服务，不支持退换；②️在个人中心-定制服务中可查看/添加成品等信息";
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:3];
    _titleLabel.preferredMaxLayoutWidth = 216;
    
}
-(void)creatTTCustomizeBubble{
    
    [self.shadeView removeFromSuperview];
    self.shadeView = nil;
    
    _bgImageView.image =[UIImage imageNamed:@"customize_guide_tt_bubble"];
    _bgImageView.userInteractionEnabled = YES;
    [_bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@252);
        make.height.equalTo(@50);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).offset(15);;
        make.centerY.equalTo(_bgImageView).offset(3);
    }];
    self.titleLabel.text = @"首创文玩连麦定制服务";
    _titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
    _titleLabel.textColor = kColor333;
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:3];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    button.titleLabel.font= [UIFont fontWithName:kFontMedium size:12];
    button.layer.cornerRadius = 19.0;
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(57, 28) radius:19];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
   
    [_bgImageView addSubview:button];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgImageView).offset(-15);;
        make.centerY.equalTo( self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(57, 28));
    }];
    
}
-(void)creatSellMarketBubble{
    
    [self.shadeView removeFromSuperview];
    self.shadeView = nil;
    
    _bgImageView.image =[UIImage imageNamed:@"customize_guide_live_cell_bubble"];
    _bgImageView.userInteractionEnabled = YES;
    [_bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@239);
        make.height.equalTo(@50);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).offset(15);;
        make.centerY.equalTo(_bgImageView).offset(-3);
    }];
    self.titleLabel.text = @"打开直播间开启定制之旅";
    _titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
    _titleLabel.textColor = kColor333;
    [UILabel changeLineSpaceForLabel:self.titleLabel WithSpace:3];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    button.titleLabel.font= [UIFont fontWithName:kFontMedium size:12];
    button.layer.cornerRadius = 19.0;
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(57, 28) radius:19];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
   
    [_bgImageView addSubview:button];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgImageView).offset(-15);;
        make.centerY.equalTo( self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(57, 28));
    }];
    
}
-(UIView *)shadeView
{
    if(!_shadeView)
    {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _shadeView.backgroundColor = [UIColor clearColor];
        _shadeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
        [_shadeView  addGestureRecognizer:tap];
    }
    return _shadeView;
}
-(UIImageView *)bgImageView
{
    if(!_bgImageView)
    {
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        //_bgImageView.backgroundColor = [UIColor redColor];
        _bgImageView.image =[UIImage imageNamed:@"customize_detail_payInfo_paopao"];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont systemFontOfSize:10];
        _titleLabel.textColor = kColor666;
        _titleLabel.numberOfLines = 0;
      //  _titleLabel.preferredMaxLayoutWidth = 216;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
       
    }
    return _titleLabel;
}

-(void)disMiss{
    
    [self.shadeView removeFromSuperview];
    [self removeFromSuperview];
    
}
-(void)buttonPress{
    if (self.clickHandle) {
        self.clickHandle();
    }
}
- (void)dealloc
{
    NSLog(@"JHCommBubbleTipView_dealloc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
