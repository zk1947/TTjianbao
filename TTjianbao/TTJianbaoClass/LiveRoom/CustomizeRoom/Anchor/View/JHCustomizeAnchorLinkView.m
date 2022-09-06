//
//  JHCustomizeAnchorLinkView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAnchorLinkView.h"
#import "JHLiveAudienceCell.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "NTESAnchorLiveViewController.h"
#import "TTjianbaoHeader.h"
#import "UIView+JHGradient.h"

@interface JHCustomizeAnchorLinkView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<NTESMicConnector *> *dataList;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) UIButton *detailBtn;

@property (nonatomic, strong) UIButton *linkBtn;

//@property (nonatomic, strong) UIButton *sendRedBtn;
//
//@property (nonatomic, strong) UIButton *orderBtn;
////! 鉴定记录
//@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, assign) NSInteger index;


@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *bottomToolBarView;
@property (nonatomic, strong) NSMutableArray <UIButton *>*bottomBtns;

@end

@implementation JHCustomizeAnchorLinkView

- (void)dealloc {
    [self.linkBtn removeObserver:self forKeyPath:@"selected" context:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *back = [[UIImageView alloc] initWithFrame:self.bounds];//WithImage:[UIImage imageNamed:@"bg_rect_black"]
        back.backgroundColor = UIColor.whiteColor;
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        back.layer.mask = maskLayer;
        [self addSubview:back];
        
        [self addSubview:self.scrollView];

        [self addSubview:self.bottomToolBarView];
        [self.bottomToolBarView addSubview:self.detailBtn];
        [self.bottomToolBarView addSubview:self.linkBtn];
//        [self.bottomToolBarView addSubview:self.sendRedBtn];
//        [self.bottomToolBarView addSubview:self.orderBtn];
//        [self.bottomToolBarView addSubview:self.recordBtn];
        
        _bottomBtns = @[].mutableCopy;
        [_bottomBtns addObject:self.detailBtn];
       // [_bottomBtns addObject:self.orderBtn];
        [_bottomBtns addObject:self.linkBtn];
       // [_bottomBtns addObject:self.recordBtn];
       // [_bottomBtns addObject:self.sendRedBtn];

        self.statusType = 0;
        
        [self addSubview:self.pageControl];
        
        [self creatItems];
        [self.linkBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        
        
    }
    return self;
}

#pragma mark - get
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.frame = CGRectMake(0, 20, ScreenW, 200);
        _scrollView.delegate = self;
        
    }
    
    return _scrollView;
}


- (UIScrollView *)bottomToolBarView {
    if(!_bottomToolBarView) {
        UIScrollView *bottomTollBarView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.mj_h-42-UI.bottomSafeAreaHeight, ScreenW, 32)];
        bottomTollBarView.showsHorizontalScrollIndicator = NO;
        bottomTollBarView.bounces = NO;
        _bottomToolBarView = bottomTollBarView;
    }
    return _bottomToolBarView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = (ScreenW - 60)/4.0;
    CGFloat buttonHeight = 32;
    CGFloat left = 15;
    CGFloat itemSpace = 10;
