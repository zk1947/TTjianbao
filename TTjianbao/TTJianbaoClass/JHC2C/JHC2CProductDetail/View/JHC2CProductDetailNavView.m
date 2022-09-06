//
//  JHC2CProductDetailNavView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailNavView.h"

#import "JHC2CProductDetailBusiness.h"


typedef NS_ENUM(NSUInteger, TopNavAnimateViewType) {
    TopNavAnimateViewType_See = 0,
    TopNavAnimateViewType_Save,
    MyEnumValueCTopNavAnimateViewType_Only,
};


@interface TopNavAnimateView : UIView

@property(nonatomic, assign) TopNavAnimateViewType  type;

@property(nonatomic, strong) NSMutableArray<UIImageView*>* iconViewArr;
@property(nonatomic, strong) UILabel * noticeLbl;

@end

@implementation TopNavAnimateView

- (instancetype)initWithType:(TopNavAnimateViewType)type{
    if (self = [super initWithFrame:CGRectZero]) {
        self.type = type;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    switch (self.type) {
        case TopNavAnimateViewType_See:
        {
            [self addIconViewsWithCount:3];
            [self addTitleLlbWithText:@"344人正在浏览此商品"];
        }
            break;
        case TopNavAnimateViewType_Save:
        {
            [self addIconViewsWithCount:4];
            [self addTitleLlbWithText:@"9分钟前收藏了此商品"];
        }
            break;
        case MyEnumValueCTopNavAnimateViewType_Only:
        {
            [self addTitleLlbWithText:@"库存仅为1件，先到先得！"];
        }
            break;
        default:
            break;
    }
    
}

- (void)layoutItems{
    UIImageView *lastView = nil;
    for (int i = 0; i < self.iconViewArr.count; i++) {
        UIImageView* imageView = self.iconViewArr[i];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerY.equalTo(@0);
            if (lastView) {
                make.left.equalTo(lastView).offset(16);
            }else{
                make.left.equalTo(@0);
            }
        }];
        lastView = imageView;
    }
    [self.noticeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        if (lastView) {
            make.left.equalTo(lastView.mas_right).offset(6);
        }else{
            make.left.equalTo(@0);
        }
    }];
}

- (void)addIconViewsWithCount:(NSInteger)count{
    self.iconViewArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 12;
        imageView.image = kDefaultAvatarImage;
        [self addSubview:imageView];
        [self.iconViewArr addObject:imageView];
    }
    
}

- (void)addTitleLlbWithText:(NSString*)text{
    self.noticeLbl.text = text;
    [self addSubview:self.noticeLbl];
}

#pragma mark -- <set and get>

- (UILabel *)noticeLbl{
    if (!_noticeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x222222);
        _noticeLbl = label;
    }
    return _noticeLbl;
}
@end



@interface JHC2CProductDetailNavView()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) NSMutableArray<TopNavAnimateView*>* subViewArray;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, strong) JHC2CProductDetailUserListModel * seeModel;

@property(nonatomic, strong) JHC2CProductDetailUserListModel * wantModel;


@end

@implementation JHC2CProductDetailNavView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setProductID:(NSString *)productID{
    _productID = productID;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    [JHC2CProductDetailBusiness requestC2CProductDetailSeeCount:self.productID completion:^(NSError * _Nullable error, JHC2CProductDetailUserListModel * _Nullable model) {
        self.seeModel = model;
        dispatch_group_leave(group);
    }];
    
    [JHC2CProductDetailBusiness requestC2CProductDetailCollectCount:self.productID completion:^(NSError * _Nullable error, JHC2CProductDetailUserListModel * _Nullable model) {
        self.wantModel = model;

        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setItems];
        [self layoutItems];
    });
}

- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.quanBtn];
    [self.backView addSubview:self.wechatBtn];
    
    // 已售出商品不展示 库存、收藏、浏览
    if ([self.dataModel.productStatus isEqualToString:@"4"] || [self.auModel.flowStatus isEqualToString:@"2"]) return;
    
    TopNavAnimateView *noticeView = [[TopNavAnimateView alloc] initWithType:MyEnumValueCTopNavAnimateViewType_Only];
    noticeView.hidden = NO;
    [self.subViewArray addObject:noticeView];
    [self.backView addSubview:noticeView];
   
    // 下架商品 不展示收藏、浏览
    NSArray *list = @[@"20",@"21",@"22",@"30",@"31",@"32",@"33",@"35"];
    NSString *status = [NSString stringWithFormat:@"%@", @(self.auModel.productDetailStatus) ];
    if ([self.dataModel.productStatus isEqualToString:@"1"] || (self.auModel != nil && ![list containsObject: status])) return;
    
    if (self.seeModel.userResponses.count) {
        TopNavAnimateView *seeView = [[TopNavAnimateView alloc] initWithType:TopNavAnimateViewType_See];
        seeView.hidden = YES;
        [self.backView addSubview:seeView];
        [self.subViewArray addObject:seeView];
        
        NSInteger peopleCount = self.seeModel.num.integerValue;
        seeView.noticeLbl.text = [NSString stringWithFormat:@"%ld人正在浏览此商品",peopleCount];
        NSInteger count = MIN(self.seeModel.userResponses.count, 3);
        UIView *lastView = nil;
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = seeView.iconViewArr[i];
            if (i < count) {
                JHC2CSeeUserInfo *info = self.seeModel.userResponses[i];
                [imageView jhSetImageWithURL:[NSURL URLWithString:info.img] placeholder:kDefaultAvatarImage];
                lastView = imageView;
            }
            imageView.hidden = i >= count;
        }
        
        [seeView.noticeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(lastView.mas_right).offset(6);
        }];
    }
    if (self.wantModel.userResponses.count) {
        TopNavAnimateView *saveView = [[TopNavAnimateView alloc] initWithType:TopNavAnimateViewType_Save];
        saveView.hidden = YES;
        [self.backView addSubview:saveView];
        [self.subViewArray addObject:saveView];
        saveView.noticeLbl.text = [NSString stringWithFormat:@"%@分钟前收藏了此商品",self.wantModel.time];
        NSInteger count = MIN(self.wantModel.userResponses.count, 4);
        UIView *lastView = nil;
        for (int i = 0; i < 4; i++) {
            UIImageView *imageView = saveView.iconViewArr[i];
            if (i < count) {
                JHC2CSeeUserInfo *info = self.wantModel.userResponses[i];
                [imageView jhSetImageWithURL:[NSURL URLWithString:info.img] placeholder:kDefaultAvatarImage];
                lastView = imageView;
            }
            imageView.hidden = i >= count;
        }
        
        [saveView.noticeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(lastView.mas_right).offset(6);
        }];
    }
    
    self.currentIndex = 0;
    if (self.subViewArray.count > 1) {
        @weakify(self);
        self.timer = [NSTimer timerWithTimeInterval:3 block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self moveNext];
        } repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}


- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.mas_equalTo(UI.navBarHeight);
    }];
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(@0);
    }];
    [self.quanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wechatBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerY.equalTo(@0);
    }];
    
    for (int i = 0; i< self.subViewArray.count; i++) {
        [self.subViewArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(@0);
            make.right.equalTo(@0).offset(-75);
        }];
    }
}

- (void)moveNext{
    TopNavAnimateView *currentView = self.subViewArray[self.currentIndex];
    NSInteger nextIndex = self.currentIndex + 1;
    if (nextIndex == self.subViewArray.count) {
        nextIndex = 0;
    }
    TopNavAnimateView *nextView = self.subViewArray[nextIndex];
    nextView.transform = CGAffineTransformMakeTranslation(0, UI.navBarHeight);
    nextView.hidden = NO;
    [UIView animateWithDuration:0.6 animations:^{
        currentView.transform = CGAffineTransformMakeTranslation(0, -UI.navBarHeight);
        nextView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        currentView.hidden = YES;
    }];
    self.currentIndex = nextIndex;
}


#pragma mark -- <set and get>

- (NSMutableArray<TopNavAnimateView *> *)subViewArray{
    if (!_subViewArray) {
        _subViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _subViewArray;
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.layer.masksToBounds = YES;
        _backView = view;
    }
    return _backView;
}

- (UIButton *)quanBtn{
    if (!_quanBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_wechatquan"] forState:UIControlStateNormal];
        _quanBtn = btn;
    }
    return _quanBtn;
}

- (UIButton *)wechatBtn{
    if (!_wechatBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_wechat"] forState:UIControlStateNormal];
        _wechatBtn = btn;
    }
    return _wechatBtn;
}

@end



