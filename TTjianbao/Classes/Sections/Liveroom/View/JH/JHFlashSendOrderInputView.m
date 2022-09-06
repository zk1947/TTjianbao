//
//  JHFlashSendOrderInputView.m
//  TTjianbao
//
//  Created by user on 2021/9/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFlashSendOrderInputView.h"

#import "LBXScanViewController.h"
#import "LBXZBarWrapper.h"
#import "JHQRViewController.h"
#import "JHTitleTextItemView.h"
#import "NOSUpImageTool.h"
#import "JHAntiFraud.h"
#import "TTjianbaoBussiness.h"
#import "JHPickerView.h"
#import "JHSendOrderProccessGoodView.h"
#import "JHCommBubbleTipView.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"
#import "CommAlertView.h"
#import "JHFlashSendOrderModel.h"

#define NumbersWithDot     @"0123456789.\n"
#define NumbersWithoutDot  @"0123456789\n"

@interface JHFlashSendOrderInputView () <
UITextFieldDelegate,
STPickerSingleDelegate
>
@property (nonatomic, strong) UIButton     *addImageBtn;
@property (nonatomic, strong) UIView       *showImageView;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic,   copy) NSString     *imageURL;
@property (nonatomic, strong) UIButton     *scanBtn;
@property (nonatomic, strong) UILabel      *topTitleLabel;

/// 标题
@property (nonatomic, strong) UITextField  *titleTextField;
/// 选择类别
@property (nonatomic, strong) UITextField  *cagetoryTextField;
/// 宝贝价格
@property (nonatomic, strong) UITextField  *goodsPriceTextField;
/// 闪购数量
@property (nonatomic, strong) UITextField  *countTextField;
/// 材料费
@property (nonatomic, strong) UITextField  *materialsPrice;
/// 手工费
@property (nonatomic, strong) UITextField  *dealPrice;
/// 合计
@property (nonatomic, strong) UITextField  *allPrice;

@property (nonatomic, strong) NSArray      *pickerDataArray;
@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSDictionary *selectedCate;
@property (nonatomic, strong) NSArray      *orderTypesArray;
@end

@implementation JHFlashSendOrderInputView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)makeUI {
    [self.backView addSubview:self.topTitleLabel];
    [self.backView addSubview:self.addImageBtn];
    if (self.flashStyle == JHFlashSendOrderStyle_ProcessOrder) {
        self.topTitleLabel.text = @"闪购加工单";
    } else if (self.flashStyle == JHFlashSendOrderStyle_WelfareOrder) {
        self.topTitleLabel.text = @"闪购福利单";
    } else {
        self.topTitleLabel.text = @"闪购常规单";
    }
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(@270);
    }];
    NSMutableArray *titles = @[@"商品标题",@"选择类别",@"闪购数量",@"宝贝价格"].mutableCopy;
    if (self.flashStyle == JHFlashSendOrderStyle_ProcessOrder) {
        [titles addObject:@"材料费  "];
        [titles addObject:@"手工费  "];
        [titles addObject:@"合计    "];
    }
    NSArray *place = @[@"请填写商品标题，30字以内",@"请选择宝贝类别",@"请输入整数",@"请输入价格",@"请输入价格",@"请输入价格"];
    for (int i = 0; i<titles.count; i++) {
        JHTitleTextItemView *view = [[JHTitleTextItemView alloc] initWithTitle:titles[i] textPlace:place[i] isEdit:YES isShowLine:YES];
        if (i == 6) {
            self.allPrice = view.textField;
            view.textField.enabled = NO;
            view.line.hidden = YES;
            view.textField.textColor = HEXCOLOR(0xF23730);
            view.textField.font = [UIFont fontWithName:kFontNormal size:13];
            view.textField.text = @"¥0";
        }
        
        view.textField.font = [UIFont fontWithName:kFontNormal size:13];
        [view.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        view.textField.delegate = self;
        [self.backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addImageBtn.mas_bottom).offset(10+35*i);
            make.leading.trailing.equalTo(self.backView);
            make.height.offset(35);
        }];
        if (i != 0) {
            view.textField.keyboardType = UIKeyboardTypeDecimalPad;
        } else {
            view.textField.keyboardType = UIKeyboardTypeDefault;
        }
        if (i == 0) {
            self.titleTextField = view.textField;
        } else if (i == 1){
            self.cagetoryTextField = view.textField;
            view.textField.enabled = NO;
            UIButton *scan = [UIButton buttonWithType:UIButtonTypeCustom];
            [scan setImage:[UIImage imageNamed:@"icon_cell_arrow"] forState:UIControlStateNormal];
            scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            self.scanBtn = scan;
            [scan addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:scan];
            [scan mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.equalTo(view.textField);
                make.trailing.equalTo(view.textField).offset(-10);
            }];
        } else if (i == 2){
            self.countTextField = view.textField;
        } else if (i == 3) {
            self.goodsPriceTextField = view.textField;
        } else if (i == 4) {
            self.materialsPrice = view.textField;
        } else if (i == 5) {
            self.dealPrice = view.textField;
        }
    }
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.top.leading.trailing.equalTo(self.backView);
    }];

    [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.backView);
        make.height.equalTo(@178);
        make.width.equalTo(@160);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickSendOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
    btn.backgroundColor = kColorMain;
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [self.backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImageBtn.mas_bottom).offset(10+35.f*titles.count);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(40);
        make.bottom.offset(-12.f);
    }];
}


- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.font = [UIFont fontWithName:kFontNormal size:16];
        _topTitleLabel.textColor = HEXCOLOR(0x333333);
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitleLabel;
}

- (UIButton *)addImageBtn {
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setBackgroundImage:[UIImage imageNamed:@"bg_add_pic"] forState:UIControlStateNormal];
        _addImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_addImageBtn addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
        _addImageBtn.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _addImageBtn;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}

- (UIView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _showImageView.backgroundColor = [UIColor blackColor];
        UIImageView *image = [[UIImageView alloc] initWithFrame:_showImageView.bounds];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        self.imageView = image;
        [_showImageView addSubview:image];
        CGFloat ww = (ScreenW-100)/2.;
        NSArray *titles = @[@"icon_pic_cancel", @"icon_pic_ok"];
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ww*i+50, ScreenH-90, ww, 70);
            [btn setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(actionSelecte:) forControlEvents:UIControlEventTouchUpInside];
            [_showImageView addSubview:btn];
        }
    }
    return _showImageView;
}

- (void)actionSelecte:(UIButton *)btn{
    if (btn.tag == 0) {
        [self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"bg_add_pic"] forState:UIControlStateNormal];
        self.imageView.image = nil;
    } else {
        [self.addImageBtn setBackgroundImage:self.imageView.image forState:UIControlStateNormal];
        [self uploadImage:self.imageView.image];
    }
    [self.showImageView removeFromSuperview];
}

#pragma mark -
- (void)changedTextField:(UITextField *)textField {
    if (self.allPrice) {
        double allPrice = [self.goodsPriceTextField.text doubleValue]+[self.materialsPrice.text doubleValue]+[self.dealPrice.text doubleValue];
        self.allPrice.text = [NSString stringWithFormat:@"¥%.2f",allPrice];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(NO)];
    return YES;
}

//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (textField == self.titleTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.titleTextField.text.length >= 30) {
            self.titleTextField.text = [textField.text substringToIndex:30];
            return NO;
        }
        return YES;
    }
    //新输入的
    if (string.length == 0) {
        return YES;
    }
    
    //第一个参数，被替换字符串的range
    //第二个参数，即将键入或者粘贴的string
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";

    if (![string isEqualToString:@""]) {
           NSCharacterSet *cs;
           if ([textField isEqual:self.goodsPriceTextField] || [textField isEqual:self.materialsPrice] || [textField isEqual:self.dealPrice]) {
               // 小数点在字符串中的位置 第一个数字从0位置开始
               NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
               // 判断字符串中是否有小数点，并且小数点不在第一位
               // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
               // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
               if (dotLocation == NSNotFound && range.location != 0) {
                   // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                   /*
                    [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                    在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                    */
                   cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                   if (range.location >= 8) {
                       NSLog(@"单笔金额不能超过亿位");
                       if ([string isEqualToString:@"."] && range.location == 8) {
                           return YES;
                       }
                       return NO;
                   }
               } else {
                   cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
               }
               // 按cs分离出数组,数组按@""分离出字符串
               NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
               BOOL basicTest = [string isEqualToString:filtered];
               if (!basicTest) {
                   NSLog(@"只能输入数字和小数点");
                   return NO;
               }
               if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                   NSLog(@"小数点后最多两位");
                   return NO;
               }
               if (textField.text.length > 11) {
                   return NO;
               }
           } else if ([textField isEqual:self.countTextField]) { /// 数量
               if ([string isEqualToString:@"."]) {
                   return NO;
               }
               if (range.location >= 8) {
                   return NO;
               }
               return YES;
           }
       }
    
    //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL)isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (void)selectedImage:(UIButton *)sender {
    if (self.clickImage) {
        self.clickImage(self);
    }
}

- (void)closeAction:(UIButton *)btn {
    if (self.clickClose) {
        self.clickClose(self);
    }
    [super closeAction:btn];
}

