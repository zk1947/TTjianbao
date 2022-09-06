//
//  JHSearchAssociateView.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchAssociateView.h"
#import "JHSearchAssociateTitleCell.h"
#import "JHSearchAssociateModel.h"
@interface JHSearchAssociateView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger currentIndex; // 当前子页

@property (nonatomic, copy) NSString *tableName; // 历史数据和本地数据 表名

@property (nonatomic, strong) NSMutableArray *allModellList; // 插入了前三固定数据的 列表总数据

@property (nonatomic, assign) NSInteger lastRequestTime; // 最后请求联想接口的时间戳

@end

@implementation JHSearchAssociateView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = kControlBGColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height) style:UITableViewStylePlain];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor = kLineColor;
//    self.tableView.backgroundColor = kWhiteColor;
    
    [self.tableView registerClass:[JHSearchAssociateTitleCell class] forCellReuseIdentifier:@"JHSearchAssociateTitleCellID"];
    
    [self addSubview:self.tableView];
}


- (NSMutableArray *)allModellList {
    
    if (!_allModellList) {
        _allModellList = [NSMutableArray array];
    }
    return _allModellList;
}

#pragma mark - 数据
// 联想数据
- (void)showAssociateViewWithKeyword:(NSString *)keyword currentPageIndex:(NSInteger)currentIndex {
   
    // 删完
    if (keyword.length == 0) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    self.keyword = keyword;
    self.currentIndex = currentIndex;
    
    
    // 请求频率控制 到上一次间隔>500毫秒
    NSInteger currentTime = [[CommHelp getNowTimeTimestamp] integerValue];
    if (currentTime - self.lastRequestTime > 500) {
        // 联想请求
        [self requestAssociateData];
        self.lastRequestTime = currentTime;
    }
}

- (void)requestAssociateData {
    
    NSDictionary *param = @{@"searchWord": self.keyword};
    
    NSString *url= FILE_BASE_STRING(@"/mall/search/search/queryAssociativeWord");
    @weakify(self);
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
            self.allModellList = [JHSearchAssociateModel mj_objectArrayWithKeyValuesArray:respondObject.data];
            [self.tableView reloadData];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
    
        }];
}


#pragma - mark <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allModellList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSearchAssociateTitleCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"JHSearchAssociateTitleCellID"];
    JHSearchAssociateModel *model = self.allModellList[indexPath.row];
    cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.keyword = self.keyword;
    [cardCell setcellWithKey:model.word  andSearchkey:self.keyword];
    return cardCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pushToResultVC) {
        JHSearchAssociateModel *model = SAFE_OBJECTATINDEX(self.allModellList, indexPath.row);
        self.pushToResultVC(model.word);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.supVC.view endEditing:YES];
}


@end
