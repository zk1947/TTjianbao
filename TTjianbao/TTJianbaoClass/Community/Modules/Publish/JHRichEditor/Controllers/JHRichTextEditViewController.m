//
//  JHRichTextEditViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHDraftBoxModel.h"
#import "JHPlateSelectView.h"
#import "JHRichTextEditViewController.h"
#import <YYKit.h>
#import "NSAttributedString+YYText.h"
#import "NSParagraphStyle+YYText.h"
#import "YYTextArchiver.h"
#import "YYTextRunDelegate.h"
#import "YYTextUtilities.h"
#import <CoreFoundation/CoreFoundation.h>
#import <IQKeyboardManager.h>
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
#import "TZImagePickerController.h"
#import "JHRichTextImage.h"
#import "JHImagePickerPublishManager.h"
#import "JHWebViewController.h"
#import "JHSQUploadModel.h"
#import "JHRichTextImageRankViewController.h"
#import "UITextView+XWAutoHeight.h"
#import "JHYYTextView.h"
#import "JHEmojiManager_YYText.h"
#import "PPStickerDataManager.h"
#import "PPTextBackedString.h"
#import "NSAttributedString+PPAddition.h"
#import "JHRichTextCompleteController.h"
#import "JHSQManager.h"
#import "JHAttributeStringTool.h"
#import "JHLinkClickAction.h"
#import "JHSQApiManager.h"
#import "JHContactUserInfoModel.h"
#import "JHPostDetailModel.h"

#define  imageLimitCount   200
#define  videoLimitCount   1
#define  titlePlaceholder   @"请输入标题（5-30个字之间)"
#define  contentPlaceholder @"请输入正文，字数大于30字"

#define  titleMinCount   5
#define  contentMinCount   30
#define  titleTextLimitCount   30
#define  contentTextLimitCount   2000


#define  titleMinH  31   //标题最低高度
#define  contentMinH  200   //内容最低高度
#define  titleSpace   10     //标题距离上边的距离
#define  contentTopSpace   15     //内容距离标题的间距
#define  contentBottomSpace   20     //内容距离底部的间距

@interface YYTextExampleEmailBindingParser :NSObject <YYTextParser>
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation YYTextExampleEmailBindingParser

- (instancetype)init {
    self = [super init];
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:nil];
    self.regex = atPersionRE;
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    NSMutableString *toBeString = [text string].mutableCopy;
    if (![toBeString isNotBlank] || ![toBeString containsString:@"@"]) {
        return NO;
    }
    [JHAttributeStringTool matchHighLightText:text];
    return YES;
}

@end

@interface JHRichTextEditViewController ()<UITextViewDelegate,YYTextViewDelegate,JHRichTextImageDelegate, YYTextParser>
{
     float lastContentOffsetY;//删除前的滚动位置
     float lastHeight;
    
}
@property (strong, nonatomic) JHYYTextView *titleTextView;
@property (strong, nonatomic) JHYYTextView *contentTextView;
@property (nonatomic, assign) NSRange textViewRange;
@property (nonatomic, weak) JHSQPublishBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray <JHPublishTopicDetailModel *> *topicArray;
@property (nonatomic, assign) NSInteger  imageCount;
@property (nonatomic, assign) NSInteger  videoCount;
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong)  UILabel *titleTip;
/// 发布模型
@property (nonatomic, strong) JHSQPublishModel *model;
/** 保存封面*/
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSRegularExpression *regex;

/// 编辑
@property (nonatomic, strong) JHPostDetailModel *detailData;

@property (nonatomic, assign) BOOL isEdit;

@end

@implementation JHRichTextEditViewController

