//
//  JHCustomizeFlyUserOrderView.m
//  TTjianbao
//
//  Created by lihang on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFlyUserOrderView.h"

#import "IQKeyboardManager.h"
#import "UITextField+PlaceHolderColor.h"
#import "JHTitleTextItemView.h"
#import "UserInfoRequestManager.h"
#import "JHCustomizeFlyOrderTagsView.h"
#import "JHCustomizeFlyOrderCountPickerView.h"
#import "JHCustomizeFlyOrderCountCategoryModel.h"
#import "NTESGrowingInternalTextView.h"
#import "UIView+JHGradient.h"
#import "JHSendOrderModel.h"
#import "JHAntiFraud.h"
#import "NOSUpImageTool.h"
#import "NSString+UISize.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"
#import "JHGrowingIO.h"
#import "JHOrderConfirmViewController.h"
#import "JHImagePickerPublishManager.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

#define backWidth  260
@interface JHCustomizeFlyUserOrderView()
@property (nonatomic, strong) UIView *screenImageBGView;
@property (nonatomic, strong) UIScrollView *imagesBGView;
@property (nonatomic, strong) NSString *screenImage;
@property (nonatomic, strong) NSMutableArray *imagesArray;//里面存NSString

@property (nonatomic, strong) JHCustomizeFlyOrderTagsView *countTagsView;
@property (nonatomic, strong) UIImageView *toastBGImageView;
@property (nonatomic, strong) UIButton *yuFuKuanToastBtn;

@end

@implementation JHCustomizeFlyUserOrderView

-(void)showAlert {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    
    [self initImageArray];//初始化图片
    [self makeUI];
    [super showAlert];
}

-(void)initImageArray {
    if(self.model.goodsUrl){
        NSArray *array = [self.model.goodsUrl componentsSeparatedByString:@","];
        self.screenImage = (NSString *)array.firstObject;
        [self.imagesArray addObjectsFromArray:array];
        [self.imagesArray removeObjectAtIndex:0];
    }
}