//    self.detailBtn.frame = CGRectMake(ScreenW- buttonWidth - left, 0, buttonWidth, buttonHeight);
      self.linkBtn.right = ScreenW - left;
      self.linkBtn.size = CGSizeMake(buttonWidth, buttonHeight);
    
    self.detailBtn.right = self.linkBtn.left - itemSpace;
    self.detailBtn.size = CGSizeMake(buttonWidth, buttonHeight);
    
    self.pageControl.center = CGPointMake(ScreenW/2., self.mj_h-60-UI.bottomSafeAreaHeight);
    
    
}
- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.backgroundColor = [UIColor clearColor];
        _detailBtn.layer.borderColor = [UIColor colorWithHexString:@"BDBFC2"].CGColor;
        _detailBtn.layer.borderWidth = 1;
        _detailBtn.layer.cornerRadius = 16;
        _detailBtn.layer.masksToBounds = YES;
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_detailBtn setTitle:@"看详情" forState:UIControlStateNormal];
        [_detailBtn setTitle:@"看详情" forState:UIControlStateSelected];
        [_detailBtn setTitle:@"看详情" forState:UIControlStateDisabled];
        
        [_detailBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _detailBtn;
}
- (UIButton *)linkBtn {
    if (!_linkBtn) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_linkBtn setBackgroundImage:[UIImage imageNamed:@"jh_img_link_bg"] forState:UIControlStateNormal];
        [_linkBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _linkBtn.layer.cornerRadius = 16;
        _linkBtn.clipsToBounds = YES;
        _linkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_linkBtn setTitle:@"连接" forState:UIControlStateNormal];
        [_linkBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        
        [_linkBtn setTitle:@"连麦中..." forState:UIControlStateDisabled];
        [_linkBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateDisabled];
        
        [_linkBtn setTitle:@"断开" forState:UIControlStateSelected];
        [_linkBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        
        [_linkBtn addTarget:self action:@selector(linkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _linkBtn;
}

//- (UIButton *)sendRedBtn {
//    if (!_sendRedBtn) {
//        _sendRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendRedBtn.backgroundColor = [UIColor clearColor];
//        _sendRedBtn.layer.cornerRadius = 16;
//        _sendRedBtn.layer.masksToBounds = YES;
//        _sendRedBtn.layer.borderColor = [UIColor colorWithHexString:@"BDBFC2"].CGColor;
//        _sendRedBtn.layer.borderWidth = 1;
//        _sendRedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//
//        [_sendRedBtn setTitle:@"发红包" forState:UIControlStateNormal];
//        [_sendRedBtn setTitleColor:kColor333 forState:UIControlStateNormal];
//
//        [_sendRedBtn addTarget:self action:@selector(sendRedAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _sendRedBtn;
//}
//
//- (UIButton *)orderBtn {
//    if (!_orderBtn) {
//        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _orderBtn.backgroundColor = [UIColor clearColor];
//        _orderBtn.layer.cornerRadius = 16;
//        _orderBtn.layer.masksToBounds = YES;
//        _orderBtn.layer.borderColor = [UIColor colorWithHexString:@"BDBFC2"].CGColor;
//        _orderBtn.layer.borderWidth = 1;
//        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//
//        [_orderBtn setTitle:@"看订单" forState:UIControlStateNormal];
//        [_orderBtn setTitleColor:kColor333 forState:UIControlStateNormal];
//
//        [_orderBtn addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _orderBtn;
//}
//
//- (UIButton *)recordBtn {
//    if (!_recordBtn) {
//        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        recordBtn.backgroundColor = [UIColor clearColor];
//
//        recordBtn.layer.cornerRadius = 16;
//        recordBtn.layer.masksToBounds = YES;
//        recordBtn.layer.borderColor = [UIColor colorWithHexString:@"BDBFC2"].CGColor;
//        recordBtn.layer.borderWidth = 1;
//        recordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//
//        [recordBtn setTitle:@"鉴定记录" forState:UIControlStateNormal];
//        [recordBtn setTitleColor:kColor333 forState:UIControlStateNormal];
//
//        [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
//        _recordBtn = recordBtn;
//    }
//
//    return _recordBtn;
//}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        
    }
    return _pageControl;
}

- (void)creatItems {
    
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (!self.dataList || self.dataList.count == 0) {
        return;
    }
    
    CGFloat ww = 60;
    CGFloat hh = 90;
    CGFloat space = (ScreenW-ww*5)/6.;
    
    NSInteger page = ceil(self.dataList.count/10.);
    _scrollView.contentSize = CGSizeMake(page*ScreenW, _scrollView.mj_h);
    _pageControl.numberOfPages = page;
    _pageControl.currentPage = 0;
    
    self.itemsArray = [NSMutableArray array];
    
    for (int p = 0; p<page; ++p) {
        for (int i = 0; i < 2; ++i) {
            for (int j = 0; j<5; j++) {
                int index = p*10+i*5+j;
                if (index<_dataList.count) {
                    JHAnchorLinkerCell *cell = [[JHAnchorLinkerCell alloc] initWithFrame:CGRectMake(p*ScreenW+space + (space + ww) * j, hh * i, ww, hh)];
                    cell.userInteractionEnabled = YES;
                    NTESMicConnector *model = self.dataList[index];
                    cell.model = self.dataList[index];
                    cell.tag = index;
                    if (self.selectedModel) {
                        if ([self.selectedModel.uid isEqualToString:model.uid]) {
                            self.index = index;
                        }
                    }else{
                        self.index = 0;
                        self.selectedModel = self.dataList[0];
                    }
                    if (index == self.index) {
                        cell.selected = YES;
                    }else {
                        cell.selected = NO;
                    }
                    
                    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedCell:)]];
                    [_scrollView addSubview:cell];
                    [self.itemsArray addObject:cell];
                    
                }
                
            }
            
        }
    }
    
}

#pragma mark -- Actions
//- (void)sendRedAction:(UIButton *)btn {
//  //  [self hiddenAlert];
//    if (self.index>=self.dataList.count) {
//        return;
//    }
//
//    if (_delegate && [_delegate respondsToSelector:@selector(sendRedPocket:model:)]) {
//        [_delegate sendRedPocket:self.index model:self.dataList[self.index]];
////        self.selectedModel = nil;
//        [self hiddenAlert];
//    }
//}
//- (void)orderAction:(UIButton *)btn {
//
//  //  [self hiddenAlert];
//    if (self.index>=self.dataList.count) {
//        return;
//    }
//    if (_delegate && [_delegate respondsToSelector:@selector(lookOrderList:model:)]) {
//        [_delegate lookOrderList:self.index model:self.dataList[self.index]];
//    }
//}
- (void)linkAction:(UIButton *)btn {
    if (self.index>=self.dataList.count) {
        return;
    }
    if (_statusType == 0) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(connectUser:model:)]) {
            [_delegate connectUser:self.index model:self.dataList[self.index]];
        }
        
    }else if (_statusType == 2) {
        [self hiddenAlert];
        if (_delegate && [_delegate respondsToSelector:@selector(disconnectUser:model:)]) {
            [_delegate disconnectUser:self.index model:self.dataList[self.index]];
            self.selectedModel = nil;
        }
    }
}