- (instancetype)init {
    self = [super init];
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:nil];
    self.regex = atPersionRE;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写文章";
    [self initNavBarRightButtons];
    [self initSubviews];
    [self addObserver];
    
    if(_topic)
    {
        [self.topicArray addObject:_topic];
    }
    if(_plate)
    {
        self.model.channel_id = _plate.channel_id;
        self.model.channel_name = _plate.channel_name;
    }
    if(self.draftBoxModel) {
        [self updateUIWithDraftBoxModel:self.draftBoxModel];
    }
    
    NSString *position = @"长文章";
    [JHTracking trackEvent:@"nrfbContentEdit" property:@{@"content_type":position}];
}
#pragma mark -------- 草稿箱 --------
-(void)backActionButton:(UIButton *)sender
{
    
    if([self.contentTextView.text length] > 0 && !self.isEdit)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"保存草稿" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveDraftBox];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
       
        [alert addAction:[UIAlertAction actionWithTitle:@"不保存" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///保存草稿箱
-(void)saveDraftBox
{
    JHDraftBoxModel* draft = [JHDraftBoxModel new];
    draft.style = JHDraftBoxStyleImageText;
    draft.channel_id = self.model.channel_id;
    if (self.coverImage) {
        draft.coverImageData = UIImageJPEGRepresentation(self.coverImage, 1);
    }
    draft.plateTitle = self.model.channel_name;
#warning  -- todo
    
    draft.topicArray = [JHPublishTopicDetailModel mj_keyValuesArrayWithObjectArray:self.topicArray];
    
    NSArray * arr =[self getRichTextArray];
    if(arr.count > 0){
    for ( id obj in arr) {
        if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
            JHAlbumPickerModel *albumModel=(JHAlbumPickerModel*)obj;
            //JHAlbumPickerModel 里的复杂数据类型不能赋值  否则不能存储 所以每一个单独赋值
            JHAlbumPickerModel * imageMode=[[JHAlbumPickerModel alloc]init];
            imageMode.isVideo=albumModel.isVideo;
            imageMode.sourceUrl=albumModel.sourceUrl;
            imageMode.coverUrl=albumModel.coverUrl;
            imageMode.videoPath=albumModel.videoPath;
            imageMode.image=UIImageJPEGRepresentation(albumModel.image, 1);
            [draft.richTextArray addObject:[imageMode mj_keyValues]];
            if(!draft.imageData){
               draft.imageData = imageMode.image;
            }
        }
        else{
            NSString * text =(NSString*)obj;
            [draft.richTextArray addObject:text?:@""];
            if(!draft.content){
               draft.content = text;
            }
        }
     
      }
    }
    draft.title = self.titleTextView.text;
    [JHDraftBoxModel saveDataModel:draft];
}

- (void)updateUIWithDraftBoxModel:(JHDraftBoxModel *)draft {
    if(draft.channel_id && draft.plateTitle)
    {
        self.model.channel_id = draft.channel_id;
        self.model.channel_name = draft.plateTitle;
    }
    if (draft.coverImageData) {
        self.coverImage  = [UIImage imageWithData: draft.coverImageData];
    }
    
    self.topicArray = [JHPublishTopicDetailModel mj_objectArrayWithKeyValuesArray:draft.topicArray];
  
    if(draft.title)
       {
         self.titleTextView.text =draft.title;
       }
    NSMutableArray * arr =[NSMutableArray arrayWithCapacity:10];
    for (id obj  in draft.richTextArray) {
        if ([obj isKindOfClass:[NSDictionary class]]){
        JHAlbumPickerModel *mode =[JHAlbumPickerModel mj_objectWithKeyValues:obj];
        mode.image=[UIImage imageWithData:mode.image];
        [arr addObject:mode];
    }
       
        else{
            NSString * text =(NSString*)obj;
            [arr addObject:text?:@""];
        }
    }
    [self addAttImage:arr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = YES;
        [nav setShouldReceiveTouchViewController:nil];
    }
    ///发布页停留时长：开始
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPublishBrowse params:@{@"item_type" : @1,JHUPBrowseKey:JHUPBrowseBegin}];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ///发布页停留时长：
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPublishBrowse params:@{@"item_type" : @1,JHUPBrowseKey:JHUPBrowseEnd}];
}
-(void)initSubviews{

     [self.view addSubview:self.contentScroll];
     [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
     }];
    [self.contentScroll addSubview:self.titleTextView];
    [self.contentScroll addSubview:self.contentTextView];
    [[JHEmojiManager_YYText sharedInstance] setCurrentText:self.contentTextView andType:self.contentTextView.font];
    [self.contentTextView addSubview:self.titleTip];
    self.titleTextView.frame = CGRectMake(15, titleSpace, ScreenW-30, titleMinH);
    self.contentTextView.frame = CGRectMake(15, _titleTextView.bottom+contentTopSpace, ScreenW-30, contentMinH);
     self.contentScroll.contentSize = CGSizeMake(ScreenW, _contentTextView.bottom+contentBottomSpace);
}
-(void)addObserver{
    
    @weakify(self);
    [RACObserve(self.bottomView, frame) subscribeNext:^(id  _Nullable x) {
      @strongify(self);
          CGRect rect = [x CGRectValue];
         CGFloat y = abs((int)rect.origin.y);
          NSLog(@"yyy==%lf",y);
        if (rect.origin.y==ScreenH - UI.bottomSafeAreaHeight - [JHSQPublishBottomView viewSize].height) {
            [self.view endEditing:YES];
            [self.bottomView setHidePhotoButton:NO];
            [self.bottomView setHideCalluserButton:NO];
        }
        else{
           
        }
        if ([self.titleTextView isFirstResponder]) {
            [self.bottomView setHidePhotoButton:YES];
            [self.bottomView setHideCalluserButton:YES];
        }
        if ([self.contentTextView isFirstResponder]) {
            [self scrollToSelectRange];
            [self.bottomView setHidePhotoButton:NO];
            [self.bottomView setHideCalluserButton:NO];
        }
    }];
    
    [RACObserve(self.titleTextView, contentSize) subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        CGSize size = [x CGSizeValue];
        CGFloat textHeight = abs((int)size.height);
        NSLog(@"mmmm==%lf",textHeight);
        if (textHeight<titleMinH) {
            textHeight=titleMinH;
        }
        self.titleTextView.height =textHeight;
        self.contentTextView.top =self.titleTextView.bottom+contentTopSpace;
        self.contentScroll.contentSize = CGSizeMake(ScreenW, self.contentTextView.bottom+contentBottomSpace);
    }];
    [RACObserve(self.contentTextView, contentSize) subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        CGSize size = [x CGSizeValue];
        CGFloat textHeight = abs((int)size.height);
        NSLog(@"ddd3==%lf",textHeight);
        if (textHeight<contentMinH) {
            textHeight=contentMinH;
        }
        self.contentTextView.height =textHeight;
        self.contentScroll.contentSize = CGSizeMake(ScreenW, self.contentTextView.bottom+contentBottomSpace);
    }];
}

