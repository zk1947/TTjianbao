//
//  JHRoomSendOrderView.m
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHRoomSendOrderView.h"
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


#define NumbersWithDot     @"0123456789.\n"
#define NumbersWithoutDot  @"0123456789\n"

@interface JHRoomSendOrderView ()<UITextFieldDelegate, STPickerSingleDelegate>

@property (strong, nonatomic) UIButton     *addImageBtn;
@property (strong, nonatomic) UIView       *showImageView;
@property (strong, nonatomic) UIImageView  *imageView;
@property (copy,   nonatomic) NSString     *imageURL;
@property (strong, nonatomic) UITextField  *cardId;
@property (strong, nonatomic) UIButton     *scanBtn;
@property (strong, nonatomic) UILabel      *topTitleLabel;
@property (strong, nonatomic) UITextField  *goodsPrice;
@property (strong, nonatomic) UITextField  *materPrice;
@property (strong, nonatomic) UITextField  *dealPrice;
@property (strong, nonatomic) UITextField  *allPrice;
@property (nonatomic, strong) NSArray      *pickerDataArray;
@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSDictionary *selectedCate;
@property (strong, nonatomic) NSArray      *orderTypesArray;
@property (strong, nonatomic) UIView       *chooseCustomizeView;
@property (assign, nonatomic) BOOL          isCustomize;
@end

@implementation JHRoomSendOrderView
- (void)dealloc {
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCustomize = NO;
        _isCustomizePackage = NO;
    }
    return self;
}

- (void)makeUI {
    [self.backView addSubview:self.topTitleLabel];
    [self.backView addSubview:self.addImageBtn];
    self.topTitleLabel.text = self.orderCategory.name;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
        make.width.equalTo(@230);
    }];
    NSMutableArray *titles = @[@"选择类别",@"宝贝价格"].mutableCopy; //@"宝卡号",
    
    if ([self.orderCategory.Id isEqualToString:JHOrderCategoryHandling]) {
        [titles addObject:@"材料费"];
        [titles addObject:@"手工费"];
        [titles addObject:@"合计"];
    }
    
    NSArray *place = @[@"请选择宝贝类别",@"¥请输入价格",@"¥请输入价格",@"¥请输入价格",@"¥请输入价格"];//@"宝卡号",
    
    for (int i = 0; i<titles.count; i++) {
        JHTitleTextItemView *view = [[JHTitleTextItemView alloc] initWithTitle:titles[i] textPlace:place[i] isEdit:YES isShowLine:YES];
        
        if (i == 4) {
            view.textField.enabled = NO;
            view.line.hidden = YES;
            view.textField.textColor = HEXCOLOR(0xFF4200);
            view.textField.font = [UIFont fontWithName:kFontBoldDIN size:15];
            view.textField.text = @"¥0";
            
        }
        [view.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
        view.textField.keyboardType = UIKeyboardTypeDecimalPad;
        view.textField.delegate = self;
        [self.backView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addImageBtn.mas_bottom).offset(10+35*i);
            make.leading.trailing.equalTo(self.backView);
            make.height.offset(35);
        }];
        
        if (i == 0) {
            self.cardId = view.textField;
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
        }else if (i == 1){
            self.goodsPrice = view.textField;
        }else if (i == 2){
            self.materPrice = view.textField;
        }else if (i == 3) {
            self.dealPrice = view.textField;
        }else if (i == 4) {
            self.allPrice = view.textField;
        }
        
    }
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(40);
        make.top.leading.trailing.equalTo(self.backView);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.height.equalTo(@1);
        make.top.equalTo(self.topTitleLabel.mas_bottom);
    }];
    
    [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(15);
        make.centerX.equalTo(self.backView);
        make.height.equalTo(@178);
        make.width.equalTo(@160);
    }];
    
    //是否关联定制view
    _chooseCustomizeView = [[UIView alloc]init];
    [self.backView addSubview:_chooseCustomizeView];
    [_chooseCustomizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImageBtn.mas_bottom).offset(10+35*titles.count);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(0);
    }];

    
    NSString *btnTitle = @"发送订单";
    
    //常规单有关联定制选项
    if ([self.orderCategory.Id isEqualToString:JHOrderCategoryNorm] && self.isCustomizeSelf) {
        [_chooseCustomizeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addImageBtn.mas_bottom).offset(10+35*titles.count+10);
            make.height.offset(40);
        }];
        [self initChooseCustomizeSubviews];
    }
    else if (self.isCustomizePackage) {
        /// 定制套餐
        btnTitle = @"下一步";
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([btnTitle isEqualToString:@"下一步"]) {
        [btn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [btn addTarget:self action:@selector(clickSendOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    btn.backgroundColor = kColorMain;
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chooseCustomizeView.mas_bottom).offset(10);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(40);
        make.bottom.offset(-20);
    }];
    
}

-(void)initChooseCustomizeSubviews{
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"是否关联定制:";
    [_chooseCustomizeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_chooseCustomizeView).offset(0);
        make.leading.offset(10);
    }];
    
    UIButton *tipButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton setBackgroundImage:[UIImage imageNamed:@"customize_payinfo_icon"] forState:UIControlStateNormal];//
    [tipButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
   // button.backgroundColor = [UIColor redColor];
    tipButton.contentMode = UIViewContentModeScaleToFill;
    [_chooseCustomizeView addSubview:tipButton];
    [tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(5);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    
    NSArray *arr = @[@"是",@"否"];
    UIButton * lastView;
    for (int i=0; i<[arr count]; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"customizeagreeBtn_NO"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"customizeagreeBtn_YES"] forState:UIControlStateSelected];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(chooseCustomizeClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [_chooseCustomizeView addSubview:button];
        button.selected=NO;
        self.isCustomize = NO;
        if (i == 1) {
            button.selected=YES;
        }
        UILabel  *desc=[[UILabel alloc]init];
        desc.text=arr[i];
        desc.font=[UIFont systemFontOfSize:15];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=kColor333;
        [_chooseCustomizeView addSubview:desc];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_right).offset(5);
            make.centerY.equalTo(button);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.equalTo(tipButton.mas_right).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(30);
            }
            make.centerY.equalTo(_chooseCustomizeView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        lastView= button;
    }
}

