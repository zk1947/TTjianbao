//
//  JHMarketScrollAnimationView.m
//  ZkDemoAll
//
//  Created by 赵凯 on 2021/5/30.
//  Copyright © 2021 赵凯. All rights reserved.
//

#import "JHMarketScrollAnimationView.h"
#import "JHPageControl.h"
#import "JHMarketHomeDataReport.h"

//布局计算（一行四列，第一屏最多四行，第二屏最多六行）
#define kMkLineNum 3         /** 行数 */
#define kMkRowNum  4         /** 列数 */
#define kMkLineHeight 42     /** 行高 */
#define kMkSpaceHeight 12    /** 行列间距 */
#define kMkPageHeight 30     /** 指示器高度 */

@interface JHMarketScrollView : UIScrollView
@end

@implementation JHMarketScrollView
#pragma mark -解决button不响应滑动手势的问题
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    [super touchesShouldCancelInContentView:view];
    return YES;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
//    return self.contentOffset.x >= kScreenWidth ? YES : NO;
//}
@end

@interface JHMarketScrollAnimationView ()<UIScrollViewDelegate>

/** 滑动视图 */
@property (nonatomic, strong) JHMarketScrollView *marketScrollView;
/** 分页指示器 */
@property (nonatomic, strong) JHPageControl *pageControl;
/**第一屏高度*/
@property (nonatomic, assign) CGFloat scrPageOneH;
/**第二屏高度*/
@property (nonatomic, assign) CGFloat scrPageTowH;
/**第二屏额外高度*/
@property (nonatomic, assign) CGFloat addscrH;

@end

@implementation JHMarketScrollAnimationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.pageIndex = 0;
    [self addSubview:self.marketScrollView];
    [self addSubview:self.pageControl];
}

- (void)setResourceArray:(NSArray *)resourceArray{
    _resourceArray = resourceArray;
    [self calculateSize];
    [self createSubView];
}

#pragma mark -计算布局
-(void)calculateSize{
    //计算第一屏高度
    [self getScrollViewPageOneHeight];
    //计算第二屏高度
    [self getScrollViewPageTowHeight];
    //计算第二屏额外高度
    [self getScrollViewAddHeight];
    //计算滑动区域
    self.marketScrollView.size = CGSizeMake(kScreenWidth, _scrPageOneH);
    self.marketScrollView.contentSize = CGSizeMake(kScreenWidth * (_resourceArray.count > kMkRowNum*kMkLineNum ? 2:1), 0);
}

#pragma mark -计算第一屏高度
- (CGFloat)getScrollViewPageOneHeight{
    if (_resourceArray.count == 0) {
        _scrPageOneH = 0.f;
    }else if (_resourceArray.count > kMkRowNum*(kMkLineNum-1)){//两页
        _scrPageOneH = kMkLineNum * kMkLineHeight + kMkPageHeight;
    }else{//一页
        _scrPageOneH = _resourceArray.count/kMkRowNum * kMkLineHeight + (_resourceArray.count%kMkRowNum == 0 ? 0 : kMkLineHeight)+kMkPageHeight;
    }
    return _scrPageOneH;
}
#pragma mark -计算第二屏高度
- (CGFloat)getScrollViewPageTowHeight{
    _scrPageTowH = 0;
    if (_resourceArray.count > kMkRowNum*kMkLineNum) {
        NSInteger pageTowCount = _resourceArray.count - kMkRowNum*kMkLineNum;
        _scrPageTowH = pageTowCount/kMkRowNum * kMkLineHeight + (pageTowCount%kMkRowNum == 0 ? 0 : kMkLineHeight)+kMkPageHeight;
    }else if (_resourceArray.count > kMkRowNum*kMkLineNum*2) {
        _scrPageTowH = _scrPageOneH;
    }
    return _scrPageTowH;
}
#pragma mark -计算第二屏额外高度
- (CGFloat)getScrollViewAddHeight{
    _addscrH = 0;
    if (_resourceArray.count > kMkRowNum*kMkLineNum*2) {
        _addscrH = ((_resourceArray.count - kMkRowNum*kMkLineNum*2)/kMkRowNum + (_resourceArray.count%kMkRowNum == 0 ? 0 : 1))*kMkLineHeight;
    }
    return _addscrH;
}