-(void)initNavBarRightButtons{
//    [self.navbar addrightBtn: withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-62,0,50,26)];
//    [self.navbar.rightBtn addTarget :self action:@selector(:) forControlEvents:UIControlEventTouchUpInside];
//    self.navbar.rightBtn.backgroundColor = UIColor.whiteColor;
//    self.navbar.rightBtn.jh_titleColor(RGB515151).jh_fontNum(15);
//
    
    [self initRightButtonWithName:@"下一步" action:@selector(nextButtonClickAction:)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];

    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:[UIImage imageNamed:@"publish_artcle_sort"] forState:UIControlStateNormal];
    cameraBtn.backgroundColor = UIColor.whiteColor;
    [cameraBtn addTarget:self action:@selector(sortAttImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.jhNavView addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView).offset(0);
        make.right.equalTo(self.jhRightButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
}

#pragma mark - get
-(UIScrollView*)contentScroll{
    if (!_contentScroll) {
        _contentScroll =[[UIScrollView alloc]init];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = YES;
        _contentScroll.backgroundColor =[UIColor whiteColor];
        _contentScroll.scrollEnabled=YES;
        _contentScroll.alwaysBounceVertical=YES;
    }
    return _contentScroll;
}
-(UILabel*)titleTip{
    if (!_titleTip) {
        _titleTip=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 20)];
        _titleTip.text=contentPlaceholder;
        _titleTip.font = [UIFont fontWithName:kFontNormal size:16];
        _titleTip.textColor = kColor999;
        _titleTip.numberOfLines = 1;
        _titleTip.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _titleTip.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleTip;
}

-(JHYYTextView*)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[JHYYTextView alloc]init];
        _titleTextView.userInteractionEnabled = YES;
        _titleTextView.scrollEnabled = NO;
        _titleTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _titleTextView.font = [UIFont fontWithName:kFontMedium size:22];
        _titleTextView.textColor = kColor333;
        _titleTextView.placeholderFont = [UIFont fontWithName:kFontMedium size:22];
        _titleTextView.placeholderTextColor = kColor999;
        _titleTextView.placeholderText = titlePlaceholder;
        _titleTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _titleTextView.delegate = self;
//        _titleTextView.tintColor=kColorMain;
       _titleTextView.returnKeyType =UIReturnKeyDone;
    }
    return _titleTextView;

}
-(JHYYTextView*)contentTextView{
    if (!_contentTextView) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"com.ttjianbao.yijian"];
        text.font = [UIFont fontWithName:kFontNormal size:16.];
        text.lineSpacing = 5;
        text.color = [UIColor blackColor];

        _contentTextView = [[JHYYTextView alloc]init];
        _contentTextView.userInteractionEnabled = YES;
        _contentTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentTextView.font = [UIFont fontWithName:kFontNormal size:16];
        _contentTextView.textColor = kColor333;
        _contentTextView.placeholderFont = [UIFont fontWithName:kFontNormal size:16];
        _contentTextView.placeholderTextColor = kColor999;
       // _contentTextView.placeholderText = contentPlaceholder;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentTextView.delegate = self;
