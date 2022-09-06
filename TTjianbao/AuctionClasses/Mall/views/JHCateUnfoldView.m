//
//  JHCateUnfoldView.m
//  TTjianbao
//种类展开view
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCateUnfoldView.h"
#import "CommHelp.h"
#import "TTjianbaoMarcoUI.h"
#import "UIColor+YYAdd.h"
@interface JHCateUnfoldView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *tagView;
@end

@implementation JHCateUnfoldView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
            [self addGestureRecognizer:tapGesture];
            self.userInteractionEnabled=YES;
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
        [self addSubview:_contentView];
      
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.width.offset(ScreenW);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor=[UIColor clearColor];
        [closeBtn setImage:[UIImage imageNamed:@"mall_selectbtn_icon_shang"] forState:UIControlStateNormal];
        closeBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.right.offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _tagView=[[UIView alloc]init];
        _tagView.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
        [_contentView addSubview:_tagView];
        
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(closeBtn.mas_bottom).offset(10);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
    return self;
}

-(void)setTitles:(NSArray<VideoCateMode *> *)titles{
    
    _titles=titles;
    float imaWidth=76;
    float imaHeight=28;
    NSInteger margin = round((ScreenW-(76*4)-20)/3);//设置相隔距离
    UIButton * lastView ;;
    for (int i=0; i<_titles.count; i++) {
    
        UIButton * button=[[UIButton alloc]init];
        button.backgroundColor = kColorF5F6FA;
        button.titleLabel.font= [UIFont fontWithName:kFontNormal size:14];
        [button setTitleColor:kColor333 forState:UIControlStateNormal];
        [button setTitleColor:kColor333 forState:UIControlStateSelected];
        [button setTitle:[_titles objectAtIndex:i].name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 14;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 10);
        button.layer.masksToBounds = YES;
        button.clipsToBounds = YES;
        
        [self.tagView addSubview:button];
        button.selected=NO;
        button.tag=100+i;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(imaWidth);
            make.height.offset(imaHeight);
            if (i/4==0) {
                make.top.equalTo(self.tagView.mas_top).offset(0);
            }
            else{
                NSInteger  rate= i/4;
                make.top.equalTo(self.tagView.mas_top).offset(imaHeight*rate+15*(rate));
            }
            if (i%4 == 0) {
                make.left.offset(10);
                
            }else{
                make.left.equalTo(lastView.mas_right).offset(margin);
            }
            if (i%4 == 3) {
                make.right.offset(-10);
            }
            if (i == [_titles count] - 1){
                make.bottom.equalTo(self.tagView).offset(-20);
            }
        }];
        lastView= button;
    }
}
-(void)buttonPress:(UIButton*)button{
    [self makeButtonnSelect:button];
    [self close];
    if (self.buttonClick) {
           self.buttonClick([NSNumber numberWithInteger:button.tag-100]);
       }
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex=selectIndex;
    UIButton * button=[self.tagView viewWithTag:100+_selectIndex];
    [self makeButtonnSelect:button];
    
}
-(void)makeButtonnSelect:(UIButton*)button{
    
    for ( UIView * view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font=[UIFont fontWithName:kFontNormal size:14];
            btn.backgroundColor=[UIColor clearColor];
        }
    }
    button.backgroundColor=HEXCOLOR(0xfee100);
    button.selected=YES;
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:14];
}
-(void)close{
    
    [self removeFromSuperview];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
