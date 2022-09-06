//
//  JHBeginIdentifyViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBeginIdentifyViewController.h"
#import "CommAlertView.h"
#import "NSString+Extension.h"
#import "JHCustomerCerDatePickerView.h"
#import "JHChatRecordView.h"
#import "AudioTool.h"
#import "JHAudioPlayerManager.h"
#import "SVProgressHUD.h"
#import "JHAppraisalResultlModel.h"
#import "JHRecycleOrderCancelViewController.h"
#import "JHImageTextAuthDetailViewController.h"
#import "UIButton+zan.h"
#import "JHIdentifyTextView.h"
#import "JHIdentifyDownBoxView.h"
#import "JHIdentifySelectView.h"
#import "JHIdentifyTextSelectView.h"
#import "JHIdentifyTitleDetailView.h"
#import "UIImageView+JHAnimation.h"
#import "UIView+JHGradient.h"
#import "MBProgressHUD.h"
#import "JHUploadManager.h"

static NSInteger const MaxTextNums = 200;


@interface JHBeginIdentifyViewController () <UITextFieldDelegate,UITextViewDelegate,AudioToolDidFinish,UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView *containScrollerView;
@property(strong,nonatomic) UIView *TopView;
@property(strong,nonatomic) UIView *topContentView;
@property(strong,nonatomic) UIView *BottomView;
/// 鉴定选项视图
@property(strong,nonatomic) UIView *titleBtnContaion;
@property(strong,nonatomic) UILabel *titleLabel;

@property(strong,nonatomic) UILabel *resultLabel;
/// 鉴定结果描述文本
@property (nonatomic, strong) UITextView *desTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *wordsNumberLabel;
@property (nonatomic, strong) UIView *TFView;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *volicePlayBtn;
@property (nonatomic, strong) UIButton *voliceDelBtn;
/// 音频视图
@property (nonatomic, strong) UIView *voliceView;

@property (nonatomic, assign) BOOL isRecordCancel;
@property(copy,nonatomic) NSString *resultText;
@property(assign,nonatomic) int resultIntValue;
//@property(copy,nonatomic) NSString *levelText;

@property (nonatomic, strong) JHCustomerCerDatePickerView *timePicker;
@property (nonatomic, strong) NSString *fileUrl;   //文件路径
@property (nonatomic, strong) NSString *videoAliPath;

@property (nonatomic, strong) NSArray<JHAppraisalResultlModel *> *dataInfos;
@property (nonatomic, copy) NSString *remarkType;

/// 语音视图
@property (nonatomic, strong) UIStackView *dateContentView;
/// 语音播放动画
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *dateLabel;

/// 背景视图
@property (nonatomic, strong) UIView *bgView;

@end



@implementation JHBeginIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProps];
    [self requestDataInfo];
    self.remarkType = @"1";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}
- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
- (void)setupProps {
    self.jhNavView.backgroundColor = UIColor.clearColor;
    self.title = @"开始鉴定";
    self.view.backgroundColor = HEXCOLOR(0XFFF5F5F8);
    self.fileUrl = [self getWavFilePathWithStr:1];
    [AudioTool shareInstance].filePath = self.fileUrl;
    [AudioTool shareInstance].delegate = self;
}

- (void)setupUI {
    [self setupMainUI];
    [self setupTopUI];
    [self setupBottomUI];
}

#pragma mark - 点击鉴定选项
- (void)btnClick:(UIButton *)btn {
    NSLog(@"btnClick");
    if([self.titleBtnContaion.subviews containsObject:btn]){
        for (UIButton *tmp in self.titleBtnContaion.subviews) {
            tmp.selected = NO;
        };
        self.resultText = btn.titleLabel.text;
        btn.selected = YES;
//        self.resonView.hidden = YES;
//        self.otherTF.hidden = YES;
        self.resultIntValue = (int)btn.tag;
        
        [self setupDetailUI];

        [self.view setNeedsLayout];
        return;
    }
    
//    if([self.levelBtnContaion.subviews containsObject:btn]){
//        for (UIButton *tmp in self.levelBtnContaion.subviews) {
//            tmp.selected = NO;
//        };
//        btn.selected = YES;
////        self.levelText = btn.titleLabel.text;
//        return;
//    }
    
}