//        _contentTextView.tintColor=kColorMain;
        _contentTextView.allowsPasteImage = NO;
        _contentTextView.allowsPasteAttributedString = NO;
        _contentTextView.allowsCopyAttributedString = NO;
        _contentTextView.textParser = [[YYTextExampleEmailBindingParser alloc] init];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
            NSParagraphStyleAttributeName:paragraphStyle
        };
        _contentTextView.typingAttributes = attributes;
    }
    return _contentTextView;
}
-(JHSQPublishModel*)model{
    if (!_model) {
        _model = [[JHSQPublishModel alloc]init];
    }
    return _model;
}
-(void)sortAttImage{
    
    NSArray * attImages = [self getAttImges];
    JHRichTextImageRankViewController * rank = [JHRichTextImageRankViewController new];
    rank.albumArray=[attImages mutableCopy];
    [self.navigationController pushViewController:rank animated:YES];
    @weakify(self);
    rank.completeBlock = ^(id obj) {
        @strongify(self);
        NSArray *attImages  = (NSArray*)obj;
        [self replaceAttimage:attImages];
    };
    [JHGrowingIO trackEventId:JHSQPublishEditAllSortClick];
}
-(void)replaceAttimage:(NSArray<JHAlbumPickerModel*>*)attImages{
    NSInteger index = 0;
    NSMutableArray * richTextArr = [[self getRichTextArray] mutableCopy];
    for (int i =0; i<[richTextArr count]; i++) {
        id obj = richTextArr[i];
        if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
            if (index<attImages.count) {
                [richTextArr replaceObjectAtIndex:i withObject:attImages[index]];
                index++;
            }
        }
    }
    self.contentTextView.attributedText=nil;
    self.contentTextView.selectedRange=NSMakeRange(self.contentTextView.text.length, 0);
    [self addAttImage:richTextArr];
    
}
/** 点击下一步,选择封面图*/
- (void)nextButtonClickAction:(UIButton *)sender{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    if(![self.titleTextView hasText])
    {
        [self.view makeToast:@"请填写标题" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if(self.titleTextView.text.length < titleMinCount)
    {
        [self.view makeToast:@"标题过短，请大于5个字" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if(self.titleTextView.text.length > titleTextLimitCount)
    {
        [self.view makeToast:@"标题过长，请小于30个字" duration:2.0 position:CSToastPositionCenter];
        return;
    }
   
    if([self textCount] < contentMinCount)
    {
        [self.view makeToast:@"正文太短，请大于30个字" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    self.model.item_type = 30;
    self.model.title = self.titleTextView.text;
    NSMutableArray * richTextArr =[[self getRichTextArray] mutableCopy];
    if ([self getAttImges].count==0) {
        NSMutableString * string =[NSMutableString stringWithCapacity:10];
        for (id obj in richTextArr) {
            if ([obj isKindOfClass:[NSString class]]){
                NSString *text = (NSString*)obj?:@"";
                [string appendString:text];
             }
        }
       NSString * str = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.model.desc = str;
    }
    
    JHRichTextCompleteController *completeVc = [[JHRichTextCompleteController alloc] init];
    completeVc.isEdit = self.isEdit;
    completeVc.model = self.model;
    completeVc.richTextArr = richTextArr;
    completeVc.topicArray = self.topicArray;
    completeVc.pageFrom = self.pageFrom;
    completeVc.backActionBlock = ^(JHSQPublishModel * _Nonnull model, UIImage * _Nullable coverImage, NSMutableArray * _Nonnull topicArray) {
        self.model = model;
        self.coverImage = coverImage;
        self.topicArray = topicArray;
    };
   
    if (self.coverImage) {
        completeVc.coverImage = self.coverImage;
    }
    if(self.detailData && self.detailData.preview_image)
    {
        completeVc.coverUrl = self.detailData.preview_image;
    }
    [self.navigationController pushViewController:completeVc animated:YES];
}
- (void)selectAlbumMethod
{
    //如果bottom在底部，设置光标位置在最后
    if (self.bottomView.origin.y==ScreenH-UI.bottomSafeAreaHeight - [JHSQPublishBottomView viewSize].height) {
        self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.text.length,0);
    }
    NSInteger type = 0;
    NSInteger imageCount = self.imageCount;
    NSInteger videoCount = self.videoCount;
    if (imageCount>=imageLimitCount&&videoCount>=videoLimitCount) {
        [self.view makeToast:@"图片视频已达上限" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (imageCount>=imageLimitCount&&videoCount<videoLimitCount) {
        type = 2;
    }
    if (videoCount>=videoLimitCount&&imageCount<imageLimitCount) {
        type = 1;
    }
    
    [JHImagePickerPublishManager showImagePickerViewWithType:type maxImagesCount:imageLimitCount-imageCount assetArray:@[] viewController:self photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        [self addAttImage:dataArray];
        
    } videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
      
        JHAlbumPickerModel *model = dataArray.firstObject;
        [JHImagePickerPublishManager getOutPutPath:model.asset block:^(NSString * _Nonnull outPath) {
            [self pushCorpVideoWithOutPutPath:outPath];
        }];
    }];
}
-(void)addAttImage:(NSArray*)dataArray{
    _textViewRange = self.contentTextView.selectedRange;
    NSMutableAttributedString *contentText = [self.contentTextView.attributedText mutableCopy];
       for (NSInteger i = dataArray.count - 1; i >= 0; i--) {
           id obj = dataArray[i];
           if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
               JHAlbumPickerModel* mode =(JHAlbumPickerModel*)obj;
               JHRichTextImage *imageView = [[JHRichTextImage alloc] initWithDataSourece:self];
               imageView.albumModel=mode;
               float scale = 1.0;
               if([mode.image isKindOfClass:[UIImage class]]) {
                   UIImage * image = mode.image;
                   imageView.imageW = image.size.width;
                   imageView.imageH = image.size.height;
                   imageView.image = image;
                   scale = image.size.width / image.size.height;
               }
               else {
                   imageView.imageW = mode.width;
                   imageView.imageH = mode.height;
                   imageView.image = mode.image;
                   scale = mode.width / mode.height;
               }
               CGSize size = CGSizeMake(ScreenW-30, (ScreenW-30)/scale);
               imageView.frame = CGRectMake(0, 0, size.width, size.height);
               
               NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:size alignToFont:self.contentTextView.font alignment:YYTextVerticalAlignmentCenter];
               [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:_textViewRange.location];
               [contentText insertAttributedString:attachText atIndex:_textViewRange.location+1];
               [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"] atIndex:_textViewRange.location+2];
               
           }
           else{
               NSString* text =(NSString*)obj;
               
               if (i == 0) {
                   [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:text] atIndex:_textViewRange.location];
                   [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyTextNOBlank:contentText font:JHFont(16)];
               }
               else{
                   [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:_textViewRange.location];
                   [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:text] atIndex:_textViewRange.location+1];
                   [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyTextNOBlank:contentText font:JHFont(16)];
               }
               contentText = [JHAttributeStringTool markAtBlue:contentText];
           }
      }
   
     [contentText setFont:[UIFont fontWithName:kFontNormal size:16]];
      contentText.lineSpacing = 5;
    
     self.contentTextView.attributedText = contentText;
     self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.text.length, 0);
}
/// 切换到显示视频截取页面
- (void)pushCorpVideoWithOutPutPath:(NSString *)outPutPath {
    JHVideoCropViewController *vc = [[JHVideoCropViewController alloc] initWithVideoWithOutPutPath:outPutPath];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    @weakify(self)
    vc.selectVideoBlock = ^(AVURLAsset *tmpAsset, CMTimeRange tmpTimeRange) {
        @strongify(self);
        [self showVideoViewWithAsset:tmpAsset timeRange:tmpTimeRange];
    };
}

/// 显示视频
-(void)showVideoViewWithAsset:(AVURLAsset *)asset timeRange:(CMTimeRange)timeRange
{
    [JHVideoCropManager exportVideoWithAVAsset:asset timeRange:timeRange selectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        if(dataArray.count > 0) {
            
            int time = CMTimeGetSeconds(timeRange.duration);
            self.model.duration = time * 1000;
             dataArray[0].videoDuration = time;
            [self addAttImage:dataArray];
        }
    }];
}

