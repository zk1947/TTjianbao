//
//  JHLiveRoomPKHeaderView.m
//  TTjianbao
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPKHeaderView.h"

@implementation JHLiveRoomPKHeaderButton

@end


@interface JHLiveRoomPKHeaderView ()
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIView *buttonView;
@property (nonatomic ,strong) UIView *segeView;
@property (nonatomic ,strong) NSMutableArray *btnArray;
@property (nonatomic ,assign) float fontFloat;
@end

@implementation JHLiveRoomPKHeaderView
- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        if (type == 2) {
            self.fontFloat = 14;
        }else{
            self.fontFloat = 15;
        }
        [self configPageTitleView];
    }
    return self;
}
//导航标签
- (void)configPageTitleView {
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"totalRank_bg"];//increaseRank_bg
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 45)];
    [self addSubview:self.buttonView];
    self.segeView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, 10)];
    [self addSubview:self.segeView];
    
//    [self creatCategoryViwe];
    
}
- (void)resetBgViewimage:(NSString*)typeStr{
    if ([typeStr isEqualToString:@"summaryRanking"]) {
        self.image = [UIImage imageNamed:@"totalRank_bg"];
    }else{
        self.image = [UIImage imageNamed:@"increaseRank_bg"];
    }
}
//标签栏
- (void)creatCategoryViwe{
    if (self.categoryTitleArray.count<=0) {
        return;
    }
    [self.btnArray removeAllObjects];
    
    NSInteger tag = 0;
    for (NSString *title in self.categoryTitleArray) {
        UIButton * btn = [UIButton jh_buttonWithTarget:self action:@selector(categoryBtnAction:) addToSuperView:self.buttonView];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(self.fontFloat);
        btn.tag = tag;
        [self.btnArray addObject:btn];
        tag++;
    }
    if (self.btnArray.count < 2) {
        UIButton * btn = (UIButton *)[self.btnArray firstObject];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.buttonView);
        }];
        [self categoryBtnAction:btn];
        
    }else{
        [self.btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
        [self.btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        UIButton * btn = (UIButton *)[self.btnArray firstObject];
        [self categoryBtnAction:btn];
    }
    
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 2;
    self.bottomView.clipsToBounds = YES;
    [self.segeView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.width/self.categoryTitleArray.count/2-7);
        make.size.mas_equalTo(CGSizeMake(15, 4));
        make.bottom.equalTo(self.segeView).offset(-6);
    }];
}
- (void)categoryBtnAction:(UIButton *)sender{
    for (UIButton *btn in self.btnArray) {
        btn.titleLabel.font = JHFont(self.fontFloat);
    }
    sender.titleLabel.font = JHBoldFont(self.fontFloat);
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sender.centerX-7);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryBtnAction:andTypeStr:)]) {
        if (sender.tag<self.categoryTypeArray.count) {
            [self.delegate categoryBtnAction:sender andTypeStr:self.categoryTypeArray[sender.tag]];
        }
    }
}
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
@end
