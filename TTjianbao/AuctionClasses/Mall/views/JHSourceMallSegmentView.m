//
//  JHSourceMallSegmentView.m
//  TTjianbao
//
//  Created by jiang on 2019/8/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSourceMallSegmentView.h"
#import "NSString+NTES.h"
#import "HGPersonalCenterExtendMacro.h"
#import "VideoCateMode.h"
#import "TTjianbaoHeader.h"
#import "UIButton+WebCache.m"
@interface JHSourceMallSegmentView  ()
{
}
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) UIView *redDotView;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) NSMutableArray<UIButton*>*buttonArr;
@property (nonatomic, strong) NSMutableArray<VideoCateMode*>*cateArr;
@end

@implementation JHSourceMallSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //segmentScrollView默认宽度是屏幕宽度
        _segmentWidth=ScreenW;
        //默认选中第一个
        
        
         self.originalIndex=0;
        
       // self.selectIndex=self.originalIndex;
    
        self.buttonArr=[NSMutableArray arrayWithCapacity:10];
        self.backgroundColor = kColorF5F6FA;
        
    }
    return self;
}
-(void)initSegmentScrollView{
    
    [self addSubview:self.segmentScrollView];
    [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.offset(HGCategoryViewDefaultHeight);
        make.top.equalTo(self).offset(0);
        make.width.offset(self.segmentWidth);
    }];
}
-(void)setBackColor:(UIColor *)backColor{
    
    self.backgroundColor=backColor;
    
}
-(void)setTitles:(NSArray<VideoCateMode *> *)titles{
    _titles=titles;
    [self setUpSegmentView:_titles];
}
-(void)setUpSegmentView:(NSArray<VideoCateMode *>*)cates{
    
    UIButton * lastView;
    for (int i=0; i<[cates count]; i++) {
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:[cates objectAtIndex:i].name forState:UIControlStateNormal];
        button.tag=100+i;
        //   button.backgroundColor=HEXCOLOR(0xeeeeee);
        button.backgroundColor=[UIColor clearColor];
        button.titleLabel.font= [UIFont fontWithName:kFontNormal size:14];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        button.clipsToBounds = YES;
        [self.segmentScrollView addSubview:button];
        [self.buttonArr addObject:button];
        
       // if (i==self.originalIndex)
        if (i==self.originalIndex){
            button.selected=YES;
            button.titleLabel.font= [UIFont fontWithName:kFontMedium size:15];
            button.backgroundColor=HEXCOLOR(0xfee100);
        }
//
//        if ([[cates objectAtIndex:i].ID isEqualToString:@"50"]) {
//             [button addSubview:self.redDotView];
//             [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.offset(-5);
//                make.top.offset(5);
//                 make.height.offset(5);
//                  make.width.offset(5);
//            }];
//        }
        CGSize titleSize=[[[cates objectAtIndex:i]name] stringSizeWithFont: [UIFont fontWithName:kFontMedium size:15]];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.segmentScrollView);
            make.height.offset(28);
            make.width.offset(titleSize.width+25);
            if (i==0) {
                make.left.equalTo(self.segmentScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(8);
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
-(UIView*)redDotView{
    
    if (!_redDotView) {
        _redDotView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 7 )];
        _redDotView.backgroundColor = kColorMainRed;
        _redDotView.layer.cornerRadius = 3.5;
        _redDotView.layer.masksToBounds = YES;
    }
    
    return _redDotView;
    
}
-(void)buttonPress:(UIButton*)button{
    
    self.selectIndex=button.tag-100;
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font=[UIFont fontWithName:kFontNormal size:14];
            btn.backgroundColor=[UIColor clearColor];
            
        }
    }
    
    
    button.backgroundColor=HEXCOLOR(0xfee100);
    button.selected=YES;
    _type = button.tag;
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    
    VideoCateMode * mode= [self.titles objectAtIndex:button.tag-100];
    if ([mode.ID isEqualToString:@"50"]) {
       [self.redDotView removeFromSuperview];
   }
    
    [self scrollSegementView:button complete:^{
        if (self.selectedItemHelper) {
            self.selectedItemHelper(button.tag-100);
        }
    }];
    
}
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex{
    
    UIButton * button=[self.segmentScrollView viewWithTag:100+targetIndex];
    self.selectIndex=button.tag-100;
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font=[UIFont fontWithName:kFontNormal size:14];
            btn.backgroundColor=[UIColor clearColor];
            // btn.backgroundColor=HEXCOLOR(0xeeeeee);
            
        }
    }
    button.backgroundColor=HEXCOLOR(0xfee100);
    button.selected=YES;
    _type = button.tag;
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    
    [self scrollSegementView:button complete:nil];
}
- (void)scrollSegementView:(UIButton*)selectButton complete:(JHFinishBlock)handle{
    
    CGFloat selectedWidth = selectButton.frame.size.width;
    CGFloat offsetX = (self.segmentWidth - selectedWidth) / 2;
    
    UIButton* lastBtn=[self.segmentScrollView viewWithTag:100+self.titles.count-1];
    
    //不够一屏不滚动
    if (lastBtn.right<self.segmentWidth) {
        if (handle) {
            handle();
        }
    }
    else  if (selectButton.frame.origin.x <= self.segmentWidth / 2) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        } completion:^(BOOL finished) {
            if (handle) {
                handle();
            }
            
        }];
        
    } else if (CGRectGetMaxX(selectButton.frame) >= (self.segmentScrollView.contentSize.width - self.segmentWidth / 2)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width - self.segmentWidth, 0) animated:NO];
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
-(void)showRedDot{
    
    [self.titles  enumerateObjectsUsingBlock:^(VideoCateMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.ID isEqual:@"50"]) {
            UIButton * button=[self.segmentScrollView viewWithTag:100+idx];
            [button addSubview:self.redDotView];
            [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-5);
                make.top.offset(5);
                make.height.offset(7);
                make.width.offset(7);
            }];
          * stop=YES;
        }
    }];
    

}
@end