// 查看鉴定详情
- (void)rightActionButton:(UIButton *)btn {
    JHImageTextAuthDetailViewController *vc = [JHImageTextAuthDetailViewController new];
    vc.taskId = self.taskId.intValue;
    vc.isFromIdentify = true;
    vc.recordInfoId = self.recordInfoId.intValue;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 文字 语音 切换
- (void)switchActionButton:(UIButton *)btn {
    self.TFView.hidden = !self.TFView.hidden;
    self.finishBtn.hidden = self.TFView.hidden;
    self.recordButton.hidden = !self.finishBtn.hidden;
    if(self.TFView.hidden){
        [self.switchBtn setTitle:@"切换文字" forState:UIControlStateNormal];
        self.remarkType = @"1";
        if (self.voliceDelBtn.hidden == false) {
            self.finishBtn.hidden = false;
        }
    }else {
        [self.switchBtn setTitle:@"切换语音" forState:UIControlStateNormal];
        self.remarkType = @"0";
    }
}
#pragma mark - 语音播放
- (void)volicePlayBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [[JHAudioPlayerManager shareManger] createAudioWithAudioFilePath:self.fileUrl];
        [[JHAudioPlayerManager shareManger] play];
        [self startAnimation];
        @weakify(self)
        [JHAudioPlayerManager shareManger].didFinished = ^(void){
            @strongify(self)
            [self stopAnimation];
        };
        
    }else {
        [[JHAudioPlayerManager shareManger] pause];
        [self stopAnimation];
    }
    //    [[AudioTool shareInstance] startPlayWithUrl:[NSURL URLWithString:self.fileUrl] atTime:0.f];
    
}
#pragma mark - 语音删除
- (void)voliceDelBtnClick:(UIButton *)btn {
    NSLog(@"voliceDelBtnClick");
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"请确认是否删除？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        NSLog(@"voliceDelBtnClick 确认");
        [self deleteFilePath:self.fileUrl];
        self.voliceDelBtn.hidden = YES;
        self.volicePlayBtn.hidden = YES;
        self.recordButton.hidden = NO;
        self.finishBtn.hidden = YES;
        [self stopAnimation];
    };
    
    alert.cancleHandle = ^{
        NSLog(@"voliceDelBtnClick 取消");
    };
}
#pragma mark - 开始录音
- (void)recordAudio: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始录音");
        [self startRecordAudio];
        self.recordButton.selected = true;
        self.recordButton.backgroundColor = HEXCOLOR(0xe5e5e5);
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.isRecordCancel) {
            NSLog(@"取消录音");
            [self cancelledRecordAudio];
        }else {
            NSLog(@"停止录音");
            [self stopRecordAudio];
        }
        self.recordButton.selected = false;
        self.recordButton.backgroundColor = HEXCOLOR(0xfecb33);
    }else {
//        CGPoint point = [sender locationInView:self.BottomView];
//        CGFloat y = self.recordButton.frame.origin.y;
//        NSLog(@"%f",point.y);
//        if (point.y + 40 <= y && self.isRecordCancel == false) {
//            self.isRecordCancel = true;
//            [JHChatRecordView showWithType:JHChatRecordViewTypeCancel];
//        }else if (point.y + 40 > y && self.isRecordCancel == true) {
//            self.isRecordCancel = false;
//            [JHChatRecordView showWithType:JHChatRecordViewTypeRecording];
//        }
    }
}

