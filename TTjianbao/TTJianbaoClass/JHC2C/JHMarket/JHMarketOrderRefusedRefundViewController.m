//
//  JHMarketOrderRefusedRefundViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderRefusedRefundViewController.h"
#import <AVKit/AVKit.h>
#import "JHSQPublishModel.h"
#import "JHSQPublishVideoView.h"
#import "JHSQPublishImageView.h"
#import "JHSQPublishBottomView.h"
#import "JHVideoCropManager.h"
#import "PanNavigationController.h"
#import "JHSQPublishViewController.h"
#import "JHPublishSelectTopicController.h"
#import "JHVideoCropViewController.h"
#import "JHSQUploadManager.h"
#import "JHPublishTopicModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "JHDraftBoxModel.h"
#import "JHPlateSelectView.h"
#import "JHSQPublishSelectPlateTopicView.h"
#import "JHSQModel.h"
#import "JHSQManager.h"
#import "JHEmojiManager.h"
#import "JHSQApiManager.h"
#import "JHPostDetailModel.h"
#import "JHAttributeStringTool.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"
#import "JHRecycleOrderCancelViewController.h"
#import "MBProgressHUD.h"
#import "NOSUpImageTool.h"
#import "NSArray+JHExtension.h"
#import "JHUploadManager.h"

#define kLimitNumber  200

@interface JHMarketOrderRefusedRefundViewController () <UITextViewDelegate>

/// 图片数组
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *imageArray;

/// 输入框
@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, strong) UILabel *placeholderLabel;

/// 照片view
@property (nonatomic, weak) JHSQPublishImageView *imagesView;

/// 可滚动载体
@property (nonatomic, weak) UIScrollView *scrollView;

/// 编辑
@property (nonatomic, strong) JHPostDetailModel *detailData;

@property (nonatomic, strong) UILabel *whyLabel;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, weak) UILabel *wordsNumberLabel;

@property (nonatomic, copy) NSString *refuseReason;
@end

@implementation JHMarketOrderRefusedRefundViewController

- (void)dealloc {
    NSLog(@"🔥");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self reportPageView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拒绝退货/退款";
    
    [self initLeftButton];
    
    [self addUI];
        
    [self addObservers];
}

- (void)addUI {
    _scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:YES bounces:YES pagingEnabled:NO addToSuperView:self.view];
    _scrollView.backgroundColor = HEXCOLOR(0xFFF5F6FA);
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIButton *nextBtn = [UIButton jh_buttonWithTitle:@"提交" fontSize:16.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(rightActionButton:) addToSuperView:self.view];
    nextBtn.layer.cornerRadius = 22.f;
    nextBtn.clipsToBounds = YES;
    nextBtn.enabled = YES;
    nextBtn.alpha = 1.0;
    
    [self.view layoutIfNeeded];
    [nextBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    self.nextBtn = nextBtn;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    
    [nextBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-(UI.bottomSafeAreaHeight+10));
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@44);
    }];
    
    [self setupTopView];
}

- (void)addObservers {
    [self.textView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"attributedText"]) {
        [self wordsNumber:self.textView.attributedText.length];
//        self.model.content = [[JHEmojiManager sharedInstance] plainText];
        self.placeholderLabel.hidden = (self.textView.attributedText.length > 0);
    }
}

///字数限制
- (void)wordsNumber:(NSInteger)wordsNumber {
    ///字数
    if(wordsNumber < 0) {
        wordsNumber = 0;
    }
    
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%@/%@",@(wordsNumber),@(kLimitNumber)];
    
    self.wordsNumberLabel.textColor = (wordsNumber > kLimitNumber ? RGB(255, 66, 0) : RGB153153153);
}

