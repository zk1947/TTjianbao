//
//  JHMallSelectMoreController.m
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSelectMoreController.h"
#import "JHMallMoreCategoryView.h"
#import "TTjianbao.h"

@interface JHMallSelectMoreController ()

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) JHMallMoreCategoryView *categoryView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, assign) CGFloat categoryHeight;

@end

@implementation JHMallSelectMoreController

- (void)dealloc {
    
    NSLog(@"%s被释放了🔥🔥🔥", __func__);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLORA(0x000000, .4f);
    _categoryHeight = 0.f;
    [self setupViews];
}

- (void)setupViews {
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    _naviView = navView;
    
    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.text = @"全部分类";
    allLabel.backgroundColor = [UIColor whiteColor];
    allLabel.font = [UIFont fontWithName:kFontMedium size:16];
    allLabel.textColor = kColor333;
    [_naviView addSubview:allLabel];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setImage:[UIImage imageNamed:@"iocn_mall_more_fold"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"iocn_mall_more_fold"] forState:UIControlStateHighlighted];
    [moreBtn addTarget:self action:@selector(handleMoreButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [_naviView addSubview:moreBtn];
    _moreButton = moreBtn;
    
    JHMallMoreCategoryView *cateView = [[JHMallMoreCategoryView alloc] init];
    cateView.backgroundColor = [UIColor whiteColor];
    cateView.channelArray = self.channelArray;
    cateView.selectBlock = self.selectBlock;
    [self.view insertSubview:cateView belowSubview:_naviView];
    _categoryView = cateView;
    @weakify(self);
    cateView.heightBlock = ^(CGFloat height) {
        @strongify(self);
        [self changeCategoryViewHeight:height];
    };
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(UI.statusAndNavBarHeight+50);
    }];
    
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(14);
        make.bottom.equalTo(navView).offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView);
        make.centerY.equalTo(allLabel);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];

    [cateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(navView);
        make.bottom.equalTo(self.naviView);
        make.height.mas_equalTo(self.categoryHeight);
    }];
}

- (void)changeCategoryViewHeight:(CGFloat)height {
    self.categoryHeight = height;
    [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.categoryHeight);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCategorys];
}

- (void)showCategorys {
    [UIView animateWithDuration:.25f animations:^{
        CGRect rect = self.categoryView.frame;
        rect.size.height = self.categoryHeight;
        self.categoryView.frame = rect;
        [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.naviView.mas_bottom).offset(self.categoryHeight);
        }];
        [self.view layoutIfNeeded];
        [self startAnimation];
    }];
}

- (void)handleMoreButtonEvent {
    self.categoryHeight = 0.;
    [self startAnimation];
    [UIView animateWithDuration:.25f animations:^{
        [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.naviView.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleMoreButtonEvent];
}

- (void)startAnimation {
    [UIView animateWithDuration:0.25f animations:^{
        if (self.moreButton) {
            CGAffineTransform transform  = self.moreButton.transform;
            self.moreButton.transform = CGAffineTransformRotate(transform, M_PI);
        }
    }];
}

@end