#pragma mark - 鉴定完成
- (void)finishActionButton:(UIButton *)btn {
    if (self.resultText.length<=0) {
        [self.view makeToast:@"请选择鉴定真伪" duration:1.f position:CSToastPositionCenter];
        return;
    }
    @weakify(self)
    [self showAlertWithTitle:@"" desc:@"请确认已鉴定完成？" sureTitle:@"确认" handle:^{
        @strongify(self)
        if ([self.remarkType isEqualToString:@"1"]) {
            [self uploadRecordToAli];
        }else {
            [self finishRequest];
        }
    } cancelHandle:nil];
}
- (void)showAlertWithTitle : (NSString *)title
                      desc : (NSString *)desc
                 sureTitle : (NSString *)sureTitle
                    handle : (JHFinishBlock)handle
              cancelHandle : (JHFinishBlock) cancelHandle {
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:title andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:sureTitle];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = handle;
    alert.cancleHandle = cancelHandle;
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
#pragma mark - 上传音频
- (void)uploadRecordToAli {
    NSTimeInterval duration = [self audioDurationFromURL:self.fileUrl];
    if (duration <= 0) {
        [self finishRequest];
        return;
    }
    
    [self showProgressHUD];
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_enter(group);
        
        NSString * aliUploadPath = @"client_publish/voice";
        [[JHUploadManager shareInstance] uploadAudioByPath:self.fileUrl filePath: aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey){
            if (isFinished){

//                NSString *sourceUrl = [NSString stringWithFormat:ALIYUNCS_FILE_BASE_STRING(@"/%@"), imgKey];
                NSString *sourceUrl = [NSString stringWithFormat:@"/%@", imgKey];
                self.videoAliPath = sourceUrl;
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
            } else {
                [self hideProgressHUD];
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
            }
        }];

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"完成!");
            [self hideProgressHUD];
            [self finishRequest];
        });
    });
}
- (void)finishRequest {
    NSMutableArray *tmps = [NSMutableArray array];
    
    JHAppraisalResultlModel *model = self.dataInfos[self.resultIntValue];
    
    [tmps appendObject:model];

    NSArray *dicArr = [JHAppraisalResultlModel mj_keyValuesArrayWithObjectArray:model.attrs];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.resultIntValue) forKey:@"appraisalResult"];
    [params setValue:self.desTextView.text forKey:@"remark"];
    [params setValue:self.remarkType forKey:@"remarkType"];
    [params setValue:self.taskId forKey:@"taskId"];
    [params setValue:@([self audioDurationFromURL:self.fileUrl]) forKey:@"voiceDuration"];
    [params setValue:self.videoAliPath forKey:@"voiceUrl"];
    [params setValue:dicArr forKey:@"appraisalReportAttrReqs"];
    
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalReportInfo/save") Parameters:params.copy requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [NSNotificationCenter.defaultCenter postNotificationName:IdentifyFinishedNotificationName object:nil];
        [self popToVC];
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)requestDataInfo {
    
    NSDictionary *params = @{@"imageType":@"s,m,b,o",
                             @"recordInfoId":self.recordInfoId
    };
    
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalCategoryAttr/getByRecordInfoId") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        
        
        self.dataInfos = [JHAppraisalResultlModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        
        //        [JHAppraisalResultlModel mj_keyValuesArrayWithObjectArray:];
        [self setupUI];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        // 刷新数据
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)popToVC {
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs animated:true];
}
#pragma mark - UI
- (void)setupMainUI {
    [self.view insertSubview:self.bgView atIndex:0];
//    [self.view addSubview:self.bgView];
    [self.view addSubview:self.containScrollerView];
    [self.containScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    UIView *TopView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.containScrollerView];
    TopView.layer.cornerRadius = 8.f;
    TopView.clipsToBounds = YES;
    self.TopView = TopView;
    [self.TopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(ScreenW-20);
    }];
    
    UIView *BottomView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.containScrollerView];
    BottomView.layer.cornerRadius = 8.f;
    BottomView.clipsToBounds = YES;
    self.BottomView = BottomView;
    [self.BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.TopView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(384);
        make.width.mas_equalTo(ScreenW-20);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setupTopUI {
    UIButton *desBtn = [UIButton jh_buttonWithTitle:@"查看鉴定详情" fontSize:14.f textColor:HEXCOLOR(0xFF999999) target:self action:@selector(rightActionButton:) addToSuperView:self.TopView];
        
    [desBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
    }];
    
    UIImageView *desImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    desImageView.image = [UIImage imageNamed:@"c2c_identify_detail_icon"];
    
    [self.TopView addSubview:desImageView];
    
    [desImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(desBtn);
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.left.mas_equalTo(desBtn.mas_right).offset(5);
    }];
    
    
    UILabel *titleLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.TopView];
    titleLabel.text = @"鉴定真伪：";
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(desBtn.mas_bottom).mas_offset(5);
        make.height.equalTo(@48);
        make.width.equalTo(@70);
    }];
    
    [self.titleBtnContaion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(titleLabel);
        make.height.equalTo(@35);
    }];
    NSArray *resultTexts = [self.dataInfos valueForKeyPath:@"appraisalResultName"];
    [self setupSingleBtnWithTitles:resultTexts andSuperView:self.titleBtnContaion];
   
    self.resultText = resultTexts.firstObject;
    
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(-16);
    }];
    
    [self setupDetailUI];
}

