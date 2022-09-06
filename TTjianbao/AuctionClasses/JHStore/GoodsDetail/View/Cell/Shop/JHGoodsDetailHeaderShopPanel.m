//
//  JHGoodsDetailHeaderShopPanel.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailHeaderShopPanel.h"

#import "JHShopHomeController.h"
#import "YYControl.h"

#import "GrowingManager.h"

@interface JHGoodsDetailHeaderShopPanel ()

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *logoIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *intoLabel;
@property (nonatomic, strong) UIImageView *arrowIcon; //icon_kind_right_arrow

@end

@implementation JHGoodsDetailHeaderShopPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _contentControl = [YYControl new];
    _contentControl.backgroundColor = [UIColor clearColor];
    _contentControl.layer.cornerRadius = 4;
    _contentControl.clipsToBounds = YES;
    _contentControl.exclusiveTouch = YES;
    [self addSubview:_contentControl];
    @weakify(self);
    _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                [self enterShopHomeVC];
            }
        }
    };
    
    _logoIcon = [UIImageView new];
    _logoIcon.image = kDefaultAvatarImage;
    //[_logoIcon doCircleFrame];
    _logoIcon.clipsToBounds = YES;
    _logoIcon.sd_cornerRadiusFromHeightRatio = @0.5;
    _logoIcon.layer.borderWidth = 1;
    _logoIcon.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
    
    _nameLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15]
                              textColor:[UIColor blackColor]];
    
    _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12]
                              textColor:kColor666];
    
    _intoLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14]
                              textColor:kColor666];
    
    _arrowIcon = [UIImageView new];
    
    [self sd_addSubviews:@[_logoIcon, _nameLabel, _descLabel, _intoLabel, _arrowIcon]];
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _logoIcon.sd_layout
    .leftSpaceToView(self, 15)
    .centerYEqualToView(self)
    .widthIs(50).heightEqualToWidth();
    
    _nameLabel.sd_layout
    .leftSpaceToView(_logoIcon, 5)
    .rightSpaceToView(self, 58)
    .topEqualToView(_logoIcon).offset(0)
    .heightIs(25);
    
    _descLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self, 58)
    .bottomEqualToView(_logoIcon).offset(0)
    .heightIs(20);
    
    _arrowIcon.sd_layout
    .rightSpaceToView(self, 15)
    .centerYEqualToView(self)
    .widthIs(5).heightIs(8);
    
    _intoLabel.sd_layout
    .rightSpaceToView(_arrowIcon, 5)
    .centerYEqualToView(self)
    .widthIs(28).heightIs(30);
}

- (void)setShopInfo:(CShopInfo *)shopInfo {
    _shopInfo = shopInfo;
    
    [_logoIcon jhSetImageWithURL:[NSURL URLWithString:shopInfo.head_img]
                              placeholder:[UIImage imageNamed:@"icon_live_default_avatar"]];
    _nameLabel.text = shopInfo.name;
    ///shopInfo.onsale_desc  之前用的这个字段 后来这个字段社区详情界面不返回这个字段所以自己拼了
    _descLabel.text = [NSString stringWithFormat:@"在售商品%@", shopInfo.publish_num];
    _intoLabel.text = @"进店";
    _arrowIcon.image = [UIImage imageNamed:@"icon_kind_right_arrow"];
}

//进入商家店铺主页
- (void)enterShopHomeVC {
    if (self.enterShopBlock) {
        self.enterShopBlock(_shopInfo.seller_id);
    }
    ///之前的代码  现在方法放在vc里面了 代码被注释掉了  lh
//    JHShopHomeController *vc = [JHShopHomeController new];
//    vc.sellerId = _shopInfo.seller_id;
//    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//    [JHNotificationCenter postNotificationName:GoodsDetailEnterShopPageNotification object:nil];
}

@end
