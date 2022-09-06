//
//  JHAppraisalReportViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAppraisalReportViewController.h"
#import "UIView+AddSubviews.h"
#import "PanNavigationController.h"

@interface JHAppraisalReportViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *imageScrollerView;
@property (nonatomic, strong) UILabel *resultTip;
@property (nonatomic, strong) UILabel *resultValue; /// 鉴定结果
@property (nonatomic, strong) UILabel *masterValue; /// 鉴定师
@property (nonatomic, strong) UILabel *noValue; /// 编号
@property (nonatomic, strong) UILabel *nameValue; /// 宝贝名称
@property (nonatomic, strong) UILabel *desValue;
@property (nonatomic, strong) UILabel *failDesTipValue;
@property (nonatomic, assign) Boolean isSuccess;
@end

@implementation JHAppraisalReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProps];
    [self setupUI];
}

- (void)setupProps {
    self.title = @"鉴定报告";
    self.isSuccess = YES;
}

- (void)setupUI {
    [self setupMainUI];
    [self setupCommonUI];

    if(self.isSuccess) {
        [self setupSuccessUI];
    }else {
        [self setupFaileUI];
    }
    
    [self setupImageContainerUI];
}

- (void)setupMainUI {
    self.mainView =  [UIView jh_viewWithColor:UIColor.blackColor addToSuperview:self.view];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    self.contentView =  [UIView jh_viewWithColor:HEXCOLOR(0xFFF8F8F8) addToSuperview:self.mainView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 12, 15, 12));
    }];
}

- (void)setupCommonUI {
    UIImageView *iconImageView = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_AppraisalReport_success"] addToSuperview:self.contentView ];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(100);
    }];
    if(!self.isSuccess){
        [iconImageView setImage:[UIImage imageNamed:@"icon_AppraisalReport_failed"]];
    }
    
    UILabel *titleLabel = [UILabel jh_labelWithFont:34 textColor:HEXCOLOR(0xFFB5976D) addToSuperView:self.contentView];
    titleLabel.text = @"鉴定报告";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(44);
    }];
    // 鉴定结果
    UILabel *resultTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    resultTip.text = @"鉴定结果:";
    resultTip.font = [UIFont fontWithName:kFontMedium size:14];
    resultTip.textAlignment = NSTextAlignmentLeft;
    self.resultTip = resultTip;
    
    UILabel *resultValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    resultValue.text = @"真";
    resultValue.textAlignment = NSTextAlignmentLeft;
    self.resultValue = resultValue;
    
    [resultTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(20);
        make.width.mas_equalTo(60);
    }];
    
    [resultValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(resultTip.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(resultTip);
    }];
    
    // 鉴定师
    UILabel *masterTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    masterTip.text = @"鉴定师:";
    masterTip.font = [UIFont fontWithName:kFontMedium size:14];
    masterTip.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *userHeadIcon = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"common_photo_placeholder"] addToSuperview:self.contentView];
    userHeadIcon.layer.cornerRadius = 8;
    userHeadIcon.clipsToBounds = YES;
    [userHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(masterTip.mas_centerY);
        make.left.mas_equalTo(resultValue);
        make.size.mas_equalTo(30);
    }];
    
    UILabel *masterValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    masterValue.text = @"平台鉴定师";
    masterValue.textAlignment = NSTextAlignmentLeft;
    self.masterValue = masterValue;
    
    [masterTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(self.resultTip.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [masterValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeadIcon.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(masterTip);
    }];
    
    // 印记保证在最顶层
    [iconImageView bringSubviewToFront:self.contentView];
}