-(void)chooseCustomizeClick:(UIButton*)button{
    
    for (UIView *subView in self.chooseCustomizeView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            btn.selected=NO;
        }
    }
       button.selected = YES;
      self.isCustomize = button.tag == 100?YES:NO;
    
}
-(void)btnAction:(UIButton*)button{
    
    JHCommBubbleTipView * bubble = [[JHCommBubbleTipView alloc ]init];
    [bubble creatSendOrderBubble];
    [JHKeyWindow addSubview:bubble];
    [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_top).offset(-5);
        make.left.equalTo(button).offset(-35);
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
        
//        [self scanCardIdWithImage:self.imageView.image];
        [self uploadImage:self.imageView.image];
    }
    [self.showImageView removeFromSuperview];
    
}



#pragma mark -
- (void)changedTextField:(UITextField *)textField {
    if (self.allPrice) {
        double allPrice = [self.goodsPrice.text doubleValue]+[self.materPrice.text doubleValue]+[self.dealPrice.text doubleValue];
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
           if ([textField isEqual:self.goodsPrice]) {
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
           }
       }
    
    //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

#pragma mark -
-(void)uploadImage:(UIImage *)image{
    
    NOSFormData * data = [[NOSFormData alloc]init];
    data.fileImage = image;
    if (self.isAnction) {
        data.fileDir = @"auction_img";
        
    }else {
        data.fileDir = @"goods";
        
    }
    
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

- (void)scanCardIdWithImage:(UIImage *)image {
    __weak __typeof(self) weakSelf = self;
    self.cardId.text = @"";
    [LBXZBarWrapper recognizeImage:image block:^(NSArray<LBXZbarResult *> *result) {
        if (result.count<1){
            [SVProgressHUD showErrorWithStatus:@"识别宝卡号失败 可以尝试重新拍照"];
        } else {
            weakSelf.cardId.enabled = NO;
            LBXZbarResult *firstObj = result[0];
            weakSelf.cardId.text = firstObj.strScanned;
        }
    }];
}


- (void)scanCardAction:(id)sender {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描宝卡";
    JH_WEAK(self)
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController * _Nonnull obj) {
        JH_STRONG(self)
        self.cardId.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
}


- (void)selectedImage:(UIButton *)sender {
    if (self.clickImage) {
        self.clickImage(self);
    }
}

- (void)nextAction:(UIButton *)sender {
    [self endEditing:YES];
    if (!self.imageURL) {
        [self makeToast:@"请上传图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!self.selectedCate) {
        [self makeToast:@"请选择宝贝类别" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!self.goodsPrice.text || self.goodsPrice.text.length == 0) {
        [self makeToast:@"请输入宝贝价格" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    JHSendOrderModel *model = [JHSendOrderModel new];
    model.anchorId = self.anchorId;
    model.orderCategory = self.orderCategory.Id;
    if (self.allPrice) {
        NSString *price = [self.allPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        model.orderPrice = price;
        model.goodsPrice = self.goodsPrice.text;
        model.materialCost = self.materPrice.text;
        model.manualCost = self.dealPrice.text;
        
    } else {
        model.orderPrice = self.goodsPrice.text;
    }
    model.goodsImg = self.imageURL;
    model.barCode = @"";
    
//    model.inputManual = @"2";
    model.viewerId = self.customerId;
    model.biddingId = self.biddingId;
    model.goodsCateId = self.selectedCate[@"id"];
    model.anewGoodsCateId = self.selectedCate[@"newGoodsCateId"];
    if ([self.orderCategory.Id isEqualToString:JHOrderCategoryNorm]){
        model.customizeType = self.isCustomize?@"1":@"0";
    }
    if (self.nextBlock) {
        self.nextBlock(model);
    }
}


- (void)clickSendOrder:(UIButton *)btn {
    [self endEditing:YES];
    if (!self.imageURL) {
        [self makeToast:@"请上传图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (!self.selectedCate) {
        [self makeToast:@"请选择宝贝类别" duration:1.0 position:CSToastPositionCenter];

        return;
    }
    
    if (!self.goodsPrice.text || self.goodsPrice.text.length == 0) {
        [self makeToast:@"请输入宝贝价格" duration:1.0 position:CSToastPositionCenter];

        return;
    }
    
    JHSendOrderModel *model = [JHSendOrderModel new];
    model.anchorId = self.anchorId;
//    if ([self.orderCategory.Id isEqualToString:@"normalCustomizeGroup"]) {
//        model.orderCategory = @"normal";
//    } else {
        model.orderCategory = self.orderCategory.Id;
//    }
    if (self.allPrice) {
        NSString *price = [self.allPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        model.orderPrice = price;
        model.goodsPrice = self.goodsPrice.text;
        model.materialCost = self.materPrice.text;
        model.manualCost = self.dealPrice.text;
        
    }else {
        model.orderPrice = self.goodsPrice.text;
    }
    model.goodsImg = self.imageURL;
    model.barCode = @"";
    
//    model.inputManual = @"2";
    model.viewerId = self.customerId;
    model.biddingId = self.biddingId;
    model.goodsCateId = self.selectedCate[@"id"];
    model.anewGoodsCateId = self.selectedCate[@"newGoodsCateId"];
    
    if ([self.orderCategory.Id isEqualToString:JHOrderCategoryNorm]){
        model.customizeType = self.isCustomize?@"1":@"0";
    }
    [self requestDataWithModel:model];
}


- (NSDictionary *)getCagetoryInfo {
    return self.selectedCate;
}

- (NSString *)getImageUrl {
    return self.imageURL;
}


- (void)closeAction:(UIButton *)btn {
    if (self.isCustomizePackage) {
        if (!self.imageURL && !self.selectedCate && self.goodsPrice.text.length == 0) {
            [super closeAction:btn];
            return;
        }
        CommAlertView *alertView = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"关闭后，编辑的内容不会被保存，请您确认操作" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [self addSubview:alertView];
        alertView.handle = ^{
            if (self.closeBlock) {
                self.closeBlock();
            }
            [super closeAction:btn];
        };
    } else {
        [super closeAction:btn];
    }
}

- (void)showAlert {
    
    
    [self makeUI];
    [self getCateAll];
//    if ([self.anchorId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
//        self.scanBtn.hidden = YES;
//    }else {
//        self.scanBtn.hidden = NO;
//    }
    [super showAlert];
    
}

- (void)requestDataWithModel:(JHSendOrderModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (model.biddingId) {
            [self requestBiddingAndOrder:respondObject.data[@"orderId"] biddingId:model.biddingId];
        }else {
            [SVProgressHUD dismiss];

            [SVProgressHUD showSuccessWithStatus:@"发送成功"];

            [self hiddenAlert];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (void)requestBiddingAndOrder:(NSString *)orderId biddingId:(NSString *) biddingId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"biddingId"] = biddingId;
    dic[@"orderId"] = orderId;
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/bidding/biddingAndOrder/auth") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self hiddenAlert];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];

        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
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

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }

    if (pickerSingle.tag == 1833) {//选择订单类型picker
        NSInteger index = pickerSingle.selectedIndex;
        if (self.orderTypesArray && self.orderTypesArray.count>index) {
            self.orderCategory = self.orderTypesArray[index];
            if ([self.orderCategory.Id isEqualToString:JHOrderCategoryHandlingService]) {//加工服务单
                if (self.addSelfToView) {
                    self.addSelfToView(self);
                }
                self.hidden = YES;
                JHSendOrderProccessGoodView *view = [[JHSendOrderProccessGoodView alloc] init];
                [self.superview addSubview:view];
                [view requestProccessGoodsBuyId:self.customerId isAssistant:0];

            }else {
                if (self.addSelfToView) {
                    self.addSelfToView(self);
                }
                [self showAlert];
            }
            
        }
    }else {
        NSInteger index = pickerSingle.selectedIndex;
        if (self.pickerDataArray && self.pickerDataArray.count>index) {
            self.selectedCate = self.pickerDataArray[index];
            self.cardId.text = self.selectedCate[@"name"];
        }
    }
    
}

- (void)showPicker:(UIButton *)btn {
    [self endEditing:YES];
    [self.picker show];
}

//竞拍创建订单 先弹出选择订单类型pick
- (void)showOrderTypePicker:(NSArray *)orderTypes {
    self.orderTypesArray = orderTypes;
    NSMutableArray *array = [NSMutableArray array];
    for (OrderTypeModel *model in orderTypes) {
        [array addObject:model.name];
    }
    
    JHPickerView *picker = [[JHPickerView alloc] init];
    picker.widthPickerComponent = 300;
    picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    [picker setDelegate:self];
    picker.arrayData = array;
    picker.tag = 1833;
    [picker show];
}


@end
