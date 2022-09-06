//
//  JHRecordRemarkViewController.m
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecordRemarkViewController.h"
#import "TTjianbaoMarcoKeyword.h"
#import "UIView+JHGradient.h"
#import "FileUtils.h"

#define contentMaxTextCount  300

@interface JHRecordRemarkViewController () <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITextView* contentTextView;
@end

@implementation JHRecordRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFFF;
    [self loadRemarkInfo];
    [self drawNavView];
    [self drawContentView];
}

- (void)loadRemarkInfo {
    if ([self.remark isNotBlank]) {
        self.contentTextView.text = self.remark;
    }
    else {
        NSData *data = [FileUtils readDataFromFile:kAppraisalRecordRemarkData];
        NSDictionary *dic = nil;
        if (data) {
          dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
            NSString *remark = [dic objectForKey:self.appraiseRecordId];
            if ([remark isNotBlank]) {
                self.contentTextView.text = remark;
                self.jhRightButton.enabled = YES;
            }
        }
    }
}

- (void)drawNavView {
    self.jhTitleLabel.text=@"鉴定备注";
    [self initRightButtonWithName:@"提交" action:@selector(rightActionButton:)];
    self.jhRightButton.layer.backgroundColor = HEXCOLOR(0xFFEF9F).CGColor;
    [self.jhRightButton setTitleColor:HEXCOLOR(0x111111) forState:UIControlStateNormal];
    [self.jhRightButton setTitleColor:HEXCOLOR(0x7A7353) forState:UIControlStateDisabled];
    self.jhRightButton.titleLabel.font = JHFont(13);
    [self.jhRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jhNavView).offset(-10);
        make.centerY.equalTo(self.jhTitleLabel);
        make.size.mas_equalTo(CGSizeMake(55., 24.));
    }];
    
    [self.jhRightButton layoutIfNeeded];
    self.jhRightButton.layer.cornerRadius = 5.f;
    self.jhRightButton.layer.masksToBounds = YES;
    [RACObserve(self.jhRightButton, enabled) subscribeNext:^(id  _Nullable x) {
        BOOL isEnable = [x boolValue];
        if (isEnable) {
            [self.jhRightButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFED73A), HEXCOLOR(0xFECB33)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
        }
        else {
            self.jhRightButton.layer.backgroundColor = HEXCOLOR(0xFFEF9F).CGColor;
        }
    }];
}

- (void)drawContentView {
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom).offset(6);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-9);
    }];
}

- (UITextView *)contentTextView {
    if(!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _contentTextView.font = JHFont(13);
        _contentTextView.delegate = self;
        _contentTextView.autocorrectionType = UITextAutocorrectionTypeYes;
        _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请填入备注内容，最多300字";
        placeHolderLabel.numberOfLines = 1;
        placeHolderLabel.textColor = HEXCOLOR(0x999999);
        [placeHolderLabel sizeToFit];
        placeHolderLabel.font = JHFont(13);
        [_contentTextView addSubview:placeHolderLabel];
        [_contentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _contentTextView;
}

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView {
    ///设置按钮状态
    self.jhRightButton.enabled = [self.contentTextView.text length] > 0;
    int maxNum = contentMaxTextCount;
    if (textView.text.length > maxNum) {
        textView.text = [textView.text substringToIndex:maxNum];
    }
}

- (void)toCommitRemark {
    @weakify(self);
    NSString *remark = self.contentTextView.text;
    NSString *url = FILE_BASE_STRING(@"/appraiseRecord/anchor/remark/video/record");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.appraiseRecordId forKey:@"appraiseRecordId"];
    [params setValue:remark forKey:@"remarkContent"];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:@"提交成功"];
        @strongify(self);
        if (self.backBlock) {
            self.backBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:[respondObject.message isNotBlank] ? respondObject.message : @"提交失败,请重试"];
    }];
}

#pragma mark - event

- (void)backActionButton:(UIButton *)sender {
    ////如果有输入文字 则需要将输入信息保存草稿 否则直接退出
    if (self.contentTextView.text.length > 0) {
        ///读取当前本地存储的备注草稿信息
        NSData *data = [FileUtils readDataFromFile:kAppraisalRecordRemarkData];
        NSDictionary *dic = nil;
        if (data) {
          dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        NSMutableDictionary *remarkInfo = [NSMutableDictionary dictionary];
        if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
            ///将备注信息和鉴定记录id绑定
            [remarkInfo addEntriesFromDictionary:dic];
        }
        [remarkInfo setValue:self.contentTextView.text forKey:self.appraiseRecordId];
        if ([FileUtils writeDataToFile:kAppraisalRecordRemarkData data:[NSJSONSerialization dataWithJSONObject:remarkInfo options:NSJSONWritingPrettyPrinted error:nil]]) {
            NSLog(@"写入成功");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightActionButton:(UIButton *)sender {
    [self toCommitRemark];
}

@end