- (void)setupFaileUI {
    // 鉴定评语
    UILabel *failDesTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    failDesTip.text = @"鉴定评语:";
    failDesTip.font = [UIFont fontWithName:kFontMedium size:14];
    failDesTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *failDesTipValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    failDesTipValue.numberOfLines = 0;
    failDesTipValue.text = @"这里是鉴定文字评语，这里是鉴定文字评语，这里是鉴定文字评语，这里是鉴定文字评语，这里是鉴定文字评语，这里是鉴定文字评语，这里是鉴定文字评语；";
    failDesTipValue.textAlignment = NSTextAlignmentLeft;
    self.failDesTipValue = failDesTipValue;
    [failDesTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(self.masterValue.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [failDesTipValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.right.mas_equalTo(-36);
        make.centerY.mas_equalTo(failDesTip.mas_bottom).mas_offset(12);
    }];
}

- (void)setupSuccessUI {
    // 鉴定编号
    UILabel *noTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    noTip.text = @"鉴定编号:";
    noTip.font = [UIFont fontWithName:kFontMedium size:14];
    noTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *noValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    noValue.text = @"123123213213213213";
    noValue.textAlignment = NSTextAlignmentLeft;
    self.noValue = noValue;
    
    [noTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(self.masterValue.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [noValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultValue);
        make.centerY.mas_equalTo(noTip);
    }];
    
    // 鉴定 宝贝名称
    UILabel *nameTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    nameTip.text = @"宝贝名称:";
    nameTip.font = [UIFont fontWithName:kFontMedium size:14];
    nameTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *nameValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    nameValue.text = @"真";
    nameValue.textAlignment = NSTextAlignmentLeft;
    self.nameValue = nameValue;
    
    [nameTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(noTip.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [nameValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultValue);
        make.centerY.mas_equalTo(nameTip);
    }];
    
    // 鉴定年代
    UILabel *yearTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    yearTip.text = @"宝贝断代:";
    yearTip.font = [UIFont fontWithName:kFontMedium size:14];
    yearTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *yearValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    yearValue.text = @"真";
    yearValue.textAlignment = NSTextAlignmentLeft;
    
    [yearTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(nameTip.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [yearValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultValue);
        make.centerY.mas_equalTo(yearTip);
    }];
    
    // 鉴定级别
    UILabel *levelTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    levelTip.text = @"宝贝级别:";
    levelTip.font = [UIFont fontWithName:kFontMedium size:14];
    levelTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *levelValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    levelValue.text = @"一级";
    levelValue.textAlignment = NSTextAlignmentLeft;
    
    [levelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(yearTip.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [levelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultValue);
        make.centerY.mas_equalTo(levelTip);
    }];
    
    // 鉴定评语
    UILabel *desTip = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    desTip.text = @"鉴定评语:";
    desTip.font = [UIFont fontWithName:kFontMedium size:14];
    desTip.textAlignment = NSTextAlignmentLeft;
    
    UILabel *desValue = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
    desValue.text = @"真111123213213";
    desValue.textAlignment = NSTextAlignmentLeft;
    self.desValue = desValue;
    
    [desTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultTip);
        make.top.mas_equalTo(levelTip.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(self.resultTip);
    }];
    
    [desValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultValue);
        make.centerY.mas_equalTo(desTip);
    }];
}

- (void)setupImageContainerUI {
    UIView *line = [UIView jh_viewWithColor:HEXCOLOR(0xFFB5976D) addToSuperview:self.contentView];
    UILabel *tmpLabel = self.desValue;
    if (!self.isSuccess) {
        tmpLabel = self.failDesTipValue;
    }
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tmpLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.resultTip);
        make.right.mas_equalTo(-36);
        make.height.mas_equalTo(1);
    }];
    
    UIScrollView *imageScrollerView = [UIScrollView jh_viewWithColor:UIColor.clearColor addToSuperview:self.contentView];
    imageScrollerView.userInteractionEnabled = YES;
    imageScrollerView.showsHorizontalScrollIndicator = NO;
    
    [imageScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.resultTip);
        make.right.mas_equalTo(-36);
        make.height.mas_equalTo(100);
    }];
    self.imageScrollerView = imageScrollerView;
    
    UIView *imagesView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self.imageScrollerView];
    [self.imageScrollerView setNeedsLayout];
    [self.imageScrollerView layoutIfNeeded];
    
    CGFloat imageWH = (self.imageScrollerView.width - 10*2) / 3;
    for (int i = 0; i < 10; i++) {
        UIImageView *imageView =[[UIImageView alloc]init];
        imageView.tag = 100+i;
        imageView.layer.cornerRadius = 8;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"common_photo_placeholder"];
        [imagesView addSubview:imageView];
        imageView.frame = CGRectMake(i*(imageWH+10),10, imageWH, imageWH);
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
        tapGestureRecognizer.delegate = self;
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }

    [imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(imageWH+20);
        make.width.mas_equalTo(10*imageWH+10*10);
    }];
    
    UIView *tipView = [UIView jh_viewWithColor:HEXCOLORA(0XFF000000, 0.5) addToSuperview:self.contentView];
    tipView.layer.cornerRadius = 8.5;
    tipView.clipsToBounds = YES;
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 17));
        make.right.mas_equalTo(self.imageScrollerView.mas_right).mas_offset(-6);
        make.bottom.mas_equalTo(self.imageScrollerView.mas_bottom).mas_offset(-5);
    }];

    UILabel *numValue = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF333333) addToSuperView:tipView];
    numValue.text = @"10";
    
    UIImageView *numIcon = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_image_tip_JHGraphicBuyerOrderView"] addToSuperview:tipView];
    [numIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipView);
        make.left.mas_equalTo(5);
//        make.size.mas_equalTo(CGSizeMake(7.5, 6.5));
    }];
    
    [numValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numIcon.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(tipView);
    }];
    
    // 最下面的提示文字
    UILabel *bottomTipLabel= [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0xFF999999) addToSuperView:self.contentView];
    bottomTipLabel.text = @"评估结果仅依据图片展示为参考，存在一定误差范围属于正常情况（图片清晰度等因素可影响鉴定结果）";
    bottomTipLabel.numberOfLines = 0;
    [bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.imageScrollerView);
        make.top.mas_equalTo(self.imageScrollerView.mas_bottom).mas_equalTo(5);
    }];
    
    UIImageView *buttomIcon = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"jh_icon"] addToSuperview:self.contentView];
    [buttomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
}

- (void)focusGesture:(UIGestureRecognizer*)sender {
    NSInteger index = sender.view.tag-100;
    NSLog(@"index=%ld",index);
    
    // [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.postData.images_thumb mediumImages:self.postData.images_medium origImages:self.postData.images_origin sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
}

@end
