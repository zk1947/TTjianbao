//
//  JHOrderListSegmentView.m
//  TTjianbao
//
//  Created by jiang on 2019/8/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderListSegmentView.h"
#import "NSString+NTES.h"
#import "HGPersonalCenterExtendMacro.h"
#import "VideoCateMode.h"
#import "TTjianbaoHeader.h"

@interface JHOrderListSegmentView  ()
{
}
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) NSMutableArray<UIButton*>*buttonArr;
@property (nonatomic, strong) NSMutableArray<VideoCateMode*>*cateArr;
@end

@implementation JHOrderListSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonArr=[NSMutableArray arrayWithCapacity:10];
        self.cateArr=[NSMutableArray arrayWithCapacity:10];
        self.backgroundColor=[CommHelp toUIColorByStr:@"#f7f7f7"];
        [self addSubview:self.segmentScrollView];
        [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.offset(50);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
        
        [self.segmentScrollView addSubview:self.indicateView];
        
    }
    return self;
}
-(void)setTitles:(NSArray<NSString *> *)titles{
    _titles=titles;
    [self setUpSegmentView:_titles];
    
}
-(void)setUpSegmentView:(NSArray*)cates{
    
    UIButton * lastView;
    for (int i=0; i<[cates count]; i++) {
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:[cates objectAtIndex:i] forState:UIControlStateNormal];
        button.tag=100+i;

        button.titleLabel.font= [UIFont systemFontOfSize:12];
        [button setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
       // button.backgroundColor=[ randomColor];
    //    button.layer.cornerRadius = 14;
   //     button.layer.masksToBounds = YES;
   //     button.clipsToBounds = YES;
        // button.contentMode=UIViewContentModeScaleAspectFit;
        [self.segmentScrollView addSubview:button];
        [self.buttonArr addObject:button];
        
        if (i==0) {
            button.selected=YES;
            button.titleLabel.font= [UIFont boldSystemFontOfSize:14];
        }
        
        CGSize titleSize=[[cates objectAtIndex:i]stringSizeWithFont: button.titleLabel.font];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.segmentScrollView);
            make.height.offset(45);
            make.width.offset(titleSize.width+30);
            if (i==0) {
                make.left.equalTo(self.segmentScrollView).offset(0);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(0);
            }
            if (i==[cates count]-1) {
                make.right.equalTo(self.segmentScrollView);
            }
        }];
        
        lastView= button;
    }
    
  
    
}
-(UIScrollView*)segmentScrollView{
    
    if (!_segmentScrollView) {
        _segmentScrollView=[[UIScrollView alloc]init];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor clearColor];
        _segmentScrollView.scrollEnabled=YES;
        _segmentScrollView.alwaysBounceHorizontal = YES;
    }
    
    return _segmentScrollView;
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
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font= [UIFont systemFontOfSize:12];
        //    btn.backgroundColor=HEXCOLOR(0xeeeeee);
        }
    }
    
 //   button.backgroundColor=HEXCOLOR(0xfee100);
    button.selected=YES;
    _type = button.tag;
    button.titleLabel.font= [UIFont boldSystemFontOfSize:14];
  
   // [self layoutIfNeeded];
    CGPoint center  = self.indicateView.center;
    center.x = button.center.x;
    [UIView animateWithDuration:0.3f animations:^{
        self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
    }];
    
    [self scrollSegementView:button complete:^{
        if (self.selectedItemHelper) {
            self.selectedItemHelper(button.tag-100);
        }
    }];
    
}
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex{
    
    UIButton * button=[self.segmentScrollView viewWithTag:100+targetIndex];
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font= [UIFont systemFontOfSize:12];
        //    btn.backgroundColor=HEXCOLOR(0xeeeeee);
        }
    }
  //  button.backgroundColor=HEXCOLOR(0xfee100);
    button.selected=YES;
    _type = button.tag;
    button.titleLabel.font= [UIFont boldSystemFontOfSize:14];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
    }];
    [self scrollSegementView:button complete:nil];
}
- (void)scrollSegementView:(UIButton*)selectButton complete:(JHFinishBlock)handle{
    
    CGFloat selectedWidth = selectButton.frame.size.width;
    CGFloat offsetX = (ScreenW - selectedWidth) / 2;
    
    if (selectButton.frame.origin.x <= ScreenW / 2) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        } completion:^(BOOL finished) {
            if (handle) {
                handle();
            }
            
        }];
        
    } else if (CGRectGetMaxX(selectButton.frame) >= (self.segmentScrollView.contentSize.width - ScreenW / 2)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width - ScreenW, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (handle) {
                handle();
            }
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(CGRectGetMinX(selectButton.frame) - offsetX, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (handle) {
                handle();
            }
        }];
    }
    
}
@end