- (void)setupDetailUI {
    [self.topContentView removeAllSubviews];
    NSArray *attrs = ((JHAppraisalResultlModel *)self.dataInfos[self.resultIntValue]).attrs;
    
    UIView *currentView = self.titleLabel;
    for (int i=0; i< attrs.count; i++) {
        JHAppraisalAttrsResultlModel *model = attrs[i];
        if ([model.attrValueType isEqualToString:@"0"]) { // 固定值
            currentView = [self setupTitleDetailUI:model topView:currentView];
        }else if ([model.attrValueType isEqualToString:@"1"]) { // 自定义 输入
            currentView = [self setupTextViewUI:model topView:currentView];
        }
        else if ([model.attrValueType isEqualToString:@"2"]) { // 单选
            currentView = [self setupSingleSelectView:model topView:currentView];
        }
        else if ([model.attrValueType isEqualToString:@"3"]) { // 枚举
            currentView = [self setupDownBoxUI:model topView:currentView];
        }
        else if ([model.attrValueType isEqualToString:@"4"]) { // 单选+输入
            currentView = [self setupResonView:model topView:currentView];
        }
    }
    [currentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}
- (UIView *)setupTitleDetailUI:(JHAppraisalAttrsResultlModel *)model topView : (UIView *)topView {
    JHIdentifyTitleDetailView *view = [[JHIdentifyTitleDetailView alloc] initWithFrame:CGRectZero];
    view.model = model;
    [self.topContentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(0);
        }else {
            make.top.mas_equalTo(0);
        }
    }];
    
    return view;
    
}
- (UIView *)setupTextViewUI:(JHAppraisalAttrsResultlModel *)model topView : (UIView *)topView{
    
    JHIdentifyTextView *textView = [[JHIdentifyTextView alloc] initWithFrame: CGRectZero];
    textView.model = model;
    [self.topContentView addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(0);
        }else {
            make.top.mas_equalTo(0);
        }
    }];
    
    return textView;
}

- (UIView *)setupDownBoxUI:(JHAppraisalAttrsResultlModel *)model topView : (UIView *)topView{
    
    JHIdentifyDownBoxView *view = [[JHIdentifyDownBoxView alloc] initWithFrame:CGRectZero];
    view.model = model;
    [self.topContentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(0);
        }else {
            make.top.mas_equalTo(0);
        }
    }];
    
    return view;
}

- (UIView *)setupSingleSelectView:(JHAppraisalAttrsResultlModel *)model topView : (UIView *)topView {
    
    JHIdentifySelectView *view = [[JHIdentifySelectView alloc] initWithFrame:CGRectZero];
    view.model = model;
    [self.topContentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(0);
        }else {
            make.top.mas_equalTo(0);
        }
    }];
    
    return view;
    

//    NSArray *tmps = [model.attrValues valueForKeyPath:@"name"];
//    [self setupSingleBtnWithTitles:tmps andSuperView:levelBtnContaion];
//    self.levelBtnContaion = levelBtnContaion;
//    self.levelText = tmps.firstObject;
}

- (UIView *)setupResonView:(JHAppraisalAttrsResultlModel *)model topView : (UIView *)topView {
    
    JHIdentifyTextSelectView *view = [[JHIdentifyTextSelectView alloc] initWithFrame:CGRectZero];
    
    view.model = model;
    [self.topContentView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(0);
        }else {
            make.top.mas_equalTo(0);
        }
    }];
    
    return view;
}

