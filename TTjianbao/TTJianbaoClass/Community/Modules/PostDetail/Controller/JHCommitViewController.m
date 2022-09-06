//
//  JHCommitViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/9/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommitViewController.h"
#import "UIView+CornerRadius.h"
#import "UIView+JHGradient.h"
#import "JHSQApiManager.h"
#import "JHSQModel.h"

@interface JHCommitViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *palceholderLabel;

@end

@implementation JHCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLORA(0x000000, .4f);
    [self configUI];
    
    
}

- (void)configUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = kColorFFF;
    [self.view addSubview:backView];
    _whiteBackView = backView;
        
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.backgroundColor = HEXCOLOR(0xF9FAF9);
    textView.textColor = kColor333;
    textView.font = [UIFont fontWithName:kFontNormal size:15.f];
    textView.delegate = self;
    textView.layer.cornerRadius = 8.f;
    textView.layer.masksToBounds = YES;
    [_whiteBackView addSubview:textView];
    _inputTextView = textView;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请填写封禁理由";
    label.font = [UIFont fontWithName:kFontNormal size:15.f];
    label.textColor = kColor999;
    [_inputTextView addSubview:label];
    _palceholderLabel = label;
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = kColorEEE;
    [commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:kColor999 forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    commitBtn.layer.cornerRadius = 22.f;
    commitBtn.layer.masksToBounds = YES;
    [_whiteBackView addSubview:commitBtn];
    [commitBtn addTarget:self action:@selector(__handleCommitEvent) forControlEvents:UIControlEventTouchUpInside];
    _commitButton = commitBtn;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColorF5F6FA;
    [_whiteBackView addSubview:lineView];
    _lineView = lineView;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColor666 forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:18];
    [_whiteBackView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(__handleCancelEvent) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelBtn;
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo([JHCommitViewController viewHeight]);
    }];
    
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.whiteBackView).offset(15);
        make.trailing.equalTo(self.whiteBackView).offset(-15);
        make.height.mas_equalTo(137);
    }];
    
    [_palceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.inputTextView).offset(10);
        make.right.equalTo(self.whiteBackView).offset(-10);
    }];
    
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextView.mas_bottom).offset(15);
        make.leading.equalTo(self.whiteBackView).offset(28);
        make.trailing.equalTo(self.whiteBackView).offset(-28);
        make.height.mas_equalTo(44);
    }];
   
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitButton.mas_bottom).offset(20);
        make.leading.trailing.equalTo(self.whiteBackView);
        make.height.mas_equalTo(1);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.trailing.equalTo(self.whiteBackView);
        make.bottom.equalTo(self.whiteBackView).offset(-UI.bottomSafeAreaHeight);
    }];
    
    [self.view layoutIfNeeded];
    [self.whiteBackView yd_setCornerRadius:12.f corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self.inputTextView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
}

- (void)__handleCommitEvent {
    if (self.inputTextView.text.length == 0) {
        return;
    }
    
    NSInteger itemType = self.commentModel.parent_id > 0 ? 3 : 2;
    @weakify(self);
    [JHSQApiManager banRequest:self.commentModel.comment_id itemType:itemType userId:self.commentModel.publisher.user_id reasonId:self.inputTextView.text block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [UITipView showTipStr:@"封号成功"];
        [self __handleCancelEvent];
    }];
}

- (void)__handleCancelEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.palceholderLabel.hidden = textView.text.length > 0;
    self.commitButton.enabled = textView.text.length > 0;
    NSArray *colors = nil;
    UIColor *titleColor = nil;
    if (textView.text.length > 0) {
        colors = @[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)];
        titleColor = kColor333;
    }
    else {
        colors = @[kColorEEE, kColorEEE];
        titleColor = kColor999;
    }
    
    [self.commitButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.commitButton jh_setGradientBackgroundWithColors:colors locations:@[@0, @.5, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 0)];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

+ (CGFloat)viewHeight {
    return 277 + UI.bottomSafeAreaHeight;
}

@end
