//
//  JHSQPublishViewController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import <SVProgressHUD.h>
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

#define kLimitNumber  10000

@interface JHSQPublishViewController () <UITextViewDelegate>

/// 视频模型
@property (nonatomic, strong) JHAlbumPickerModel *videoModel;

/// 图片数组
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *imageArray;

/// 发布模型
@property (nonatomic, strong) JHSQPublishModel *model;

///视频时长
@property (nonatomic, assign) NSInteger videoDuration;

/// 输入框
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;

/// 视频 view
@property (nonatomic, weak) JHSQPublishVideoView *videoView;

/// 照片view
@property (nonatomic, weak) JHSQPublishImageView *imagesView;

@property (nonatomic, weak) JHSQPublishBottomView *bottomView;

/// 板块、话题
@property (nonatomic, weak) JHSQPublishSelectPlateTopicView *plateTopicView;

@property (nonatomic, strong) NSMutableArray <JHPublishTopicDetailModel *> *topicArray;

/// 可滚动载体
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger popCount;

/// 编辑
@property (nonatomic, strong) JHPostDetailModel *detailData;

@property (nonatomic, assign) BOOL isEdit;

@end

@implementation JHSQPublishViewController

- (void)dealloc {
    NSLog(@"🔥");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = YES;
        [nav setShouldReceiveTouchViewController:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    ///发布页停留时长：结束
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPublishBrowse params:@{@"item_type" : @(self.type + 1),JHUPBrowseKey:JHUPBrowseEnd}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _popCount = self.type == 2 ? 2 : 1;
    
    [self initLeftButton];
    
    [self addUI];
    
    if((_type == 2) && _asset){//视频
        [self showVideoViewWithAsset:(AVURLAsset *)_asset timeRange:_timeRange];
    }
    else if(_type == 1 && _dataArray && _dataArray.count > 0){//图片
        [self.imageArray addObjectsFromArray:_dataArray];
        self.imagesView.dataArray = _dataArray;
    }
    if(_topic) {
        [self.topicArray addObject:_topic];
    }
    if(_plate) {
        self.model.channel_id = _plate.channel_id;
        self.plateTopicView.plateName = _plate.channel_name;
    }
    self.plateTopicView.topicArray = self.topicArray;
    ///发布页停留时长：开始
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPublishBrowse params:@{@"item_type" : @(self.type +  1),JHUPBrowseKey:JHUPBrowseBegin}];
    [self addObservers];
    
    if(self.draftBoxModel) {
        [self updateUIWithDraftBoxModel:self.draftBoxModel];
    }
    
    NSString *position = (self.type == 2 ? @"小视频" : @"动态");
    [JHTracking trackEvent:@"nrfbContentEdit" property:@{@"content_type":position}];
    
}
- (void)addObservers {
    [self.textView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"attributedText"]) {
        self.bottomView.wordsNumber = self.textView.attributedText.length;
        self.model.content = [[JHEmojiManager sharedInstance] plainText];
        self.placeholderLabel.hidden = (self.textView.attributedText.length > 0);
    }
}

- (void)addUI {
    [self initRightButtonWithName:@"发布" action:@selector(rightActionButton:)];

    _scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:YES bounces:YES pagingEnabled:NO addToSuperView:self.view];
    _scrollView.backgroundColor = UIColor.whiteColor;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    
    UILabel *placeholderLabel = [UILabel jh_labelWithText:@"有趣丰富的描述会为您的创作带来更多的关注和互动" font:16 textColor:RGB153153153 textAlignment:0 addToSuperView:self.scrollView];
    placeholderLabel.numberOfLines = 2;
    _placeholderLabel = placeholderLabel;
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(13);
        make.right.equalTo(self.scrollView).offset(-13);
        make.top.equalTo(self.scrollView).offset(10);
        make.width.mas_equalTo(ScreenW - 26.5);/// 撑开 scrollview
    }];
    
    UITextView *textView = [UITextView new];
    textView.textColor = RGB515151;
    textView.delegate = self;
    textView.font = JHFont(16);
    textView.tintColor = kColorMain;
    textView.backgroundColor = UIColor.clearColor;

    [self.scrollView addSubview:textView];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    bar.hidden = YES;
    textView.inputAccessoryView = bar;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
        NSParagraphStyleAttributeName:paragraphStyle
    };
    textView.typingAttributes = attributes;
    _textView = textView;
    [[JHEmojiManager sharedInstance] setCurrentText:_textView andType:_textView.font];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.top.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(150);
    }];
    
    [self changePlateTopicViewTop];
    
    [self bottomView];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *toBeString = [self.textView.attributedText mutableCopy];
    self.bottomView.wordsNumber = toBeString.string.length;
    self.model.content = toBeString.string;
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
            [self configTextAttributeText:toBeString];
        }
        else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }
    else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.string.length > kLimitNumber) {
            textView.text = [toBeString.string substringToIndex:kLimitNumber];
        }
        [self configTextAttributeText:toBeString];
    }
}

