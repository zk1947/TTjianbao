//
//  JHSecKillSegmentUIView.m
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSecKillSegmentUIView.h"

#import "NSString+NTES.h"
#import "HGPersonalCenterExtendMacro.h"
#import "VideoCateMode.h"
#import "TTjianbaoHeader.h"

@interface JHSecKillSegmentUIView  ()
{
}
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) NSMutableArray<VideoCateMode*>*cateArr;
@end

@implementation JHSecKillSegmentUIView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cateArr=[NSMutableArray arrayWithCapacity:10];
        self.backgroundColor=[UIColor clearColor];
        [self addSubview:self.segmentScrollView];
        [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
        
    }
    return self;
}

-(void)setUpSegmentView:(NSArray<JHSecKillTitleMode *> *)titles{
    
    CGFloat space=30;
    CGFloat width=70;
    CGFloat height=30;
    
    UIButton * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:titles[i].title forState:UIControlStateNormal];
        button.tag=100+i;
        // button.backgroundColor=[CommHelp randomColor];
        button.titleLabel.font= [UIFont fontWithName:kFontMedium size:16];
        [button setTitleColor:kColor666 forState:UIControlStateNormal];
        [button setTitleColor:kColorMainRed forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentScrollView addSubview:button];
        
        if (i==0) {
            button.selected=YES;
        }
        
        if (titles.count==1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.segmentScrollView);
                make.height.offset(height);
                make.width.offset(width);
                make.centerX.equalTo(self).offset(0);
            }];
        }
        
        else if (titles.count==2) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.segmentScrollView);
                make.height.offset(height);
                make.width.offset(width);
                if (i==0) {
                    make.left.equalTo(self.segmentScrollView).offset(ScreenW/2-width-space/2);
                }
                else{
                    
                    make.left.equalTo(lastView.mas_right).offset(space);;
                }
                if (i==[titles count]-1) {
                    make.right.equalTo(self.segmentScrollView).offset(0);;
                }
            }];
            
        }
        else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.segmentScrollView);
                make.height.offset(height);
                make.width.offset(width);
                if (i==0) {
                    //  make.centerX.equalTo(self).offset(0);
                }
                else{
                    make.left.equalTo(lastView.mas_right).offset(space);
                    
                }
                if (i==1) {
                    make.left.equalTo(self.segmentScrollView).offset((ScreenW-width)/2);
                }
                if (i==[titles count]-1) {
                    make.right.equalTo(self.segmentScrollView).offset(0);;
                }
            }];
            
        }
        
        UIButton * descBtn = [[UIButton alloc]init];
        [descBtn setTitle:titles[i].sub_title forState:UIControlStateNormal];
        descBtn.tag=200+i;
        descBtn.titleLabel.font= [UIFont systemFontOfSize:12];
        [descBtn setTitleColor:kColor666 forState:UIControlStateNormal];
        [descBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
        [descBtn addTarget:self action:@selector(descBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        descBtn.backgroundColor=[UIColor clearColor];
        descBtn.layer.cornerRadius = 10;
        descBtn.layer.masksToBounds = YES;
        descBtn.clipsToBounds = YES;
        
        [self.segmentScrollView addSubview:descBtn];
        
        if (i==0) {
            descBtn.selected=YES;
            descBtn.backgroundColor=kColorMainRed;
        }
        CGSize titleSize=[titles[i].sub_title stringSizeWithFont: descBtn.titleLabel.font];
        
        [descBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.width.offset(titleSize.width+10);
            make.top.equalTo(button.mas_bottom).offset(0);
            make.height.offset(20);
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
-(void)buttonPress:(UIButton*)button{
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.backgroundColor=[UIColor clearColor];
        }
    }
    button.selected=YES;
    UIButton * btn=[self.segmentScrollView viewWithTag:button.tag+100];
    btn.selected=YES;
    btn.backgroundColor= kColorMainRed;
    
    if (self.selectedItemHelper) {
        self.selectedItemHelper(button.tag-100);
    }
    
}
-(void)descBtnPress:(UIButton*)button{
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.backgroundColor=[UIColor clearColor];
        }
    }
    button.selected=YES;
    button.backgroundColor= kColorMainRed;
    
    UIButton * btn=[self.segmentScrollView viewWithTag:button.tag-100];
    btn.selected=YES;
    if (self.selectedItemHelper) {
        self.selectedItemHelper(button.tag-200);
    }
    
}

- (void)setCurrentIndex:(NSUInteger)targetIndex{
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.backgroundColor=[UIColor clearColor];
        }
    }
    //  button.backgroundColor=HEXCOLOR(0xfee100);
    UIButton * button=[self.segmentScrollView viewWithTag:100+targetIndex];
    button.selected=YES;
    
    UIButton * btn=[self.segmentScrollView viewWithTag:200+targetIndex];
    btn.selected=YES;
    btn.backgroundColor= kColorMainRed;
}
-(void)setTitles:(NSArray<JHSecKillTitleMode *> *)titles{
    _titles=titles;
    for (int i=0; i<[titles count]; i++) {
        UIButton * button=[self.segmentScrollView viewWithTag:100+i];
        [button setTitle:[NSString stringWithFormat:@"%@",titles[i].title] forState:UIControlStateNormal];
        UIButton * btn=[self.segmentScrollView viewWithTag:200+i];
        [btn setTitle:[NSString stringWithFormat:@"%@",titles[i].sub_title] forState:UIControlStateNormal];
    }
    
}

@end


