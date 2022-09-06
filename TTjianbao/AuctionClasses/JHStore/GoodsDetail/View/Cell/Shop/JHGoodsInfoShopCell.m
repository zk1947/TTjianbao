//
//  JHGoodsInfoShopCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsInfoShopCell.h"
#import "JHGoodsDetailHeaderShopPanel.h"
#import "CGoodsDetailModel.h"
#import "GrowingManager.h"
#import "JHShopHomeController.h"


@interface JHGoodsInfoShopCell ()

@property (nonatomic, strong) JHGoodsDetailHeaderShopPanel *shopPanel;

@end


@implementation JHGoodsInfoShopCell

+ (CGFloat)cellHeight {
    return 84;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)setShopInfo:(CShopInfo *)shopInfo {
    if (!shopInfo) {
        return;
    }
    _shopInfo = shopInfo;
    _shopPanel.shopInfo = _shopInfo;
}

- (void)configUI {
    _shopPanel = [[JHGoodsDetailHeaderShopPanel alloc] init];
    _shopPanel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_shopPanel];
    [_shopPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    @weakify(self);
    _shopPanel.enterShopBlock = ^(NSInteger sellerId) {
        @strongify(self);
        [self enterShopHomePage:sellerId];
    };
}

- (void)enterShopHomePage:(NSInteger)sellerId {
    if (self.enterShopBlock) {
        self.enterShopBlock(sellerId);
    }
}



@end
