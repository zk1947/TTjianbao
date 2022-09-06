//
//  JHSaleGoodsView.m
//  TTjianbao
//
//  Created by jesee on 18/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSaleGoodsView.h"
#import "JHTitleTextItemView.h"
#import "JHLine.h"
#import "UIButton+JHWebImage.h"

#define maxCount  30
#define kGoodsWidth 280
#define kGoodsHeight 435

@interface JHSaleGoodsView () 

@property (nonatomic, strong) UIView* goodsContentView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* closeBtn;
@property (nonatomic, strong) UIButton* addImgBtn;
@property (nonatomic, strong) UIButton* finishBtn;
@property (nonatomic, strong) JHTitleTextItemView* goodsTitle;
@property (nonatomic, strong) JHTitleTextItemView* goodsCategory;
@property (nonatomic, strong) JHTitleTextItemView* goodsPrice;
@property (nonatomic, strong) JHShopwindowGoodsListModel* dataModel;
@end

@implementation JHSaleGoodsView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithData:(JHShopwindowGoodsListModel*)model
{
    if(self = [super init])
    {
        [JHKeyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(JHKeyWindow);
        }];
        [self drawSubviews];
        [self refreshView:model];
        //创建通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)drawSubviews
{
    self.backgroundColor = HEXCOLORA(0x0, 0.4);
    //全部子view承载框
    [self addSubview:self.goodsContentView];
    [self.goodsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kGoodsWidth, kGoodsHeight));
        make.centerX.equalTo(self);
        make.centerY.mas_equalTo(self).offset(-7);
    }];
    //close
    [_goodsContentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsContentView).offset(0);
        make.right.equalTo(_goodsContentView).offset(0);
        make.size.mas_equalTo(40);
    }];
    //title
    [_goodsContentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.top.equalTo(_goodsContentView).offset(14);
        make.centerX.equalTo(_goodsContentView);
    }];
    //line
    JHCustomLine* line = [JHCustomLine new];
    [_goodsContentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.goodsContentView).offset(0);
        make.right.equalTo(self.goodsContentView).offset(0);
        make.height.offset(0.5);
    }];
    //addImgBtn
    [_goodsContentView addSubview:self.addImgBtn];
    [self.addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(18);
        make.centerX.equalTo(self.goodsContentView);
        make.size.mas_equalTo(CGSizeMake(160, 150));
    }];
    //textField:title+category+price
    self.goodsTitle = [self makeFieldText:@"商品标题" placeHolder:@"请填写商品标题，30字以内"];
    self.goodsTitle.textField.delegate = nil;
    self.goodsTitle.textField.keyboardType = UIKeyboardTypeDefault;
    [self.goodsTitle.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_goodsContentView addSubview:self.goodsTitle];
    [self.goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addImgBtn.mas_bottom).offset(15);
        make.left.equalTo(self.goodsContentView).offset(8);
        make.right.equalTo(self.goodsContentView).offset(-8);
        make.height.offset(35);
    }];
    //line
    JHCustomLine* line1 = [JHCustomLine new];
    [_goodsContentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsTitle.mas_bottom).offset(1);
        make.left.equalTo(self.goodsContentView).offset(17);
        make.right.equalTo(self.goodsContentView).offset(-17);
        make.height.offset(0.5);
    }];
    self.goodsCategory = [self makeFieldText:@"选择类别" placeHolder:@"请选择宝贝类别"];
    [self.goodsCategory openClickActionRightArrowWithTarget:self action:@selector(showCatePicker:)];
    self.goodsCategory.textField.textAlignment = NSTextAlignmentLeft;
    [_goodsContentView addSubview:self.goodsCategory];
    [self.goodsCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsTitle.mas_bottom).offset(12);
        make.left.right.height.equalTo(self.goodsTitle);
    }];
    //line
    JHCustomLine* line2 = [JHCustomLine new];
    [_goodsContentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsCategory.mas_bottom).offset(1);
        make.left.right.equalTo(line1);
        make.height.offset(0.5);
    }];
    self.goodsPrice = [self makeFieldText:@"宝贝价格" placeHolder:@"￥请输入价格"];
    [_goodsContentView addSubview:self.goodsPrice];
    [self.goodsPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsCategory.mas_bottom).offset(12);
        make.left.right.height.equalTo(self.goodsTitle);
    }];
    //line
    JHCustomLine* line3 = [JHCustomLine new];
    [_goodsContentView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsPrice.mas_bottom).offset(1);
        make.left.right.equalTo(line1);
        make.height.offset(0.5);
    }];
    //finish
    [_goodsContentView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsPrice.mas_bottom).offset(14);
        make.centerX.equalTo(self.goodsContentView);
        make.size.mas_equalTo(CGSizeMake(120, 38));
    }];
}

