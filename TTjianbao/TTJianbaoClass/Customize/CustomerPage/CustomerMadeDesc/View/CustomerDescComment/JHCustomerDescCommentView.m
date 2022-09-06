//
//  JHCustomerDescCommentView.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescCommentView.h"
#import "JHCustomerDescCommentTextTableViewCell.h"
#import "JHCustomerDescCommentPictTableViewCell.h"
#import "JHCustomerDescInProcessModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHCustomerDescCommentView () <
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *cdcTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation JHCustomerDescCommentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    [self addSubview:self.cdcTabelView];
    self.cdcTabelView.scrollEnabled = NO;
    self.cdcTabelView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self.cdcTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 0.f, 0.f, 5.f));
        make.top.equalTo(self.mas_top).offset(5.f);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-5.f);
    }];
}

- (UITableView *)cdcTabelView {
    if (!_cdcTabelView) {
        _cdcTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cdcTabelView.dataSource                     = self;
        _cdcTabelView.delegate                       = self;
        _cdcTabelView.separatorColor                 = [UIColor clearColor];
        _cdcTabelView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
        _cdcTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _cdcTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
//            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_cdcTabelView registerClass:[JHCustomerDescCommentTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerDescCommentTextTableViewCell class])];
        [_cdcTabelView registerClass:[JHCustomerDescCommentPictTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerDescCommentPictTableViewCell class])];

        if ([_cdcTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_cdcTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_cdcTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_cdcTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _cdcTabelView;
}

#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeCommentItemVOSModel *model = self.dataSourceArray[indexPath.row];
    if (!model) {
        return nil;
    }
    if (model.commentItemImgList.count >0) {
        JHCustomerDescCommentPictTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerDescCommentPictTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomerDescCommentPictTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerDescCommentPictTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        @weakify(self);
        cell.pictActionBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
            @strongify(self);
            if (self.commentPictsAcitonBlock) {
                self.commentPictsAcitonBlock(index, imgArr);
            }
        };
        return cell;
    } else {
        JHCustomerDescCommentTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerDescCommentTextTableViewCell class])];
        if (!cell) {
            cell = [[JHCustomerDescCommentTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerDescCommentTextTableViewCell class])];
        }
        [cell setViewModel:self.dataSourceArray[indexPath.row]];
        return cell;
    }
}

- (void)setViewModel:(id)viewModel {
    if (!viewModel) {
        return;
    }
    NSArray<JHCustomizeCommentItemVOSModel*> *array = (NSArray<JHCustomizeCommentItemVOSModel*> *)viewModel;
    [self.dataSourceArray removeAllObjects];
    if (array && array.count >0) {
        [self.dataSourceArray addObjectsFromArray:array];
    }
    [self.cdcTabelView reloadData];
}

@end
