//
//  JHConfirmBreakPaperView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHConfirmBreakPaperView.h"
#import "JHBreakPaperTableView.h"
#import "JHBreakPaperTableCell.h"

@interface JHConfirmBreakPaperView ()
@property (nonatomic, strong)JHBreakPaperTableView *mainView;


@end

@implementation JHConfirmBreakPaperView

- (void)makeUI {
    [super makeUI];

 
    self.titleLabel.text = @"拆单";
    [self.okBtn setTitle:@"确认拆单" forState:UIControlStateNormal];
    [self style1];
    self.mainView = [[JHBreakPaperTableView alloc] init];
    [self.backView addSubview:_mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-10);
        make.height.equalTo(@(107));
    }];
    
  
    NSLog(@"self.mainView.tableView.contentSize====%@",NSStringFromCGSize(self.mainView.tableView.contentSize));
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.mainView.tableView.contentSize.height));

    }];
    
}

- (void)setModel:(JHStoneMessageModel *)model {
    [super setModel:model];
    
    self.mainView.dataArray = [JHMainLiveSplitDetailModel mj_objectArrayWithKeyValuesArray:model.splitStoneList].mutableCopy;
    
    [self.mainView.tableView reloadData];
    self.mainView.stoneOrderItem.model = self.model;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.mainView.tableView.contentSize.height));

    }];
      
}

- (void)okAction {
    JHStoneMessageModel *selfModel = self.model;
    JHUserConfirmBreakReqModel *model = [JHUserConfirmBreakReqModel new];
    model.stoneId = selfModel.stoneId;
    model.channelCategory = selfModel.channelCategory;
    [SVProgressHUD show];
    [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"拆单成功"];
            [super okAction];
        }
        
    }];
    if (self.actionBlock) {
        self.actionBlock(nil, RequestTypeConfirmBreakPaper);
    }
}


@end