- (void)showAlert {
    [self makeUI];
    [self getCateAll];
    [super showAlert];
}

- (void)showPicker:(UIButton *)btn {
    [self endEditing:YES];
    [self.picker show];
}

- (void)getCateAll {
    if ([UserInfoRequestManager sharedInstance].feidanPickerDataArray) {
        self.pickerDataArray = [UserInfoRequestManager sharedInstance].feidanPickerDataArray;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in self.pickerDataArray) {
            [array addObject:dic[@"name"]];
        }
        self.picker.arrayData = array;
        return;
    }
    [[UserInfoRequestManager sharedInstance] getNewFlyOrder_successBlock:^(RequestModel * _Nullable respondObject) {
       self.pickerDataArray = respondObject.data;
       NSMutableArray *array = [NSMutableArray array];
       for (NSDictionary *dic in self.pickerDataArray) {
           [array addObject:dic[@"name"]];
       }
       self.picker.arrayData = array;
       [UserInfoRequestManager sharedInstance].feidanPickerDataArray = respondObject.data;
    } failureBlock:^(RequestModel * _Nullable respondObject) {}];
}

#pragma mark -
- (void)showImageViewAction:(UIImage *)image {
    [self.superview addSubview:self.showImageView];
    self.imageView.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.backView) {
        CGPoint point = [touches.anyObject locationInView:self];
        if (CGRectContainsPoint(self.backView.frame, point)) {
            return;
        }
    }
    [self.viewController touchesBegan:touches withEvent:event];
}

#pragma mark - picker
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    NSInteger index = pickerSingle.selectedIndex;
    if (self.pickerDataArray && self.pickerDataArray.count>index) {
        self.selectedCate = self.pickerDataArray[index];
        self.cagetoryTextField.text = self.selectedCate[@"name"];
    }
}


#pragma mark -
-(void)uploadImage:(UIImage *)image {
    NOSFormData * data = [[NOSFormData alloc]init];
    data.fileImage = image;
    data.fileDir = @"goods";
    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageURL = respondObject.data;
            [SVProgressHUD dismiss];
            [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            if (self.auctionUploadFinish) {
                self.auctionUploadFinish(respondObject.data);
            }
        });
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    [SVProgressHUD show];
}


- (void)clickSendOrder:(UIButton *)btn {
    [self endEditing:YES];
    if (isEmpty(self.titleTextField.text)) {
        [self makeToast:@"请输入商品标题" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!self.imageURL) {
        [self makeToast:@"请上传图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!self.selectedCate) {
        [self makeToast:@"请选择宝贝类别" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!self.countTextField.text || self.countTextField.text.length == 0) {
        [self makeToast:@"请输入闪购数量" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!self.goodsPriceTextField.text || self.goodsPriceTextField.text.length == 0) {
        [self makeToast:@"请输入商品价格" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.countTextField.text isEqualToString:@"0"]) {
        [self makeToast:@"闪购数量需大于0" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.flashStyle == JHFlashSendOrderStyle_ProcessOrder) {
        if (!self.materialsPrice.text || self.materialsPrice.text.length == 0) {
            [self makeToast:@"请输入材料费" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        
        if (!self.dealPrice.text || self.dealPrice.text.length == 0) {
            [self makeToast:@"请输入手工费" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    
    JHFlashSendOrderRequestModel *model = [[JHFlashSendOrderRequestModel alloc] init];
    model.productTitle                  = self.titleTextField.text;
    model.anchorId                      = self.anchorId;
    model.productImg                    = self.imageURL;
    model.anewSecondCategoryId          = self.selectedCate[@"newGoodsCateId"];
    model.oldSecondCategoryId           = self.selectedCate[@"id"];
    model.price                         = self.goodsPriceTextField.text;
    model.materialCost                  = self.materialsPrice.text;
    model.manualCost                    = self.dealPrice.text;
    model.store                         = self.countTextField.text;
    if (self.flashStyle == JHFlashSendOrderStyle_NormalOrder) {
        model.productType = @"normal"; /// 常规单
    } else if (self.flashStyle == JHFlashSendOrderStyle_ProcessOrder) {
        model.productType = @"processingOrder"; /// 加工单
    } else if (self.flashStyle == JHFlashSendOrderStyle_WelfareOrder) {
        model.productType = @"giftOrder"; /// 福利单
    }
    [self requestDataWithModel:model];
}

- (void)requestDataWithModel:(JHFlashSendOrderRequestModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    [SVProgressHUD show];
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/flash/sales/publish") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        if (self.clickClose) {
            self.clickClose(self);
        }
        [self hiddenAlert];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}


@end