- (void)configTextAttributeText:(NSMutableAttributedString *)toBeString {
    self.textView.attributedText = [JHAttributeStringTool markAtBlue:toBeString];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"@"]) {  //判断输入的字符是不是@
        //在这里跳转
        __block NSMutableAttributedString *content = [self.textView.attributedText mutableCopy];
        [JHSQManager enterCallUsetListPage:^(JHContactUserInfoModel * _Nonnull model) {
            if (model && [model.name isNotBlank]) {
                [content appendString:[NSString stringWithFormat:@"@%@ ", model.name]];
                [self configTextAttributeText:content];
            }
        }];
    }
    return YES;
}

#pragma mark -------- get --------
///视频View
- (JHSQPublishVideoView *)videoView {
    if(!_videoView) {
        JHSQPublishVideoView *videoView = [JHSQPublishVideoView new];
        videoView.backgroundColor = UIColor.whiteColor;
        [self.scrollView insertSubview:videoView belowSubview:self.bottomView];
        [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(10);
            make.left.equalTo(self.textView);
            make.size.mas_equalTo([JHSQPublishVideoView viewSize]);
        }];
        @weakify(self);
        videoView.videoClickBlock = ^{
            @strongify(self);
            NSURL *url;
            if(self.isEdit) {
                url = [NSURL URLWithString:self.detailData.videoInfo.url];
            }
            else {
                [NSURL fileURLWithPath:self.videoModel.videoPath];
            }
            AVPlayerViewController *ctrl = [AVPlayerViewController new];
            ctrl.player = [[AVPlayer alloc]initWithURL:url];
            [self presentViewController:ctrl animated:YES completion:nil];
        };
        videoView.deleteActionBlock = ^{
            @strongify(self);
            self.videoModel = nil;
            self.videoView.hidden = YES;
            self.imagesView.hidden = NO;
            self.imagesView.dataArray = self.imageArray;
            [JHGrowingIO trackEventId:JHSQPublishDeleteSourcesClick];
            [self changePlateTopicViewTop];
        };
        _videoView = videoView;
    }
    return _videoView;
}

/// 图片View
- (JHSQPublishImageView *)imagesView
{
    if(!_imagesView)
    {
        JHSQPublishImageView *imagesView = [JHSQPublishImageView new];
        imagesView.backgroundColor = UIColor.whiteColor;
        [self.scrollView insertSubview:imagesView belowSubview:self.plateTopicView];
        [imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(10);
            make.centerX.equalTo(self.scrollView);
            make.size.mas_equalTo([JHSQPublishImageView viewSize]);
        }];
        @weakify(self);
        imagesView.addAlbumBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
            [JHGrowingIO trackEventId:JHSQPublishAddSourcesDescClick];
        };
        
        imagesView.deleteActionBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.imageArray.count > index)
            {
                [self.imageArray removeObjectAtIndex:index];
                self.imagesView.dataArray = self.imageArray;
            }
            [JHGrowingIO trackEventId:JHSQPublishDeleteSourcesClick];
            [self changePlateTopicViewTop];
        };
        _imagesView = imagesView;
    }
    return _imagesView;
}

