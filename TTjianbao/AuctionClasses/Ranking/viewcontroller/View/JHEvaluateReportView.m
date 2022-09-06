//
//  JHEvaluateReportView.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEvaluateReportView.h"
#import "JHEvaluateReportViewCell.h"
#import "UITextField+PlaceHolderColor.h"
#import "JHGrowingIO.h"

#define kReportItemSize (CGSizeMake(129*ScreenWidth/375.0, 30))

@interface JHEvaluateReportView () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, JHEvaluateReportViewCellDelegate>
{
    UIView* contentViews;
    UIButton* closeBtn;
    UIButton* submitBtn;
    UILabel* titleLabel;
    UILabel* subTitleLabel;
    UITextField* textField;
}
@property (nonatomic, assign) BOOL helpful;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *detailLayout;
@property (nonatomic, strong) JHEvaluateReportModel* reportModel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *remarks;
@end

@implementation JHEvaluateReportView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)preLoadData:(JHEvaluateReportModel*)model helpful:(BOOL)helpful
{
    [self dismissView:NO];
    self.reportModel = model;
    self.helpful = helpful;
    self.remarks = model.remark;
    self.dataArray = model.tags;
    if(self.helpful)
      subTitleLabel.text = @"感谢反馈，我们会继续努力哒";
    else
      subTitleLabel.text = @"非常抱歉，你遇到了哪些问题";
    textField.text = nil;
    NSInteger count = self.dataArray.count;
    CGFloat height = (30+14)* (count/2 + (count%2 ? 1 : 0));
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textField.mas_top).offset(-30);
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
    
    //提交
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = HEXCOLORA(0xEEEEEE, 1);
    submitBtn.titleLabel.font = JHFont(15);
    submitBtn.layer.cornerRadius = JHScaleToiPhone6(40)/2.0;
    [submitBtn setTitle:@"匿名提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(pressSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [contentViews addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentViews).offset(-20);
        make.left.equalTo(contentViews).offset(50);
        make.right.equalTo(contentViews).offset(-50);
        make.height.mas_equalTo(44);
    }];
    
    //编辑框
    textField = [[UITextField alloc] init];
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 33)];
    textField.leftView.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView.layer.cornerRadius = 17.5;
    textField.backgroundColor = HEXCOLOR(0xF5F6FA);
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.font = JHFont(13);
    textField.textColor = HEXCOLOR(0x333333);
    textField.placeholder = @"其他想说的";
    [textField placeHolderColor:HEXCOLOR(0x999999)];
    textField.layer.cornerRadius = 17.5;
    textField.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    textField.layer.borderWidth = 0.5;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [contentViews addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(submitBtn.mas_top).offset(-20);
        make.left.equalTo(contentViews).offset(50);
        make.right.equalTo(contentViews).offset(-50);
        make.height.mas_equalTo(35);
    }];
    
    //collection
    [contentViews addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(textField.mas_top).offset(-30+14);
        make.left.right.equalTo(contentViews);
        make.height.mas_equalTo(30);
    }];
    
    subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = JHMediumFont(20);
    subTitleLabel.textColor = HEXCOLOR(0x333333);
    if(self.helpful)
        subTitleLabel.text = @"感谢反馈，我们会继续努力哒";
    else
        subTitleLabel.text = @"非常抱歉，你遇到了哪些问题";
    subTitleLabel.numberOfLines = 1;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [contentViews addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.bottom.mas_equalTo(self.collectionView.mas_top).offset(-30);
        make.centerX.equalTo(contentViews);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [contentViews addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(subTitleLabel.mas_top).offset(-30);
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
    cell.mDelegate = self;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 30) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self pressTitleAction];
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    CGFloat keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
        make.bottom.mas_equalTo(JHKeyWindow).offset(0 - keyBoradHeight);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];
}

#pragma mark - event
- (void)pressSubmitButton
{
    [self dismissView:YES];
    self.reportModel.remark = textField.text;
    if(self.callbackAction)
    {
        self.callbackAction(self.reportModel);
    }
}

- (void)pressCloseButton
{
    [self dismissView:YES];
    NSString* nameStr = @"";
    for (JHEvaluateReportTagsModel* m in self.dataArray)
    {
        if(m.selected)
        {
            nameStr = [NSString stringWithFormat:@"%@,%@", nameStr, m.name ? : @""];
        }
    }
    
    [JHGrowingIO trackPublicEventId:JHClickOrderEvaluateListProblemClick paramDict:@{@"title": nameStr, @"submit":@"false"}];
}

- (void)dismissView:(BOOL)hidden
{
    self.hidden = hidden;
    submitBtn.backgroundColor = HEXCOLORA(0xEEEEEE, 1);
    [submitBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [submitBtn removeTarget:self action:@selector(pressSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self endEditing:YES];
//    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)pressTitleAction
{
    BOOL isShow = NO;
    if([textField.text length] > 0)
    {
        isShow = YES;
    }
    if(!isShow)
    {
        for (JHEvaluateReportTagsModel* m in self.dataArray)
        {
            if(m.selected)
            {
                isShow = YES;
                break;
            }
        }
    }
    if(isShow)
    {
        submitBtn.backgroundColor = HEXCOLORA(0xFEE100, 1);
        [submitBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(pressSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        submitBtn.backgroundColor = HEXCOLORA(0xEEEEEE, 1);
        [submitBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [submitBtn removeTarget:self action:@selector(pressSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
