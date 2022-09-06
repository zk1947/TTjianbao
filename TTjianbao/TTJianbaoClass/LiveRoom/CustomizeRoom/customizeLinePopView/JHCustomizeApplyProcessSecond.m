//
//  JHCustomizeApplyProcessSecond.m
//  TTjianbao
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyProcessSecond.h"
#import "JHCustomizeApplyProcessThird.h"
#import "JHChooseMaterialsCell.h"
#import "JHMeterialsCategoryModel.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "JHUIFactory.h"

@interface JHCustomizeApplyProcessSecond ()<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView* emptyImageView;
@property (nonatomic, strong) UILabel* emptyLabel;
@property (nonatomic, strong) UICollectionView* resultCollectionView;
@property (nonatomic, strong) NSArray <JHMeterialsCategoryModel*> *pickerDataArray;
@property (nonatomic, strong) JHMeterialsCategoryModel *selectModel;
@property (nonatomic, strong) JHCustomizeApplyProcessThird *thirdView;
@property (nonatomic, copy) NSString * channelId;//channelID
@end

@implementation JHCustomizeApplyProcessSecond

- (instancetype)initWithFrame:(CGRect)frame andCustomizeId:(NSString *)channelId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bar.frame= CGRectMake(0, 0, ScreenW, 362+UI.bottomSafeAreaHeight);
        self.channelId = channelId;
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.titleLabel.text = @"请选择您想要定制的类别（2/3）";
    [self creatBottomBtn:2];
    [self showSubviews];
    
    [self requestCategoryData];
}
- (void)showSubviews
{
    [self.resultCollectionView registerClass:[JHChooseMaterialsCell class] forCellWithReuseIdentifier:NSStringFromClass([JHChooseMaterialsCell class])];
    [self.resultCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    [self.bar addSubview:self.resultCollectionView];
    [self.resultCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.sureBtn.mas_top).offset(-10);
    }];
    [self.bar bringSubviewToFront:self.topView];
}
- (UICollectionView *)resultCollectionView
{
    if (!_resultCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;// 设置item的大小
        CGFloat itemW = (ScreenWidth-42) / 3 ;
        flowLayout.itemSize = CGSizeMake(itemW, itemW*80/111);
        // 设置每个分区的 上左下右 的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 10 ,10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        _resultCollectionView.showsVerticalScrollIndicator = NO;
        _resultCollectionView.showsHorizontalScrollIndicator = NO;
        _resultCollectionView.alwaysBounceVertical = YES;
        _resultCollectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _resultCollectionView;
}

#pragma mark - collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pickerDataArray.count; 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHChooseMaterialsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHChooseMaterialsCell class]) forIndexPath:indexPath];
    [cell setRecordModel:self.pickerDataArray[indexPath.item] andNullTitle:@"本直播间\n不支持此类别" andprocess:@"second"];
    return cell;
}

 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHMeterialsCategoryModel * model = self.pickerDataArray[indexPath.item];
    if (!model.customizeFlag) {
        [self makeToast:@"定制师不支持该类别" duration:1.5 position:CSToastPositionCenter];
        return;
    }
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    //do something ...
    self.selectModel.isSelect = NO;
    self.selectModel = self.pickerDataArray[indexPath.item];
    self.selectModel.isSelect = YES;
    [self.resultCollectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = CGSizeMake(ScreenW, 47);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        // 头部视图
        return [[UICollectionReusableView alloc] init];


    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
        [footer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel * label = [JHUIFactory createLabelWithTitle:@"更多定制类别，敬请期待！" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(0, 0, ScreenW, 47);
        [footer addSubview:label];
        return footer;
    }
    return reusableView;
}

- (void)requestCategoryData{///anon/customize/fee/template-list
    NSDictionary *dic = @{@"channelId":self.channelId};
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/appraisal/customizeFee/getUserCustomizeFeeList") Parameters:dic successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        self.pickerDataArray = [JHMeterialsCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.resultCollectionView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - empty page
- (void)showEmptyText
{
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyLabel];
    
    self.emptyImageView.hidden = NO;
    [self.emptyImageView setImage:[UIImage imageNamed:@"img_default_page"]];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-60);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.emptyLabel.hidden = NO;
    self.emptyLabel.text = @"暂无数据~";
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.emptyImageView.mas_centerX);
    }];
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView)
    {
        _emptyImageView = [UIImageView new];
        _emptyImageView.contentMode = UIViewContentModeCenter;
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel
{
    if (_emptyLabel == nil)
    {
        _emptyLabel = [UILabel new];
        _emptyLabel.font = [UIFont systemFontOfSize:18];
        _emptyLabel.textColor = HEXCOLOR(0xa7a7a7);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}
-(JHCustomizeApplyProcessThird *)thirdView{
    if (!_thirdView) {
        _thirdView = [[JHCustomizeApplyProcessThird alloc] initWithFrame:self.bounds];
    }
    return _thirdView;
}
-(void)nextClick:(UIButton *)sender{

    if (!self.selectModel) {
        [self makeToast:@"请选择您想要定制的类别" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    self.applyModel.customizeFeeId = self.selectModel.ID;
    self.applyModel.customizeFeeName = self.selectModel.name;
    
    self.thirdView.applyModel = self.applyModel;
    self.thirdView.completeBlock = self.completeBlock;
    [self.thirdView requestImageData];
    [self addSubview:self.thirdView];
    [self.thirdView pushAlertView];
}

@end