///底部工具
- (JHSQPublishBottomView *)bottomView
{
    if(!_bottomView)
    {
        CGSize size = [JHSQPublishBottomView viewSize];
        _bottomView = [JHSQPublishBottomView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
        _bottomView.frame = CGRectMake(0, ScreenH - UI.bottomSafeAreaHeight - size.height, size.width, size.height);
        @weakify(self);
        _bottomView.addAlbumBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
            [JHGrowingIO trackEventId:JHSQPublishAddSourcesButtonClick];
        };
        _bottomView.keybordSwitchBlock = ^(BOOL showEmoji) {
            [[JHEmojiManager sharedInstance] changeKeyboardTo:showEmoji];
        };
        _bottomView.callUsetListBlock = ^{
            [JHSQManager enterCallUsetListPage:^(JHContactUserInfoModel * _Nonnull model) {
                @strongify(self);
                [self matchHighLightText:model isMenual:NO];
            }];
        };
    }
    return _bottomView;
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

- (JHSQPublishSelectPlateTopicView *)plateTopicView {
    if(!_plateTopicView)
    {
        _plateTopicView = [JHSQPublishSelectPlateTopicView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.scrollView];
        [_plateTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollView);
            make.height.mas_equalTo(97);
            make.top.equalTo(self.scrollView).offset(250);
            make.bottom.equalTo(self.scrollView).offset(-100);
        }];
        @weakify(self);
        _plateTopicView.addTopicBlock = ^{
            @strongify(self);
            [self selectTopicAction];
        };
        _plateTopicView.addCatePlateBlock = ^{
            @strongify(self);
            if(!self.isEdit) {
                [self selectCatePlateAction];
            }
        };
        _plateTopicView.deleteTopicBlock = ^(NSInteger index) {
            @strongify(self);
            if(self.topicArray.count > index)
            {
                [self.topicArray removeObjectAtIndex:index];
                self.plateTopicView.topicArray = self.topicArray.copy;
            }
        };
        _plateTopicView.deletePlateBlock = ^{
            @strongify(self);
            self.plateTopicView.plateName = @"";
            self.model.channel_id = nil;
        };
    }
    return _plateTopicView;
}

- (void)changePlateTopicViewTop {
    
    CGFloat top = 190;
    if(self.imageArray.count > 0)
    {
        if(self.imageArray.count <= 2)
        {
            top += (ScreenW / 3.0) * 1.f;
        }
        else if(self.imageArray.count <= 5)
        {
            top += (ScreenW / 3.0) * 2.0;
        }
        else
        {
            top += (ScreenW / 3.0) * 3.0;
        }
    }
    else if(self.videoModel)
    {
        top += [JHSQPublishVideoView viewSize].height;
    }
    else
    {
        if(_imagesView && !_imagesView.isHidden)
        {
            top += (ScreenW / 3.0);
        }
        else
        {
            top += 90.0;
        }
    }
   
    [self.plateTopicView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(top);
    }];
}

