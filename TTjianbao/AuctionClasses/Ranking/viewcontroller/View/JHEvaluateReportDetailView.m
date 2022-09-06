//
//  JHEvaluateReportDetailView.m
//  TTjianbao
//
//  Created by jesee on 9/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEvaluateReportDetailView.h"
#import "JHEvaluateReportViewCell.h"
#import "UITextField+PlaceHolderColor.h"

#define kReportItemSize (CGSizeMake(129*ScreenWidth/375.0, 30))

@interface JHEvaluateReportDetailView () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
{
    UIView* contentViews;
    UIButton* closeBtn;
    UILabel* titleLabel;
    UILabel* remarkLabel;
    UIButton* helpfulBtn;
    UIImageView* helpfulImg;
}
@property (nonatomic, assign) BOOL helpful;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *detailLayout;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *remarks;
@end

@implementation JHEvaluateReportDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x0, 0.4);
        [JHKeyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(JHKeyWindow);
        }];
        [self drawSubview];
    }
    return self;
}

- (void)preLoadData:(JHEvaluateReportModel*)model helpful:(BOOL)helpful
{
    [self dismissView:NO];
    self.helpful = helpful;
    self.remarks = model.remark;
    self.dataArray = model.tags;
    if(self.helpful)
    {
        [helpfulBtn setTitle:@"有帮助" forState:UIControlStateNormal];
        [helpfulImg setImage:[UIImage imageNamed:@"icon_evaluate_report_good"]];
    }
    else
    {
        [helpfulBtn setTitle:@"没帮助" forState:UIControlStateNormal];
        [helpfulImg setImage:[UIImage imageNamed:@"icon_evaluate_report_bad"]];
    }
    if([model.remark length] > 0)
        remarkLabel.text = [NSString stringWithFormat:@"“%@”", model.remark];
    NSInteger count = self.dataArray.count;
    CGFloat height = (30+14)* (count/2 + (count%2 ? 1 : 0));
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(remarkLabel.mas_top).offset(-20);
       make.left.right.equalTo(contentViews);
       make.height.mas_equalTo(height);
    }];
    [self.collectionView reloadData];
}

- (void)drawSubview
{
    contentViews = [[UIView alloc] initWithFrame:CGRectZero];
    contentViews.backgroundColor = HEXCOLOR(0xFFFFFF);
    contentViews.layer.cornerRadius = 12;
    [self addSubview:contentViews];
    [contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
    remarkLabel = [[UILabel alloc]init];
    remarkLabel.font = JHFont(13);
    remarkLabel.textColor = HEXCOLOR(0x999999);
//    remarkLabel.text = @"不错，非常好";
    remarkLabel.numberOfLines = 1;
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    [contentViews addSubview:remarkLabel];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.bottom.mas_equalTo(contentViews).offset(-40);
        make.left.equalTo(contentViews).offset(66);
    }];
    
    //collection
    [contentViews addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(remarkLabel.mas_top).offset(-20);
        make.left.right.equalTo(contentViews);
        make.height.mas_equalTo(30);
    }];
    
    //button
    helpfulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpfulBtn setTitle:@"有帮助" forState:UIControlStateNormal];
    [helpfulBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    helpfulBtn.titleLabel.font = JHFont(14);
    helpfulBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    helpfulBtn.layer.borderWidth = 0.5;
    helpfulBtn.layer.cornerRadius = 14;
    helpfulBtn.userInteractionEnabled = NO;
    helpfulBtn.backgroundColor = HEXCOLOR(0xFFFDF1);
    helpfulBtn.layer.borderColor = HEXCOLORA(0xFEE100, 1).CGColor;
//    [helpfulBtn addTarget:self action:@selector(helpfulAction) forControlEvents:UIControlEventTouchUpInside];
    [contentViews addSubview:helpfulBtn];
    [helpfulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView.mas_top).offset(-33);
        make.centerX.equalTo(contentViews).offset(7/2.0);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(85);
    }];
    
    helpfulImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_evaluate_report_good"]];
//    helpfulImg.contentMode = UIViewContentModeScaleAspectFit;
    helpfulImg.backgroundColor = [UIColor clearColor];
    helpfulImg.userInteractionEnabled = NO;
    [contentViews addSubview:helpfulImg];
    [helpfulImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(helpfulBtn).offset(-13);
        make.top.equalTo(helpfulBtn).offset(-2);
        make.size.mas_equalTo(CGSizeMake(32, 33));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [contentViews addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(helpfulBtn.mas_top).offset(-30);
       make.height.mas_equalTo(1);
       make.left.right.equalTo(contentViews);
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = JHMediumFont(15);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.text = @"评价";
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentViews addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentViews).offset(16);
        make.bottom.mas_equalTo(line.mas_top).offset(-13);
        make.centerX.equalTo(contentViews);
        make.height.mas_equalTo(21);
    }];
    
    //close
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"img_msg_notice_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [contentViews addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(contentViews).offset(0);
        make.size.mas_equalTo(40);
    }];
}

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.detailLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
        [_collectionView registerClass:[JHEvaluateReportViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHEvaluateReportViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)detailLayout
{
    if(!_detailLayout)
    {
        _detailLayout = [UICollectionViewFlowLayout new];
        _detailLayout.itemSize = kReportItemSize;
        _detailLayout.minimumLineSpacing = 14; //行间距
        _detailLayout.minimumInteritemSpacing = 15.0; //行内item间距
    }
    return _detailLayout;
}

#pragma mark - delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHEvaluateReportTagsModel* model = [self.dataArray objectAtIndex:indexPath.item];
    
    JHEvaluateReportViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHEvaluateReportViewCell class]) forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    [cell updateData:model];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - event
- (void)pressCloseButton
{
    [self dismissView:YES];
}

- (void)dismissView:(BOOL)hidden
{
    self.hidden = hidden;
//    [self removeFromSuperview];
}

@end
