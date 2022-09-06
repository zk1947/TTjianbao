//
//  JHRecycleOrderTemplateCameraViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleTemplateCameraViewController.h"
#import "JHRecycleImageTemplateView.h"
#import "JHRecycleImagePickerTempViewController.h"
#import "JHRecycleImageTemplateView.h"


@interface JHRecycleTemplateCameraViewController ()
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) JHRecycleImageTemplateView *templateView;
@property (nonatomic, strong) UIStackView *finishView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *finishLabel;
@property (nonatomic, strong) UIButton *finishButton;

@end

@implementation JHRecycleTemplateCameraViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindData];
//    self.currentIndex = 0;
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"回收相机拍摄页"}];
    
    
    if (self.fromType == TemplateCameraFromTypeRecycle) {
        [self getRecycleTemplateRequest];
    }else if (self.fromType == TemplateCameraFromTypeC2C) {
        
    }
    
}

- (void)getRecycleTemplateRequest {
    @weakify(self);
    [JHRecycleUploadProductBusiness requestRecycleUploadQueryExampleCategoryId:self.categoryId.integerValue Completion:^(NSError * _Nullable error, JHRecycleUploadExampleTotalModel * _Nullable model) {
        @strongify(self);
        if (!error) {
            self.singleModelArr = model.singleImgSimples;
            self.multiImgModelArr = model.multiImgSimples;
            [self setImageAndLabel:self.currentIndex];
        }
    }];
}

- (void)setImageAndLabel:(NSInteger)index{
    if (self.singleModelArr.count > index) {
        JHRecycleUploadExampleModel * model = self.singleModelArr[index];
        [self.examButton jh_setImageWithUrl:model.baseImage.small];
        self.examLabel.text = model.exampleDesc;
    }
    if (self.multiImgModelArr.count > index) {
        JHRecycleUploadExampleModel * model = self.multiImgModelArr[index];
        [self.examButton2 jh_setImageWithUrl:model.baseImage.small];
        self.examLabel2.text = model.exampleDesc;
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.templateView scrollToItem];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"相机-模板-ViewController-%@ 释放", [self class]);
}
#pragma mark - Action
// 点击相册
- (void)didClickAlbum {
    JHRecycleImagePickerTempViewController *vc = [[JHRecycleImagePickerTempViewController alloc] init];
    vc.pickerType = RecycleImagePickerTypeImage;
    vc.itemList = self.templateView.viewModel.itemList;
    vc.allowCrop = self.allowCrop;
    [self.navigationController pushViewController:vc animated:true];
    
    RAC(self.templateView.viewModel, finishNum) = RACObserve(vc.templateView.viewModel, finishNum);
    @weakify(self)
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self)
        [self.assetHandle sendNext:self.templateList];
    }];
}
// 点击重拍
- (void)didClickRemakePhone {
    [self.templateView.viewModel.currentViewModel.deleteEvent sendNext:nil];
}
// 点击完成
- (void)didClickFinishAction : (UIButton *)sender {
    [self.assetHandle sendNext:self.templateList];
    [self.navigationController popViewControllerAnimated:true];
}
// 点击返回
- (void)backActionButton:(UIButton *)sender {
    [self.assetHandle sendNext:self.templateList];
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark - Private Functions
// 设置拍摄进度、UI
- (void)setupNumWithNum : (NSInteger)num total : (NSInteger)total {
    if (num == total) {
        self.numLabel.textColor = HEXCOLOR(0x1a1a1a);
        self.finishLabel.textColor = HEXCOLOR(0x1a1a1a);
        self.finishButton.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        self.numLabel.textColor = HEXCOLOR(0x7a7353);
        self.finishLabel.textColor = HEXCOLOR(0x7a7353);
        self.finishButton.backgroundColor = HEXCOLOR(0xffef9f);
    }
    self.numLabel.text = [NSString stringWithFormat:@"%@/%@",@(num), @(total)];
}
- (void)setupData {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (JHRecycleTemplateImageModel *model in self.templateList) {
        JHRecycleImageTemplateCellViewModel *viewModel = [[JHRecycleImageTemplateCellViewModel alloc] init];
        viewModel.templateModel = model;
        viewModel.isSelected = model.isSelected;
        [list appendObject:viewModel];
    }
    self.templateView.viewModel.itemList = list;
}

#pragma mark - Bind
- (void)handleAssetModel : (JHAssetModel *)assetModel {
    [self.templateView.viewModel setupAssetModel:assetModel];
}
- (void)bindData {
    @weakify(self)
    [RACObserve(self.templateView.viewModel, finishNum)
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger num = [x integerValue];
        self.currentIndex = self.templateView.viewModel.currentIndex;;
        [self setImageAndLabel:self.currentIndex];
        [self setupNumWithNum:num total:self.templateView.viewModel.totalNum];
    }];
    [self.templateView.viewModel.showRemake subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        BOOL show = [x boolValue];
        self.takeView.isRemake = show;
    }];
    [RACObserve(self, singleModelArr) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSArray *arr = x;
        NSInteger count = arr.count;
        self.examButton.hidden = count <= 0;
        self.examLabel.hidden = count <= 0;
    }];
    [RACObserve(self, multiImgModelArr) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSArray *arr = x;
        NSInteger count = arr.count;
        self.examButton2.hidden = count <= 0;
        self.examLabel2.hidden = count <= 0;
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    self.jhTitleLabel.text = [NSString stringWithFormat:@"%@图片",self.firstCategoryName];
    [self.customView addSubview:self.descLabel];
    [self.customView addSubview:self.templateView];
    
    [self.customView addSubview:self.finishButton];
    [self.finishButton addSubview:self.finishView];
    
}
- (void)layoutViews {
    [super layoutViews];
    [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(186);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.right.mas_equalTo(0);
    }];
    [self.templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(84);
        make.bottom.equalTo(self.customView).offset(-56);
        make.left.equalTo(self.customView).offset(20);
        make.width.mas_equalTo(64 * 4 + 5);
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.top.equalTo(self.templateView.mas_top).offset(6);
    }];
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.finishButton);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
}
#pragma mark - Lazy

