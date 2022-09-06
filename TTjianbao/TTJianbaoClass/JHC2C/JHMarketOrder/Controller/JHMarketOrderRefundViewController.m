//
//  JHMarketOrderRefundViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderRefundViewController.h"
#import "JHMarketImagesUpLoadView.h"
#import "MBProgressHUD.h"
#import "JHMarketRefundInfoView.h"
#import "IQKeyboardManager.h"
#import "JHMarketOrderViewModel.h"
#import "UIImage+JHWebImage.h"
#import "UIView+JHGradient.h"
#import "NSString+AttributedString.h"
#import "CommAlertView.h"

@interface JHMarketOrderRefundViewController ()<YYTextViewDelegate>
/** scrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 容器*/
@property (nonatomic, strong) UIView *containerView;
/** 商品详情*/
@property (nonatomic, strong) UIView *goodsView;
/** 标签*/
@property (nonatomic, strong) UILabel *tagLabel;
/** 退款商品*/
@property (nonatomic, strong) UILabel *refundLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;

/** 退款信息*/
@property (nonatomic, strong) JHMarketRefundInfoView *refundInfoView;

/** 宝贝图片*/
@property (nonatomic, strong) UIView *pictureView;
/** label*/
@property (nonatomic, strong) UILabel *pictureTagLabel;
/** 编剧区域*/
@property (nonatomic, strong) UIView *contentView;
/** 文字输入框*/
@property (nonatomic, strong) YYTextView *desTextView;
/** 文字字数*/
@property (nonatomic, strong) UILabel *textCountLabel;
/** 上传图片*/
@property (nonatomic, strong) JHMarketImagesUpLoadView *uploadView;
/** 底图*/
@property (nonatomic, strong) UIView *bottomView;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *submitButton;

/** 记录输入框高度*/
@property (nonatomic, assign) CGFloat textViewHeight;

/** 记录退款原因的选择数据*/
@property (nonatomic, strong) NSArray *reasonsArray;
@end

