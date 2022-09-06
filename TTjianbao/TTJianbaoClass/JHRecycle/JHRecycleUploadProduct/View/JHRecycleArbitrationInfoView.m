//
//  JHRecycleArbitrationInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleArbitrationInfoView.h"
#import "JHRecycleArbitrationDetailView.h"
#import "JHRecycleArbitrationPicturesView.h"

@interface JHRecycleArbitrationInfoView()

/// 滚动试图
@property(nonatomic, strong) UIScrollView * backScrollView;

/// 仲裁说明
@property(nonatomic, strong) JHRecycleArbitrationDetailView * productIllustrationView;

/// 仲裁图片
@property(nonatomic, strong) JHRecycleArbitrationPicturesView * productDetailView;


@end

@implementation JHRecycleArbitrationInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.productIllustrationView];
    [self.backScrollView addSubview:self.productDetailView];
}

- (void)layoutItems{
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.productIllustrationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(89);
    }];
    [self.productDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productIllustrationView.mas_bottom).offset(10);
        make.left.bottom.right.equalTo(@0);
    }];
}

- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    [self.productDetailView addProductDetailPictureWithName:model];
}
- (void)resignFirst{
    [self.productIllustrationView.textView resignFirstResponder];
}
#pragma mark -- <set and get>

- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        _backScrollView = view;
    }
    return _backScrollView;
}

- (void)setAddProductDetailBlock:(void (^)(NSInteger))addProductDetailBlock{
    self.productDetailView.addProductDetailBlock = addProductDetailBlock;
}

- (JHRecycleArbitrationPicturesView *)productDetailView{
    if (!_productDetailView) {
        JHRecycleArbitrationPicturesView *view = [JHRecycleArbitrationPicturesView new];
        _productDetailView = view;
    }
    return _productDetailView;
}

- (JHRecycleArbitrationDetailView *)productIllustrationView{
    if (!_productIllustrationView) {
        JHRecycleArbitrationDetailView *view = [JHRecycleArbitrationDetailView new];
        _productIllustrationView = view;
    }
    return _productIllustrationView;
}

- (NSString *)detailString{
    return self.productIllustrationView.textView.text;
}
- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return self.productDetailView.productDetailPictureArr;
}
@end