- (void)setupBottomUI {
    UILabel *resultLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.BottomView];
    resultLabel.text = @"鉴定结果：";
    self.resultLabel = resultLabel;
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(20);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(resultLabel);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(86, 33));
    }];
    [self setupVoliceView];
    [self setupTFView];
    
    [self.BottomView addSubview:self.recordButton];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
    }];
    
}
#pragma mark - 设置 - 音频UI
- (void)setupVoliceView {

    [self.BottomView addSubview:self.voliceView];
    
    [self.voliceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultLabel);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.resultLabel.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-64);
    }];
    
    UILabel *tipLabel = [UILabel jh_labelWithFont:11 textColor:HEXCOLOR(0xFF999999) addToSuperView:self.voliceView];
    tipLabel.text = @"请通过下方的语音按钮进行回复";
    
    [self.volicePlayBtn addSubview:self.dateContentView];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [self.volicePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultLabel);
        make.size.mas_equalTo(CGSizeMake(140, 30));
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(10);
    }];
    [self.dateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.voliceDelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(44, 30));
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(10);
    }];
    
}
#pragma mark - 设置 - 文本UI
- (void)setupTFView {
    [self.BottomView addSubview:self.TFView];
    
    [self.TFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.resultLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.resultLabel.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-64);
    }];
    
    UILabel *placeholderLabel = [UILabel jh_labelWithText:@"必填，不超过200个汉字" font:14 textColor:RGB153153153 textAlignment:0 addToSuperView:self.TFView];
    placeholderLabel.numberOfLines = 0;
    _placeholderLabel = placeholderLabel;
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(18);
    }];
    
    
    [self.TFView addSubview: self.desTextView];
    [self.desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    //    self.wordsNumberLabel = [UILabel jh_labelWithFont:11 textColor:RGB153153153 textAlignment:2 addToSuperView:bottomView];
    //    self.wordsNumberLabel.backgroundColor = UIColor.redColor;
    //    self.wordsNumberLabel.text = @"0/200";
    //    [self.wordsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(textView.mas_right).mas_offset(-3);
    //        make.top.mas_equalTo(textView.mas_top).mas_offset(65);
    //    }];
    
    //    [bottomView addSubview:self.imagesView];
    //    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.textView.mas_bottom).offset(10);
    //        make.left.mas_equalTo(0);
    //        make.right.mas_equalTo(0);
    //        make.height.mas_equalTo(self.imagesView.ViewHeight);
    //        make.bottom.mas_equalTo(-10);
    //    }];
}
#pragma mark - 设置 - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isEqual:self.desTextView]) {
        self.placeholderLabel.hidden = textView.text.length!=0;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MaxTextNums)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MaxTextNums];
        
        [textView setText:s];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if([NSString isNineKeyBoard:string]) return YES;
    if (string.length <= 0) return true;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MaxTextNums - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
 
}

///字数限制
- (void)wordsNumber:(NSInteger)wordsNumber {
    ///字数
    //    if(wordsNumber < 0) {
    //        wordsNumber = 0;
    //    }
    
    //    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%@/%@",@(wordsNumber),@(kLimitNumber)];
    
    //    self.wordsNumberLabel.textColor = (wordsNumber > 200 ? RGB(255, 66, 0) : RGB153153153);
}

- (void)setupSingleBtnWithTitles:(NSArray *)titles andSuperView:(UIView *)superView {
    UIButton *tempBtn;
    for (int i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UIButton *btn = [UIButton jh_buttonWithTitle:title fontSize:13 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(btnClick:) addToSuperView:superView];
        btn.tag = i;
        btn.layer.cornerRadius = 16.5;
        btn.clipsToBounds = YES;
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFF5F5F5)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFCEC9D)] forState:UIControlStateSelected];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0) {
                btn.selected = YES;
                make.left.mas_equalTo(0);
            }else {
                make.left.mas_equalTo(tempBtn.mas_right).mas_offset(10);
            }
            make.centerY.mas_equalTo(superView);
            make.height.mas_equalTo(33);
            make.width.mas_equalTo(title.length>2?77:46);
        }];
        tempBtn = btn;
    }
    
}
#pragma mark - 录音相关
-(NSString *)getWavFilePathWithStr:(NSInteger)num {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"myRecord%zd.wav",num]];
    NSLog(@"WavFilePath=%@",filePath);
    return filePath;
}

