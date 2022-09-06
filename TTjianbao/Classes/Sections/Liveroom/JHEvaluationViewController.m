//
//  JHEvaluationViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHEvaluationViewController.h"
#import "JHAnchorInfoModel.h"
#import "NIMAvatarImageView.h"
#import <IQKeyboardManager.h>

@interface JHEvaluationViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UITextView *contentView;

@property (copy, nonatomic)  NSString *pass;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;

@property (weak, nonatomic) IBOutlet UIButton *noPassBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (strong, nonatomic) NSArray *tags;

@property (strong, nonatomic) NSMutableArray *selecteTags;

@property (strong, nonatomic) JHAnchorInfoModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end

@implementation JHEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView.delegate = self;
    _pass = @"pass";
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
    [self getTags];
    [self fetchAnchorInfo];
//    [self  initToolsBar];
    self.title = @"评价";
    [self initRightButtonWithImageName:@"login_close" action:@selector(backActionButton:)];
//    [self.navbar setTitle:@"评价"];
//    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"login_close"] withHImage:[UIImage imageNamed:@"login_close"] withFrame:CGRectMake(ScreenW-50,0,44,44)];
//    self.navbar.ImageView.backgroundColor = [UIColor clearColor];
//    
//    [self.navbar.comBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topHeight.constant = UI.statusAndNavBarHeight;
    if (ScreenW == 320.) {
        self.bottomHeight.constant = 30;
    }
}

- (void)viewWillLayoutSubviews {

}

- (void)backActionButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setModel:(JHAnchorInfoModel *)model {
    _model = model;
    if (model) {
        [_avatar nim_setImageWithURL:[NSURL URLWithString:model.appraiserImg] placeholderImage:kDefaultAvatarImage];
        _nickLabel.text = model.appraiserName;
        _postLabel.text = model.appraiserDesc;
        _countLabel.text = @(model.appraiseCount).stringValue;
        
        _rateLabel.text = [NSString stringWithFormat:@"%@%%",model.grade];
        
    }
}

- (NSMutableArray *)selecteTags {
    if (!_selecteTags) {
        _selecteTags = [NSMutableArray array];
    }
    return _selecteTags;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sadAction:(UIButton *)sender {
    sender.selected = YES;
    self.pass = @"not_pass";
    self.passBtn.selected = NO;
}

- (IBAction)smileAction:(UIButton *)sender {
    sender.selected = YES;
    self.pass = @"pass";
    self.noPassBtn.selected = NO;

}
- (IBAction)submitAction:(UIButton *)sender {

    if (!self.pass) {
        [self.view makeToast:@"请选择是否满意" duration:1.0 position:CSToastPositionCenter];

        return;
    }
    if (!_selecteTags || _selecteTags.count == 0) {
        [self.view makeToast:@"请选择标签" duration:1.0 position:CSToastPositionCenter];

        return;
    }
//    if (!_contentView.text || _contentView.text.length<=0) {
//        [self.view makeToast:@"请填写评价内容" duration:1.0 position:CSToastPositionCenter];
//
//        return;
//
//    }
    id tagstring = @"";
    if (self.selecteTags.count) {
        tagstring = [self.selecteTags mj_JSONString];
    }
    
    NSDictionary *dic = @{@"appraiseRecordId":self.appraiseId,@"commentTags":tagstring,@"commentContent":_contentView.text?:@"",@"isPass":self.pass};
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/auth/appraise/comment") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:@"   评价成功   "];

        if (self.finishBlock) {
            self.finishBlock(@"1");
        }

        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];

    }];

    
}

- (void)getTags {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/appraise/comment/tags") Parameters:nil successBlock:^(RequestModel *respondObject) {
        if ([respondObject.data isKindOfClass:[NSNull class]]) {
            return ;
        }
        self.tags = (NSArray *)respondObject.data;
        [self addTags];
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}


- (void)addTags {

    [self.view layoutIfNeeded];
    CGFloat ww = (self.tabView.mj_w-20)/3.;
    for (NSInteger i = 0; i<_tags.count; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_tab_label"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_tab_label_press"] forState:UIControlStateSelected];
       // btn.backgroundColor = HEXCOLOR(0xfee133);
        NSDictionary *dic = _tags[i];
        [btn setTitle:dic[@"tagName"] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake((ww+10)*(i%3), (10+25)*(int)(i/3), ww, 25);
        btn.tag = i;
        [btn addTarget:self action:@selector(tagAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabView addSubview:btn];
        
    }
    
    NSInteger n = ceil( _tags.count/3.);
    self.tagViewHeight.constant = n*25+(n-1)*10;
    
}

- (void)tagAction:(UIButton *)btn {
    if (!btn.selected) {
//        if (self.selecteTags.count>=3) {
//            [self.view makeToast:@"只能选择3个标签"];
//            return;
//        }

        [self.selecteTags addObject:self.tags[btn.tag]];
        
    }else {
        [self.selecteTags removeObject:self.tags[btn.tag]];
    }
    btn.selected = !btn.selected;

    
}

- (void)fetchAnchorInfo {
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/authoptional/appraise") Parameters:@{@"customerId" : self.anchorId} successBlock:^(RequestModel *respondObject) {
        self.model = [JHAnchorInfoModel mj_objectWithKeyValues:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];

}

- (void)hiddenKeyBoard {
    [self.contentView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

}


#pragma mark - UITextViewDElegate

@end
