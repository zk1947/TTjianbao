//
//  JHCommentTagView.m
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCommentTagView.h"

#import "JHAudienceCommentMode.h"

@interface JHCommentTagView ()
@property (nonatomic, strong) NSArray<CommentTagMode *> *tags;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) BOOL isShow;

@end


@implementation JHCommentTagView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)makeUI {
    self.selectedArray = [NSMutableArray array];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat wMax = 0;
    CGFloat hMax = 0;
    
    for (int i = 0; i<self.tags.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_comment_tag_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg_comment_tag_selected"] forState:UIControlStateSelected];
        [btn setTitleColor:HEXCOLOR(0xff4200) forState:UIControlStateSelected];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        
        NSString *title = self.tags[i].tagName;
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateNormal];
        if (self.isShow) {
            btn.selected = YES;
        } else {
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.tag = i;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(wMax);
            make.top.equalTo(self).offset(hMax);
        }];
        [self layoutIfNeeded];
        if (CGRectGetMaxX(btn.frame)>self.width) {
            wMax = 0;
            hMax += (25+10);
        }
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(wMax);
            make.top.equalTo(self).offset(hMax);
        }];

        [self layoutIfNeeded];
        wMax = CGRectGetMaxX(btn.frame)+15;
        

    }
    if (!self.tags || self.tags.count == 0) {
        self.contentHeight = 0;

    }else {
        self.contentHeight = hMax+25;

    }
    

}

- (void)clickAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.selectedArray addObject:[self.tags[btn.tag] mj_keyValues]];
    } else {
        [self.selectedArray removeObject:[self.tags[btn.tag] mj_keyValues]];
    }
    if (self.clickTagFinish) {
        self.clickTagFinish(btn);
    }
    
}

- (void)showTagArray:(NSArray *)array {
    self.tags = array;
    self.isShow = YES;
    [self makeUI];
    if (self.finish) {
        self.finish(self.contentHeight);
    }
}


- (void)setStarCount:(NSInteger)starCount {
    _starCount = starCount;
    if (starCount <= 2) {
//        self.tags = self.tagArray[@"badTags"];
        self.tags = [CommentTagMode mj_objectArrayWithKeyValuesArray:self.tagArray[@"badTags"]];

    }else if (starCount>2&&starCount<=4) {
//        self.tags = self.tagArray[@"generalTags"];
        self.tags = [CommentTagMode mj_objectArrayWithKeyValuesArray:self.tagArray[@"generalTags"]];

    }else {
        self.tags = [CommentTagMode mj_objectArrayWithKeyValuesArray:self.tagArray[@"goodTags"]];
    }
        [self makeUI];
        if (self.finish) {
            self.finish(self.contentHeight);
        }

}
@end