- (void)setupTopView {
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.cornerRadius = 5.f;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = UIColor.whiteColor;
    [mainView addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(idCardViewTapAction)]];
    [self.scrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.top.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(71.f);
        make.width.mas_equalTo(ScreenW - 20);/// 撑开 scrollview
    }];
    
    UILabel *idCardTiplabel = [[UILabel alloc] init];
    idCardTiplabel.text = @"拒绝说明";
    idCardTiplabel.numberOfLines = 1;
    idCardTiplabel.textAlignment = NSTextAlignmentLeft;
    idCardTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    idCardTiplabel.font = [UIFont boldSystemFontOfSize:15.f];
    idCardTiplabel.textColor = HEXCOLOR(0x333333);
    
    [mainView addSubview:idCardTiplabel];
    [idCardTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12.f);
    }];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.text = @"* ";
    tip.numberOfLines = 1;
    tip.textAlignment = NSTextAlignmentLeft;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    tip.font = [UIFont boldSystemFontOfSize:13.f];
    tip.textColor = HEXCOLOR(0xFFFF4200);
    [mainView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(idCardTiplabel.mas_bottom).mas_offset(10.f);
        make.left.mas_equalTo(idCardTiplabel);
    }];
    
    UILabel *idCardSubTiplabel = [[UILabel alloc] init];
    idCardSubTiplabel.text = @"拒绝原因";
    idCardSubTiplabel.numberOfLines = 1;
    idCardSubTiplabel.textAlignment = NSTextAlignmentLeft;
    idCardSubTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    idCardSubTiplabel.font = [UIFont boldSystemFontOfSize:13.f];
    idCardSubTiplabel.textColor = HEXCOLOR(0xFF999999);
    
    [mainView addSubview:idCardSubTiplabel];
    [idCardSubTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip);
        make.left.mas_equalTo(tip.mas_right).mas_offset(1);
    }];
    
    UILabel *whyLabel = [[UILabel alloc] init];
    whyLabel.text = @"请选择";
    whyLabel.numberOfLines = 1;
    whyLabel.textAlignment = NSTextAlignmentLeft;
    whyLabel.font = [UIFont boldSystemFontOfSize:13.f];
    whyLabel.textColor = HEXCOLOR(0xFF333333);
    self.whyLabel = whyLabel;
    [mainView addSubview:whyLabel];
    [whyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip);
        make.right.mas_equalTo(-10);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.layer.cornerRadius = 5.f;
    bottomView.clipsToBounds = YES;
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.top.equalTo(mainView.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
//        make.height.mas_equalTo(234.f);
//        make.width.mas_equalTo(ScreenW - 20); /// 撑开 scrollview
    }];
    
    UILabel *idCardTiplabel1 = [[UILabel alloc] init];
    idCardTiplabel1.text = @"拒绝说明和凭证";
    idCardTiplabel1.numberOfLines = 1;
    idCardTiplabel1.textAlignment = NSTextAlignmentLeft;
    idCardTiplabel1.lineBreakMode = NSLineBreakByWordWrapping;
    idCardTiplabel1.font = [UIFont boldSystemFontOfSize:15.f];
    idCardTiplabel1.textColor = HEXCOLOR(0x333333);
    
    [bottomView addSubview:idCardTiplabel1];
    [idCardTiplabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12.f);
    }];
    
    UILabel *placeholderLabel = [UILabel jh_labelWithText:@"为更好解决您的问题，请描述具体的问题以及您的期望；凭证可上传，如收货时的商品图，聊天记录截图，快照单照片的等有效证据" font:12 textColor:RGB153153153 textAlignment:0 addToSuperView:bottomView];
    placeholderLabel.numberOfLines = 0;
    _placeholderLabel = placeholderLabel;
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(13);
        make.right.equalTo(bottomView).offset(-13);
        make.top.equalTo(idCardTiplabel1.mas_bottom).mas_equalTo(10);
    }];
    
    UITextView *textView = [UITextView new];
    textView.textColor = RGB515151;
    textView.showsHorizontalScrollIndicator = NO;
    textView.delegate = self;
    textView.font = JHFont(12);
    textView.tintColor = kColorMain;
    textView.backgroundColor = UIColor.clearColor;

    [bottomView addSubview:textView];
    _textView = textView;
//    textView.backgroundColor = UIColor.yellowColor;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView).offset(-13);
        make.top.equalTo(idCardTiplabel1.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    self.wordsNumberLabel = [UILabel jh_labelWithFont:11 textColor:RGB153153153 textAlignment:2 addToSuperView:bottomView];
//    self.wordsNumberLabel.backgroundColor = UIColor.redColor;
    self.wordsNumberLabel.text = @"0/200";
    [self.wordsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(textView.mas_right).mas_offset(-3);
        make.top.mas_equalTo(textView.mas_top).mas_offset(65);
    }];
    
    [bottomView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.imagesView.ViewHeight);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)idCardViewTapAction {
    [self selectCatePlateAction];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *toBeString = [self.textView.attributedText mutableCopy];
    [self wordsNumber:toBeString.string.length];
    self.placeholderLabel.hidden = (toBeString.string.length > 0);
    
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.string.length > kLimitNumber) {
                textView.text = [toBeString.string substringToIndex:kLimitNumber];
            }
        }
    }
    else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.string.length > kLimitNumber) {
            textView.text = [toBeString.string substringToIndex:kLimitNumber];
        }
    }
}

#pragma mark -------- get --------
/// 图片View
- (JHSQPublishImageView *)imagesView {
    if(!_imagesView) {
        JHSQPublishImageView *imagesView = [JHSQPublishImageView new];
        imagesView.backgroundColor = UIColor.clearColor;
        imagesView.customizeNeedThis = YES;
        [imagesView hiddenAddImageBtn:6];
        @weakify(self);
        imagesView.addAlbumBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
        };
        
        imagesView.deleteActionBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.imageArray.count > index)
            {
                [self.imageArray removeObjectAtIndex:index];
                self.imagesView.dataArray = self.imageArray;
            }
        };
        _imagesView = imagesView;
    }
    return _imagesView;
}