#pragma mark - refresh & data
- (void)refreshView:(JHShopwindowGoodsListModel*)model
{
    self.dataModel = model;
    if(self.dataModel)
    {
        [self.addImgBtn jhSetImageWithURL:[NSURL URLWithString:model.listImage ? : @""] forState:UIControlStateNormal];
        self.goodsTitle.textField.text = model.title;
        self.goodsCategory.textField.text = model.goodsCateIdName;
        self.goodsPrice.textField.text = model.price;
    }
}

- (JHShopwindowGoodsListModel*)goodsAddInfos
{//默认赋值认为是编辑
    JHShopwindowGoodsListModel* goodsInfo = [JHShopwindowGoodsListModel new];
    goodsInfo.Id = self.dataModel.Id;
    goodsInfo.listImage = self.dataModel.listImage;
    goodsInfo.title = self.goodsTitle.textField.text;
    goodsInfo.goodsCateId = self.dataModel.goodsCateId;
    goodsInfo.price = self.goodsPrice.textField.text;
    return goodsInfo;
}

#pragma mark - subviews
- (UIView *)goodsContentView
{
    if(!_goodsContentView)
    {
        _goodsContentView = [UIView new];
        _goodsContentView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _goodsContentView.layer.cornerRadius = 12;
        _goodsContentView.layer.masksToBounds = YES;
    }
    return _goodsContentView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = JHFont(15);
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.text = @"添加商品";
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn
{
    if(!_closeBtn)
    {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"img_msg_notice_close"] forState:UIControlStateNormal];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(28, 28, 28, 28)];
        [_closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)finishBtn
{
    if(!_finishBtn)
    {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成添加" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:HEXCOLORA(0x333333, 1) forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = JHMediumFont(14);
        _finishBtn.backgroundColor = HEXCOLOR(0xFFC242);
        _finishBtn.layer.cornerRadius = 19;
        _finishBtn.layer.masksToBounds = YES;
        [_finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.goodsContentView addSubview:_finishBtn];
    }
    return _finishBtn;
}

- (UIButton *)addImgBtn
{
    if (!_addImgBtn) {
        _addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"dis_addPic"] forState:UIControlStateNormal];
        _addImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_addImgBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgBtn;
}

- (JHTitleTextItemView*)makeFieldText:(NSString*)title placeHolder:(NSString*)placeHolder
{
    JHTitleTextItemView* textView = [[JHTitleTextItemView alloc] initWithTitle:title textPlace:placeHolder isEdit:YES isShowLine:NO];
    textView.titleLabel.font = JHMediumFont(13);
    textView.textField.delegate = self;
    textView.textField.textColor = HEXCOLOR(0xbbbbbb);
    textView.textField.font = JHFont(13);
    textView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.goodsContentView addSubview:textView];

    return textView;
}

- (JHPickerView *)catePicker
{
    if(!_catePicker)
    {
        _catePicker = [[JHPickerView alloc] init];
        _catePicker.tag = 1;
        _catePicker.widthPickerComponent = 300;
        _catePicker.delegate = self;
    }
    return _catePicker;
}
//设置选中图片,从相册中选择
- (void)setSelectedAlbumIcon:(UIImage*)img
{
    if(img)
    {
        [self.addImgBtn setImage:img forState:UIControlStateNormal];
    }
}

#pragma mark - delegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > maxCount)
    {
        textField.text = [textField.text substringToIndex:maxCount];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }
    if(self.goodsTitle.textField == textField)
    {
        return YES;
    }
    //第一个参数，被替换字符串的range
    //第二个参数，即将键入或者粘贴的string
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    self.goodsCategory.textField.text = selectedTitle;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    CGFloat keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.goodsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kGoodsWidth, kGoodsHeight));
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self).offset(- 7 - keyBoradHeight);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.goodsContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kGoodsWidth, kGoodsHeight));
        make.centerX.equalTo(self);
        make.centerY.mas_equalTo(self).offset(-7);
    }];
}

#pragma mark - event
- (void)dismiss
{
    if(self.hiddenBlock)
    {
        self.hiddenBlock(NO);
    }
    [self removeFromSuperview];
}

- (void)showCatePicker:(UIButton *)button
{
    [self endEditing:YES];
}

- (void)addImageAction:(UIButton *)button
{

}

- (BOOL)finishAction:(UIButton *)button
{
    if (!self.addImgBtn.imageView.image)
    {
        [self makeToast:@"请上传图片" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    
    if (!self.goodsTitle.textField.text || self.goodsTitle.textField.text.length == 0)
    {
        [self makeToast:@"请输入商品标题" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    
    if (!self.goodsCategory.textField.text || self.goodsCategory.textField.text.length == 0)
    {
        [self makeToast:@"请选择宝贝类别" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }

    if (!self.goodsPrice.textField.text || self.goodsPrice.textField.text.length == 0)
    {
        [self makeToast:@"请输入宝贝价格" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}

- (void)closeButtonAction:(UIButton *)button
{
    [self dismiss];
}

@end