- (JHSQPublishBottomView *)bottomView
{
    if(!_bottomView)
    {
        CGSize size = [JHSQPublishBottomView viewSize];
        _bottomView = [JHSQPublishBottomView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
        [_bottomView setHidePhotoButton:NO];
        [_bottomView setHideCalluserButton:NO];
        _bottomView.showDoneButton = YES;
        _bottomView.frame = CGRectMake(0, ScreenH - UI.bottomSafeAreaHeight - size.height, size.width, size.height);
        @weakify(self);
        _bottomView.addAlbumBlock = ^{
            @strongify(self);
            [self selectAlbumMethod];
        };
        _bottomView.completePlateBlock = ^{
            @strongify(self);
            [self.view endEditing:YES];
        };
        _bottomView.keybordSwitchBlock = ^(BOOL showEmoji) {
            [[JHEmojiManager_YYText sharedInstance] changeKeyboardTo:showEmoji];
        };
        _bottomView.callUsetListBlock = ^{
            [JHSQManager enterCallUsetListPage:^(JHContactUserInfoModel * _Nonnull model) {
                @strongify(self);
                if (model && [model.name isNotBlank]) {
                    NSMutableAttributedString *str = self.contentTextView.attributedText.mutableCopy;
                    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@ ", model.name]]];
                    [str addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                                                     NSForegroundColorAttributeName:kColor333
                    } range:NSMakeRange(0, str.length)];
                    NSArray *matches = [_regex matchesInString:str.string options:NSMatchingReportProgress range:str.string.rangeOfAll];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange matchRange = [match range];
                        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
                        [str setTextBinding:binding range:matchRange]; /// Text binding
                        [str setColor:[UIColor colorWithRed:0.000 green:0.519 blue:1.000 alpha:1.000] range:matchRange];
                    }
                    self.contentTextView.attributedText = str;
                }
            }];
        };
    }
    return _bottomView;
}

