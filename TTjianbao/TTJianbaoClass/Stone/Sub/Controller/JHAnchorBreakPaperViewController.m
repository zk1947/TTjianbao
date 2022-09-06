//
//  JHAnchorBreakPaperViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHAnchorBreakPaperViewController.h"
#import "JHAnchorBreakPaperItemView.h"
#import "JHKeyValueModel.h"
#import "JHMainLiveSmartModel.h"
#import "NSString+Common.h"

@interface JHAnchorBreakPaperViewController ()
@property (nonatomic, strong) JHAnchorBreakPaperItemView *orderCount;
@property (nonatomic, strong) NSMutableArray<JHAnchorBreakPaperItemView *> *arrayItem;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSArray *arraySplitStyle;

@end

@implementation JHAnchorBreakPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.priceTotal = [self.priceTotal priceString];
    [self makeNav];
    [self makeUI];
    [self requestProsesStyle];


}

- (void)makeNav
{
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self initToolsBar];
//    [self.navbar setTitle:@"拆单"];
    self.title = @"拆单";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(1);
    }];
    
    self.contentView = [UIView new];
    [self.scrollView addSubview:self.contentView];
    

}

- (void)makeUI {
    self.orderCount = [JHAnchorBreakPaperItemView new];
    [self.orderCount makeUIOrderCount];
    JH_WEAK(self)
    self.orderCount.seletedBlock = ^(id sender) {
        JH_STRONG(self)
        [self makeItems];
    };
    [self.contentView addSubview:self.orderCount];
    [self.orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.offset(10);
        make.trailing.offset(-10);
    }];
    [self makeItems];
   
}

- (void)makeItems {

    for (JHAnchorBreakPaperItemView *view in self.arrayItem) {
        [view removeFromSuperview];
    }
    [self.saveBtn removeFromSuperview];
    self.arrayItem = [NSMutableArray array];
    int count = [self.orderCount.breakStyle.textField.text intValue];
    JHAnchorBreakPaperItemView *lastItem;
    for (int i = 0; i<count; i++) {
        JHAnchorBreakPaperItemView *item = [JHAnchorBreakPaperItemView new];
        [item makeUI];
        item.title.text = [NSString stringWithFormat:@"%d",i+1];
        [self.contentView addSubview:item];
        if (lastItem) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastItem.mas_bottom).offset(10);
                make.leading.trailing.equalTo(self.orderCount);
            }];

        }else {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.orderCount.mas_bottom).offset(10);
                make.leading.trailing.equalTo(self.orderCount);

            }];

        }
        
        lastItem = item;
        item.splitModeArray = self.arraySplitStyle;
        [self.arrayItem addObject:item];
               
    }
    
      
    
    UIButton *submitBtn = [JHUIFactory createThemeBtnWithTitle:@"完成拆单" cornerRadius:22 target:self action:@selector(finishBreak)];
    [self.view addSubview:submitBtn];
    self.saveBtn = submitBtn;
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastItem.mas_bottom).offset(50);
        make.leading.equalTo(self.view).offset(40);
        make.trailing.equalTo(self.view).offset(-40);
        make.height.equalTo(@(44));
        make.bottom.equalTo(self.contentView).offset(-50);
        
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.leading.trailing.equalTo(self.scrollView);
          make.width.equalTo(@(ScreenW));
        make.bottom.equalTo(submitBtn).offset(20);
      }];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(ScreenW, self.contentView.height>self.scrollView.height?self.contentView.height:self.scrollView.height+1);

}


- (void)requestProsesStyle {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone/list-split-mode") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSMutableArray *array = [JHKeyValueModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.arraySplitStyle = array;
        for (JHAnchorBreakPaperItemView *view in self.arrayItem) {
            view.splitModeArray = array;
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)postData {
    NSMutableArray *array = [NSMutableArray array];
    double price = 0.0;
    for (JHAnchorBreakPaperItemView *view in self.arrayItem) {
        JHMainLiveSplitDetailModel *model = [JHMainLiveSplitDetailModel new];
        model.splitMode = view.tag;
        model.purchasePrice = view.breakPrice.textField.text;
        if (view.tag == 0) {
            [self.view makeToast:@"请选择拆单方式" duration:1.5 position:CSToastPositionCenter];

            return;
        }
        [array addObject:model];
        price = price + [model.purchasePrice doubleValue];
    }
//    不校验了 后台校验
//    NSString *priceString = [@(price).stringValue priceString];
//
//    if (![priceString isEqualToString:self.priceTotal]) {
//        [self.view makeToast:@"请调整价格，保证价格合计等于购买价格" duration:1.5 position:CSToastPositionCenter];
//        return;
//    }
    
    
    [SVProgressHUD show];
    JHMainLiveSplitReqModel *model = [JHMainLiveSplitReqModel new];
    model.channelCategory = self.channelCategory;
    model.stoneId = self.stoneId;
    model.splitStoneList = array;
    [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }
    }];
}

- (void)finishBreak {
    [self postData];
}
@end
