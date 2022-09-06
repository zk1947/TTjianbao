//
//  JHPhotoExampleViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPhotoExampleViewController.h"
#import "JHRecyclePhotoExampleView.h"
#import "JHRecycleUploadProductBusiness.h"

@interface JHPhotoExampleViewController ()

@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * descLabel;

@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, strong) JHRecyclePhotoExampleView * oneProductView;
@property(nonatomic, strong) JHRecyclePhotoExampleView * moreProductView;

@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * multiImgModelArr;
@property(nonatomic, copy) NSString *showString;

@end

@implementation JHPhotoExampleViewController

- (instancetype)init{
    if (self = [super init]) {
        [self setModalPresentationStyle:UIModalPresentationCustom];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    [self setItems];
    [self layoutItems];
    @weakify(self);
    
    if (self.useLocalData) {
        [self refreshImageViews];
    }else{
        [JHRecycleUploadProductBusiness requestRecycleUploadQueryExampleCategoryId:self.categoryId.integerValue Completion:^(NSError * _Nullable error, JHRecycleUploadExampleTotalModel * _Nullable model) {
            @strongify(self);
            if (!error) {
                self.singleModelArr = model.singleImgSimples;
                self.multiImgModelArr = model.multiImgSimples;
                self.showString = model.sampleDesc;
                [self refreshImageViews];
            }
        }];

    }
    
    
}


- (void)refreshImageViews{
    self.descLabel.text = self.showString;
    if (self.showType == 1) {
        [self.scrollView addSubview:self.oneProductView];
        [self.oneProductView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            
        }];
        self.titleLbl.text = @"拍摄示例";
    }else if(self.showType == 2){
        [self.scrollView addSubview:self.moreProductView];
        [self.moreProductView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
        self.titleLbl.text = @"拍摄示例";
    }
//    [self.scrollView addSubview:self.oneProductView];
//    [self.scrollView addSubview:self.moreProductView];
//    [self.oneProductView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(@0);
//        make.width.mas_equalTo(ScreenWidth);
//    }];
//    [self.moreProductView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(@0);
//        make.top.equalTo(self.oneProductView.mas_bottom).offset(20);
//    }];
}


- (void)setItems{
    ///模糊图层
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:blurEffectView];
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.scrollView];
    
}

- (void)layoutItems{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0).offset(UI.navBarHeight);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(39);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0).offset(-35);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(UI.statusAndNavBarHeight + 10);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(-20);
    }];
}

- (void)closeActionWithSender:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- <set and get>

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"recycle_photo_example_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(24);
        label.text = @"拍摄示例";
        label.textColor = HEXCOLOR(0xffffff);
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.font = JHFont(14);
        label.textColor = HEXCOLOR(0xffffff);
        _descLabel = label;
    }
    return _descLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scView = [UIScrollView new];
        _scrollView = scView;
    }
    return _scrollView;

}

- (JHRecyclePhotoExampleView *)oneProductView{
    if (!_oneProductView) {
        NSString *title = self.useLocalData ? @"示例" : @"单个钱币示例";
        _oneProductView = [[JHRecyclePhotoExampleView alloc] initWithTitle:title andImageArray:self.singleModelArr];
    }
    return _oneProductView;
}

- (JHRecyclePhotoExampleView *)moreProductView{
    if (!_moreProductView) {
        _moreProductView = [[JHRecyclePhotoExampleView alloc] initWithTitle:@"多个钱币示例" andImageArray:self.multiImgModelArr];
    }
    return _moreProductView;
}

@end