- (void)detailAction:(UIButton *)btn {
    
    if (self.index>=self.dataList.count) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(disconnectUser:model:)]) {
               [_delegate lookUserDetail:self.index model:self.dataList[self.index]];
           }
    
}

//- (void)recordAction {
//
//    if (!self.selectedModel ) {
//        return;
//    }
//
//    [self hiddenAlert];
//
//    if (_delegate && [_delegate respondsToSelector:@selector(lookOrderList:model:)]) {
//        [_delegate showRecordList:self.index model:self.dataList[self.index]];
//    }
//
//}

- (void)selectedCell:(UITapGestureRecognizer *)gest {
    
    if (self.selectedModel ) {
        
        if (
            self.selectedModel.state==NTESLiveMicStateConnected||
            self.selectedModel.state==NTESLiveMicStateWait) {
            return;
            
        }
    }
    self.index = gest.view.tag;
    self.selectedModel = self.dataList[self.index];
    [self refreshData];
    
    self.statusType=0;
    
    switch (self.selectedModel.state) {
        case NTESLiveMicStateWait:
            
            self.statusType=1;
            
            break;
        case NTESLiveMicStateConnected:
            
            self.statusType=2;
            
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)refreshData {
    for (NSInteger i = 0; i<self.itemsArray.count; i++) {
        JHAnchorLinkerCell *cell = self.itemsArray[i];
        cell.selected = i == self.index;
    }
    
    if (self.detailBtn.selected) {
        self.detailBtn.hidden = ![self isReporterBtnEnable];
    }
}

- (BOOL)isReporterBtnEnable {
    NSInteger b = 1;
    NTESAnchorLiveViewController *vc = (NTESAnchorLiveViewController *)self.viewController;
    if ([vc isKindOfClass:[NTESAnchorLiveViewController class]]) {
        b = [vc.sendedReporterList[self.selectedModel.appraiseRecordId] integerValue]?0:1;
        NSLog(@"sendedReporterList=====%@",vc.sendedReporterList);
        
    }
    
    return b;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.linkBtn && [keyPath isEqualToString:@"selected"]) {
        [self layoutSubviews];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark - public

- (void)reloadData:(NSMutableArray *)array {
    
    self.dataList = array;
    if (self.selectedModel) {
        BOOL b = NO;
        for (NTESMicConnector *mic in array) {
            if ([mic.uid isEqualToString:self.selectedModel.uid]) {
                self.selectedModel = mic;
                b = YES;
                break;
            }
        }
        if (b == NO) {
            self.selectedModel = nil;
        }

    }
    
    [self creatItems];
    [self refreshData];
}

- (void)showAlert {
    if (self.detailBtn.selected) {
        self.detailBtn.hidden = ![self isReporterBtnEnable];
    }else {
        self.detailBtn.hidden = NO;
    }
    
    [self layoutSubviews];
    CGRect rect = self.frame;
    rect.origin.y = ScreenH - rect.size.height;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    
}

- (void)hiddenAlert{
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)setStatusType:(NSInteger)statusType {
    CGFloat buttonWidth = (ScreenW - 60)/4.0;
    CGFloat buttonHeight = 32;
    CGFloat left = 15;
    CGFloat itemSpace = 10;
    _statusType = statusType;
    switch (statusType) {
        case 0:
        {
            self.linkBtn.selected = NO;
            self.linkBtn.enabled = YES;
            self.detailBtn.selected = NO;
        //    self.detailBtn.frame = CGRectMake(ScreenW- buttonWidth - left, 0, buttonWidth, buttonHeight);
            
            self.linkBtn.size = CGSizeMake(buttonWidth, buttonHeight);
            self.linkBtn.right = ScreenW - left;
            self.detailBtn.right = self.linkBtn.left - itemSpace;
        }
            break;
        case 1:
        {
            self.linkBtn.selected = NO;
            self.linkBtn.enabled = NO;
            self.detailBtn.selected = NO;
            
            self.linkBtn.size = CGSizeMake(buttonWidth+40, buttonHeight);
            self.linkBtn.right = ScreenW - left;
            self.detailBtn.right = self.linkBtn.left - itemSpace;
        }
            break;
        case 2:
        {
            self.linkBtn.selected = YES;
            self.linkBtn.enabled = YES;
            self.detailBtn.selected = YES;
            
            self.linkBtn.size = CGSizeMake(buttonWidth, buttonHeight);
            self.linkBtn.right = ScreenW - left;
            self.detailBtn.right = self.linkBtn.left - itemSpace;
        }
            
            break;
            
        default:
            break;
            
    }
}

-(void)setTimeCount:(NSInteger)timeCount{
    
    if (self.statusType==1) {
        
        [_linkBtn setTitle:[NSString stringWithFormat:@"连麦中...(%lds)",(long)timeCount] forState:UIControlStateDisabled];
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / ScreenW);
}

@end

