//
//  JHEasyPollSearchBar.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEasyPollSearchBar.h"
#import <YYKit.h>
#import <YDCategoryKit/YDCategoryKit.h>

@interface JHEasyPollSearchBar ()
@property (nonatomic, assign) BOOL isShowingTop; //是否正在显示顶部label
@property (nonatomic, assign) BOOL isPolling; //是否正在轮询
@property (nonatomic, assign) NSInteger curIndex; //下一条index
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *topLabel; //top placeholder label
@property (nonatomic, strong) UILabel *bottomLabel; //bottom placeholder label


@property (nonatomic, strong) RACDisposable *racDisposable;
@end

@implementation JHEasyPollSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _curIndex = 0;
        _placeholderArray = [NSArray new];
        self.clipsToBounds = YES;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    
    _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_homeNavSearch2"]];//dis_glasses
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:_iconView];
    
    _contentView = [[UIView alloc] init];
    [bgView addSubview:_contentView];
    
    
    _topLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:UIColorHex(999999)];
    _topLabel.text = @"";
    //_topLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_topLabel];
    
    _bottomLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:UIColorHex(999999)];
    _bottomLabel.text = @"";
    //_bottomLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_bottomLabel];
    
    //布局
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(13, 15));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(bgView);
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.right.equalTo(bgView);
        make.top.bottom.equalTo(bgView);
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-8);
        make.centerY.equalTo(self.contentView).offset(kEasyPollSearchBarHeight);
    }];

    
    @weakify(self);
    [self addTapBlock2:^(id  _Nonnull obj, BOOL isLeft) {
        @strongify(self);
        if (self.didSelectedBlock) {
            self.didSelectedBlock(self.curIndex,isLeft);
        }
    }];
}
- (void)setSearchBarShowFrom:(JHSearchBarShowFromSoure)searchBarShowFrom{
    _searchBarShowFrom = searchBarShowFrom;
    if (searchBarShowFrom == JHSearchBarShowFromSoureHome) {
        UILabel *lab = [UILabel new];
        lab.backgroundColor = HEXCOLOR(0xFFD70F);
        lab.text = @"搜索";
        lab.textColor = kColor222;
        lab.font = JHFont(13);
        lab.textAlignment = NSTextAlignmentCenter;
        [lab jh_cornerRadius:15];
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) {
        return;
    }
    _placeholder = placeholder;
    _topLabel.text = _placeholder;
}

- (void)setPlaceholderArray:(NSArray<JHHotWordModel *> *)placeholderArray {
    if (!placeholderArray || placeholderArray.count == 0) {
        return;
    }
    _placeholderArray = placeholderArray;
    
//    if (_isPolling) { //正在轮询 - 此处防止下拉刷新重新赋值后动画错乱问题
//        return;
//    }
    
    _curIndex = 0;
    JHHotWordModel *data = _placeholderArray[_curIndex];
    _topLabel.text = data.title;
    
    _isShowingTop = YES;
    _topLabel.hidden = NO;
    _bottomLabel.hidden = YES;
    
    //更新布局
    [_topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    
    if (placeholderArray.count > 1) {
        _bottomLabel.text = _placeholderArray[_curIndex+1].title; //此处也赋值，防止首次动画偏移
        [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(kEasyPollSearchBarHeight);
        }];
        //开始轮询
        [self startPoll];
    }
}

- (void)startPoll {
    //RAC中的GCD
    if (_racDisposable) {
        return;
    }
    _isPolling = YES;
    @weakify(self);
    _racDisposable = [[[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        //[self.racDisposable dispose];
        @strongify(self);
        
        [self showPollLabel];
    }];
}

- (void)showPollLabel {
    if (self.stopScroll) return;
    _curIndex++;
    if (_curIndex >= _placeholderArray.count) {
        _curIndex = 0;
    }
    
    JHHotWordModel *data = _placeholderArray[_curIndex];
    
    if (_isShowingTop) {
        //显示bottomLabel
        _bottomLabel.text = data.title;
        [self showBottomLabel];
    } else {
        //显示topLabel
        _topLabel.text = data.title;
        [self showTopLabel];
    }
}

//显示topLabel
- (void)showTopLabel {
    _isShowingTop = YES;
    _topLabel.hidden = NO;
    
    [_topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    
    [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    //更新约束
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _bottomLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _bottomLabel.hidden = YES;
        _bottomLabel.alpha = 1;
        [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(kEasyPollSearchBarHeight);
        }];
    }];
}

//显示bottomLabel
- (void)showBottomLabel {
    _isShowingTop = NO;
    _bottomLabel.hidden = NO;
    
    [_topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    [_bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    
    //更新约束
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _topLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _topLabel.hidden = YES;
        _topLabel.alpha = 1;
        [_topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(kEasyPollSearchBarHeight);
        }];
    }];
}

- (void)dealloc {
    [_racDisposable dispose];
}

@end