#pragma mark -----YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    if ([textView isEqual:self.titleTextView]) {
        [self.bottomView setHidePhotoButton:YES];
        [self.bottomView setHideCalluserButton:YES];
    }
    if ([textView isEqual:self.contentTextView]) {
        [self.bottomView setHidePhotoButton:NO];
        [self.bottomView setHideCalluserButton:NO];
    }
    return YES;
}
- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    return NO;
}
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{
}
- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    
    return NO;
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{
    
}
- (void)textViewDidEndEditing:(YYTextView *)textView{
    
}

- (void)textViewDidChange:(YYTextView *)textView{
    
    if ([textView isEqual:self.titleTextView]) {
        if (textView.text.length > titleTextLimitCount){
            textView.text = [textView.text substringWithRange:NSMakeRange(0, titleTextLimitCount)];
        }
    }
   
    if ([textView isEqual:self.contentTextView]) {
        [self scrollToSelectRange];
        if ([self textCount]>0||[self firstRangeIsAttImage]) {
            [self.titleTip setHidden:YES];
        }
        else{
            [self.titleTip setHidden:NO];
        }
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //删除键
    if ([text isEqualToString:@""]) {
            return YES;
    }
    if ([textView isEqual:self.titleTextView]) {
        if ([text isEqualToString:@"\n"]){
            return NO;
        }
//        //获取高亮部分
//        YYTextRange *selectedRange = [textView valueForKey:@"_markedTextRange"];
//        NSRange range = [selectedRange asRange];
//        NSString *realString = [textView.text substringWithRange:NSMakeRange(0, textView.text.length-range.length)];
//        NSLog(@"aaaaaa==%@",realString);
//        if (realString.length+text.length > titleTextLimitCount){
//            return NO;
//        }
    }
    if (textView == self.contentTextView && [text isEqualToString:@"@"]) {  //判断输入的字符是不是@
//        __block NSMutableAttributedString *toBeString = self.contentTextView.attributedText.mutableCopy;
        [JHSQManager enterCallUsetListPage:^(JHContactUserInfoModel * _Nonnull model) {
            if (model && [model.name isNotBlank]) {
                NSMutableAttributedString *str = self.contentTextView.attributedText.mutableCopy;
                [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", model.name]]];
                [str addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                                                 NSForegroundColorAttributeName:kColor333
                } range:NSMakeRange(0, str.length)];
                NSArray *matches = [_regex matchesInString:str.string options:NSMatchingReportProgress range:str.string.rangeOfAll];
                for (NSTextCheckingResult *match in matches) {
                    NSRange matchRange = [match range];
                    YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
                    [str setTextBinding:binding range:matchRange]; /// Text binding
                    [str setColor:kHighLightColor range:matchRange];
                }
                self.contentTextView.attributedText = str;
            }
        }];
    }
    if ([textView isEqual:self.contentTextView]) {
//        if (textView.text.length > contentTextLimitCount){
//            return NO;
//        }
       
    }
     return YES;
}
-(void)remove:(JHRichTextImage*)image{

    lastContentOffsetY = self.contentScroll.contentOffset.y;
    NSArray * arr = [self getRichTextArray];
    NSMutableArray * richTextArr = [[self getRichTextArray] mutableCopy];
    for (id obj in arr) {
        if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
            JHAlbumPickerModel * mode = (JHAlbumPickerModel*)obj;
            if ([image.albumModel isEqual:mode]) {
                 [richTextArr removeObject:obj];
                  break;
            }
        }
    }
    [self.contentTextView resignFirstResponder];
    self.contentTextView.attributedText=nil;
    self.contentTextView.selectedRange=NSMakeRange(self.contentTextView.text.length, 0);
    [self addAttImage:richTextArr];

    if (self.contentScroll.contentSize.height>self.contentScroll.bounds.size.height) {
        if(self.contentScroll.contentSize.height-self.contentScroll.bounds.size.height>lastContentOffsetY) {
          [self.contentScroll setContentOffset:CGPointMake(0, lastContentOffsetY) animated:NO];
        }
        else{
            [self.contentScroll setContentOffset:CGPointMake(0, self.contentScroll.contentSize.height- self.contentScroll.bounds.size.height) animated:NO];
        }
    }

}
// -(void)remove:(JHRichTextImage*)image{
//
//     [self.view endEditing:YES];
//     NSMutableAttributedString *contentText = [self.contentTextView.attributedText mutableCopy];
//     NSString *text = [self.contentTextView.text copy];
//     [contentText enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//         YYTextAttachment *att = attrs[@"YYTextAttachment"];
//         if (att) {
//                JHRichTextImage *imgView = att.content;
//             if ([image isEqual:imgView]) {
//                 [contentText removeAttributesInRange:NSMakeRange(range.location, 2)];
//                *stop=YES;
//             }
//         }
//     }];
//     contentText.lineSpacing = 5;
//     [contentText setFont:[UIFont fontWithName:kFontNormal size:16]];
//     self.contentTextView.attributedText= contentText;
//}
-(NSArray*)getAttImges{
    
   NSMutableArray *imageArr= [NSMutableArray arrayWithCapacity:10];;
    NSMutableAttributedString *contentText = [self.contentTextView.attributedText mutableCopy];
    NSString *text = [self.contentTextView.text copy];
    [contentText enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            YYTextAttachment *att = attrs[@"YYTextAttachment"];
            if (att) {
                if ([att.content isKindOfClass:[JHRichTextImage class]]) {
                    JHRichTextImage *imgView = att.content;
                    [imageArr addObject:imgView.albumModel];
                }
            }
        }];
    return [imageArr copy];
    
    
