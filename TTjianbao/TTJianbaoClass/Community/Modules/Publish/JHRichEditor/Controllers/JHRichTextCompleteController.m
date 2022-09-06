//
//  JHRichTextCompleteController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRichTextCompleteController.h"
#import "JHSQPublishSelectPlateTopicView.h"
#import "JHPublishTopicDetailModel.h"
#import "TZImagePickerController.h"
#import "JHPlateSelectModel.h"
#import "JHPublishSelectTopicController.h"
#import "JHPlateSelectView.h"
#import "JHSQPublishModel.h"
#import "JHSQUploadModel.h"
#import "JHPublishTopicModel.h"
#import "JHSQUploadManager.h"

@interface JHRichTextCompleteController ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UINavigationControllerDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** headerView*/
@property (nonatomic, strong) UIView *headerView;
/** 封面图*/
@property (nonatomic, strong) UIImageView *coverImageView;
/** 更换按钮*/
@property (nonatomic, strong) UIButton *changeButton;
/// 板块、话题
@property (nonatomic, strong) JHSQPublishSelectPlateTopicView *plateTopicView;
/** 是否选择了封面图*/
@property (nonatomic, assign) BOOL isHaveCoverImage;
@end

@implementation JHRichTextCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
    if (self.coverImage || self.coverUrl) {
        if(self.coverImage) {
            self.coverImageView.image = self.coverImage;
        }
        else if(self.coverUrl){
            [self.coverImageView jh_setImageWithUrl:self.coverUrl];
        }
        self.isHaveCoverImage = YES;
        self.changeButton.hidden = NO;
        self.coverImageView.userInteractionEnabled = NO;
    }
    self.plateTopicView.topicArray = self.topicArray;
    if (self.model.channel_id) {
        self.plateTopicView.plateName = self.model.channel_name;
    }
}
- (void)configNav {
    self.title = @"写文章";
    self.jhTitleLabel.font = [UIFont fontWithName:kFontNormal size:18];
    [self initRightButtonWithName:@"发布" action:@selector(rightActionButton:)];
    self.jhRightButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [self.jhRightButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jhTitleLabel.mas_centerY);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
}


- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.coverImageView];
    [self.headerView addSubview:self.changeButton];
    [self.headerView addSubview:self.plateTopicView];
}

/** 返回按钮*/
- (void)backActionButton:(UIButton *)sender{
    if (self.backActionBlock) {
        self.backActionBlock(self.model, self.coverImage, self.topicArray);
    }
    [super backActionButton:sender];
}

/** 选择照片*/
- (void)selectCoverImageAction{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowCrop = YES;
    imagePickerVc.scaleAspectFillCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (kScreenHeight - kScreenWidth * 9 / 16) / 2, kScreenWidth, kScreenWidth * 9 / 16);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
            self.isHaveCoverImage = YES;
            self.coverImageView.image = photos[0];
            self.coverImage = photos[0];
            self.changeButton.hidden = NO;
            self.coverImageView.userInteractionEnabled = NO;
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -------- 发布 --------
-(void)rightActionButton:(UIButton *)sender {
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    if(!self.isHaveCoverImage)
    {
        [self.view makeToast:@"请上传封面图片" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if(!self.model.channel_id)
    {
        [self.view makeToast:@"请选择版块" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    for (JHPublishTopicDetailModel *m in self.topicArray) {
        [self.model.topic addObject:m.title];
    }
    
    JHSQUploadModel * uploadModel =[[JHSQUploadModel alloc]init];
    uploadModel.richTextArray = self.richTextArr;
    uploadModel.paramModel = self.model;
    uploadModel.image = self.coverImageView.image;
    if(self.coverImage) {
        uploadModel.image = self.coverImage;
    }
    else{
        uploadModel.image = self.coverUrl;
    }
    uploadModel.type = 3;
    [JHPublishTopicRecordModel saveTopicRecordArray:self.topicArray];
    [JHSQUploadManager addModel:uploadModel];
    
    ///369神策埋点:内容发布_点击发布 长文章
    [self trackPublishClick];
    
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [JHRootController setTabBarSelectedIndex:0];
    
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

///选择版块
-(void)selectCatePlateAction
{
    [self.view endEditing:YES];
    if(!self.isEdit) {
        @weakify(self);
        [JHPlateSelectView showInView:JHKeyWindow doneBlock:^(JHPlateSelectData *data) {
            @strongify(self);
            self.plateTopicView.plateName = data.channel_name;
            self.model.channel_id = data.channel_id;
            self.model.channel_name = data.channel_name;
            ///369神策埋点:内容发布_选择板块
            [JHTracking trackEvent:@"nrfbSectionSelect" property:@{@"content_type":@"长文章",
                                                                   @"section_id":data.channel_id,
                                                                   @"section_name":data.channel_name
            }];
        }];
    }
}
/// 选择话题
-(void)selectTopicAction
{
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

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark --UI--
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight)];
        _tableView.tableHeaderView = self.headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIImageView *)coverImageView{
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.headerView.top + 15, kScreenWidth - 30, (kScreenWidth - 30) / 16 * 9)];
        _coverImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCoverImageAction)];
        [_coverImageView addGestureRecognizer:tapGesture];
        _coverImageView.layer.cornerRadius = 8;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
        _coverImageView.image = [UIImage imageNamed:@"publish_add_cover"];
    }
    return _coverImageView;
}

- (UIButton *)changeButton{
    if (_changeButton == nil) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.frame = CGRectMake(self.coverImageView.right - 58 - 15, self.coverImageView.bottom - 21 -15, 58, 21);
        [_changeButton setTitle:@"更换封面" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeButton.backgroundColor = RGBA(0, 0, 0, 0.5);
        _changeButton.layer.cornerRadius = _changeButton.height / 2;
        _changeButton.layer.borderWidth = 1;
        _changeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _changeButton.clipsToBounds = YES;
        [_changeButton addTarget:self action:@selector(selectCoverImageAction) forControlEvents:UIControlEventTouchUpInside];
        _changeButton.hidden = YES;
    }
    return _changeButton;
}

-(JHSQPublishSelectPlateTopicView *)plateTopicView {
    if(!_plateTopicView)
    {
        _plateTopicView = [JHSQPublishSelectPlateTopicView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.headerView];
        _plateTopicView.frame = CGRectMake(0, self.coverImageView.bottom + 35, kScreenWidth, 100);
        @weakify(self);
        _plateTopicView.addTopicBlock = ^{
            @strongify(self);
            [self selectTopicAction];
        };
        _plateTopicView.addCatePlateBlock = ^{
            @strongify(self);
            [self selectCatePlateAction];
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

- (NSMutableArray<JHPublishTopicDetailModel *> *)topicArray
{
    if(!_topicArray)
    {
        _topicArray = [NSMutableArray new];
    }
    return _topicArray;
}


@end
