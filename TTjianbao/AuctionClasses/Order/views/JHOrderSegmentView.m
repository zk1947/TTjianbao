//
//  JHOrderSegmentView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderSegmentView.h"
#import "TTjianbaoHeader.h"

@interface JHOrderSegmentView   ()
{
}
 @property (nonatomic, strong) UIImageView *indicateView;
 @property (nonatomic, strong) NSMutableArray<UIButton*>*buttonArr;
@end

@implementation JHOrderSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.buttonArr=[NSMutableArray arrayWithCapacity:10];
         self.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
         [self addSubview:self.indicateView];
        
    }
    
    return self;
}
-(void)setUpSegmentView:(NSArray*)titles{
    
    UIButton * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        button.tag=i;
        button.titleLabel.font= [UIFont boldSystemFontOfSize:14];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        [self.buttonArr addObject:button];
        
        if (i==0) {
            button.selected=YES;
           
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self);
            if (i==0) {
                 make.left.equalTo(self);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(0);
                make.width.equalTo(lastView);
            }
            if (i==[titles count]-1) {
                 make.right.equalTo(self);
            }
        }];
        
          lastView= button;
    }
    
      self.indicateView.center = CGPointMake(self.mj_w/[titles count]*0.5, self.indicateView.center.y);
    
}
- (UIImageView *)indicateView {

    if (!_indicateView) {
        _indicateView=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.mj_h-5, 15, 5)];
        _indicateView.image=[UIImage imageNamed:@"home_top_line"];
        _indicateView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _indicateView;
}
-(void)buttonPress:(UIButton*)button{
    
    for ( UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
        }
    }
    
    button.selected=YES;
    CGPoint center  = self.indicateView.center;
       center.x = button.center.x;
    
    [UIView animateWithDuration:0.25f animations:^{
        
         self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
    }];
    
    if (self.delegate) {
        
        [self.delegate segMentButtonPress:button];
    }
}
-(void)setTitles:(NSArray *)titles{
    
    for (int i=0; i<[titles count]; i++) {
        
        UIButton * button=self.buttonArr[i];
        [button setTitle:[NSString stringWithFormat:@"%@",[titles objectAtIndex:i]] forState:UIControlStateNormal];
    }
}
-(void)setCurrentIndex:(int)currentIndex{
    
    for (int i=0; i<[self.buttonArr count]; i++) {
        UIButton * btn=self.buttonArr[i];
        btn.selected=NO;
    }
      UIButton * button=self.buttonArr[currentIndex];
      button.selected=YES;
    
     [self layoutIfNeeded];
     CGPoint center  = self.indicateView.center;
     center.x = button.center.x;
     [UIView animateWithDuration:0.25f animations:^{
        
        self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
    }];
}
-(void)setIndicateViewImage:(UIImage*)image{
    
    self.indicateView.image=image;
    self.indicateView.frame=CGRectMake(0,self.mj_h-2,30, 2);
}
@end