- (void)setTemplateList:(NSArray<JHRecycleTemplateImageModel *> *)templateList {
    _templateList = templateList;
    [self setupData];
}
- (JHRecycleImageTemplateView *)templateView {
    if (!_templateView) {
        _templateView = [[JHRecycleImageTemplateView alloc] initWithType:RecycleTemplateCellTypeAdd];
        @weakify(self);
        _templateView.cellClickIndex = ^(NSInteger selectIndex) {
            @strongify(self);
            self.currentIndex = selectIndex;
            [self setImageAndLabel:self.currentIndex];
            
        };
    }
    return _templateView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        NSString *parStr = self.fromType == TemplateCameraFromTypeC2C ? @"便于买家查看" : @"以便回收商更准确的报价";
        _descLabel.text = [NSString stringWithFormat:@"请把%@拍摄清晰，%@",self.firstCategoryName,parStr];
        _descLabel.textColor = HEXCOLOR(0x666666);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _descLabel;
}
- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_finishButton jh_cornerRadius:2];
        [_finishButton addTarget:self action:@selector(didClickFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}
- (UILabel *)getFinishLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = HEXCOLOR(0x1a1a1a);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:kFontBoldDIN size:12];
    return label;
}
- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [self getFinishLabel];
    }
    return _numLabel;
}
- (UILabel *)finishLabel {
    if (!_finishLabel) {
        _finishLabel = [self getFinishLabel];
        _finishLabel.text = @"完成";
    }
    return _finishLabel;
}
- (UIStackView *)finishView {
    if (!_finishView) {
        _finishView = [[UIStackView alloc] initWithArrangedSubviews:@[self.numLabel, self.finishLabel]];
        _finishView.spacing = 0;
        _finishView.axis = UILayoutConstraintAxisVertical;
        _finishView.alignment = UIStackViewAlignmentFill;
        _finishView.distribution = UIStackViewDistributionFill;
        _finishView.userInteractionEnabled = false;
    }
    return _finishView;
}

- (RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *)assetHandle {
    if (!_assetHandle) {
        _assetHandle = [RACSubject subject];
    }
    return _assetHandle;
}

@end
