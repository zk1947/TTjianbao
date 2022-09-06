//
//  JHMarketCategoryTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketCategoryTableViewCell.h"

#define kMaxCategroyCount 32

@interface JHMarketCategoryTableViewCell () <MarketScrollAnimationDelegate>

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation JHMarketCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _cellH = 120;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = kColorFFF;
    self.contentView.backgroundColor = kColorFFF;

    _animationView = [[JHMarketScrollAnimationView alloc]init];
    _animationView.animationDelegate = self;
    [self.contentView addSubview:_animationView];
    
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
        make.height.mas_equalTo(_cellH);
    }];
    
//    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.height.mas_equalTo(_cellH);
//    }];
}

- (void)reloadMyView{
    [_animationView removeFromSuperview];
    _animationView = nil;
    [self setupViews];
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//}

- (void)changeScrollViewHeight:(CGFloat)scrollH{
    _cellH = scrollH;
    [[self tableView] beginUpdates];
    [_animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
        make.height.mas_equalTo(scrollH);
    }];
    [[self tableView] endUpdates];
    [[self tableView] layoutIfNeeded];
}

- (void)scrollCategroyTouchEvent:(NSInteger)categroyIndex{
    self.pageIndex = categroyIndex;
}

- (void)setCategoryInfos:(NSArray *)categoryInfos{
    _categoryInfos = categoryInfos;
    
//    [self reloadMyView];
    
    //上限判断
    _animationView.resourceArray = _categoryInfos.count > kMaxCategroyCount ? [_categoryInfos subarrayWithRange:NSMakeRange(0, kMaxCategroyCount)] : _categoryInfos;
//    _animationView.pageIndex = self.pageIndex;
    //计算高度
    if (_animationView.pageIndex == 0) {
        _cellH = [_animationView getScrollViewPageOneHeight];
        if (_categoryInfos.count <= 12) {
            _cellH = _cellH - 20;
        }
    }else if (_animationView.pageIndex == 1){
        _cellH = [_animationView getScrollViewPageTowHeight];
//        _cellH += [_animationView getScrollViewAddHeight];
    }
    
//    [[self tableView] beginUpdates];
    [_animationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_cellH);
    }];
//    [[self tableView] endUpdates];
//    [[self tableView] layoutIfNeeded];
    
//    [[self tableView] beginUpdates];
//    [_animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.offset(0);
//        make.height.mas_equalTo(_cellH).priority(500);
//    }];
//    [[self tableView] endUpdates];
//    [[self tableView] layoutIfNeeded];
}

- (UITableView *)tableView{
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isKindOfClass:[UITableView class]] && nextResponder != nil) {
        nextResponder = nextResponder.nextResponder;
    }
    return (UITableView *)nextResponder;
}

@end
