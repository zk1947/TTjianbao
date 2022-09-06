//
//  JHSegmentView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSegmentView.h"
#import "TTjianbaoHeader.h"

@interface JHSegmentView ()<UIScrollViewDelegate>
{
    CGFloat   buttonWidth;
     jh_indexBlock resultBlock;
}

@property (nonatomic, strong) UIView *segmentTitleView;
@property (nonatomic, strong) UIScrollView *segmentContentView;
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) NSArray *viewControllersArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIViewController *parentViewController;
@end

@implementation JHSegmentView

- (instancetype)initWithFrame:(CGRect)frame ViewControllersArr:(NSArray *)viewControllersArr TitleArr:(NSArray *)titleArr  ParentViewController:(UIViewController *)parentViewController ReturnIndexBlock: (jh_indexBlock)indexBlock{
    
    if (self = [super initWithFrame:frame]) {
        
        resultBlock=indexBlock;
        buttonWidth=130;
        
        self.parentViewController=parentViewController;
        self.viewControllersArr=viewControllersArr;
        self.titleArr=titleArr;
        [self addSubview:self.segmentContentView];
        [self addSubview:self.segmentTitleView];
        [self.segmentTitleView addSubview:self.indicateView];
        
        [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset((ScreenW/2-buttonWidth)+(buttonWidth-15)/2);
             make.bottom.equalTo(_segmentTitleView).offset(-5);
        }];
        
        [self initButtons];
        if (resultBlock) {
            resultBlock(_selectedButton.tag);
        }
    }
    return self;
}
- (UIView *)segmentTitleView {
    if (!_segmentTitleView) {
        _segmentTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,200,ScreenW, UI.statusBarHeight+44)];
        _segmentTitleView.backgroundColor = [[CommHelp toUIColorByStr:@"#f7f7f7"] colorWithAlphaComponent:0.95];
        
    }
    return _segmentTitleView;
}

- (UIScrollView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , ScreenW,ScreenH)];
        _segmentContentView.delegate = self;
        _segmentContentView.showsHorizontalScrollIndicator = NO;
        _segmentContentView.pagingEnabled = YES;
        _segmentContentView.bounces = NO;
        _segmentContentView.contentSize = CGSizeMake(ScreenW * self.viewControllersArr.count, 0);
        UIViewController *viewController = self.viewControllersArr[0];
        viewController.view.frame = CGRectMake(ScreenW * 0, 0, ScreenW, ScreenH);
        [self.parentViewController addChildViewController:viewController];
        [viewController didMoveToParentViewController:_parentViewController];
        [_segmentContentView addSubview:viewController.view];
    }
    return _segmentContentView;
}

- (UIImageView *)indicateView {
    if (!_indicateView) {
        _indicateView=[[UIImageView alloc]init];
        _indicateView.image=[UIImage imageNamed:@"home_top_line"];
        _indicateView.contentMode=UIViewContentModeScaleAspectFit;
      
    }
    return _indicateView;
}
-(void)initButtons{
    
      self.buttonArr=[NSMutableArray arrayWithCapacity:10];
    for ( int i=0; i<[self.titleArr count]; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.titleArr objectAtIndex:i] forState:UIControlStateNormal];
        button.tag=i;
        
        button.titleLabel.font= [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#999999"] forState:UIControlStateNormal];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self.segmentTitleView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset(UI.statusBarHeight);
            make.width.offset(buttonWidth);
            make.bottom.equalTo(self.segmentTitleView).offset(-5);
            if (i==0) {
                button.selected=YES;
                _selectedButton=button;
                make.right.equalTo(self.segmentTitleView).offset(-ScreenW/2);
                
            }
            if (i==1) {
                make.left.equalTo(self.segmentTitleView).offset(ScreenW/2);
            }
            
        }];
        
        [self.buttonArr addObject:button];
    }
    
}
-(void)didClickButton:(UIButton*)button{
    
    NSLog(@"%ld",button.tag);
    for (UIView* view in self.segmentTitleView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn=(UIButton*)view;
            btn.selected=NO;
        }
    }
       button.selected = YES;
      _selectedButton = button;
       [self scrollContentView];

        CGPoint center = self.indicateView.center;
        center=CGPointMake(button.center.x,self.indicateView.center.y);
        [UIView animateWithDuration:0.25f animations:^{
            self.indicateView.center= center;
        }];
    
    if (resultBlock) {
        resultBlock(_selectedButton.tag);
    }
    
     [self loadOtherVCWith:_selectedButton.tag];
  }
- (void)loadOtherVCWith:(NSInteger)tag {
    
    UIViewController *viewController = self.viewControllersArr[tag];
    [viewController.view setFrame:CGRectMake(ScreenW*tag, 0, ScreenW, ScreenH)];
    [_parentViewController addChildViewController:viewController];
    [viewController didMoveToParentViewController:_parentViewController];
    [_segmentContentView addSubview:viewController.view];
    
}
- (void)setSelectedItemAtIndex:(NSInteger)index{
    
    for (UIView *view in _segmentTitleView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == index) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
        }
    }
    
}
- (NSInteger)selectedAtIndex {
    return _selectedButton.tag;
}
- (void)scrollContentView {
    
    NSInteger index = [self selectedAtIndex];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        [weakSelf.segmentContentView setContentOffset:CGPointMake(index * ScreenW, 0)];
    }];
 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
      self.segmentTitleView.mj_y=scrollView.contentOffset.y;
    
    return;
    if (scrollView.contentOffset.y>=190) {
        
        self.segmentTitleView.mj_y=scrollView.contentOffset.y;
        
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
     NSInteger index = round(scrollView.contentOffset.x / ScreenW);
    [self setSelectedItemAtIndex:index];
   
}
@end