///图片数组
- (NSMutableArray<JHAlbumPickerModel *> *)imageArray {
    if(!_imageArray)
    {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

///选择的话题数组
- (NSMutableArray<JHPublishTopicDetailModel *> *)topicArray {
    if(!_topicArray)
    {
        _topicArray = [NSMutableArray new];
    }
    return _topicArray;
}

- (JHSQPublishModel *)model {
    if(!_model)
    {
        _model = [JHSQPublishModel new];
    }
    return _model;
}

#pragma mark -------- 草稿箱 --------
- (void)backActionButton:(UIButton *)sender {
    if((self.imageArray.count > 0 || self.videoModel) && !self.detailData)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        @weakify(self);
        [alert addAction:[UIAlertAction actionWithTitle:@"保存草稿" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self saveDraftBox];
            [self popViewController];
        }]];
       
        [alert addAction:[UIAlertAction actionWithTitle:@"不保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self popViewController];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self popViewController];
    }
}

- (void)popViewController {
    if(self.type == 2)
    {
        NSArray *array = self.navigationController.viewControllers;
        if(array && array.count >= 3)
        {
            [self.navigationController popToViewController:array[array.count - 3] animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

///保存草稿箱
- (void)saveDraftBox {
    JHDraftBoxModel* draft = [JHDraftBoxModel new];
    draft.style = JHDraftBoxStyleImageText;
    draft.channel_id = self.model.channel_id;
    draft.plateTitle = self.plateTopicView.plateName;
    draft.topicArray = [JHPublishTopicDetailModel mj_keyValuesArrayWithObjectArray:self.topicArray];
    if(self.imageArray.count > 0)
    {
        for (JHAlbumPickerModel *m in self.imageArray) {
            [draft.imageDataArray addObject:UIImageJPEGRepresentation(m.image, 1)];
        }
        for (JHAlbumPickerModel *m in self.imageArray) {
            
            [draft.localIdentifierArray addObject:m.asset.localIdentifier];
        }
        draft.imageCount = @(self.imageArray.count).stringValue;
        draft.style = JHDraftBoxStyleIcons;
    }
    else if (self.videoModel)
    {
        draft.duration = self.videoDuration;
        draft.durationStr = [CommHelp getHMSWithSecond:self.videoDuration];
        draft.imageData = UIImageJPEGRepresentation(self.videoModel.image, 1);
        draft.outPutUrl = self.videoModel.videoPath;
        draft.style = JHDraftBoxStyleVideo;
    }
    if([self.textView hasText])
    {
        draft.content = self.textView.text;
    }
    [JHDraftBoxModel saveDataModel:draft];
}

- (void)updateUIWithDraftBoxModel:(JHDraftBoxModel *)draft {
    if(draft.channel_id) {
        self.model.channel_id = draft.channel_id;
        self.plateTopicView.plateName = draft.plateTitle;
    }
    
    if(draft.topicArray) {
        self.topicArray = [JHPublishTopicDetailModel mj_objectArrayWithKeyValuesArray:draft.topicArray];
        self.plateTopicView.topicArray = self.topicArray;
    }
    
    if(draft.style == JHDraftBoxStyleIcons) {
        for (int i = 0; i < draft.imageDataArray.count; i++) {
            JHAlbumPickerModel *m = [JHAlbumPickerModel new];
            m.image = [UIImage imageWithData:draft.imageDataArray[i]];
            m.asset = SAFE_OBJECTATINDEX(draft.imageAssetArray, i);
            m.isVideo = NO;
            self.type = 1;
            [self.imageArray addObject:m];
        }
        self.imagesView.dataArray = self.imageArray;
    }
    else if (draft.style == JHDraftBoxStyleVideo) {
        self.videoModel = [JHAlbumPickerModel new];
        self.videoDuration = draft.duration;
        self.videoModel.image = [UIImage imageWithData:draft.imageData];
        self.videoModel.videoPath = draft.outPutUrl;
        self.videoDuration = draft.duration;
        self.type = 2;

        self.videoView.imageView.image = self.videoModel.image;
        self.videoView.timeLabel.text = draft.durationStr;
        self.model.duration = draft.duration * 1000;
    }
    
    if(draft.content && draft.content.length > 0) {
        self.model.content = draft.content;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:draft.content attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16.], NSForegroundColorAttributeName:kColor333}];
        attri = [JHAttributeStringTool markAtBlue:attri];
        self.textView.attributedText = attri;
//        self.textView.text = draft.content;
    }
    [self changePlateTopicViewTop];
}

#pragma mark -------- method --------
///选择相册
- (void)selectAlbumMethod {
    if(_isEdit) {
        if(self.detailData.videoInfo && self.detailData.videoInfo.url) {
            _type = 2;
        }
        else {
            _type = 1;
        }
    }
    else {
        if(self.imageArray.count <= 0 && !self.videoModel) {
            _type = 0;
        }
    }
    NSMutableArray *assetArray = [NSMutableArray new];
    if(!self.isEdit) {
        for (JHAlbumPickerModel *m in self.imageArray) {
            [assetArray addObject:m.asset];
        }
    }
    
    [JHImagePickerPublishManager showImagePickerViewWithType:_type maxImagesCount:(_isEdit ? (9 - self.imageArray.count) : 9) assetArray:assetArray viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        self.type = 1;
        if(self.isEdit) {
            [self.imageArray addObjectsFromArray:dataArray];
        }
        else {
            [self.imageArray removeAllObjects];
            [self.imageArray addObjectsFromArray:dataArray];
        }
        
        self.imagesView.dataArray = self.imageArray;
        self.imagesView.hidden = NO;
        if(self.videoView)
        {
            self.videoView.hidden = YES;
        }
        [self changePlateTopicViewTop];
        
    } videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        _type = 2;
        JHAlbumPickerModel *model = dataArray.firstObject;
        [JHImagePickerPublishManager getOutPutPath:model.asset block:^(NSString * _Nonnull outPath) {
            [self pushCorpVideoWithoutPath:outPath];
        }];
    }];
}

/// 切换到显示视频截取页面
- (void)pushCorpVideoWithoutPath:(NSString *)outPath {
    JHVideoCropViewController *vc = [[JHVideoCropViewController alloc] initWithVideoWithOutPutPath:outPath];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    @weakify(self)
    vc.selectVideoBlock = ^(AVURLAsset *tmpAsset, CMTimeRange tmpTimeRange) {
        @strongify(self);
        [self showVideoViewWithAsset:tmpAsset timeRange:tmpTimeRange];
    };
}