- (void)matchHighLightText:(JHContactUserInfoModel *)model isMenual:(BOOL)isMenual {
    if (model && [model.name isNotBlank]) {
        NSMutableAttributedString *str = self.textView.attributedText.mutableCopy;
        NSString *callString = !isMenual ? @"@" : @"";
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ ", callString, model.name]]];
        [str addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                                         NSForegroundColorAttributeName:kColor333
        } range:NSMakeRange(0, str.length)];
        NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matches = [atPersionRE matchesInString:str.string options:NSMatchingReportProgress range:str.string.rangeOfAll];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if (matchRange.length > 0 && matchRange.length <= kMax_CallTextCount) {
                YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
                [str setTextBinding:binding range:matchRange]; /// Text binding
                [str setColor:kHighLightColor range:matchRange];
            }
        }
        self.textView.attributedText = str;
    }
}

///图片数组
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if(!_imageArray)
    {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------- method --------
///选择相册
- (void)selectAlbumMethod {
  
    NSMutableArray *assetArray = [NSMutableArray new];
    for (JHAlbumPickerModel *m in self.imageArray) {
        [assetArray addObject:m.asset];
    }
    
    [JHImagePickerPublishManager showImagePickerViewWithType:1 maxImagesCount:6 assetArray:assetArray viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:dataArray];
        
        self.imagesView.dataArray = self.imageArray;
        self.imagesView.hidden = NO;
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.imagesView.ViewHeight);
        }];
    } videoSelectedBlock:nil];
    
}

///选择举报原因
- (void)selectCatePlateAction {
    [self.view endEditing:YES];
    
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
//    [vc setTitleText:@"请选择宝贝断代"];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.requestType = 5;

    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString *code) {
        @strongify(self);
        self.whyLabel.text = message;
        self.refuseReason = code;
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
#pragma mark - 上传图片
- (void)uploadImage {
    if ([self.imageArray count]<=0) {
        [self uploadDataSource];
        return;
    }
    [self showProgressHUD];
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        [self.imageArray enumerateObjectsUsingBlock:^(JHAlbumPickerModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if(model.sourceUrl){
                return;
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_group_enter(group);
            NSString * aliUploadPath = @"client_publish/c2c/order_comment";///评价图片地址
            UIImage *needUploadImage = model.image;
            CGFloat sp = 0.7;
            NSData* imageData = UIImageJPEGRepresentation(needUploadImage, sp);
            while (imageData.length/1024.0 > 500) {
                sp -= 0.1;
                imageData = UIImageJPEGRepresentation(needUploadImage, sp);
            }
            needUploadImage = [UIImage imageWithData:imageData];
            [[JHUploadManager shareInstance] uploadSingleImage:needUploadImage filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey){
                if (isFinished){
                    
                    model.sourceUrl = [NSString stringWithFormat:ALIYUNCS_FILE_BASE_STRING(@"/%@"), imgKey];
                    dispatch_semaphore_signal(semaphore);
                    dispatch_group_leave(group);
                } else {
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore);
                    [self hideProgressHUD];
                }
            }];
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"完成!");
            [self hideProgressHUD];
            [self uploadDataSource];
        });
    });
}

#pragma mark -------- 发布 --------
- (void)rightActionButton:(UIButton *)sender {
    if (self.whyLabel.text.length == 0) {
        JHTOAST(@"请填写拒绝原因");
        return;
    }
    [self uploadImage];
}

- (void)uploadDataSource {
    
    NSArray *imgUrls = [self.imageArray valueForKeyPath:@"sourceUrl"];
    NSMutableDictionary *params =  [NSMutableDictionary dictionary];
    [params setValue:self.orderId forKey:@"orderId"];
    [params setValue:self.refuseReason forKey:@"refuseReason"];
    [params setValue:self.textView.text forKey:@"refuseDesc"];
    [params setValue:self.workOrderStatus forKey:@"workOrderStatus"];
    [params setValue:self.workOrderId forKey:@"workOrderId"];
    [params setValue:imgUrls forKey:@"images"];
    
    [self showProgressHUD];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/refuseWorkOrderDetailSeller") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [self hideProgressHUD];
        [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
        [self.reloadUPData sendNext:nil];
        [self.navigationController popViewControllerAnimated:NO];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self hideProgressHUD];
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (RACSubject *)reloadUPData {
    if (!_reloadUPData) {
        _reloadUPData = [RACSubject subject];
    }
    return _reloadUPData;
}

#pragma mark - 埋点
/// 提交页面埋点
- (void)reportPageView {
    NSDictionary *par = @{
        @"page_name" : @"集市拒绝退货退款卖家页",
        @"order_id" : self.orderId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
