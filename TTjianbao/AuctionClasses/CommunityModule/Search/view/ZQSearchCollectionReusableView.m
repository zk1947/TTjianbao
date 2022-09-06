//
//  ZQSearchCollectionReusableView.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchCollectionReusableView.h"
#import "UIColor+ZQSearch.h"
#import "ZQSearchConst.h"
#import "UIButton+zan.h"
#import "TTjianbaoHeader.h"

@interface ZQSearchCollectionReusableView()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *moreImgV;



@property (nonatomic, weak) UIView *topGapV;

@property (nonatomic, copy) emptyBlock block;

@end

@implementation ZQSearchCollectionReusableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
//    UIView *topGapV = [UIView new];
//    topGapV.backgroundColor = HEXCOLOR(0xf8f8f8);
//    [self addSubview:topGapV];
//    self.topGapV = topGapV;
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor colorWithHexString:@"#494949" alpha:1];
    self.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [self addSubview:self.label];
    
    self.moreImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_searchUnfold"]];
    self.moreImgV.hidden = YES;
    [self addSubview:self.moreImgV];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.hidden = YES;
    [deleteBtn setImage:[UIImage imageNamed:@"dis_searchDelete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    self.button = deleteBtn;
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.moreBtn.hidden = YES;
    [self addSubview:self.moreBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.topGapV.frame = CGRectMake(0, 0, ScreenW, 5);
    
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20, 5, self.label.frame.size.width, self.height-5);
    
    [self.button sizeToFit];
    self.button.frame = CGRectMake(ZQSearchWidth - 30 - 10, 5, 20, self.height-5);
    
    [self.moreImgV sizeToFit];
    self.moreImgV.frame = CGRectMake(CGRectGetMaxX(self.label.frame)+3, self.label.frame.origin.y + (self.label.frame.size.height - 7)*0.5, 12, 7);
    
    self.moreBtn.frame = CGRectMake(20, self.label.frame.origin.y, CGRectGetMaxX(self.moreImgV.frame), 20);
}

- (void)showDeleteHistoryBtn:(BOOL)show
                 showMoreBtn:(BOOL)showMore
                unfoldStatus:(BOOL)showAll
                    CallBack:(void(^)(void))callBack {
    self.button.hidden = !show;
    self.moreImgV.hidden = !showMore;
    self.moreBtn.hidden = !show;
    self.block = callBack;
    
    
    if (showAll) {
        self.moreBtn.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
                        self.moreImgV.transform = CGAffineTransformIdentity;
//            self.moreImgV.transform = CGAffineTransformRotate(self.moreImgV.transform, M_PI);
        }];
    }else {
        self.moreBtn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.moreImgV.transform = CGAffineTransformRotate(self.moreImgV.transform, -M_PI);
        }];
    }
    
}
- (void)moreBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [UIView animateWithDuration:0.25 animations:^{
          self.moreImgV.transform = CGAffineTransformRotate(self.moreImgV.transform, -M_PI);
        }];
        if (self.foldBlock) {
            self.foldBlock(NO);
        }
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.moreImgV.transform = CGAffineTransformIdentity;
//            self.moreImgV.transform = CGAffineTransformRotate(self.moreImgV.transform, M_PI);
        }];
        if (self.foldBlock) {
            self.foldBlock(YES);
        }
    }
    
    NSLog(@"更多");
}

- (void)deleteBtnClicked {
    if (self.block) {
        self.block();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
    [self layoutIfNeeded];
}

@end
