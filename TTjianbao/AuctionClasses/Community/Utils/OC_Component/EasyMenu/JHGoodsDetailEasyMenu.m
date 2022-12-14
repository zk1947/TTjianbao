//
//  JHGoodsDetailEasyMenu.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailEasyMenu.h"
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"

#define kTitleFontNormal    [UIFont fontWithName:kFontNormal size:14]
#define kTitleFontSelected  [UIFont fontWithName:kFontNormal size:14]
#define kBottomBarViewOriginY  5

@interface JHGoodsDetailEasyMenu ()

@property (nonatomic, strong) UIScrollView *scrollView; //滚动菜单

@property (nonatomic, strong) UIView *bottomBarView;    //底部滚动条

@property (nonatomic, strong) UIButton *currentSelectBtn;  //当前选中的按钮

@property (nonatomic,   copy) NSMutableArray *buttonsArray;  //存放所有的菜单按钮

@property (nonatomic, assign) CGFloat totalTitleWidth;

@property (nonatomic, assign) BOOL isBlock;    //防止block重复传递造成死循环

@end


@implementation JHGoodsDetailEasyMenu

+ (CGFloat)menuHeight {
    return 44.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.scrollView];
}


#pragma mark -
#pragma mark - setter and  getter

- (void)setCurrentPage:(NSInteger)currentPage {
    //防止重复设置
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = currentPage;

    if (self.titleArray.count == 0) {
        return;
    }
    
    self.isBlock = NO;
    //改变当前的按钮状态以及偏移对应的菜单
    UIButton *currentBtn = self.buttonsArray[currentPage];
    [self changeSelectedState:currentBtn];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    [self configUI];
    
    self.isBlock = YES;
    
    NSInteger btnOffset = 0;
    
    //判断要添加的item是否超出屏幕，如果没有，等分
    BOOL isMore = [self isMoreScreenWidth];

    if (isMore) {
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:kColor333 forState:UIControlStateNormal];
            [btn setTitleColor:kColor333 forState:UIControlStateSelected];
            btn.titleLabel.font = kTitleFontNormal;
            btn.tag = i;
            
            [btn sizeToFit];
            float originX = i ? 37+btnOffset : 18;
            btn.frame = CGRectMake(originX, 0, btn.frame.size.width, 48);
            
            btnOffset = CGRectGetMaxX(btn.frame);
            
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedState:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:btn];
            [self.buttonsArray addObject:btn];
            
            //默认选择第一个
            if (i == 0) {
                btn.selected = YES;
                btn.titleLabel.font = kTitleFontSelected;
                self.currentSelectBtn = btn;
                self.bottomBarView.frame = CGRectMake(btn.frame.origin.x, self.scrollView.frame.size.height-kBottomBarViewOriginY, btn.frame.size.width, 2);
                [self.scrollView addSubview:self.bottomBarView];
            }
        }
        
    } else {
        //计算等分之后的间隙大小
        CGFloat interValWidth = (ScreenWidth - self.totalTitleWidth) / (self.titleArray.count + 1);
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:kColor333 forState:UIControlStateNormal];
            [btn setTitleColor:kColor333 forState:UIControlStateSelected];
            btn.titleLabel.font = kTitleFontNormal;
            btn.tag = i;
            
            [btn sizeToFit];
            float originX =  i ? interValWidth + btnOffset : interValWidth;
            btn.frame = CGRectMake(originX, 0, btn.frame.size.width, 48);
            
            btnOffset = CGRectGetMaxX(btn.frame);
            
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedState:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrollView addSubview:btn];
            [self.buttonsArray addObject:btn];
            
            //默认选择第一个
            if (i == 0) {
                btn.selected = YES;
                btn.titleLabel.font = kTitleFontSelected;
                self.currentSelectBtn = btn;
                
                self.bottomBarView.frame = CGRectMake(btn.frame.origin.x, self.scrollView.frame.size.height-kBottomBarViewOriginY, btn.frame.size.width, 2);
                [self.scrollView addSubview:self.bottomBarView];
            }
        }
    }
    
    //更新scrollView的内容区域
    self.scrollView.contentSize = CGSizeMake(btnOffset+18, self.scrollView.frame.size.height);
}

- (BOOL)isMoreScreenWidth {
    CGFloat totalWidth = 0;
    totalWidth += 18;
    
    for (int i = 0; i<self.titleArray.count; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.titleArray[i];
        
        [label sizeToFit];
        totalWidth += label.frame.size.width;
        totalWidth += 22;
        self.totalTitleWidth += label.frame.size.width;
    }
    
    if (totalWidth < ScreenWidth - 18) {
        return NO;
    }
    
    return YES;
}

- (void)changeSelectedState:(UIButton *)button {
    self.currentSelectBtn.selected = NO;
    self.currentSelectBtn.titleLabel.font = kTitleFontNormal;
    
    self.currentSelectBtn = button;
    
    self.currentSelectBtn.selected = YES;
    self.currentSelectBtn.titleLabel.font = kTitleFontSelected;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (button.tag == 0) {
            self.bottomBarView.frame = CGRectMake(self.currentSelectBtn.frame.origin.x, self.scrollView.frame.size.height - kBottomBarViewOriginY, self.currentSelectBtn.frame.size.width, 2);
            [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
            
        } else {
            UIButton *preButton = self.buttonsArray[button.tag - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame) - 18;
            
            [self.scrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.scrollView.frame.size.width, button.frame.size.height) animated:YES];
            
            self.bottomBarView.frame = CGRectMake(self.currentSelectBtn.frame.origin.x, self.scrollView.frame.size.height-kBottomBarViewOriginY, self.currentSelectBtn.frame.size.width, 2);
        }
        
        //self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH *button.tag, 0);
        
        if(self.pageSelectBlock && self.isBlock) {
            NSLog(@"current seleted menu is %ld",button.tag);
            self.currentPage = button.tag;  //更新当前的curPage
            self.pageSelectBlock(button.tag);
        }
        
        //默认将传递打开
        self.isBlock = YES;
    }];
}

#pragma mark -
#pragma mark - lazyload

- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray new];
    }
    return _buttonsArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-2);
    }
    return _scrollView;
}

- (UIView *)bottomBarView {
    if (!_bottomBarView) {
        _bottomBarView = [UIView new];
        _bottomBarView.backgroundColor = kColorMain;
    }
    return _bottomBarView;
}

@end
