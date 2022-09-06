//
//  JHChatEvaluationViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatEvaluationViewController.h"
#import "JHChatEvaluationCell.h"

static CGFloat const LeftSpacing = 30.f;
static CGFloat const ContainerWidth = 306.f;

@interface JHChatEvaluationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *selectedLabel;

@property (nonatomic, strong) NSArray<JHChatEvaluationModel *> *dataSource;

@property (nonatomic, strong) JHChatEvaluationModel *selectedModel;

@end

@implementation JHChatEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self bindData];
    [self.collectionView reloadData];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}
#pragma mark - Event
- (void)didClickSubmit : (UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.selectedModel == nil) return;
    [self.submitSubject sendNext:self.selectedModel];
}
- (void)didClickClose : (UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHChatEvaluationModel *model = self.dataSource[indexPath.item];
    model.isSelected = true;
    self.selectedModel = model;
    self.selectedLabel.text = model.title;
    self.selectedLabel.hidden = false;
    for (JHChatEvaluationModel *mo in self.dataSource) {
        if (mo != model) {
            mo.isSelected = false;
        }
    }
}
- (void)bindData {
    @weakify(self)
    [RACObserve(self, selectedModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHChatEvaluationModel *selectedModel = x;
        if (selectedModel.evaluationId.length > 0) {
            self.submitButton.userInteractionEnabled = true;
            self.submitButton.backgroundColor = HEXCOLOR(0xfee100);
        }else {
            self.submitButton.userInteractionEnabled = false;
            self.submitButton.backgroundColor = HEXCOLOR(0xcfcfcf);
        }
        
    }];
}
#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.containerView jh_cornerRadius:8];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview: self.submitButton];
    [self.containerView addSubview:self.selectedLabel];
}
- (void)layoutViews {
    [self.submitButton jh_cornerRadius:self.submitButton.bounds.size.height / 2];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(ContainerWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(LeftSpacing);
        make.right.mas_equalTo(-LeftSpacing);
        make.height.mas_equalTo(70);
    }];
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(0);
        make.height.mas_equalTo(30);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(28);
        make.bottom.mas_equalTo(-26);
        make.left.mas_equalTo(LeftSpacing);
        make.right.mas_equalTo(-LeftSpacing);
    }];
    
}
- (void)registerCells {
    [self.collectionView registerClass:[JHChatEvaluationCell class] forCellWithReuseIdentifier:@"JHChatEvaluationCell"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHChatEvaluationModel *model = self.dataSource[indexPath.item];
    
    JHChatEvaluationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHChatEvaluationCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 40.f;
    CGFloat height = collectionView.bounds.size.height;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat spacing = floor(((ContainerWidth - LeftSpacing * 2 - 40 * 4) / 3));
    return spacing;
}
#pragma mark - LAZY
- (NSArray<JHChatEvaluationModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [JHChatEvaluationModel getEvaluationList];
    }
    return _dataSource;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"您对本次服务满意吗";
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"IM_order_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.scrollEnabled = false;
    }
    return _collectionView;
}
- (UILabel *)selectedLabel {
    if (!_selectedLabel) {
        _selectedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectedLabel.textColor = HEXCOLOR(0x333333);
        _selectedLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _selectedLabel.textAlignment = NSTextAlignmentCenter;
        _selectedLabel.backgroundColor = HEXCOLOR(0xffffff);
        _selectedLabel.hidden = true;
    }
    return _selectedLabel;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _submitButton.backgroundColor = HEXCOLOR(0xcfcfcf);
        _submitButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(didClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (RACSubject<JHChatEvaluationModel *> *)submitSubject {
    if (!_submitSubject) {
        _submitSubject = [RACSubject subject];
    }
    return _submitSubject;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            [self dismissViewControllerAnimated:true completion:nil];
            return;
        }
    }
}
@end
