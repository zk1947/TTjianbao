//
//  JHOperationBanView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOperationBanView.h"
#import "CommHelp.h"
#import <IQKeyboardManager.h>
#import "UIView+Toast.h"
#import "TTjianbaoMarcoUI.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
@interface JHOperationBanView ()<UITextViewDelegate>{
    UILabel*  titleTip;
    CGFloat maxCount; //最大输入字数
    UITextView * noteTextview;
    UIView *showview ;
    UIButton *sureBtn;
}
@end
@implementation JHOperationBanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        maxCount = 200;
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [[IQKeyboardManager sharedManager] setEnable:NO];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self setupViews];
        
    }
    return self;
}
-(void)setupViews{
    
    showview =  [[UIView alloc]init];
    showview.backgroundColor= [UIColor whiteColor];
    [self addSubview:showview];
    [showview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(311+UI.bottomSafeAreaHeight);
        
    }];
    [showview jh_cornerRadius:12 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight bounds:CGRectMake(0, 0, ScreenW, 311+UI.bottomSafeAreaHeight)];
    
    UIButton *cancleBtn=[[UIButton alloc]init];
    cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
    cancleBtn.titleLabel.font=[UIFont fontWithName:kFontMedium size:18];
    cancleBtn.layer.cornerRadius = 22;
    [cancleBtn setBackgroundColor:[CommHelp toUIColorByStr:@"ffffff"]];
    [cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [showview addSubview:cancleBtn];
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(showview.mas_bottom).offset(-5-UI.bottomSafeAreaHeight);
        make.left.offset(27);
        make.right.offset(-27);
        make.height.offset(44);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [showview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancleBtn.mas_top).offset(-5);
        make.height.equalTo(@.5);
        make.left.offset(0);
        make.right.offset(0);
        
    }];
    
    sureBtn=[[UIButton alloc]init];
    sureBtn.contentMode=UIViewContentModeScaleAspectFit;
    sureBtn.layer.cornerRadius = 22;
    [sureBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    sureBtn.titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
//    [sureBtn setBackgroundColor:[CommHelp toUIColorByStr:@"fee100"]];
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [showview addSubview:sureBtn];
    [sureBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:HEXCOLOR(0xEEEEEE)];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancleBtn.mas_top).offset(-20);
        make.left.offset(27);
        make.right.offset(-27);
        make.height.offset(44);
    }];
    
    
    noteTextview=[[UITextView alloc]init];
    noteTextview.backgroundColor=[CommHelp toUIColorByStr:@"F9FAF9"];
    noteTextview.font = JHFont(15);
    noteTextview.textColor = HEXCOLOR(0x333333);
    noteTextview.alpha=1.0;
    noteTextview.layer.borderColor = [CommHelp toUIColorByStr:@"#eeeeee"].CGColor;
    noteTextview.layer.cornerRadius = 8.0;
    noteTextview.layer.borderWidth = 0;
    noteTextview.delegate=self;
    noteTextview.autocorrectionType = UITextAutocorrectionTypeYes;
    noteTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteTextview.keyboardType = UIKeyboardTypeDefault;
  //  noteTextview.returnKeyType = UIReturnKeyDone;
    [showview addSubview:noteTextview];
    
    [noteTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(10);
        make.left.equalTo(showview).offset(15);
        make.right.equalTo(showview).offset(-15);
        make.bottom.equalTo(sureBtn.mas_top).offset(-15);
    }];
    
    titleTip=[[UILabel alloc]init];
    titleTip.text=@"请填写封禁理由";
    titleTip.font=[UIFont systemFontOfSize:15];
    titleTip.backgroundColor=[UIColor clearColor];
    titleTip.textColor=[CommHelp toUIColorByStr:@"#999999"];
    titleTip.numberOfLines = 1;
    titleTip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    titleTip.lineBreakMode = NSLineBreakByWordWrapping;
    [showview addSubview:titleTip];
    
    [titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextview).offset(7);
        make.left.equalTo(noteTextview).offset(5);
        make.width.equalTo(noteTextview);
    }];
    
    
}
-(void)sureClick:(UIButton *)sender{
    
    if ([noteTextview.text length]==0) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"请输入封禁理由" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    [self dismiss];
    if (self.completeBlock) {
        self.completeBlock(noteTextview.text);
    }
    
}
- (void)show
{
    showview.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        showview.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        showview.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark =============== delegate ===============
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
    //        [textView resignFirstResponder];
    //        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    //    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [titleTip setHidden:NO];
        [sureBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [sureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xEEEEEE), HEXCOLOR(0xEEEEEE)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }else{
        [titleTip setHidden:YES];
        [sureBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [sureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
    if (textView.text.length > maxCount){
        textView.text = [textView.text substringWithRange:NSMakeRange(0, maxCount)];
    }
}
#pragma mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat  keyBoardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        showview.bottom=self.bottom-keyBoardHeight;
    }];
}

#pragma mark 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        showview.bottom=self.bottom;
    }];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
