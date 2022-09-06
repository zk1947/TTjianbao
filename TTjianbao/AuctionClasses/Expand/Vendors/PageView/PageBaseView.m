//
//  PageBaseView.m
//  AutographAlbum
//
//  Created by jiangchao on 2016/11/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "PageBaseView.h"

#import "UIParameter.h"

@interface PageBaseView ()

@end

@implementation PageBaseView
{
    //  UIView *lineBottom;
    UIView *topTabBottomLine;
    NSMutableArray *btnArray;
    NSArray *titlesArray; /**<  标题   **/
    NSInteger arrayCount; /**<  topTab数量   **/
    UIColor *selectBtn;
    UIColor *unselectBtn;
    UIColor *underline;
    UIColor *topBackground;
    
}
@synthesize lineBottom;
@synthesize topTab=_topTab;

- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithTopColur:(UIColor*)topColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame=frame;
        if ([selectColor isKindOfClass:[UIColor class]]) {
            selectBtn = selectColor;
        }
        if ([unselectColor isKindOfClass:[UIColor class]]) {
            unselectBtn = unselectColor;
        }
        if ([underlineColor isKindOfClass:[UIColor class]]) {
            underline = underlineColor;
        }
        
        if ([topColor isKindOfClass:[UIColor class]]) {
            topBackground = topColor;
        }
      
    }
      return self;
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    
    
    _titleArray=titleArray;
    titlesArray = titleArray;
    arrayCount = titleArray.count;
    self.topTab.frame = CGRectMake(0, 0, self.frame.size.width, PageBtn);
    self.scrollView.frame = CGRectMake(0, PageBtn, self.frame.size.width, self.frame.size.height - PageBtn);
    [self addSubview:self.topTab];
    [self addSubview:self.scrollView];
    
}
#pragma mark - GetMethod
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.tag = 318;
        _scrollView.backgroundColor = HEXCOLOR(0xfafafa);
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * titlesArray.count, 0);
        _scrollView.pagingEnabled = YES;
    
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
    }
      return _scrollView;
}

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        _topTab.delegate = self;
        _topTab.tag = 917;
        _topTab.scrollEnabled = YES;
        _topTab.alwaysBounceHorizontal = YES;
        _topTab.showsHorizontalScrollIndicator = NO;
        _topTab.backgroundColor=topBackground;
        
        CGFloat additionCount = 0;
        if (arrayCount > 5) {
            additionCount = (arrayCount - 5.0) / 5.0;
          
        }
        _topTab.contentSize = CGSizeMake((1 + additionCount) * self.frame.size.width, 0);
        btnArray = [NSMutableArray array];
        for (NSInteger i = 0; i < titlesArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            button.backgroundColor=[UIColor clearColor];
            if ([titlesArray[i] isKindOfClass:[NSString class]]) {
                [button setTitle:titlesArray[i] forState:UIControlStateNormal];
            }else {
                NSLog(@"您所提供的标题%li格式不正确。 Your title%li not fit for topTab,please correct it to NSString!",(long)i + 1,(long)i + 1);
            }
            if (titlesArray.count > 5) {
                button.frame = CGRectMake(self.frame.size.width / 5 * i, 0, self.frame.size.width / 5, PageBtn);
            }else {
                button.frame = CGRectMake(self.frame.size.width / titlesArray.count * i, 0, self.frame.size.width / titlesArray.count, PageBtn);
            }
            [_topTab addSubview:button];
            [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnArray addObject:button];
            if (i == 0) {
                if (selectBtn) {
                    [button setTitleColor:selectBtn forState:UIControlStateNormal];
                }else {
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
//                [UIView animateWithDuration:0.3 animations:^{
//                    button.transform = CGAffineTransformMakeScale(1.15, 1.15);
//                }];
            } else {
                if (unselectBtn) {
                    [button setTitleColor:unselectBtn forState:UIControlStateNormal];
                }else {
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
//        //创建tabTop下方总览线
//        topTabBottomLine = [UIView new];
//        topTabBottomLine.backgroundColor = HEXCOLOR(0xcecece);
//        [_topTab addSubview:topTabBottomLine];
        //创建选中移动线
        lineBottom = [UIView new];
        if (underline) {
            lineBottom.backgroundColor = underline;
        }else {
            lineBottom.backgroundColor = HEXCOLOR(0xff6262);
        }
        [_topTab addSubview:lineBottom];
        
        
        CGFloat yourCount = 1.0 / arrayCount;
        additionCount = 0;
        if (arrayCount > 5) {
            additionCount = (arrayCount - 5.0) / 5.0;
            yourCount = 1.0 / 5.0;
        }
        
        NSLog(@"yourCount==%f",yourCount);

        UIButton* cc=btnArray[0];
       // lineBottom.frame = CGRectMake(0, PageBtn - 2,yourCount * self.frame.size.width, 2);
        
         NSLog(@"aa==%lf",cc.frame.origin.x);
          NSLog(@"bb==%lf",cc.frame.size.width);
      
        lineBottom.frame = CGRectMake((yourCount * self.frame.size.width-50)/2, PageBtn - 2,50, 2);
        
        topTabBottomLine.frame = CGRectMake(0, PageBtn - 1, (1 + additionCount) * self.frame.size.width, 1);

        
    }
    return _topTab;
}

#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width * button.tag, 0) animated:NO];
    self.currentPage = (self.frame.size.width * button.tag + self.frame.size.width / 2) / self.frame.size.width;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 318) {
        
        self.currentPage = (NSInteger)((scrollView.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
   
    if (scrollView.tag == 318) {
        NSInteger yourPage = (NSInteger)((scrollView.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width);
        
        if (yourPage<titlesArray.count) {
            
            CGFloat additionCount = 0;
            CGFloat yourCount = 1.0 / arrayCount;
            if (arrayCount > 5) {
                additionCount = (arrayCount - 5.0) / 5.0;
                yourCount = 1.0 / 5.0;
               // lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 5, PageBtn - 2, yourCount * self.frame.size.width, 2);
                
                
                lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 5+(yourCount * self.frame.size.width-50)/2, PageBtn - 2,50, 2);
                
            }else {
              //  lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount, PageBtn - 2, yourCount * self.frame.size.width, 2);
                
                
                lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount+(yourCount * self.frame.size.width-50)/2, PageBtn - 2,50, 2);
            }
            for (NSInteger i = 0;  i < btnArray.count; i++) {
                if (unselectBtn) {
                    [btnArray[i] setTitleColor:unselectBtn forState:UIControlStateNormal];
                }else {
                    [btnArray[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
//                UIButton *changeButton = btnArray[i];
//                [UIView animateWithDuration:0.3 animations:^{
//                    changeButton.transform = CGAffineTransformMakeScale(1, 1);
//                }];
            }
            if (selectBtn) {
                [btnArray[yourPage] setTitleColor:selectBtn forState:UIControlStateNormal];
            }else {
                [btnArray[yourPage] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
//            UIButton *changeButton = btnArray[yourPage];
//            [UIView animateWithDuration:0.3 animations:^{
//                changeButton.transform = CGAffineTransformMakeScale(1, 1);
//            }];
         }
      }
        
    }

-(void)setCurrentPage:(NSInteger)currentPage{

      _currentPage=currentPage;
     [_scrollView setContentOffset:CGPointMake(self.frame.size.width * _currentPage, 0) animated:NO];
    
}
//#pragma mark - LayOutSubViews
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self initUI];
//}
//
//- (void)initUI {
//    
//    
//  }
@end