/// 显示视频
- (void)showVideoViewWithAsset:(AVURLAsset *)asset timeRange:(CMTimeRange)timeRange {
    [JHVideoCropManager exportVideoWithAVAsset:asset timeRange:timeRange selectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        if(dataArray.count > 0) {
            if(self.imagesView)
            {
                self.imagesView.hidden = YES;
            }
            self.videoView.hidden = NO;
            
            self.videoView.hidden = NO;
            self.videoModel = dataArray.firstObject;
            self.videoView.imageView.image = self.videoModel.image;
            int time = CMTimeGetSeconds(timeRange.duration);
            self.videoDuration = time;
            
            self.videoView.timeLabel.text = [NSString stringWithFormat:@"%d:%.2d",time/60,time%60];
            self.model.duration = time * 1000;
            
            [self changePlateTopicViewTop];
        }
    }];
}

///选择版块
- (void)selectCatePlateAction {
    [self.view endEditing:YES];
    
    @weakify(self);
    [JHPlateSelectView showInView:JHKeyWindow doneBlock:^(JHPlateSelectData *data) {
        @strongify(self);
        self.plateTopicView.plateName = data.channel_name;
        self.model.channel_id = data.channel_id;
        self.model.channel_name = data.channel_name;

        ///369神策埋点:内容发布_选择板块
        NSString *type = (self.type == 1 ? @"动态" : @"小视频");
        [JHTracking trackEvent:@"nrfbSectionSelect" property:@{@"content_type":type,
                                                               @"section_id":data.channel_id,
                                                               @"section_name":data.channel_name
        }];
    }];
}