-(void)deleteFilePath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager  fileExistsAtPath:filePath]) {
        if ([manager isDeletableFileAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:nil];
        }
    } else {
        
    }
}
// 开始录音
- (void)startRecordAudio {
   
    [self deleteFilePath:self.fileUrl];
    
    [[AudioTool shareInstance] startRecordBlock:^(BOOL started) {
        if (started) {
            [JHChatRecordView showWithType:JHChatRecordViewTypeRecording];
        }else {
            JHTOAST(@"录音失败请重试");
        }
    }];
    
    
}
// 停止录音
- (void)stopRecordAudio {
    [[AudioTool shareInstance] stopRecord];
    [JHChatRecordView hide];
}
// 取消录音
- (void)cancelledRecordAudio {
    //    [self.sessionManager.chatManager cancelRecordAudio];
    [JHChatRecordView hide];
}

- (void)changeRecordCancel:(BOOL)isCancel {
    if (isCancel) {
        [JHChatRecordView showWithType:JHChatRecordViewTypeCancel];
    }else {
        [self stopRecordAudio];
        [JHChatRecordView showWithType:JHChatRecordViewTypeRecording];
    }
}

- (NSTimeInterval)audioDurationFromURL:(NSString *)url {
    AVURLAsset *audioAsset = nil;
    NSDictionary *dic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:dic];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

- (void)recorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {

    if(flag){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSTimeInterval duration = [self audioDurationFromURL:self.fileUrl];
            if (duration <= 0) return;
            NSString *tmp = [NSString stringWithFormat:@"%.1f″",duration];
            self.dateLabel.text = tmp;
            self.voliceDelBtn.hidden = NO;
            self.volicePlayBtn.hidden = NO;
            self.recordButton.hidden = YES;
            self.finishBtn.hidden = NO;
        });
    }
}

- (void)startAnimation {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i < 4; i++) {
        NSString *name = [NSString stringWithFormat:@"IM_audio_play_icon%d", i];
        [arr appendObject:name];
    }
    [self.animationView startAnimationWithImages:arr];
}
- (void)stopAnimation {
    [self.animationView stopAnimating];
}
- (void)yearActionButton:(UIButton *)btn{
    //    [self.timePicker show];
    
//    JHAppraisalAttrsResultlModel *model =  self.trueModel.attrs[1];
    
    
}
#pragma mark - Lazy
- (UIScrollView *)containScrollerView {
    if (!_containScrollerView) {
        _containScrollerView = [[UIScrollView alloc] init];
                _containScrollerView.delegate = self;
        _containScrollerView.showsHorizontalScrollIndicator = NO;
        _containScrollerView.showsVerticalScrollIndicator = NO;
        _containScrollerView.backgroundColor = UIColor.clearColor;
        
    }
    return _containScrollerView;
}

- (JHCustomerCerDatePickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[JHCustomerCerDatePickerView alloc] init];
        [_timePicker setYearLeast:([self getNowYear] - 50)];
        [_timePicker setYearSum:51];
      
    }
    return _timePicker;
}