@implementation JHMarketOrderRefundViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:50];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    NSDictionary *dic = @{
        @"page_name":@"集市申请退款买家页属性值：集市申请退款买家页",
        @"order_id":self.orderId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] unregisterTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self configUI];
    //初始化UI
    [self initDataUI];
    
    //请求数据
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    [JHMarketOrderViewModel getRefundDetailData:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        if (!error) {
            self.reasonsArray = data[@"refundReasons"];
            self.refundInfoView.reasonsArray = data[@"refundReasons"];
            self.refundInfoView.refundMoney = data[@"refundAmt"];
            NSArray *typeArray = data[@"refundType"];
            if (typeArray.count == 1) {
                [self.refundInfoView.typeButton setTitle:@"仅退款" forState:UIControlStateNormal];
                self.refundInfoView.typeButton.enabled = NO;
                self.refundInfoView.arrowImageView1.hidden = YES;
                self.refundInfoView.refundType = 1;
                self.refundInfoView.moneyDesLabel.text = @"按实际付款金额退款";
            } else {
                self.refundInfoView.moneyDesLabel.text = @"按商品金额退款,不退运费";
            }
            if (self.operationListModel) {
                [self.refundInfoView.typeButton setTitle:self.operationListModel.refundTypeDesc forState:UIControlStateNormal];
                self.refundInfoView.typeButton.enabled = NO;
                self.refundInfoView.arrowImageView1.hidden = YES;
            }
            
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)initDataUI {
    switch (self.orderModel.marketOrderCategory.integerValue) {
        case 1:
            self.tagLabel.text = @"一口价";
            break;
        case 2:
            self.tagLabel.text = @"拍卖";
            break;
        case 3:
            self.tagLabel.text = @"鉴定服务";
            break;
        case 4:
            self.tagLabel.text = @"鉴定服务";
            break;
        case 5:
            self.tagLabel.text = @"保证金";
            break;
            
        default:
            break;
    }
    
    [self.productImageView jh_setImageWithUrl:self.orderModel.goodsUrl.small];
    self.productTitleLabel.text = self.orderModel.goodsName;
    
//    if (self.orderModel.orderStatus.integerValue <= 4) {
//        [self.refundInfoView.typeButton setTitle:@"仅退款" forState:UIControlStateNormal];
//        self.refundInfoView.typeButton.enabled = NO;
//        self.refundInfoView.arrowImageView1.hidden = YES;
//        self.refundInfoView.refundType = 1;
//    } else if (self.operationListModel) {
//        [self.refundInfoView.typeButton setTitle:self.operationListModel.refundTypeDesc forState:UIControlStateNormal];
//        self.refundInfoView.typeButton.enabled = YES;
//        self.refundInfoView.arrowImageView1.hidden = NO;
//        self.refundInfoView.refundType = self.operationListModel.refundTypeCode.integerValue;
//    }
    
    if (self.operationListModel) {
        [self.refundInfoView.typeButton setTitle:self.operationListModel.refundTypeDesc forState:UIControlStateNormal];
        self.refundInfoView.typeButton.enabled = NO;
        self.refundInfoView.arrowImageView1.hidden = YES;
        self.refundInfoView.refundType = self.operationListModel.refundTypeCode.integerValue;
        [self.refundInfoView.reasonButton setTitle:self.operationListModel.refundReasonDesc forState:UIControlStateNormal];
        self.refundInfoView.reasonCode = self.operationListModel.refundReasonCode;
        
        //描述
        if(self.operationListModel.refundDesc.length > 0){
            self.desTextView.text = self.operationListModel.refundDesc;
        }
        //图片
        if (self.operationListModel.images.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (JHRefundImagesModel *model in self.operationListModel.images) {
                [array addObject:model.origin];
            }
            self.uploadView.imagesUrlArray = array;
        }
    }
}

- (void)configUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.goodsView];
    [self.goodsView addSubview:self.tagLabel];
    [self.goodsView addSubview:self.refundLabel];
    [self.goodsView addSubview:self.lineView];
    [self.goodsView addSubview:self.productImageView];
    [self.goodsView addSubview:self.productTitleLabel];
    
    [self.containerView addSubview:self.refundInfoView];
    
    [self.containerView addSubview:self.pictureView];
    [self.pictureView addSubview:self.pictureTagLabel];
    [self.pictureView addSubview:self.contentView];
    [self.contentView addSubview:self.desTextView];
    [self.contentView addSubview:self.textCountLabel];
    [self.contentView addSubview:self.uploadView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.submitButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 64);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView).offset(10);
        make.left.mas_equalTo(self.bottomView).offset(28);
        make.right.mas_equalTo(self.bottomView).offset(-28);
        make.height.mas_equalTo(44);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).offset(10);
        make.left.mas_equalTo(self.containerView).offset(10);
        make.right.mas_equalTo(self.containerView).offset(-10);
        make.height.mas_equalTo(135);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsView).offset(10);
        make.left.mas_equalTo(self.goodsView).offset(10);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(16);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.tagLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsView).offset(10);
        make.right.mas_equalTo(self.goodsView);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView).offset(10);
        make.left.mas_equalTo(self.goodsView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.goodsView).offset(-10);
    }];
    
    [self.refundInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.containerView).offset(10);
        make.right.mas_equalTo(self.containerView).offset(-10);
    }];

    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.refundInfoView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.containerView).offset(10);
        make.right.mas_equalTo(self.containerView).offset(-10);
        make.bottom.mas_equalTo(self.containerView).offset(-50);
    }];
    
    [self.pictureTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureView).offset(12);
        make.left.mas_equalTo(self.pictureView).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureTagLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.pictureView).offset(10);
        make.right.mas_equalTo(self.pictureView).offset(-10);
        make.bottom.mas_equalTo(self.pictureView).offset(-15);
    }];
    
    [self.desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(8);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(60);
    }];
    
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desTextView.mas_bottom).offset(4);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textCountLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.contentView).offset(2);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
}

- (void)submitButtonClickAction {
    
    if (self.refundInfoView.refundType == 0) {
        JHTOAST(@"请选择退款类型");
        return;
    }
    
    if (self.refundInfoView.reasonCode.length == 0) {
        JHTOAST(@"请选择退款原因");
        return;
    }
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":@"退款原因及理由将同步至卖家，并成为售后评判的依据，请您认真填写；\n", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
    itemsArray[1] = @{@"string":@"注：为保障买卖双方利益，多次发货前申请退款可能受到系统处罚", @"color":HEXCOLOR(0xFF1818), @"font":[UIFont fontWithName:kFontNormal size:12]};
    NSMutableAttributedString *string = [NSString mergeStrings:itemsArray];
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"确认提交" andMutableDesc:string cancleBtnTitle:@"取消" sureBtnTitle:@"确定" andIsLines:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self submitRequest];
    };
    
}