//     //获取图片资源
//        NSArray *attachments =  textView.textLayout.attachments;
//        for(YYTextAttachment *attachment in attachments)
//        {
//            YYAnimatedImageView *imageView = attachment.content;
//            YYImage *image = (YYImage *)imageView.image;
//            NSLog(@"获取到图片:%@",image);
//        }
//        NSArray *attachmentRanges = textView.textLayout.attachmentRanges;
//        for (NSValue *range in attachmentRanges)
//        {
//            NSRange r = [range rangeValue];
//            NSLog(@"资源所在位置：%ld 长度: %ld",r.location,r.length);
//        }
    
}
-(NSArray*)getRichTextArray{
    
    NSInteger currentIndex = 0;
//    [self.contentTextView.attributedText pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];
    NSAttributedString *dataStringAtt = [[JHEmojiManager_YYText sharedInstance] plainTextWithString];//;self.contentTextView.attributedText.string;//
    ///TODO lihui
    dataStringAtt = [JHAttributeStringTool markAtBlue:dataStringAtt.mutableCopy].copy;

    self.contentTextView.attributedText = dataStringAtt;
    NSString *dataString = self.contentTextView.attributedText.string;
    NSMutableArray *data = [[dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];

    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < data.count; i++) {
        BOOL isChangedIndex = NO;
        int attachmentIndex = 0;
        for (int j = attachmentIndex; j < self.contentTextView.textLayout.attachmentRanges.count; j++) {
            if ([self.contentTextView.textLayout.attachmentRanges[j] rangeValue].location == currentIndex) {
                if ([self.contentTextView.textLayout.attachments[j].content isKindOfClass:[JHRichTextImage class]])
                {
                    JHRichTextImage *imageView = self.contentTextView.textLayout.attachments[j].content;
                    if (!isChangedIndex) {
                        [result addObject:imageView.albumModel];
                        currentIndex += 2;
                        isChangedIndex = YES;
                        attachmentIndex ++;
                    }
                }
            }
        }
        if (!isChangedIndex) {
            NSString *string = data[i];
            
            currentIndex += string.length + 1;
            if (![string isEqualToString:@""]) {
                [result addObject:string];
            }
        }
    }
    
    //删除照片时 未知原因删不干净，会有\U0000fffc  所以过滤掉
//    NSArray * arr= [result copy ];
//    for (id obj in arr) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            NSString * string =(NSString*)obj;
//            //   "\Ufffc",
//            if ([string isEqualToString:@"\U0000fffc"]) {
//                [result removeObject:string];
//            }
//        }
//    }
    return [result copy];
}
//富文本里图片总数
-(NSInteger)imageCount{
    
    NSArray * attImages = [self getAttImges];
    NSInteger count = 0;
    for (JHAlbumPickerModel *mode in attImages) {
        if (!mode.isVideo) {
            count++;
        }
    }
    return count ;
}
//富文本里视频总数
-(NSInteger)videoCount{
    NSArray * attImages = [self getAttImges];
    NSInteger count = 0;
    for (JHAlbumPickerModel *mode in attImages) {
        if (mode.isVideo) {
            count++;
        }
    }
    return count ;
}
//去除空格和图片后的文字个数
-(NSInteger)textCount{
    NSString *content=self.contentTextView.text;
      content = [content stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"length==%ld",content.length);
    return content.length;
}
//判断第一字符是否是图片
-(BOOL)firstRangeIsAttImage{
    if ([self.contentTextView.text length]>=1) {
         NSString *s = [self.contentTextView.text substringWithRange:NSMakeRange(0, 1)];
        NSLog(@"dddddd==%@",s);
        if ([s isEqualToString:@"\U0000fffc"]) {
             NSLog(@"dddddd6==%@",s);
            return YES;
        }
    }
     return NO;
}

