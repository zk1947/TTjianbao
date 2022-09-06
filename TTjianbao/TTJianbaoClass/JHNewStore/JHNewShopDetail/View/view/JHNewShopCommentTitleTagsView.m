//
//  JHNewShopCommentTitleTagsView.m
//  TTjianbao
//
//  Created by hao on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopCommentTitleTagsView.h"

@interface JHNewShopCommentTitleTagsView ()
@property (nonatomic, strong) UIButton *currentSelectedBtn;

@end

@implementation JHNewShopCommentTitleTagsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)initSubviews:(NSArray *)tagArray{
    if (!_currentSelectedBtn) {
        _currentSelectedBtn = [[UIButton alloc] init];
    }
    for (int i = 0; i < self.tagArray.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.tagArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFCEC9D)] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF5F5F5)] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = 1100 + i;
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(clickListBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.mas_offset(28);
            CGFloat sizeWidth = [self.tagArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size.width;
            make.width.mas_equalTo(sizeWidth + 20);
            
            if (i) {
                make.left.equalTo(self.currentSelectedBtn.mas_right).offset(10);
                
            }else {
                make.left.mas_offset(12);
            }
        }];
        //默认第一个标签选中，且不可点击
        if (i == 0) {
            btn.selected = YES;
            btn.userInteractionEnabled = NO;
            self.currentSelectedBtn = btn;
        }else{
            btn.selected = NO;
        }
    }
}

- (void)clickListBtnAction:(UIButton *)sender{
    self.currentSelectedBtn.selected = NO;
    self.currentSelectedBtn.userInteractionEnabled = YES;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    self.currentSelectedBtn = sender;
    
    NSInteger index = sender.tag - 1100;
    
    if (self.tagSelectedBlock) {
        self.tagSelectedBlock([NSNumber numberWithInteger:index]);
    }

}

- (void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    [self initSubviews:tagArray];
}

@end