- (void)createSubView{
    
    if (_resourceArray.count <= 0) return;
    CGFloat bottomH = 10;
    if (_resourceArray.count > kMkRowNum*kMkLineNum) {
        bottomH = kMkPageHeight;
    }
    [self.marketScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, bottomH, 0));
//        if (_pageIndex == 0) {
//            make.height.mas_equalTo(_scrPageOneH - kMkPageHeight);
//        }else{
//            make.height.mas_equalTo(_scrPageTowH - kMkPageHeight);
//        }
    }];

    //控制器配置
    self.pageControl.hidden = self.resourceArray.count <= kMkRowNum*kMkLineNum ? YES : NO;
    self.pageControl.numberOfPages = self.resourceArray.count > kMkRowNum*kMkLineNum ? 2 : 1;
    CGFloat pageH = self.resourceArray.count == 0 ? 0.f : kMkPageHeight;
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(pageH);
    }];
    
    for (UIView *view in self.marketScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat btnW = (self.marketScrollView.width - (kMkSpaceHeight*(kMkRowNum+1)))/kMkRowNum;
    CGFloat btnH = kMkLineHeight - kMkSpaceHeight;
    for (int index = 0; index < _resourceArray.count; index ++) {
        
        JHMarketHomeKingKongItemModel *model = _resourceArray[index];
        
        //添加视图 计算第二屏布局
        CGFloat x = index >= kMkRowNum*kMkLineNum ? (kMkSpaceHeight + self.marketScrollView.width) : kMkSpaceHeight;
        int nextIndex = index >= kMkRowNum*kMkLineNum ? index-kMkRowNum*kMkLineNum : index;
        
        UIControl *ctrl = [[UIControl alloc]init];
        ctrl.tag = 2021 + index;
        [ctrl addTarget:self action:@selector(ctrlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.marketScrollView addSubview:ctrl];
        [ctrl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x + (btnW + kMkSpaceHeight)*(nextIndex%kMkRowNum));
            make.top.mas_equalTo(kMkSpaceHeight + kMkLineHeight*(nextIndex/kMkRowNum));
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
        }];
        
        UIImageView *icon = [[UIImageView alloc]init];
//        icon.userInteractionEnabled = YES;
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.clipsToBounds = YES;
        icon.image = JHImageNamed(@"c2c_market_community_icon");
        UIImage *image = [UIImage imageNamed:@"newStore_default_placehold"];
        [icon jhSetImageWithURL:[NSURL URLWithString:model.icon] placeholder:image];
        [ctrl addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(2);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(btnH);
        }];
        
        UILabel *titLab = [[UILabel alloc]init];
        titLab.font = [UIFont systemFontOfSize:11];
        titLab.textColor = kColor222;
        titLab.text = model.name;
        [ctrl addSubview:titLab];
        [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).offset(5);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(btnW-btnH-2);
            make.height.mas_equalTo(btnH);
        }];
    }
}

- (void)ctrlAction:(UIControl *)ctrl{
    if (self.resourceArray.count > 0) {
        JHMarketHomeKingKongItemModel *model = self.resourceArray[ctrl.tag - 2021];
        if (model.target) {
            //上报
            [JHMarketHomeDataReport kingKongTouchReport:model.name];
            [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:JHFromHomeSourceBuy];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.resourceArray.count == 0) return;
    CGFloat offsetX = scrollView.contentOffset.x;
    //偏移范围内改变UI布局
    if (offsetX > 0 || offsetX <= kScreenWidth) {
        
        //更新布局
        
        [self.marketScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, kMkPageHeight, 0));
        }];
        