-(void)scrollToSelectRange
{
  
    CGFloat lineHeight = 27;//16号字体行高，不同大小字体高度不一样
    CGFloat y =[self.contentTextView caretRectForPosition:self.contentTextView.selectedTextRange.start].origin.y+lineHeight;
    NSLog(@"ddd==%lf",y);
    CGRect rect = CGRectMake(0, y, self.contentTextView.width, self.contentTextView.height);
    CGRect drect=[self.contentTextView convertRect: rect toView:self.view];
    NSLog(@"ddd2==%lf",drect.origin.y);
    NSLog(@"ddd4==%lf",self.bottomView.origin.y);
    
     CGFloat space = 30;//防止键盘遮挡住边缘 多留出的距离
    if (drect.origin.y+space>self.bottomView.origin.y) {
          CGFloat  contentOffsetY= self.contentScroll.contentOffset.y;
        contentOffsetY=
        contentOffsetY-(self.bottomView.origin.y-drect.origin.y)+space;
        if (contentOffsetY>0) {
        [self.contentScroll setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
      }
    }
}

- (NSMutableArray<JHPublishTopicDetailModel *> *)topicArray
{
    if(!_topicArray)
    {
        _topicArray = [NSMutableArray new];
    }
    return _topicArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -------- 编辑 --------
- (void)setItemId:(NSString *)itemId {
    if(!itemId) {
        return;
    }
    _itemId = itemId;
    [JHSQApiManager getPostDetailInfo:@"30" itemId:_itemId block:^(JHPostDetailModel *detailModel, BOOL hasError) {
        if(!hasError) {
            self.detailData = detailModel;
        }
    }];
}

- (void)setDetailData:(JHPostDetailModel *)detailData {
    _detailData = detailData;
    _isEdit = YES;
    self.model.item_id = self.itemId;
    if(_detailData.plate_info) {
        self.model.channel_id = _detailData.plate_info.ID;
        self.model.channel_name = _detailData.plate_info.name;
    }
    
    if(_detailData.topics) {
        NSMutableArray *array = [NSMutableArray new];
        for (JHTopicInfo *t in _detailData.topics) {
            JHPublishTopicDetailModel *model = [JHPublishTopicDetailModel new];
            model.title = t.name;
            [array addObject:model];
        }
        self.model.topic = array;
    }
    
    self.model.title = _detailData.title;
    
    JHSQPublishCoverModel *cover = [JHSQPublishCoverModel new];
    cover.url = _detailData.preview_image;
    self.model.cover_info = cover;
    
    if(_detailData.title)
    {
         self.titleTextView.text = _detailData.title;
    }
    
    NSMutableArray * arr =[NSMutableArray arrayWithCapacity:10];
    for (JHPostDetailResourceModel *obj  in _detailData.resourceData) {
        if(obj.type == JHPostDetailResourceTypeVideo) {
            JHAlbumPickerModel *model = [JHAlbumPickerModel new];
            model.sourceUrl = obj.dataModel.video_url;
            model.coverUrl = obj.dataModel.video_cover_url;
            model.image = obj.dataModel.video_cover_url;
            model.height = obj.dataModel.height;
            model.width = obj.dataModel.width;
            model.isVideo = YES;
            [arr addObject:model];
        }
        else if(obj.type == JHPostDetailResourceTypeImage) {
            JHAlbumPickerModel *model = [JHAlbumPickerModel new];
            model.sourceUrl = obj.dataModel.image_url;
            model.image = obj.dataModel.image_url;
            model.height = obj.dataModel.height;
            model.width = obj.dataModel.width;
            [arr addObject:model];
        }
        else {
            NSString *text = @"";
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
            [arr addObject:text];
        }
    }
    [self addAttImage:arr];
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
            s = [NSString stringWithFormat:@"%@ ",sender.data_value];
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
@end

