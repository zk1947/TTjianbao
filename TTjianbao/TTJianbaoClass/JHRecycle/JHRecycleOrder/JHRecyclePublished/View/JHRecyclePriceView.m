//
//  JHRecyclePriceView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceView.h"
#import "JHRecyclePriceCell.h"
#import "JHRecyclePriceModel.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecyclePriceListViewController.h"
#import "JHRecyclePriceModel.h"
#import "NSString+AttributedString.h"
@interface JHRecyclePriceView()<UITableViewDelegate, UITableViewDataSource>
/** topViwew*/
@property (nonatomic, strong) UIView *topView;
/** 商家报价*/
@property (nonatomic, strong) UILabel *priceTagLabel;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 当前选择cell的索引*/
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation JHRecyclePriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)setListArray:(NSMutableArray<JHRecyclePriceModel *> *)listArray {
    _listArray = listArray;
    if (listArray.count > 0) {
        for (int i = 0; i < listArray.count; i++) {
            JHRecyclePriceModel *modelC = listArray[i];
            if (modelC.isSelect) {
                break;
            }
            if (i == listArray.count - 1) {
                JHRecyclePriceModel *model = self.listArray.firstObject;
                model.isSelect = YES;
                self.listArray[0] = model;
                self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                if (self.bitIdBlock) {
                    self.bitIdBlock(model);
                }
            }
        }
    }
    
    [self.tableView reloadData];
    if (listArray.count == 0) {
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else {
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
        }];
        CGFloat height = listArray.count > 3 ? 149.5 : listArray.count * 50 - 0.5;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)configUI {
    [self addSubview:self.topView];
    [self.topView addSubview:self.priceTagLabel];
    [self.topView addSubview:self.seeAllButton];
    [self addSubview:self.tableView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(49);
    }];
    
    [self.priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).offset(10);
        make.centerY.mas_equalTo(self.topView);
        make.height.mas_equalTo(self.topView);
    }];
    
    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).offset(-10);
        make.centerY.mas_equalTo(self.topView);
        make.height.mas_equalTo(self.topView);
        make.width.mas_equalTo(60);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(self);
    }];
}

- (void)moreButtonClickAction:(UIButton *)sender {
    JHRecyclePriceListViewController *priceListView = [[JHRecyclePriceListViewController alloc] init];
    priceListView.productId = self.productId;
    [self.viewController.navigationController pushViewController:priceListView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecyclePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecyclePriceCell"];
    cell.priceModel = self.listArray[indexPath.row];
    cell.contentView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取cell
    JHRecyclePriceCell *cell = (JHRecyclePriceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    JHRecyclePriceModel *modelC = self.listArray[self.currentIndexPath.row];
    modelC.isSelect = NO;
    self.listArray[self.currentIndexPath.row] = modelC;
    JHRecyclePriceCell *currentCell = (JHRecyclePriceCell *)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    currentCell.priceModel = modelC;
    
    self.currentIndexPath = indexPath;
    JHRecyclePriceModel *model = self.listArray[self.currentIndexPath.row];
    model.isSelect = YES;
    self.listArray[self.currentIndexPath.row] = model;
    cell.priceModel = model;
    
    if (self.bitIdBlock) {
        self.bitIdBlock(model);
    }
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.clipsToBounds = YES;
    }
    return _topView;
}

- (UILabel *)priceTagLabel {
    if (_priceTagLabel == nil) {
        _priceTagLabel = [[UILabel alloc] init];
//        _priceTagLabel.textColor = HEXCOLOR(0x333333);
//        _priceTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
//        _priceTagLabel.text = @"商家报价";
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string": @"商家报价", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
        itemsArray[1] = @{@"string":@" (从高到低)", @"color":HEXCOLOR(0x999999), @"font":[UIFont fontWithName:kFontNormal size:11]};
        _priceTagLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _priceTagLabel;
}

- (UIButton *)seeAllButton{
    if (_seeAllButton == nil) {
        _seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
        _seeAllButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_seeAllButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [_seeAllButton setImage:[UIImage imageNamed:@"store_icon_seller_more_arrow"] forState:UIControlStateNormal];
        [_seeAllButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                        imageTitleSpace:15];
        _seeAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_seeAllButton addTarget:self action:@selector(moreButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = HEXCOLOR(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.layer.cornerRadius = 4;
        _tableView.clipsToBounds = YES;
        [_tableView registerClass:[JHRecyclePriceCell class] forCellReuseIdentifier:@"JHRecyclePriceCell"];
    }
    return _tableView;
}

//- (NSMutableArray<JHRecyclePriceModel *> *)listArray {
//    if (_listArray == nil) {
//        _listArray = [NSMutableArray array];
//    }
//    return _listArray;
//}

@end
