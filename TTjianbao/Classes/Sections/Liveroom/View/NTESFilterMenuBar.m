//
//  NTESFilterMenuBar.m
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESFilterMenuBar.h"
#import "NTESMenuCell.h"
#import "ASValueTrackingSlider.h"
#import "UIView+NTES.h"

const CGFloat gFilterMenuRowsEveryPage = 4;
const CGFloat gFilterMenuLinesEveryPage = 1;

const CGFloat defaultSmoothSlidervalue = 0;
const CGFloat defaultConstrastSlidervalue = 1.0;


@interface NTESFilterMenuBar ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _row;
    CGFloat _line;
    CGRect _lastRect;
}

@property (nonatomic, strong) UILabel *barTitleLab; //名称
@property (nonatomic, strong) NSArray *filterInfos; //滤镜选项信息
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *menuList; //选项控件
@property (strong, nonatomic) UILabel *contrastSliderLabel;
@property (strong, nonatomic) UILabel *smoothSliderLabel;

@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UIView *verticalLine;

@property (nonatomic) NSInteger oldSelectIndex;

@property (nonatomic) float oldcontrastSliderValue;

@property (nonatomic) float oldsmoothSlidervalue;

@property (strong, nonatomic)  ASValueTrackingSlider *contrastSlider; //锐度强度
@property (strong, nonatomic)  ASValueTrackingSlider *smoothSlider; //磨皮强度

@property (nonatomic)  BOOL showSlider;

@end