- (void)makeUI {
    UITapGestureRecognizer* backViewTap = [[UITapGestureRecognizer alloc]init];
    [backViewTap addTarget:self action:@selector(backViewTap)];
    [self.backView addGestureRecognizer:backViewTap];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@backWidth);
        make.height.equalTo(@555);
    }];
    self.backView.backgroundColor = kColorFFF;
    
    //添加标题
    UILabel *topTitleLabel = [[UILabel alloc]init];
    topTitleLabel.font = [UIFont fontWithName:kFontNormal size:18];
    topTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.text = @"定制订单";
    [self.backView addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
    }];
    
    [self.closeBtn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
    
    //添加截屏
    [self.backView addSubview:self.screenImageBGView];
    [self.screenImageBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topTitleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@240);
    }];
    [self reloadScreenImageBGView];
    
    
    //添加图片
    [self.backView addSubview:self.imagesBGView];
    CGFloat images_top = 0;
    CGFloat imagesH = 0;
    if(self.imagesArray.count > 0){
        images_top = 10;
        imagesH = 60;
    }
    [self.imagesBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenImageBGView.mas_bottom).offset(images_top);
        make.left.right.equalTo(self.screenImageBGView);
        make.height.equalTo(@(imagesH));
    }];
    [self reloadImagesBGView];
    
    CGFloat imagesBGViewY = 295 + images_top + imagesH;
    //添加预付款
    UIView *yuFuKuanView = [[UIView alloc] init];
    [self.backView addSubview:yuFuKuanView];
    yuFuKuanView.frame = CGRectMake(0, imagesBGViewY+13, backWidth, 28);
    
    UILabel *yuFuKuanTitleLabel = [[UILabel alloc]init];
    yuFuKuanTitleLabel.font = [UIFont systemFontOfSize:13];
    yuFuKuanTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    yuFuKuanTitleLabel.text = @"预付款:";
    [yuFuKuanView addSubview:yuFuKuanTitleLabel];
    [yuFuKuanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@10);
    }];
    
    UIButton *yuFuKuanToastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yuFuKuanToastBtn setImage:[UIImage imageNamed:@"customizev_fly_toast"] forState:UIControlStateNormal];
    [yuFuKuanToastBtn addTarget:self action:@selector(yuFuKuanToastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [yuFuKuanView addSubview:yuFuKuanToastBtn];
    [yuFuKuanToastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@18);
    }];
    self.yuFuKuanToastBtn = yuFuKuanToastBtn;
    
    
    UILabel *yuFuKuanLabel = [[UILabel alloc]init];
    yuFuKuanLabel.font = [UIFont systemFontOfSize:13];
    yuFuKuanLabel.textColor = [UIColor colorWithHexString:@"#FF4200"];
    yuFuKuanLabel.text = [NSString stringWithFormat:@"¥%@",self.model.orderPrice];
    [yuFuKuanView addSubview:yuFuKuanLabel];
    [yuFuKuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(yuFuKuanToastBtn.mas_right).offset(2);
    }];
    
    
    //选择类别
    UIView *categoryView = [[UIView alloc] init];
    [self.backView addSubview:categoryView];
    categoryView.frame = CGRectMake(0, CGRectGetMaxY(yuFuKuanView.frame), backWidth, 28);
    
    
    UILabel *categoryTitleLabel = [[UILabel alloc]init];
    categoryTitleLabel.font = [UIFont systemFontOfSize:13];
    categoryTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    categoryTitleLabel.text = @"原料类别:";
    [categoryView addSubview:categoryTitleLabel];
    [categoryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@10);
    }];
    
    
    UILabel *categoryLabel = [[UILabel alloc]init];
    categoryLabel.font = [UIFont systemFontOfSize:13];
    categoryLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    categoryLabel.text = self.model.goodsCateName;
    [categoryView addSubview:categoryLabel];
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@75);
    }];
    
    
    
    //定制件数
    UIView *countView = [[UIView alloc] init];
    [self.backView addSubview:countView];
    countView.frame = CGRectMake(0, CGRectGetMaxY(categoryView.frame), backWidth, 28);
    
    UILabel *countTitleLabel = [[UILabel alloc]init];
    countTitleLabel.font = [UIFont systemFontOfSize:13];
    countTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    countTitleLabel.text = @"定制个数:";
    [countView addSubview:countTitleLabel];
    [countTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@10);
    }];
    
    [countView addSubview:self.countTagsView];
    self.countTagsView.frame = CGRectMake(75, 0, backWidth-75-20, 28);
    [self reloadTagsView];
    
    //定制说明
    CGFloat descH = [self.model.processingDes getStringHeight:[UIFont systemFontOfSize:13] width:backWidth-75-20 size:0];
    if(descH < 28){
        descH = 28;
    }
    UIView *descView = [[UIView alloc] init];
    [self.backView addSubview:descView];
    descView.frame = CGRectMake(0, CGRectGetMaxY(countView.frame), backWidth, descH);
    
    
    UILabel *descTitleLabel = [[UILabel alloc]init];
    descTitleLabel.font = [UIFont systemFontOfSize:13];
    descTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    descTitleLabel.text = @"定制说明:";
    [descView addSubview:descTitleLabel];
    [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@7.5);
    }];
    
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    descLabel.text = self.model.processingDes;
    [descView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@75);
        make.right.equalTo(@-20);
        make.top.equalTo(descTitleLabel);
    }];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    sendBtn.layer.cornerRadius = 19;
    sendBtn.layer.masksToBounds = YES;
    [self.backView addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@38);
        make.bottom.equalTo(@-15);
    }];
    
    
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(CGRectGetMaxY(descView.frame)+15+38+15));
    }];
}

-(void)reloadTagsView {
    NSArray* countArray = [self.model.orderDesc componentsSeparatedByString:@","];
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (NSString *subString in countArray) {
        if(subString.length > 0) {
            [tagsArray addObject:subString];
        }
    }
    [self.countTagsView setTagAry:tagsArray delegate:self];
}

-(void)reloadScreenImageBGView {
    [self.screenImageBGView removeAllSubviews];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView jh_setImageWithUrl:self.screenImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.screenImageBGView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    imageView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer* screenImageViewTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self checkImageWithIndex:0];
    }];
    [imageView addGestureRecognizer:screenImageViewTap];
}

-(void)reloadImagesBGView {
    [self.imagesBGView removeAllSubviews];
    CGFloat imageW = 60;
    CGFloat imageH = 60;
    [self.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = (NSString*)obj;
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView jh_setImageWithUrl:url];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        [self.imagesBGView addSubview:imageView];
        imageView.frame = CGRectMake(idx*(imageW+10), 0, imageW, imageH);
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10+idx;
        @weakify(self);
        UITapGestureRecognizer* screenImageViewTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if(self.screenImage){
                [self checkImageWithIndex:1+idx];
            }else{
                [self checkImageWithIndex:idx];
            }
        }];
        [imageView addGestureRecognizer:screenImageViewTap];
    }];
    self.imagesBGView.contentSize = CGSizeMake(self.imagesArray.count*(imageW+10)-10, 0);
}