//        [self.marketScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.offset(0);
//            make.bottom.offset(-kMkPageHeight);
//            if (_addscrH>0) {//判断第二页高度
//                make.height.mas_equalTo(_scrPageOneH + offsetX*_addscrH/kScreenWidth -20);
//            }else{
//                make.height.mas_equalTo(_scrPageOneH - offsetX*(_scrPageOneH-_scrPageTowH)/kScreenWidth - 20);
//            }
//        }];
        
        [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.mas_equalTo(kMkPageHeight);
        }];
        
        //更新外部布局
        if ([self.animationDelegate respondsToSelector:@selector(changeScrollViewHeight:)]) {
            if (_addscrH>0) {//判断第二页高度
                [self.animationDelegate changeScrollViewHeight:(_scrPageOneH + offsetX*_addscrH/kScreenWidth)];
            }else{
                [self.animationDelegate changeScrollViewHeight:(_scrPageOneH - offsetX*(_scrPageOneH-_scrPageTowH)/kScreenWidth)];
            }
        }
    }
    
    //临界处理
    if (offsetX <= 0) {
        [self reloadMinScrollOffset];
    }
    if (offsetX > kScreenWidth) {
        [self reloadMaxScrollOffset];
    }
    
    //分页索引切换
    if (offsetX > 0 && offsetX <= kScreenWidth) {
        [self.pageControl setCurrentPage:1];
        self.pageIndex = 1;
    }else{
        [self.pageControl setCurrentPage:0];
        self.pageIndex = 0;
    }
    
    if ([self.animationDelegate respondsToSelector:@selector(scrollCategroyTouchEvent:)]) {
        [self.animationDelegate scrollCategroyTouchEvent:self.pageIndex];
    }
}

- (void)reloadMinScrollOffset{
    //更新布局
    [self.marketScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, kMkPageHeight, 0));
    }];
    
//    [self.marketScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.offset(0);
//        make.bottom.offset(-kMkPageHeight);
//        make.height.mas_equalTo(_scrPageOneH -20);
//    }];
    
    
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(kMkPageHeight);
    }];
    //更新外部布局
    if ([self.animationDelegate respondsToSelector:@selector(changeScrollViewHeight:)]) {
        [self.animationDelegate changeScrollViewHeight:_scrPageOneH];
    }
}

- (void)reloadMaxScrollOffset{
    //更新布局
    
    [self.marketScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, kMkPageHeight, 0));
    }];

//    [self.marketScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.offset(0);
//        make.bottom.offset(-kMkPageHeight);
//        make.height.mas_equalTo(_scrPageTowH + _addscrH - 20);
//    }];
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(kMkPageHeight);
    }];
    
    //更新外部布局
    if ([self.animationDelegate respondsToSelector:@selector(changeScrollViewHeight:)]) {
        [self.animationDelegate changeScrollViewHeight:(_scrPageTowH + _addscrH)];
    }
}

#pragma mark - Lazy load Methods：

-(JHMarketScrollView *)marketScrollView{
    if (!_marketScrollView) {
        JHMarketScrollView *scrollView = [[JHMarketScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        _marketScrollView = scrollView;
    }
    return _marketScrollView;
}

-(JHPageControl *)pageControl{
    if (!_pageControl) {
        JHPageControl *pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMkPageHeight)];
        pageControl.pointSize = 4;
        pageControl.otherMultiple = 4; //其他点w是h的倍数(圆点)
        pageControl.currentMultiple = 1; //选中点的宽度是高度的倍数(设置长条形状)
        pageControl.pointSpacing = 2;
        pageControl.otherColor = HEXCOLOR(0xE6E6E6); //非选中点的颜色
        pageControl.currentColor = kColorMain; //选中点的颜色
        pageControl.pageControlAlignment = JHPageControlAlignmentMiddle;
        _pageControl = pageControl;
    }
    return _pageControl;
}

@end
