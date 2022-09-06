//
//  JHGoodManagerFilterCagetoryTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerFilterCagetoryTableViewCell.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerFilterCagetoryTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *cagetoryTableView;
@property (nonatomic, strong) NSMutableArray *subDataSourceArray;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) NSMutableArray *cellArray;
@end

@implementation JHGoodManagerFilterCagetoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel                     = [[UILabel alloc] init];
    _titleLabel.textColor           = HEXCOLOR(0x333333);
    _titleLabel.textAlignment       = NSTextAlignmentCenter;
    _titleLabel.font                = [UIFont fontWithName:kFontNormal size:12.f];
    _titleLabel.backgroundColor     = HEXCOLOR(0xF5F5F5);
    _titleLabel.layer.cornerRadius  = 15.f;
    _titleLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18.f);
        make.top.equalTo(self.contentView.mas_top).offset(6.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(92.f);
    }];
    
    
    [self.contentView addSubview:self.cagetoryTableView];
    [self.cagetoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0.f);
        make.left.equalTo(self.titleLabel.mas_right).offset(12.f);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(30.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-6.f);
    }];
}

#pragma mark -
- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellArray;
}

- (NSMutableArray *)subDataSourceArray {
    if (!_subDataSourceArray) {
        _subDataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _subDataSourceArray;
}

- (UITableView *)cagetoryTableView {
    if (!_cagetoryTableView) {
        _cagetoryTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cagetoryTableView.dataSource                     = self;
        _cagetoryTableView.delegate                       = self;
        _cagetoryTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _cagetoryTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _cagetoryTableView.estimatedRowHeight             = 10.f;
        _cagetoryTableView.bounces                        = NO;
        _cagetoryTableView.showsVerticalScrollIndicator   = NO;
        _cagetoryTableView.scrollEnabled                  = NO;
        if (@available(iOS 11.0, *)) {
            _cagetoryTableView.estimatedSectionHeaderHeight   = 0.1f;
            _cagetoryTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        if ([_cagetoryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_cagetoryTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_cagetoryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_cagetoryTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _cagetoryTableView;
}


#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodManagerFilterCagetoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class])];
    if (!cell) {
        cell = [[JHGoodManagerFilterCagetoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class])];
    }
    [cell setViewModel:self.subDataSourceArray[indexPath.row]];
    [self.cellArray addObject:cell];
    cell.didSelectBlock = ^{
        for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
            /// 先重置状态
            [cell setTitleLabelBackgroundColorSelect:NO];
            [cell resetAllTitleLabelStatus];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
    for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
        /// 先重置状态
        [self resetCagetoryRequestModel];
        [cell setTitleLabelBackgroundColorSelect:NO];
        [cell resetAllTitleLabelStatus];
        
        JHGoodManagerFilterCagetoryTableViewCell *cellSel = [tableView cellForRowAtIndexPath:indexPath];
        JHGoodManagerFilterModel *model = self.subDataSourceArray[indexPath.row];
        if (!isEmpty(model.cateId)) {
            if ([model.cateLevel isEqualToString:@"2"]) {
                [JHGoodManagerSingleton shared].secondCategoryId = model.cateId;
            }
            if ([model.cateLevel isEqualToString:@"3"]) {
                [JHGoodManagerSingleton shared].thirdCategoryId  = model.cateId;
            }
        }
        if (cell == cellSel) {
            [cell setTitleLabelBackgroundColorSelect:YES];
        } else {
            [cell setTitleLabelBackgroundColorSelect:NO];
        }
    }
}

- (void)setTitleLabelBackgroundColorSelect:(BOOL)select {
    if (select) {
        self.titleLabel.backgroundColor = HEXCOLOR(0xFCEC9D);
    } else {
        self.titleLabel.backgroundColor = HEXCOLOR(0xF5F5F5);
    }
}

- (void)resetAllTitleLabelStatus {
    [self setTitleLabelBackgroundColorSelect:NO];
    for (JHGoodManagerFilterCagetoryTableViewCell *cell in self.cellArray) {
        [self resetCagetoryRequestModel];
        [cell setTitleLabelBackgroundColorSelect:NO];
        [cell resetAllTitleLabelStatus];
    }
}

/// 重置分类
- (void)resetCagetoryRequestModel {
    [JHGoodManagerSingleton shared].firstCategoryId  = @"";
    [JHGoodManagerSingleton shared].secondCategoryId = @"";
    [JHGoodManagerSingleton shared].thirdCategoryId  = @"";
}


- (void)setViewModel:(JHGoodManagerFilterModel *)cagetory {
    [self.subDataSourceArray removeAllObjects];
    [self.cellArray removeAllObjects];
    
    
    if (!isEmpty(cagetory.cateName)) {
        self.titleLabel.text = cagetory.cateName;
        self.titleLabel.hidden = NO;
        NSArray<JHGoodManagerFilterModel *> *arr = [NSArray cast:cagetory.children];
        if (arr && arr.count >0)  {
            [self.subDataSourceArray addObjectsFromArray:arr];
            
            for (int i = 0; i<self.subDataSourceArray.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@_%d",NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class]),i];
                [self.cagetoryTableView registerClass:[JHGoodManagerFilterCagetoryTableViewCell class] forCellReuseIdentifier:str];
            }
            
            [self.cagetoryTableView reloadData];
            
            NSInteger countMax = 1;
            NSMutableArray *thirdMu = [NSMutableArray arrayWithCapacity:0];
            for (JHGoodManagerFilterModel *subModel in self.subDataSourceArray) {
                NSArray<JHGoodManagerFilterModel *> *subArray = [NSArray cast:subModel.children];
                [thirdMu addObject:@(subArray.count)];
            }
            
            NSArray *result = [thirdMu sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            
            countMax = [[result lastObject] integerValue];
            if (countMax == 0) {
                countMax = 1;
            }
            
            CGFloat cagetoryTableViewHeight = (36.f * self.subDataSourceArray.count * countMax);
//            NSLog(@"cagetoryTableViewHeight = %f, count = %lu, max = %ld",cagetoryTableViewHeight, (unsigned long)self.subDataSourceArray.count,(long)countMax);
            [self.cagetoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(cagetoryTableViewHeight);
            }];
        } else {
            [self.cagetoryTableView registerClass:[JHGoodManagerFilterCagetoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class])];
            [self.cagetoryTableView reloadData];
            [self.cagetoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30.f);
            }];
        }
    } else {
        self.titleLabel.hidden = YES;
        [self.cagetoryTableView registerClass:[JHGoodManagerFilterCagetoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerFilterCagetoryTableViewCell class])];
        [self.cagetoryTableView reloadData];
        [self.cagetoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    }
}

@end
