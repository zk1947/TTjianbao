//
//  HomeTableViewHeader.m
//  TTjianbao
//
//  Created by jiangchao on 2018/11/27.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "HomeTableViewHeader.h"
#import "SDCycleScrollView.h"
#import "BannerMode.h"
#import "TTjianbaoHeader.h"
#import "UIButton+ImageTitleSpacing.h"

#define circlerate (float)440/750
@interface HomeTableViewHeader ()<SDCycleScrollViewDelegate>
{
    float scrollViewimageRate;
    UIView * buttonsView;
}
@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end
@implementation HomeTableViewHeader
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor=[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=[UIColor clearColor];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        
        NSArray *imagesURLStrings = @[
                                      @"",
                                      ];
    
        [self initCycleScrollView:imagesURLStrings];
        [self initButtonsView];
    
    }
    return self;
}

-(void)initCycleScrollView:(NSArray*)arr{
    
    _cycleScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,ScreenW,circlerate*ScreenW)  delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval=3;
    _cycleScrollView. infiniteLoop=YES;
    _cycleScrollView.imageURLStringsGroup=arr;
    _cycleScrollView.backgroundColor=[UIColor clearColor];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView addSubview:_cycleScrollView];
    
}

-(void)initButtonsView{
    
    buttonsView=[[UIView alloc]init];
    buttonsView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:buttonsView];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(0);
        make.right.equalTo(self).offset(0);
        make.width.offset(ScreenW);
        make.bottom.equalTo(self.contentView);
    }];
    
    return;
    UILabel *  title=[[UILabel alloc]init];
    title.text=@"全部直播";
//    title.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:22.f];
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textColor=[CommHelp toUIColorByStr:@"#000000"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [buttonsView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonsView).offset(15);
        make.top.equalTo(buttonsView).offset(20);
        make.bottom.equalTo(buttonsView).offset(0);
    }];

    
    return;
  //  [buttonsView.layer addSublayer: [HomeTableViewHeader replicatorLayer_Circle]];

  
    NSArray * images=@[@"home_header_1",@"home_header_2",@"home_header_3",@"home_header_4"];
    NSArray * names=@[@"免费鉴定",@"行业专家",@"全面鉴定",@"超值服务"];
    UIButton * lastBtn;
    
    for (int i=0; i<[images count]; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundColor:[CommHelp randomColor]];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];//
        button.tag=i+1;
        [button setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:1.00f green:0.42f blue:0.42f alpha:1.00f] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.top.equalTo(buttonsView);
            if (i==0) {
                make.left.equalTo(buttonsView);
            }
            
            else{
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(lastBtn);
                
            }
            if (i==[images count]-1) {
                
                make.right.equalTo(buttonsView);
            }
            
        }];
        
        lastBtn=button;
        CGFloat space =5;
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                imageTitleSpace:space];
    
        if (i<[images count]-1) {
          
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#666666"];
            line.alpha=0.7;
            [button addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(button).offset(17);
                make.bottom.equalTo(button).offset(-17);
                make.right.equalTo(button.mas_right).offset(-1);
                make.width.offset(1);
            }];
        }
       
    }
    
}

-(void)setBanners:(NSArray *)banners{
    
    _banners=banners;
    
    NSMutableArray * imagesURLStrings=[NSMutableArray arrayWithCapacity:10];
    
    for (BannerMode * banner in _banners) {
        
        [imagesURLStrings addObject:banner.picUrl];
    }
    
    self.cycleScrollView.imageURLStringsGroup=imagesURLStrings;
}
-(void)buttonPress:(UIButton*)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerTap:)]) {
        [self.delegate headerButtonPress:button];
    }
    
//      JHConnectMicPopAlertView * alert=[[JHConnectMicPopAlertView alloc]init];
//      [alert showAlertWithTitle:@"有新用户请求接单，\n是否接单" cancelButtonTitle:@"不，现在忙" completeButtonTitle:@"是，立即接单" completeBlock:^{
//
//      }];
   
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)imageIndex{
    
    NSLog(@"%ld",imageIndex);
  
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerTap:)]) {
        [self.delegate bannerTap:self.banners[imageIndex]];
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