- (NSInteger)getNowYear {
    NSDate *date = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString = [dateformatter stringFromDate:date];
    return [thisYearString integerValue];
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton jh_cornerRadius:5];
        [_recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开 结束" forState:UIControlStateSelected];
        _recordButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_recordButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _recordButton.backgroundColor = HEXCOLOR(0xFFFECB33);
        UILongPressGestureRecognizer *longPgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordAudio: )];
        longPgr.minimumPressDuration = 0.5;
        [_recordButton addGestureRecognizer:longPgr];
    }
    return _recordButton;
}
- (UIView *)topContentView {
    if (!_topContentView) {
        _topContentView = [UIView jh_viewWithColor:HEXCOLOR(0xffffff) addToSuperview:self.TopView];
    }
    return _topContentView;
}
- (UIView *)voliceView {
    if (!_voliceView) {
        _voliceView = [[UIView alloc] initWithFrame:CGRectZero];
        _voliceView.layer.cornerRadius = 5.f;
        _voliceView.clipsToBounds = YES;
        _voliceView.backgroundColor = UIColor.whiteColor;
    }
    return _voliceView;
}
- (UIButton *)volicePlayBtn {
    if (!_volicePlayBtn) {
        _volicePlayBtn = [UIButton jh_buttonWithTitle:@"" fontSize:13 textColor:HEXCOLOR(0x333333) target:self action:@selector(volicePlayBtnClick:) addToSuperView:self.voliceView];
        _volicePlayBtn.hidden = true;
        [_volicePlayBtn setBackgroundImage:[UIImage imageNamed:@"c2c_audio_bg_icon"] forState:UIControlStateNormal];
    }
    return _volicePlayBtn;
}
- (UIButton *)voliceDelBtn {
    if (!_voliceDelBtn) {
        _voliceDelBtn = [UIButton jh_buttonWithTitle:@" 删除" fontSize:12 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(voliceDelBtnClick:) addToSuperView:self.voliceView];
        [_voliceDelBtn setImage:[UIImage imageNamed:@"c2c_audio_delete_icon"] forState:UIControlStateNormal];
        _voliceDelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _voliceDelBtn.hidden = true;
    }
    return _voliceDelBtn;
}

- (UIStackView *)dateContentView {
    if (!_dateContentView) {
        _dateContentView = [[UIStackView alloc] initWithArrangedSubviews:@[self.animationView, self.dateLabel]];
        _dateContentView.axis = UILayoutConstraintAxisHorizontal;;
        _dateContentView.spacing = 4;
        _dateContentView.alignment = UIStackViewAlignmentCenter;
        _dateContentView.distribution = UIStackViewDistributionEqualSpacing;
        _dateContentView.userInteractionEnabled = false;
    }
    return _dateContentView;
}
- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationView.image = [UIImage imageNamed:@"IM_audio_play_icon3"];
    }
    return _animationView;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textColor = HEXCOLOR(0x333333);
        _dateLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _dateLabel;
}
- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UIButton jh_buttonWithTitle:@" 切换文字" fontSize:14.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(switchActionButton:) addToSuperView:self.BottomView];
        _switchBtn.layer.cornerRadius = 5.0f;
        _switchBtn.layer.borderWidth = 1;
        _switchBtn.layer.borderColor = HEXCOLOR(0xffd70f).CGColor;
        _switchBtn.backgroundColor = HEXCOLOR(0xfffbee);
        [_switchBtn setImage:[UIImage imageNamed:@"c2c_audio_switch_icon"] forState:UIControlStateNormal];
    }
    return _switchBtn;
}
- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton jh_buttonWithTitle:@"鉴定完成" fontSize:14.f textColor:HEXCOLOR(0xFF333333) target:self action:@selector(finishActionButton:) addToSuperView:self.BottomView];
        _finishBtn.layer.cornerRadius = 5.0f;
        _finishBtn.backgroundColor =HEXCOLOR(0xFFFECB33);
        _finishBtn.hidden = YES;
    }
    return _finishBtn;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW * 307 / 375)];
        NSArray *colors = @[HEXCOLOR(0xfeecb6), HEXCOLOR(0xf5f5f8)];
        [_bgView jh_setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }
    return _bgView;
}
- (UITextView *)desTextView {
    if (!_desTextView) {
        _desTextView = [UITextView new];
        _desTextView.textColor = RGB515151;
        _desTextView.showsHorizontalScrollIndicator = NO;
        _desTextView.delegate = self;
        _desTextView.font = JHFont(14);
        _desTextView.tintColor = kColorMain;
        _desTextView.backgroundColor = UIColor.clearColor;
        _desTextView.returnKeyType = UIReturnKeyDone;
    }
    return _desTextView;
}
- (UIView *)titleBtnContaion {
    if (!_titleBtnContaion) {
        _titleBtnContaion = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.TopView];
    }
    return _titleBtnContaion;
}
- (UIView *)TFView {
    if (!_TFView) {
        _TFView = [[UIView alloc] init];
        _TFView.layer.cornerRadius = 5.f;
        _TFView.clipsToBounds = YES;
        _TFView.backgroundColor = UIColor.whiteColor;
        _TFView.hidden = YES;
    }
    return _TFView;
}
@end