- (void)submitRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    params[@"refundType"] = @(self.refundInfoView.refundType);
    params[@"refundAmount"] = self.refundInfoView.refundMoney;
    params[@"refundReason"] = self.refundInfoView.reasonCode;
    params[@"refundDesc"] = self.desTextView.text;
    params[@"images"] = self.uploadView.imagesArray;
    if (self.workOrderId.length > 0) {
        params[@"workOrderId"] = self.workOrderId;
    }
    [JHMarketOrderViewModel refundRequest:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            JHTOAST(@"提交成功");
            if (self.completeBlock) {
                self.completeBlock();
            }
            [self.navigationController  popViewControllerAnimated:YES];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}


/// 监听键盘输入
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    self.textCountLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    CGFloat height = textView.textLayout.textBoundingSize.height;
    if (height < 60) {
        height = 60;
    }
    if (height != self.textViewHeight) {
        self.textViewHeight = height;
        [self.desTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(8);
            make.left.mas_equalTo(self.contentView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(height);
        }];
        [[IQKeyboardManager sharedManager] reloadLayoutIfNeeded];
        
    }
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _bottomView;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_submitButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _submitButton.layer.cornerRadius = 22;
        _submitButton.clipsToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HEXCOLOR(0xf5f5f5);
    }
    return _containerView;
}

- (UIView *)goodsView {
    if (_goodsView == nil) {
        _goodsView = [[UIView alloc] init];
        _goodsView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _goodsView;
}

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEXCOLOR(0xfc4200);
        _tagLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _tagLabel.text = @"拍卖";
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.borderColor = HEXCOLOR(0xfc4200).CGColor;
        _tagLabel.clipsToBounds = YES;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UILabel *)refundLabel {
    if (_refundLabel == nil) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.textColor = HEXCOLOR(0x333333);
        _refundLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _refundLabel.text = @"退款商品";
    }
    return _refundLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _lineView;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.layer.cornerRadius = 4;
        _productImageView.clipsToBounds = YES;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x333333);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}


- (JHMarketRefundInfoView *)refundInfoView {
    if (_refundInfoView == nil) {
        _refundInfoView = [[JHMarketRefundInfoView alloc] init];
        _refundInfoView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _refundInfoView;
}

- (UIView *)pictureView {
    if (_pictureView == nil) {
        _pictureView = [[UIView alloc] init];
        _pictureView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _pictureView;
}

- (UILabel *)pictureTagLabel {
    if (_pictureTagLabel == nil) {
        _pictureTagLabel = [[UILabel alloc] init];
        _pictureTagLabel.text = @"补充描述和凭证";
        _pictureTagLabel.textColor = HEXCOLOR(0x333333);
        _pictureTagLabel.font = [UIFont fontWithName:kFontMedium size:14];
    }
    return _pictureTagLabel;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = HEXCOLOR(0xfafafa);
        _contentView.layer.cornerRadius = 5;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (YYTextView *)desTextView {
    if (_desTextView == nil) {
        _desTextView = [[YYTextView alloc] init];
        _desTextView.backgroundColor = HEXCOLOR(0xfafafa);
        _desTextView.textColor = HEXCOLOR(0x333333);
//        _desTextView.placeholderText = @"补充描述，有助于卖家更好处理售后问题，上传发货前拍摄的物品或者物流图，减少不必要纠纷";
        _desTextView.font = [UIFont fontWithName:kFontNormal size:12];
        _desTextView.delegate = self;
        _desTextView.scrollEnabled  = NO;
        
        NSString *placeStr = @"补充描述，有助于卖家更好处理售后问题，上传发货前拍摄的物品或者物流图，减少不必要纠纷";
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),
                                                                                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12]
                                                                                   }];
        _desTextView.placeholderAttributedText = attstr;
    }
    return _desTextView;
}

- (UILabel *)textCountLabel {
    if (_textCountLabel == nil) {
        _textCountLabel = [[UILabel alloc] init];
        _textCountLabel.text = @"0/200";
        _textCountLabel.textColor = HEXCOLOR(0xbbbbbb);
        _textCountLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _textCountLabel;
}

- (JHMarketImagesUpLoadView *)uploadView {
    if (_uploadView == nil) {
        _uploadView = [[JHMarketImagesUpLoadView alloc] initWithMaxPhotos:6];
        _uploadView.backgroundColor = HEXCOLOR(0xfafafa);
    }
    return _uploadView;
}


@end
