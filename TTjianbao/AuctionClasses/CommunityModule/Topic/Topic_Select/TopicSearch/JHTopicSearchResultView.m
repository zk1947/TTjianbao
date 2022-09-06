//
//  JHTopicSearchResultView.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSearchResultView.h"
#import "YDBaseTableView.h"
#import "CTopicModel.h"
#import "JHTopicSearchResultCell.h"
#import "TopicApiManager.h"


@interface JHTopicSearchResultView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CTopicModel *curModel;
@property (nonatomic, strong) YDBaseTableView *tableView;
@end


@implementation JHTopicSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _curModel = [[CTopicModel alloc] init];
        
        [self configTableView];
    }
    return self;
}

- (void)configTableView {
    _tableView = ({
        YDBaseTableView *table = [[YDBaseTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        table.backgroundColor = [UIColor whiteColor];
        table.delegate = self;
        table.dataSource = self;
        table.sectionFooterHeight = 60;
        table.rowHeight = [JHTopicSearchResultCell cellHeight];
        //table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [table registerClass:[JHTopicSearchResultCell class] forCellReuseIdentifier:kCellId_JHTopicSearchResultCell];
        [self addSubview:table];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        table;
    });
}


#pragma mark -
#pragma mark - 数据处理

- (void)setKeywordStr:(NSString *)keywordStr {
    _keywordStr = keywordStr;
    if (![keywordStr isNotBlank]) {
        [_curModel.list removeAllObjects];
        [_tableView reloadData];
        return;
    }
    [self sendSearchRequest];
}

- (void)configModel:(CTopicModel *)model {
    _curModel = model;
    
    if (_curModel && _curModel.list) { //搜索到了
        __block BOOL isExist = NO;
        [_curModel.list enumerateObjectsUsingBlock:^(CTopicData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_keywordStr isEqualToString:obj.title]) {
                isExist = YES;
                *stop = YES;
            }
        }];
        
        if (!isExist) {
            CTopicData *data = [[CTopicData alloc] init];
            data.title = _keywordStr;
            data.needCreate = YES;
            [_curModel.list insertObject:data atIndex:0];
        }
    
    } else { //未搜索到
        CTopicData *data = [[CTopicData alloc] init];
        data.title = _keywordStr;
        data.needCreate = YES;
        _curModel = [[CTopicModel alloc] init];
        [_curModel.list insertObject:data atIndex:0];
    }
    
    [self.tableView reloadData];
}

- (void)sendSearchRequest {
    NSLog(@"在这里发起请求");
    @weakify(self);
    [TopicApiManager request_topicListWithKeyword:_keywordStr completeBlock:^(CTopicModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self configModel:respObj];
    }];
}


#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

/** 适配iOS11：这两个方法必须实现，且返回高度必须大于0，不然不起作用！！！ */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTopicSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHTopicSearchResultCell forIndexPath:indexPath];
    CTopicData *data = _curModel.list[indexPath.row];
    cell.curData = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CTopicData *data = _curModel.list[indexPath.row];
    if (self.didSelectedBlock) {
        self.didSelectedBlock(data);
    }
}

@end