/// 选择话题
- (void)selectTopicAction {
    @weakify(self);
    JHPublishSelectTopicController *vc = [JHPublishSelectTopicController new];
    [vc prepareSelectedTopicArray:self.topicArray.copy];
    vc.selectDataBlock = ^(NSArray<JHPublishTopicDetailModel *> * _Nonnull sender) {
        @strongify(self)
        if(sender && sender.count > 0)
        {
            self.plateTopicView.topicArray = sender;
            self.topicArray = [NSMutableArray arrayWithArray:sender];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -------- 发布 --------
- (void)rightActionButton:(UIButton *)sender {
    if(!self.model.channel_id)
    {
        JHTOAST(@"请选择版块");
        return;
    }
    if(self.isEdit && !self.videoModel && (self.type == 2)) {
        JHTOAST(@"请选择视频资源");
        return;
    }

    BOOL noSources = NO;
    if(self.imageArray.count <= 0 && !self.videoModel)
    {
        /// 没有资源就是无图动态
        self.type = 1;
        noSources = YES;
    }
    
    if(![self.textView hasText] && noSources)
    {
        JHTOAST(@"请输入文字");
        return;
    }
    if(self.bottomView.isGreaterMaxWords)
    {
        JHTOAST(@"请输入规定范围字数");
        return;
    }

    self.model.content = [[JHEmojiManager sharedInstance] plainText];
    JHSQUploadModel *param = [JHSQUploadModel new];
    param.paramModel = self.model;
    
    if(self.type == 1 && self.imageArray.count > 0)
    {
        param.photoArray = self.imageArray;
    }
    
    if(self.type == 2)
    {
        param.videoModel = self.videoModel;
    }
    
    param.type = self.type;
    
    param.paramModel.item_type = (self.type == 1 ? 20 : 40);
    for (JHPublishTopicDetailModel *m in self.topicArray) {
        [param.paramModel.topic addObject:m.title];
    }
    [JHPublishTopicRecordModel saveTopicRecordArray:self.topicArray];
    [JHSQUploadManager addModel:param];
    
    ///369神策埋点:内容发布_点击发布
    [self trackPublishClick];
    
    NSArray *array = self.navigationController.viewControllers;
    if(IS_ARRAY(array) && _popCount == 2) {
        [self.navigationController popToViewController:array[array.count -3] animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)trackPublishClick {
    NSMutableArray *topicNames = [NSMutableArray array];
    for (JHPublishTopicRecordModel *topic in self.topicArray) {
        [topicNames addObject:topic.title];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.pageFrom forKey:@"page_position"];
    [params setValue:self.model.channel_id forKey:@"section_id"];
    [params setValue:self.model.channel_name forKey:@"section_name"];
    [params setValue:topicNames forKey:@"theme_name"];
    
    [JHTracking trackEvent:@"nrfbReleaseClick" property:params];
}

#pragma mark -------- 编辑 --------
- (void)setItemId:(NSString *)itemId {
    if(!itemId) {
        return;
    }
    _itemId = itemId;
    
    [JHSQApiManager getPostDetailInfo:_itemType itemId:_itemId block:^(JHPostDetailModel *detailModel, BOOL hasError) {
        if(!hasError) {
            self.detailData = detailModel;
        }
    }];
}

- (void)setDetailData:(JHPostDetailModel *)detailData {
    _detailData = detailData;
    _isEdit = YES;
    _plateTopicView.isEdit = _isEdit;
    self.model.item_id = self.itemId;
    if(_detailData.plate_info) {
        self.model.channel_id = _detailData.plate_info.ID;
        self.plateTopicView.plateName = _detailData.plate_info.name;
    }
    
    if(_detailData.topics) {
        NSMutableArray *array = [NSMutableArray new];
        for (JHTopicInfo *t in _detailData.topics) {
            JHPublishTopicDetailModel *model = [JHPublishTopicDetailModel new];
            model.title = t.name;
            [array addObject:model];
        }
        self.plateTopicView.topicArray = array;
    }
    
    if(_detailData.videoInfo && _detailData.videoInfo.url) {
        /// 小视频
        int time = [OBJ_TO_STRING(_detailData.videoInfo.duration) intValue];
        self.videoModel = [JHAlbumPickerModel new];
        self.videoDuration = time;
        self.videoModel.sourceUrl = _detailData.videoInfo.url;
        self.videoModel.coverUrl = _detailData.videoInfo.image;
        self.videoModel.image = _detailData.videoInfo.image;
        [self.videoView.imageView jh_setImageWithUrl:_detailData.videoInfo.image];
        self.videoView.timeLabel.text = [NSString stringWithFormat:@"%d:%.2d",time/60,time%60];;
        self.model.duration = time * 1000;
        [self changePlateTopicViewTop];
    }
    if(_detailData.images && IS_ARRAY(_detailData.images) && _detailData.images.count > 0) {
        /// 小视频
        for (NSString *url in _detailData.images) {
            JHAlbumPickerModel *p = [JHAlbumPickerModel new];
            p.image = url;
            [self.imageArray addObject:p];
        }
        self.imagesView.dataArray = self.imageArray;
        _imagesView.hidden = NO;
        if(_videoView)
        {
            _videoView.hidden = YES;
        }
        [self changePlateTopicViewTop];
    }
    
    if(_detailData.resourceData) {
        NSString *text = @"";
        for (JHPostDetailResourceModel *obj  in _detailData.resourceData) {
            if(obj.type == JHPostDetailResourceTypeText) {
                if(obj.dataModel.attrArray){
                    for(NSDictionary *att in obj.dataModel.attrArray) {
                        
                        LinkStringModel *m = [LinkStringModel mj_objectWithKeyValues:att];
                        NSString *url = [self getPublishUrl:m];
                        text = [text stringByAppendingFormat:@"%@",url];
                    }
                    [text stringByAppendingFormat:@"\n"];
                }
                else if(obj.dataModel.text) {
                    text = [text stringByAppendingFormat:@"%@\n",obj.dataModel.text];
                }
            }
        }
        if(text.length > 0) {
            self.model.content = text;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16.], NSForegroundColorAttributeName:kColor333}];
            attri = [JHAttributeStringTool markAtBlue:attri];
            self.textView.attributedText = attri;
            self.placeholderLabel.hidden = YES;
//            [self.textView scrollToBottom];
        }
    }
}

- (NSString *)getPublishUrl:(LinkStringModel *)sender {
    NSString *s = sender.sub_text;
    switch (sender.sub_type.integerValue) {
        case -1:
            s = [NSString stringWithFormat:@"%@ ",sender.data_value];
            break;
            
        case JHLinkTypeCommunity:
            s = [NSString  stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/community/communityDetail/communityDetailShare.html?item_type=0&item_id=%@ "),sender.data_value];
            break;
            
        case JHLinkTypeHTML5:
            s = sender.data_value;
            break;
            
        case JHLinkTypeTopic:
            s = [NSString  stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/community/communityTopic/communityTopicShare.html?topicId=%@ "),sender.data_value];
            break;
            
        case JHLinkTypePlate:
            s = [NSString  stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/community/communitySection/communitySectionShare.html?plateId=%@ "),sender.data_value];
            break;
            
        default:
            s = sender.sub_text;
            break;
    }
    return s;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
