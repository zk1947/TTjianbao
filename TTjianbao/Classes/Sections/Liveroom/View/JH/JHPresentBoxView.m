//
//  JHPresentBoxView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPresentBoxView.h"
#import "JHPresentItemView.h"
#import "NTESLiveManager.h"
#import "JHMyBeanViewController.h"
#import "UIView+NTES.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"

@interface JHPresentBoxView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) UILabel *beanCount;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, assign) NSInteger index;


@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation JHPresentBoxView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *back = [[UIImageView alloc] initWithFrame:self.bounds];//WithImage:[UIImage imageNamed:@"bg_rect_black"]
        back.backgroundColor = HEXCOLORA(0x000000, 0.8);
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        back.layer.mask = maskLayer;
        [self addSubview:back];
        
        
        [self addSubview:self.scrollView];
        
        [self addSubview:self.pageControl];
        
        [self creatItems];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live_bean"]];
        img.contentMode = UIViewContentModeCenter;
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight);
            make.height.equalTo(@44);
        }];
        
        [self addSubview:self.beanCount];
        [self.beanCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.bottom.equalTo(img);
            make.leading.equalTo(img.mas_trailing).offset(10);
        }];
     
        UILabel *label = [UILabel new];
        label.text = @"鉴豆";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = HEXCOLOR(0xa7a7a7);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.beanCount.mas_trailing).offset(2);
            make.bottom.height.equalTo(self.beanCount);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"充值" forState:UIControlStateNormal];
        [btn setTitleColor:kGlobalThemeColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.beanCount);
            make.leading.equalTo(label.mas_trailing);
            make.width.equalTo(@(60));
        }];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_yellow"]];
        [btn addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(btn);
            make.centerY.equalTo(btn);
        }];
        
        [self addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self.beanCount);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBean) name:NotificationNameRechargeSuccess object:nil];
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
        _scrollView.frame = CGRectMake(0, 0, ScreenW, 210);
        _scrollView.delegate = self;
        
    }
    
    return _scrollView;
}

- (void)layoutSubviews {
 
    self.pageControl.center = CGPointMake(ScreenW/2., self.mj_h-50);
    
}

- (UILabel *)beanCount {
    if (!_beanCount) {
        _beanCount = [UILabel new];
        _beanCount.textColor = kGlobalThemeColor;
        _beanCount.font = [UIFont systemFontOfSize:12];
        User *user = [UserInfoRequestManager sharedInstance].user;
        _beanCount.text = user.balance;
    }
    
    return _beanCount;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"bg_send_present"] forState:UIControlStateNormal];        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        
        
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendBtn;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        
    }
    return _pageControl;
}

- (void)creatItems {
    NSArray *array = [NTESLiveManager sharedInstance].presentArray;
    self.dataList = [NSMutableArray array];
    [self.dataList addObjectsFromArray:array];
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (!self.dataList || self.dataList.count == 0) {
        [self requestPresentList];
        return;
    }
    
    CGFloat ww = ScreenW/4.;
    CGFloat hh = 100;
    CGFloat space = 0.0;
    
    NSInteger page = ceil(self.dataList.count/8.);
    _scrollView.contentSize = CGSizeMake(page*ScreenW, _scrollView.mj_h);
    _pageControl.numberOfPages = page;
    _pageControl.currentPage = 0;

    if (page<=1) {
        _pageControl.hidden = YES;
    }else {
        _pageControl.hidden = NO;
    }
    self.itemsArray = [NSMutableArray array];
    
    for (int p = 0; p<page; ++p) {
        for (int i = 0; i < 2; ++i) {
            for (int j = 0; j<4; j++) {
                int index = p*8+i*4+j;
                if (index<_dataList.count) {
                    JHPresentItemView *cell = [[JHPresentItemView alloc] initWithFrame:CGRectMake(p*ScreenW+space + (space + ww) * j, hh * i, ww, hh)];
                    cell.userInteractionEnabled = YES;
                    cell.tag = index;
                    cell.model = self.dataList[index];
                    cell.tag = index;
                    
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

- (void)rechargeAction {
    JHMyBeanViewController *vc = [[JHMyBeanViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


- (void)sendAction:(UIButton *)btn {
    if (self.index>=self.dataList.count) {
        return;
    }
    

    NTESPresent *p = self.dataList[self.index];
    NSInteger balance = [[UserInfoRequestManager sharedInstance].user.balance integerValue];
    if (p.price>balance) {
//        [self makeToast:@"津贴不足，请充值"];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"您的鉴豆不足，请先充值" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self rechargeAction];
        }]];
        [self.viewController presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    if (self.sendPresnt) {
        
        self.sendPresnt(self.dataList[self.index]);
    }

}

- (void)selectedCell:(UIGestureRecognizer *)gest {
    if (self.index<self.itemsArray.count) {
        JHPresentItemView *oldcell = self.itemsArray[self.index];
        oldcell.selected = NO;
    }
    
    JHPresentItemView *cell = self.itemsArray[gest.view.tag];
    cell.selected = YES;
    self.index = gest.view.tag;
}


#pragma mark - public

- (void)reloadData:(NSMutableArray *)array {
    
    self.dataList = array;
    [self creatItems];
}

- (void)showAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH - rect.size.height;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / ScreenW);
    
}
- (void)updateBean {
        
    self.beanCount.text = [UserInfoRequestManager sharedInstance].user.balance;
}

- (void)requestPresentList {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/gift/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [UserInfoRequestManager sharedInstance].user.balance = [NSString stringWithFormat:@"%@",respondObject.data[@"balance"]];// [((NSNumber *)respondObject.data[@"balance"]) stringValue];
        
                [NTESLiveManager sharedInstance].presents = [NSMutableDictionary dictionary];
        [NTESLiveManager sharedInstance].presentArray = [NSMutableArray array];
        
        
        
        NSArray *present = [NTESPresent mj_objectArrayWithKeyValuesArray:respondObject.data[@"gifts"]];
        for (NTESPresent *p in present) {
            [[NTESLiveManager sharedInstance].presents setObject:p forKey:p.Id];
            [[NTESLiveManager sharedInstance].presentArray addObject:p];
        }
        
        [self creatItems];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

@end
