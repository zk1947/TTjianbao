//

//  TTjianbao
//
//  Created by jingxin on 2019/5/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHMallSegmentView.h"
#import "NSString+NTES.h"
#import "JHDiscoverChannelModel.h"
#import "TTjianbaoHeader.h"

@interface JHMallSegmentView()
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) NSMutableArray<UIButton*>*buttonArr;
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelModel*>*cateArr;
//@property(nonatomic, strong) UIButton *moreSegmentBtn;
@property(nonatomic, strong) UIView *redFlag;
@end

@implementation JHMallSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonArr=[NSMutableArray array];
        self.cateArr=[NSMutableArray array];
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.segmentScrollView];
        //[self addSubview:self.moreSegmentBtn];
  
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.moreSegmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-15);
//        make.centerY.equalTo(self.segmentScrollView);
//    }];
    
    [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.offset(self.height-UI.statusBarHeight);
        make.top.equalTo(self).offset(UI.statusBarHeight);
        make.right.equalTo(self).offset(0);
        //        make.right.equalTo(self);
    }];
}
- (void)clickMoreseg {
    NSLog(@"点击重新选择感兴趣话题");
    if (self.clickeMoreHeader) {
        self.clickeMoreHeader();
    }
}
-(void)setUpSegmentView:(NSMutableArray*)cates defaultSelectIndex:(NSInteger)index {
    [self.segmentScrollView removeAllSubviews];
    [self.buttonArr removeAllObjects];
    [self.cateArr removeAllObjects];
    self.cateArr = [NSMutableArray arrayWithArray:cates];
    
    UIButton * lastView;
    for (int i=0; i<[cates count]; i++) {
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:[[cates objectAtIndex:i]name] forState:UIControlStateNormal];
        button.tag= 100 + i;
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        UIImage *buttonImage = [UIImage imageNamed:@"dis_segmentSele"];
        buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
        [button setBackgroundImage:buttonImage forState:UIControlStateSelected];
        button.titleLabel.font= [UIFont systemFontOfSize:15];
        [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        //        button.contentMode=UIViewContentModeScaleAspectFit;
        [self.segmentScrollView addSubview:button];
        [self.buttonArr addObject:button];
        NSLog(@"LabAdd = %@", button.titleLabel);
        UIView *redV = [[UIView alloc] init];
        redV.backgroundColor = [UIColor redColor];
        redV.layer.cornerRadius = 4;
        redV.clipsToBounds = YES;
        redV.tag = 10000+i;
        redV.hidden = YES;
        [button addSubview:redV];
        
        if (i == index) {
            button.selected=YES;
            button.titleLabel.font= [UIFont boldSystemFontOfSize:18];
            //            [self scrollSegementView:button];
        }
        
        CGSize titleSize=[[[cates objectAtIndex:i]name] stringSizeWithFont: button.titleLabel.font];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.segmentScrollView);
            //            make.height.offset(24);
            make.width.offset(titleSize.width + 15);//+30
            if (i==0) {
                make.left.equalTo(self.segmentScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(10);
            }
            if (i==[cates count]-1) {
                make.right.equalTo(self.segmentScrollView);
            }
            make.bottom.equalTo(self.segmentScrollView).offset(-5);
        }];
        
        [redV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.titleLabel).offset(5);
            make.top.equalTo(button.titleLabel);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        lastView= button;
    }
    
}


- (void)dismissRedFlag {
    [self.redFlag removeFromSuperview];
    self.redFlag = nil;
}

-(void) buttonPress:(UIButton*)button{
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font= [UIFont systemFontOfSize:15];
        }
    }
    button.selected=YES;
    _type = button.tag;
    button.titleLabel.font= [UIFont boldSystemFontOfSize:18];
    
    CGSize titleSize=[button.titleLabel.text stringSizeWithFont: button.titleLabel.font];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(titleSize.width + 5);//+30
    }];
    NSInteger pressBtnIndex = [self.buttonArr indexOfObject:button];
    
//    if (self.cateArr[pressBtnIndex].channel_id == -1) {
//        UIView *redV = [self.segmentScrollView viewWithTag:10000];
//        redV.hidden = YES;
//    }
    
    [self scrollSegementView:button];
    
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex=selectIndex;
    UIButton * button=[self.segmentScrollView viewWithTag:100+selectIndex];
    [self buttonPress:button];
    
}
- (void)scrollSegementView:(UIButton*)selectButton{
    //    if (self.segmentScrollView.contentSize.width > self.segmentScrollView.width) {
    CGFloat selectedWidth = selectButton.frame.size.width;
    CGFloat offsetX = ((ScreenW) - selectedWidth) / 2;
    
    if (selectButton.frame.origin.x <= (ScreenW) / 2) {
        [UIView animateWithDuration:0.3 animations:^{
            if (self.segmentScrollView.contentSize.width > self.segmentScrollView.width) {
                [self.segmentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(selectButton);
            }
        }];
        
    } else if (CGRectGetMaxX(selectButton.frame) >= (self.segmentScrollView.contentSize.width - (ScreenW) / 2)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (self.segmentScrollView.contentSize.width > self.segmentScrollView.width) {
                [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width - (ScreenW), 0) animated:NO];
                
            }
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(selectButton);
            }
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(CGRectGetMinX(selectButton.frame) - offsetX, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(selectButton);
            }
        }];
    }
    //    }
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
@end

