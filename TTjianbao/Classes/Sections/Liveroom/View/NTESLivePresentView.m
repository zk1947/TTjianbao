//
//  NTESLivePresentView.m
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePresentView.h"
#import "NTESPresent.h"
#import "NTESLivePresentCell.h"
#import "UIView+NTES.h"

@interface NTESLivePresentView()<UITableViewDelegate,UITableViewDataSource,NTESLivePresentCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger lastAnimateIndex;

@property (nonatomic,strong) NSMutableArray<NIMMessage *> *prepareDatas;

@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation NTESLivePresentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _datas = [@[[NSNull null],[NSNull null]] mutableCopy];
        _prepareDatas = [[NSMutableArray alloc] init];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)addPresentMessage:(NIMMessage *)message
{
    [self.prepareDatas addObject:message];
    [self checkPrepareData];
}

- (void)checkPrepareData
{
    NIMMessage *message = self.prepareDatas.firstObject;
    if (!message || ![self.datas containsObject:[NSNull null]]) {
        return;
    }
    NSArray *array = [NSArray arrayWithArray:self.datas];
    BOOL find = NO;
    NSInteger index = array.count - 1;
    for (;index >= 0; index--) {
        NSObject *object = array[index];
        if ([object isKindOfClass:[NSNull class]]) {
            find = YES;
            break;
        }
    }
    if (!find) {
        //全满了就替换最老的一个
        index = labs(self.lastAnimateIndex - 1) % 2;
    }
    
    self.datas[index]  = message;
    
    NTESLivePresentCell *cell = self.tableView.visibleCells[index];
    
    [cell refreshWithPresentMessage:message];
    [cell show];
    
    [self.prepareDatas removeObject:message];
    
    self.lastAnimateIndex = index;
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTESLivePresentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    NIMMessage *message = self.datas[indexPath.row];
    cell.delegate = self;
    [cell refreshWithPresentMessage:message];
    return cell;
}


#pragma mark - NTESLivePresentCellDelegate

- (void)cellDidHide:(NTESLivePresentCell *)cell
            message:(NIMMessage *)message
{
    NSInteger index = [self.tableView indexPathForCell:cell].row;
    if (message == self.datas[index]) {
        self.datas[index] = [NSNull null];
        [self checkPrepareData];
    }
}

#pragma mark - Get
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[NTESLivePresentCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
