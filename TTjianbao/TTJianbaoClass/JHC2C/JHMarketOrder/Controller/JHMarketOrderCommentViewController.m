//
//  JHMarketOrderCommentViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderCommentViewController.h"
#import "JHMarketImagesUpLoadView.h"
#import "MBProgressHUD.h"
#import "JHMarketOrderViewModel.h"
#import "UIView+JHGradient.h"
#import "IQKeyboardManager.h"
#import "NSString+AttributedString.h"

@interface JHMarketOrderCommentViewController ()<YYTextViewDelegate, UIScrollViewDelegate>
/** scrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 容器*/
@property (nonatomic, strong) UIView *containerView;
/** 购买心得*/
@property (nonatomic, strong) UIView *contentView;
/** label*/
@property (nonatomic, strong) UILabel *tagLabel;
/** 输入框*/
@property (nonatomic, strong) UIView *contentTextView;
/** 文本输入框*/
@property (nonatomic, strong) YYTextView *textView;
/** 文字字数*/
@property (nonatomic, strong) UILabel *textCountLabel;
/** 宝贝图片*/
@property (nonatomic, strong) UIView *pictureView;
/** label*/
@property (nonatomic, strong) UILabel *pictureTagLabel;
/** 上传图片*/
@property (nonatomic, strong) JHMarketImagesUpLoadView *uploadView;
/** 底图*/
@property (nonatomic, strong) UIView *bottomView;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *submitButton;

/** 记录输入框高度*/
@property (nonatomic, assign) CGFloat textViewHeight;
@end

@implementation JHMarketOrderCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:50];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] unregisterTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评论";
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.contentView];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView addSubview:self.textView];
    [self.contentTextView addSubview:self.textCountLabel];
    [self.containerView addSubview:self.pictureView];
    [self.pictureView addSubview:self.pictureTagLabel];
    [self.pictureView addSubview:self.uploadView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.submitButton];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 64);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView).offset(10);
        make.left.mas_equalTo(self.bottomView).offset(28);
        make.right.mas_equalTo(self.bottomView).offset(-28);
        make.height.mas_equalTo(44);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).offset(10);
        make.left.mas_equalTo(self.containerView).offset(10);
        make.right.mas_equalTo(self.containerView).offset(-10);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(12);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(14);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
    
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentTextView.mas_bottom).offset(-10);
        make.right.mas_equalTo(self.contentTextView.mas_right).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTextView).offset(10);
        make.left.mas_equalTo(self.contentTextView).offset(10);
        make.right.mas_equalTo(self.contentTextView).offset(-10);
        make.height.mas_greaterThanOrEqualTo(60);
        make.bottom.mas_equalTo(self.textCountLabel.mas_top).offset(-5);
    }];

    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.containerView).offset(10);
        make.right.mas_equalTo(self.containerView).offset(-10);
        make.bottom.mas_equalTo(self.containerView).offset(-50);
    }];
    
    [self.pictureTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureView).offset(12);
        make.left.mas_equalTo(self.pictureView).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pictureTagLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.pictureView).offset(2);
        make.right.mas_equalTo(self.pictureView);
        make.bottom.mas_equalTo(self.pictureView).offset(-12);
    }];
}

- (void)submitButtonClickAction {
    
    if (self.textView.text.length == 0) {
        JHTOAST(@"请填写购买心得");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    params[@"commentContent"] = self.textView.text;
    params[@"commentImgs"] = [self.uploadView.imagesArray mj_JSONString];
    [JHMarketOrderViewModel commentRequest:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            JHTOAST(@"发表成功");
            if (self.completeBlock) {
                self.completeBlock();
            }
            [self.navigationController  popViewControllerAnimated:YES];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
    
}


/// 监听键盘输入
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    self.textCountLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    CGFloat height = textView.textLayout.textBoundingSize.height;
    if (height < 60) {
        height = 60;
    }
    if (height != self.textViewHeight) {
        self.textViewHeight = height;
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentTextView).offset(10);
            make.left.mas_equalTo(self.contentTextView).offset(10);
            make.right.mas_equalTo(self.contentTextView).offset(-10);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(self.textCountLabel.mas_top).offset(-5);
        }];

    }
}


- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _bottomView;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_submitButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _submitButton.layer.cornerRadius = 22;
        _submitButton.clipsToBounds = YES;
        [_submitButton addTarget:self action:@selector(submitButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HEXCOLOR(0xf5f5f5);
    }
    return _containerView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _contentView;
}

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEXCOLOR(0x222222);
        _tagLabel.font = [UIFont fontWithName:kFontMedium size:15];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"* ", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:15]};
        itemsArray[1] = @{@"string":@"购买心得", @"color":HEXCOLOR(0x222222), @"font":[UIFont fontWithName:kFontBoldDIN size:15]};
        _tagLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _tagLabel;
}

- (UIView *)contentTextView {
    if (_contentTextView == nil) {
        _contentTextView = [[UIView alloc] init];
        _contentTextView.backgroundColor = HEXCOLOR(0xf9f9f9);
    }
    return _contentTextView;
}

- (YYTextView *)textView {
    if (_textView == nil) {
        _textView = [[YYTextView alloc] init];
        _textView.backgroundColor = HEXCOLOR(0xf9f9f9);
        _textView.textColor = HEXCOLOR(0x333333);
//        _textView.placeholderText = @"聊聊宝贝品相、尺寸容量、卖家服务等，您的评价能帮助到其他人";
        _textView.font = [UIFont fontWithName:kFontNormal size:12];
        _textView.delegate = self;
        _textView.scrollEnabled  = NO;
        NSString *placeStr = @"聊聊宝贝品相、尺寸容量、卖家服务等，您的评价能帮助到其他人";
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),
                                                                                                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12]
                                                                                   }];
        _textView.placeholderAttributedText = attstr;
    }
    return _textView;
}

- (UILabel *)textCountLabel {
    if (_textCountLabel == nil) {
        _textCountLabel = [[UILabel alloc] init];
        _textCountLabel.text = @"0/200";
        _textCountLabel.textColor = HEXCOLOR(0xbbbbbb);
        _textCountLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _textCountLabel;
}

- (UIView *)pictureView {
    if (_pictureView == nil) {
        _pictureView = [[UIView alloc] init];
        _pictureView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _pictureView;
}

- (UILabel *)pictureTagLabel {
    if (_pictureTagLabel == nil) {
        _pictureTagLabel = [[UILabel alloc] init];
        _pictureTagLabel.text = @"宝贝图片";
        _pictureTagLabel.textColor = HEXCOLOR(0x222222);
        _pictureTagLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _pictureTagLabel;
}

- (JHMarketImagesUpLoadView *)uploadView {
    if (_uploadView == nil) {
        _uploadView = [[JHMarketImagesUpLoadView alloc] initWithMaxPhotos:6];
    }
    return _uploadView;
}



@end
