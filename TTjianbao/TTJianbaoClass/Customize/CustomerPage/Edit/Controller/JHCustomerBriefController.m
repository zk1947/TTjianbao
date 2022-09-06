//
//  JHCustomerBriefController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomInfoModel.h"
#import "JHCustomerBriefController.h"
#import "CommAlertView.h"
#import "IQKeyboardManager.h"

@interface JHCustomerBriefController ()

/// 输入框
@property (nonatomic, weak) UITextView *textView;

@end

@implementation JHCustomerBriefController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.isRecycle boolValue]) {
        self.title = @"编辑回收师介绍";
    } else {
        self.title = @"编辑定制师介绍";
    }
    [self jhNavBottomLine];
    [self initRightButtonWithName:@"保存" action:@selector(rightActionButton:)];
    [self textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)rightActionButton:(UIButton *)sender {
    NSString *text = @"";
    if([self.textView hasText]) {
        text = self.textView.text;
    }
    
    [self.view endEditing:YES];
    @weakify(self);
    JHLiveRoomInfoCustomizeAddReqModel* info = [JHLiveRoomInfoCustomizeAddReqModel new];
    info.channelLocalId = self.channelLocalId;
    info.introduction = self.textView.text;
    [JH_REQUEST asynPost:info success:^(id respData) {
        @strongify(self);
        if(self.callbackMethod) {
            self.callbackMethod();
        }
        JHTOAST(@"保存成功");
        [self popToLast];
    } failure:^(NSString *errorMsg) {
        JHTOAST(errorMsg);
    }];
}

- (void)popToLast {
    if ([self.vcName isNotBlank]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[NSClassFromString(self.vcName) class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITextView *)textView {
    if(!_textView) {
        
        UILabel *titleLabel      = [[UILabel alloc] init];
        titleLabel.textColor     = HEXCOLOR(0x333333);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font          = [UIFont fontWithName:kFontMedium size:18.f];
        titleLabel.text          = @"个人介绍";
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15.f);
            make.right.equalTo(self.view.mas_right).offset(-15.f);
            make.top.equalTo(self.jhNavView.mas_bottom).offset(20.f);
            make.height.mas_equalTo(25.f);
        }];
        
        
        UILabel *placeholderLabel = [UILabel jh_labelWithText:@"请输入个人介绍" font:15 textColor:HEXCOLOR(0x999999) textAlignment:0 addToSuperView:self.view];
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
        }];
        
        UITextView *textView = [UITextView new];
        textView.textColor = RGB515151;
        textView.font = JHFont(15);
        textView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:textView];
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView = textView;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(9);
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.right.equalTo(self.view).offset(-7);
            make.bottom.equalTo(self.view);
        }];
        
        [_textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            placeholderLabel.hidden = (x.length > 0);
            if(x.length > 300){
                UITextRange *selectedRange = [self.textView markedTextRange];
                if (!selectedRange) {
                    x = [x substringToIndex:300];
                    textView.text = x;
                    JHTOAST(@"最多输入300个字");
                }
            }
        }];
        if(self.text && self.text.length > 0)  {
            _textView.text = self.text;
            placeholderLabel.hidden = YES;
        }
        
    }
    return _textView;
}

-(void)backActionButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    if([self.textView hasText] && IS_STRING(self.text) && ![self.text isEqualToString:self.textView.text]) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"确认返回后，编辑的内容不会被保存" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        [self.view addSubview:alert];
        @weakify(self);
        alert.handle = ^{
            @strongify(self);
            [self popToLast];
//            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    else
    {
        [self popToLast];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