@implementation NTESFilterMenuBar
- (instancetype)init
{
    if (self = [super init])
    {
        //默认自然模式
        self.selectedIndex = 1;
        self.oldSelectIndex = 1;
        
        [self addSubview:self.barTitleLab];
        [self addSubview:self.menuList];
        [self addSubview:self.smoothSliderLabel];
        [self addSubview:self.smoothSlider];
        [self addSubview:self.contrastSliderLabel];
        [self addSubview:self.contrastSlider];
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        [self addSubview:self.verticalLine];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.height = self.barHeight;
    
    self.barTitleLab.frame = CGRectMake(10.0,
                                        20,
                                        self.barTitleLab.width,
                                        self.barTitleLab.height);
    
    
    
    self.menuList.frame = CGRectMake(self.barTitleLab.left,
                                     self.barTitleLab.bottom + 35,
                                     self.width - self.barTitleLab.left * 2,
                                     64.0);
    
    if (_showSlider) {
        self.smoothSliderLabel.frame = CGRectMake(self.menuList.left,
                                                  self.menuList.bottom + 26.0,
                                                  self.smoothSliderLabel.width,
                                                  self.smoothSliderLabel.height);
        
        self.smoothSlider.frame = CGRectMake(self.smoothSliderLabel.right + 4.0,
                                             0,
                                             self.width - self.smoothSliderLabel.right - 4.0 - 12.0,
                                             32);
        self.smoothSlider.center = CGPointMake(self.smoothSlider.centerX,
                                               self.smoothSliderLabel.centerY);
        
        
        self.contrastSliderLabel.frame = CGRectMake(self.smoothSliderLabel.left,
                                                    self.smoothSliderLabel.bottom + 26.0,
                                                    self.contrastSliderLabel.width,
                                                    self.contrastSliderLabel.height);
        
        self.contrastSlider.frame = CGRectMake(self.smoothSlider.left,
                                               0,
                                               self.smoothSlider.width,
                                               self.smoothSlider.height);
        self.contrastSlider.center = CGPointMake(self.contrastSlider.centerX,
                                                 self.contrastSliderLabel.centerY);

    }
    
    
    self.topLine.frame = CGRectMake(0, self.barTitleLab.bottom + 20, self.width, 0.5);
    
    self.bottomLine.frame = CGRectMake(0, _showSlider? self.contrastSlider.bottom + 20:self.menuList.bottom  + 20, self.width, 0.5);
    
    self.verticalLine.frame = CGRectMake(self.width * 0.5, _showSlider? self.contrastSlider.bottom + 20 :self.menuList.bottom  + 20, 0.5, _showSlider? self.height - self.contrastSlider.bottom - 20: self.height - self.menuList.bottom - 20);

    self.cancelButton.frame = CGRectMake(0, _showSlider? self.contrastSlider.bottom+ 20:self.menuList.bottom  + 20, self.width * 0.5,_showSlider? self.height - self.contrastSlider.bottom - 20: self.height - self.menuList.bottom - 20);

    self.confirmButton.frame = CGRectMake(self.width * 0.5, _showSlider? self.contrastSlider.bottom+ 20:self.menuList.bottom  + 20, self.width * 0.5,_showSlider? self.height - self.contrastSlider.bottom - 20: self.height - self.menuList.bottom - 20);


}

- (void)cancel
{
    [self onCancelButtonPressed];
}

-(void)setShowSlider:(BOOL)showSlider
{
    _showSlider = showSlider;
    self.contrastSlider.hidden = !showSlider;
    self.contrastSliderLabel.hidden = !showSlider;
    self.smoothSlider.hidden = !showSlider;
    self.smoothSliderLabel.hidden = !showSlider;
    [self setNeedsLayout];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filterInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell hiddenAllSeparate];

    NSDictionary *dic = self.filterInfos[indexPath.row];
    if (dic) {
        NSString *name = dic[@"name"];
        NSString *icon = dic[@"icon"];
        NSString *selectIcon = dic[@"selectIcon"];
        [cell refreshCell:name icon:icon selectIcon:selectIcon];
    }
    
    cell.selected = (indexPath.row == self.selectedIndex);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
    //关闭美颜
    if (self.selectedIndex == 0) {
        self.smoothSlider.value = defaultSmoothSlidervalue;
        self.contrastSlider.value = defaultConstrastSlidervalue;
        
        //恢复磨皮
        [self smoothSliderValueChanged:self.smoothSlider];
        //恢复对比度
        [self contrastSliderValueChanged:self.contrastSlider];

    }
    if (self.selectBlock) {
        self.selectBlock(self.selectedIndex);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.menuList.height - 15, self.menuList.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    NSInteger itemCount = self.filterInfos.count;
//    CGFloat itemWidth = self.menuList.height;
//    CGFloat interval = ((self.menuList.width + itemWidth/2) - itemCount*itemWidth) / (itemCount - 1);
    return 15;
}

- (void)contrastSliderValueChanged:(ASValueTrackingSlider *)slider
{
    
    if (_contrastChangedBlock) {
        _contrastChangedBlock(slider.value);
    }
}

- (void)smoothSliderValueChanged:(ASValueTrackingSlider *)slider
{
    if (_smoothChangedBlock) {
        _smoothChangedBlock(slider.value);
    }
}

#pragma mark - Getter/Setter
-(NSArray *)filterInfos
{
    if (!_filterInfos) {
        _filterInfos = @[
                         @{@"name": @"关闭",
                           @"icon": @"icon_filter_0_normal",
                           @"selectIcon": @"icon_filter_0_selected"},
                         
                         @{@"name": @"自然",
                           @"icon": @"icon_filter_1_normal",
                           @"selectIcon": @"icon_filter_1_selected"},
                         
                         @{@"name": @"怀旧",
                           @"icon": @"icon_filter_2_normal",
                           @"selectIcon": @"icon_filter_2_selected"},
                         
                         @{@"name": @"粉嫩",
                           @"icon": @"icon_filter_3_normal",
                           @"selectIcon": @"icon_filter_3_selected"},
                         
                         @{@"name": @"黑白",
                           @"icon": @"icon_filter_4_normal",
                           @"selectIcon": @"icon_filter_4_selected"}];
    }
    return _filterInfos;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout)
    {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0.1f;
        _layout.minimumInteritemSpacing = 0.1f;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)menuList
{
    if (!_menuList)
    {
        _menuList = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _menuList.backgroundColor = [UIColor clearColor];
        _menuList.showsVerticalScrollIndicator = NO;
        _menuList.showsHorizontalScrollIndicator = NO;
        _menuList.dataSource = self;
        _menuList.delegate   = self;
        _menuList.bounces = NO;
        [_menuList registerClass:[NTESMenuCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _menuList;
}

- (UILabel *)contrastSliderLabel
{
    if (!_contrastSliderLabel)
    {
        _contrastSliderLabel = [[UILabel alloc] init];
        _contrastSliderLabel.font = [UIFont systemFontOfSize:10.0];
        _contrastSliderLabel.textColor = [UIColor whiteColor];
        _contrastSliderLabel.text = @"对比强度";
        [_contrastSliderLabel sizeToFit];
        _contrastSliderLabel.hidden = YES;
    }
    return _contrastSliderLabel;
}

- (UILabel *)smoothSliderLabel
{
    if (!_smoothSliderLabel)
    {
        _smoothSliderLabel = [[UILabel alloc] init];
        _smoothSliderLabel.font = [UIFont systemFontOfSize:10.0];
        _smoothSliderLabel.textColor = [UIColor whiteColor];
        _smoothSliderLabel.text = @"磨皮强度";
        [_smoothSliderLabel sizeToFit];
        _smoothSliderLabel.hidden = YES;

    }
    return _smoothSliderLabel;
}

- (ASValueTrackingSlider *)contrastSlider
{
    if (!_contrastSlider)
    {
        _contrastSlider = [[ASValueTrackingSlider alloc] init];
        [_contrastSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
        _contrastSlider.maximumValue = 4.0;
        _contrastSlider.popUpViewCornerRadius = 0.0;
        _contrastSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        _contrastSlider.textColor = [UIColor colorWithHue:0.65 saturation:1.0 brightness:0.5 alpha:1];
        [_contrastSlider addTarget:self action:@selector(contrastSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_contrastSlider setNumberFormatter:formatter];
        _contrastSlider.hidden = YES;
        _contrastSlider.value = defaultConstrastSlidervalue;
        _oldcontrastSliderValue = defaultConstrastSlidervalue;

    }
    return _contrastSlider;
}

- (ASValueTrackingSlider *)smoothSlider
{
    if (!_smoothSlider)
    {
        _smoothSlider = [[ASValueTrackingSlider alloc] init];
        [_smoothSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
        _smoothSlider.maximumValue = 1.0;
        _smoothSlider.popUpViewCornerRadius = 0.0;
        _smoothSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        _smoothSlider.textColor = [UIColor colorWithHue:0.75 saturation:1.0 brightness:0.5 alpha:1];
        [_smoothSlider addTarget:self action:@selector(smoothSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_smoothSlider setNumberFormatter:formatter];
        _smoothSlider.hidden = YES;
        _smoothSlider.value = defaultSmoothSlidervalue;
        _oldsmoothSlidervalue = defaultSmoothSlidervalue;

    }
    return _smoothSlider;
}

- (UILabel *)barTitleLab
{
    if (!_barTitleLab)
    {
        _barTitleLab = [[UILabel alloc] init];
        _barTitleLab.font = [UIFont systemFontOfSize:14.0];
        _barTitleLab.textColor = [UIColor whiteColor];
        _barTitleLab.text = @"美颜";
        [_barTitleLab sizeToFit];
    }
    return _barTitleLab;

}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = HEXCOLOR(0x545454);
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = HEXCOLOR(0x545454);
    }
    return _bottomLine;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalLine.backgroundColor = HEXCOLOR(0x545454);
    }
    return _verticalLine;
}

- (UIButton *)cancelButton
{
    if(!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmButton;
}
- (void)setConstrastValue:(CGFloat)constrastValue
{
    if (_constrastValue != constrastValue)
    {
        _constrastValue = constrastValue;
        
        _contrastSlider.value = constrastValue;
    }
}

- (void)setSmoothValue:(CGFloat)smoothValue
{
    if (_smoothValue != smoothValue)
    {
        _smoothValue = smoothValue;
        
        _smoothSlider.value = smoothValue;
    }
}

- (NSInteger)filterIndex
{
    return self.oldSelectIndex;
}

-(void)onCancelButtonPressed
{
    //恢复原始设置 并dismiss view
    if (self.selectBlock) {
        self.selectBlock(self.oldSelectIndex);
    }
    if (_contrastChangedBlock) {
        _contrastChangedBlock(self.oldcontrastSliderValue);
        self.contrastSlider.value = self.oldcontrastSliderValue;
    }
    
    if (_smoothChangedBlock) {
        _smoothChangedBlock(self.oldsmoothSlidervalue);
        self.smoothSlider.value = self.oldsmoothSlidervalue;
    }
    
    self.selectedIndex = self.oldSelectIndex;
    
    // 把选中图片进行还原
    [self doSetSelectedIndex];
    
    // 先恢复原始尺寸 再动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onFilterViewCancelButtonPressed)]) {
            [self.delegate onFilterViewCancelButtonPressed];
        }
    });
}

-(void)onConfirmButtonPressed
{
    //保存设置 并dismiss view
    self.oldSelectIndex = self.selectedIndex;
    self.oldsmoothSlidervalue = self.smoothSlider.value;
    self.oldcontrastSliderValue = self.contrastSlider.value;
    
    self.smoothValue = self.smoothSlider.value;
    self.constrastValue = self.contrastSlider.value;

    if (self.delegate && [self.delegate respondsToSelector:@selector(onFilterViewConfirmButtonPressed)]) {
        [self.delegate onFilterViewConfirmButtonPressed];
    }
}

#pragma mark - 父类重载
- (void)doSetSelectedIndex
{
    self.showSlider = self.selectedIndex;

    [_menuList reloadData];
}

- (CGFloat)barHeight
{
    return _showSlider ?  290.0 : 200.0;
}

@end