-(void)backViewTap {
    self.yuFuKuanToastBtn.selected = NO;
    [self.toastBGImageView removeFromSuperview];
}

//预付款toast点击
-(void)yuFuKuanToastBtnClick:(UIButton*)sender{
    [self endEditing:YES];
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.backView addSubview:self.toastBGImageView];
        UIImage* image = [UIImage imageNamed:@"customizev_fly_toast_bg"];
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        [self.toastBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.yuFuKuanToastBtn.mas_top).offset(3);
            make.left.equalTo(self.yuFuKuanToastBtn.mas_centerX).offset(-(80.0/432.0*imageW));
            make.width.equalTo(@(imageW));
            make.height.equalTo(@(imageH));
        }];
    }else{
        [self.toastBGImageView removeFromSuperview];
    }
}


#pragma mark - 查看图片
-(void)checkImageWithIndex:(NSInteger)index{
    NSMutableArray *photoList = [NSMutableArray array];
    if(self.screenImage){
        GKPhoto *photo = [[GKPhoto alloc]init];
        photo.url = [NSURL URLWithString:self.screenImage];
        [photoList addObject:photo];
    }
    for (NSString *url in self.imagesArray) {
        //url
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:url];
        [photoList addObject:photo];
    }
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self.viewController];
}


//发送订单
-(void)sureBtnClick:(UIButton*)sender{
    [self endEditing:YES];
    [JHGrowingIO trackEventId:JHTrackOrderlive_pay_sure_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    //确认支付
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = self.model.orderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self hiddenAlert];
}


- (UIView *)screenImageBGView {
    if (!_screenImageBGView) {
        _screenImageBGView = [[UIView alloc] init];
        _screenImageBGView.backgroundColor = kColorFFF;
        _screenImageBGView.layer.cornerRadius = 8;
        _screenImageBGView.layer.masksToBounds = YES;
    }
    return _screenImageBGView;
}

- (UIScrollView *)imagesBGView {
    if (!_imagesBGView) {
        _imagesBGView = [[UIScrollView alloc] init];
        _imagesBGView.showsVerticalScrollIndicator = NO;
        _imagesBGView.showsHorizontalScrollIndicator = NO;
    }
    return _imagesBGView;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}


- (UIView *)countTagsView {
    if (!_countTagsView) {
        _countTagsView = [[JHCustomizeFlyOrderTagsView alloc] init];
        _countTagsView.type = 1;
        _countTagsView.tagSpace = 9;
        _countTagsView.tagHeight = 18;
        _countTagsView.tagOriginX = 0;
        _countTagsView.tagOriginY = 5;
        _countTagsView.tagHorizontalSpace = 9;
        _countTagsView.tagVerticalSpace = 0;
        _countTagsView.masksToBounds = YES;
        _countTagsView.cornerRadius = 9;
        _countTagsView.titleSize = 11;
        _countTagsView.titleColor = [UIColor colorWithHexString:@"#666666"];
        _countTagsView.borderColor = [UIColor colorWithHexString:@"#BDBFC2"];
        _countTagsView.borderWidth = 0.5;
        _countTagsView.canDel = NO;
    }
    return _countTagsView;
}

- (UIImageView *)toastBGImageView {
    if (!_toastBGImageView) {
        _toastBGImageView = [[UIImageView alloc] init];
        _toastBGImageView.image = [UIImage imageNamed:@"customizev_fly_toast_bg"];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.text = @"您支付的预付款会由平台保管，在服务完成后多退少补，具体的订单金额会根据实际产生的定制费用计算。";
        label.numberOfLines = 0;
        [_toastBGImageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@8);
            make.top.equalTo(@6);
            make.right.equalTo(@-8);
        }];
        [UILabel changeLineSpaceForLabel:label WithSpace:7];
    }
    return _toastBGImageView;
}
- (void)closeAction:(UIButton *)btn{

    [JHGrowingIO trackEventId:JHTrackOrderlive_pay_close_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    [super closeAction:btn];
}

@end

