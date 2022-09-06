//
//  JHOrderProductView.m
//  TTjianbao
//
//  Created by jiang on 2020/5/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderProductView.h"
#import "JHStoreDetailViewController.h"
#import "JHStoreSnapShootViewController.h"

@interface JHOrderProductView ()
{
     UIView * tagView;
    UIButton *snapshootBtn ;
}
@property (nonatomic, strong) UIImageView *sallerHeadImage;
@property (nonatomic, strong) UILabel     *sallerName;
@property (nonatomic, strong) UILabel     *orderCategory;
@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UILabel     *productPrice;
@property (nonatomic, strong) UILabel     *productTitle;
@property (nonatomic, strong) UIView      *productContentView;
@property (nonatomic, strong) UILabel     *flashOrderSignLabel;
@end
@implementation JHOrderProductView

-(void)setSubViews{
    tagView=[UIView new];
    tagView.layer.borderColor = kColorMainRed.CGColor;
    tagView.layer.borderWidth = 1.0;
    tagView.layer.cornerRadius = 4;
    tagView.layer.masksToBounds = YES;
    [self addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.height.offset(16.f);
        make.top.offset(10);
    }];
    tagView.hidden=YES;
    
    _orderCategory=[[UILabel alloc]init];
    _orderCategory.text=@"";
    _orderCategory.font=[UIFont systemFontOfSize:10];
    _orderCategory.backgroundColor=[UIColor clearColor];
    _orderCategory.textColor=kColorMainRed;
    _orderCategory.numberOfLines = 1;
    _orderCategory.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _orderCategory.lineBreakMode = NSLineBreakByTruncatingTail;
    _orderCategory.userInteractionEnabled=YES;
    [tagView addSubview:_orderCategory];
    [_orderCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.center.equalTo(tagView);
    }];
    
    /// 闪购标识
    _flashOrderSignLabel                        = [[UILabel alloc]init];
    _flashOrderSignLabel.text                   = @"闪";
    _flashOrderSignLabel.font                   = [UIFont systemFontOfSize:10];
    _flashOrderSignLabel.backgroundColor        = [UIColor clearColor];
    _flashOrderSignLabel.textColor              = HEXCOLOR(0xFF9F40);
    _flashOrderSignLabel.numberOfLines          = 1;
    _flashOrderSignLabel.textAlignment          = NSTextAlignmentCenter;
    _flashOrderSignLabel.lineBreakMode          = NSLineBreakByWordWrapping;
    _flashOrderSignLabel.lineBreakMode          = NSLineBreakByTruncatingTail;
    _flashOrderSignLabel.userInteractionEnabled = YES;
    _flashOrderSignLabel.layer.borderWidth      = 1.0;
    _flashOrderSignLabel.layer.borderColor      = HEXCOLOR(0xFF9900).CGColor;
    _flashOrderSignLabel.layer.cornerRadius     = 4;
    _flashOrderSignLabel.layer.masksToBounds    = YES;
    _flashOrderSignLabel.hidden                 = YES;
    [self addSubview:_flashOrderSignLabel];
    [_flashOrderSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagView.mas_right).offset(0.f);
        make.centerY.equalTo(tagView.mas_centerY);
        make.width.mas_equalTo(0.f);
        make.height.mas_equalTo(16.f);
    }];
    
    _sallerHeadImage=[[UIImageView alloc]initWithImage:kDefaultAvatarImage];
    _sallerHeadImage.layer.masksToBounds =YES;
    _sallerHeadImage.layer.cornerRadius =8;
    _sallerHeadImage.userInteractionEnabled=YES;
    [_sallerHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_sallerHeadImage];
    [_sallerHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.flashOrderSignLabel.mas_right).offset(9.f);
    }];
    
    _sallerName=[[UILabel alloc]init];
    _sallerName.text=@"";
    _sallerName.font=[UIFont systemFontOfSize:13];
    _sallerName.backgroundColor=[UIColor clearColor];
    _sallerName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _sallerName.numberOfLines = 1;
    _sallerName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _sallerName.lineBreakMode = NSLineBreakByTruncatingTail;
    _sallerName.userInteractionEnabled=YES;
    [_sallerName addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_sallerName];
    
    [_sallerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_sallerHeadImage.mas_right).offset(10);
      //  make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    _orderStatusLabel = [[UILabel alloc] init];
    _orderStatusLabel.numberOfLines =1;
    _orderStatusLabel.textAlignment = NSTextAlignmentRight;
    _orderStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _orderStatusLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _orderStatusLabel.text = @"";
    _orderStatusLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:_orderStatusLabel];
    
    [ _orderStatusLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(_sallerName);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerName.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.left.offset(5);
        make.right.offset(0);
        
    }];
    
    _productContentView=[[UIView alloc]init];
    [self addSubview:_productContentView];
    [_productContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerHeadImage.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    _productImage=[[UIImageView alloc]initWithImage:nil];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    _productImage.layer.cornerRadius =8;
    _productImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [_productImage addGestureRecognizer:tapGesture];
    [_productContentView addSubview:_productImage];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productContentView).offset(5);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(_productContentView).offset(0);
    }];
    
    _productTitle=[[UILabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont fontWithName:kFontNormal size:13];
    _productTitle.textColor=kColor333;
    _productTitle.numberOfLines = 2;
    _productTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productContentView addSubview:_productTitle];
    
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productImage).offset(-10);
        make.left.equalTo(_productImage.mas_right).offset(10);
        make.right.equalTo(_productContentView.mas_right).offset(-5);
    }];
    _productPrice=[[UILabel alloc]init];
    _productPrice.text=@"";
    _productPrice.font=[UIFont fontWithName:kFontBoldDIN size:15.f];
    _productPrice.textColor=kColor333;
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productContentView addSubview:_productPrice];
    
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productTitle.mas_bottom).offset(5);
        make.left.equalTo(_productTitle);
    }];
    
    snapshootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    snapshootBtn.backgroundColor=kColorEEE;
    snapshootBtn.layer.cornerRadius = 2;
    [snapshootBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    snapshootBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    [snapshootBtn  setTitle:@"交易快照" forState:UIControlStateNormal];
    snapshootBtn.contentMode=UIViewContentModeScaleAspectFit;
    [snapshootBtn addTarget:self action:@selector(snapShoot:) forControlEvents:UIControlEventTouchUpInside];
    [_productContentView addSubview:snapshootBtn];

     [snapshootBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productPrice.mas_right).offset(10);
        make.centerY.equalTo(_productPrice);
        make.width.offset(50);
         make.height.offset(14);
    }];
    snapshootBtn.hidden = YES;
}
-(void)initStoneProductViews{
    
    [self.productContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIScrollView *  _imagesScrollView=[[UIScrollView alloc]init];
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    _imagesScrollView.showsVerticalScrollIndicator = NO;
    _imagesScrollView.scrollEnabled=YES;
    _imagesScrollView.userInteractionEnabled = YES;
    _imagesScrollView.alwaysBounceHorizontal = YES; // 水平
    _imagesScrollView.alwaysBounceVertical = NO;
    [self.productContentView addSubview:_imagesScrollView];
    [_imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productContentView);
        make.height.offset(80);
        make.top.equalTo(self.productContentView).offset(0);
        make.right.equalTo(self.productContentView);
    }];
    _productPrice=[[UILabel alloc]init];
    _productPrice.font=[UIFont fontWithName:kFontBoldDIN size:13.f];
    _productPrice.textColor=kColor333;
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = NSTextAlignmentLeft;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [self.productContentView addSubview:_productPrice];
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imagesScrollView.mas_bottom).offset(5);
        make.left.offset(10);
        make.right.offset(0);
        make.bottom.equalTo(self.productContentView);
    }];
    
    _productPrice.text=[@"订单金额:¥ " stringByAppendingString:self.orderMode.goodsPrice?:@""];
    [self initImages:self.orderMode.attachmentList view:_imagesScrollView];
    
}
-(void)initImages:(NSArray<JHRestoreOrderAttachmentMode*>*)images  view:(UIScrollView*)_imagesScrollView{
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
        // view.backgroundColor=[CommHelp randomColor];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.userInteractionEnabled=YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
        view.layer.masksToBounds =YES;
        view.tag=i;
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stoneImageTap:)];
        [view addGestureRecognizer:tapGesture];
        
        [_imagesScrollView addSubview:view];
        if (images[i].coverUrl>0) {
                   [view jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(images[i].coverUrl)] placeholder:kDefaultCoverImage];
               }
        if (images[i].attachmentType==JHOrderAttachmentTypeVideo) {
            UIImageView *playIcon=[[UIImageView alloc]init];
            playIcon.image=[UIImage imageNamed:@"stoneresale_cell_play_icon"];
            playIcon.contentMode=UIViewContentModeScaleAspectFit;
            [view addSubview:playIcon];
            [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view).offset(0);
            }];
        }
           
        float width=60;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.height.offset(width);
            make.top.equalTo(_imagesScrollView).offset(10);
            if (i==0) {
                make.left.equalTo(_imagesScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==images.count-1) {
                make.right.equalTo(_imagesScrollView.mas_right).offset(-10);
            }
        }];
        lastView=view;
    }
}
-(void)ConfigCategoryTagTitle:(JHOrderDetailMode*)mode{
    UserInfoRequestManager * manager = [UserInfoRequestManager sharedInstance];
        NSString * desc;
       if (mode.orderCategoryType!=JHOrderCategoryRestore&&
           mode.orderCategoryType!=JHOrderCategoryRestoreProcessing) {
           desc=[manager findValue:manager.dictConfigMode.AppOrderCategory byKey:mode.orderCategory];
       }
       else{
           desc=[manager findValue:manager.dictConfigMode.StoneRestoretransitionState byKey:[NSString stringWithFormat:@"%zd",mode.transitionState]];
       }
       if (!isEmpty(desc)) {
           self.orderCategory.text=desc;
            tagView.hidden = NO;
       } else {
           tagView.hidden = YES;
       }
    /// 闪购
    if (mode.flashIcon) {
        _flashOrderSignLabel.hidden = NO;
        if (tagView.hidden) {
            [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.centerY.equalTo(tagView.mas_centerY);
                make.width.mas_equalTo(16.f);
                make.height.mas_equalTo(16.f);
            }];
        } else {
            [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tagView.mas_right).offset(8.f);
                make.centerY.equalTo(tagView.mas_centerY);
                make.width.mas_equalTo(16.f);
                make.height.mas_equalTo(16.f);
            }];
        }
    } else {
        _flashOrderSignLabel.hidden = YES;
        [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagView.mas_right).offset(0.f);
            make.centerY.equalTo(tagView.mas_centerY);
            make.width.mas_equalTo(0.f);
            make.height.mas_equalTo(16.f);
        }];
    }
    
    if (isEmpty(desc)) {
        if (!mode.flashIcon) {
            [_sallerHeadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                make.size.mas_equalTo(CGSizeMake(16, 16));
                make.left.equalTo(self).offset(10);
            }];
        }
    }
}
-(void)setOrderMode:(JHOrderDetailMode *)orderMode{
    
    _orderMode=orderMode;
    [_productImage jhSetImageWithURL:[NSURL URLWithString: ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
    _productTitle.text=_orderMode.goodsTitle;
    
    if (_orderMode.isSeller) {
        [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.buyerImg] placeholder:kDefaultAvatarImage];
                _sallerName.text=_orderMode.buyerName;
    }
    else{
        [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
         _sallerName.text=_orderMode.sellerName;
    }
    
    //加工服务单不显示产品价格
    if (_orderMode.orderCategoryType!=JHOrderCategoryProcessingGoods&&
        _orderMode.orderCategoryType!=JHOrderCategoryRestoreProcessing&&
        _orderMode.orderCategoryType!=JHOrderCategoryCustomizedOrder&&
        _orderMode.orderCategoryType!=JHOrderCategoryCustomizedIntentionOrder){
        _productPrice.text=[@"¥ " stringByAppendingString:_orderMode.goodsPrice?:@""];
    }
    else{
        
        [_productTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.centerY.equalTo(_productImage).offset(0);
               make.left.equalTo(_productImage.mas_right).offset(5);
               make.right.equalTo(_productContentView.mas_right).offset(-5);
           }];
    }
    
    
    if (_orderMode.orderCategoryType==JHOrderCategoryMallOrder){
        snapshootBtn.hidden = NO;
    }
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr;
    if (self.orderMode.goodsUrl) {
        arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
        [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
               
           }];
    }
    
}
-(void)headImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderType ==0) {
        [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:JHLiveFromorderDetail];
    }
    else  if (self.orderMode.orderType ==1){
        ///enter UserInfo page
        [JHRootController enterUserInfoPage:self.orderMode.sellerCustomerId from:@""];
    }
}
-(void)stoneImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    [JHRouterManager pushStoneDetailWithStoneId:self.orderMode.stoneId complete:nil];
}

-(void)snapShoot:(UIButton*)btn{
    
//    JHStoreDetailViewController * vc = [JHStoreDetailViewController new];
//    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//
//
////    return;
    JHStoreSnapShootViewController * vc = [JHStoreSnapShootViewController new];
    vc.productId = self.orderMode.orderId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
