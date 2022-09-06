//
//  JHAudienceCommentHeaderTagView.m
//  TTjianbao
//
//  Created by jiang on 2019/6/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCommentHeaderTagView.h"
#import "JHAudienceCommentMode.h"

@interface JHCommentHeaderTagView ()
@property (nonatomic, strong) NSArray <CommentTagMode*>*tags;
@property (nonatomic, assign) CGFloat contentHeight;

@end


@implementation JHCommentHeaderTagView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)makeUI {

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat wMax = 10;
    CGFloat hMax = 10;
    
    for (int i = 0; i<self.tags.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[[UIImage imageNamed:@"commentTag_nomal"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"commentTag_select"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
   //
        NSString *title;
        if (i==0) {
            title =  [NSString stringWithFormat:@"%@",self.tags[i].tagName];
            btn.selected=YES;
        }
        else{
                title =  [NSString stringWithFormat:@"%@(%@)",self.tags[i].tagName,self.tags[i].countStr];
        }
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(wMax);
            make.top.equalTo(self).offset(hMax);
        }];
        [self layoutIfNeeded];
        if (CGRectGetMaxX(btn.frame)>ScreenW-20) {
            wMax = 10;
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
        self.contentHeight = hMax+25+10;
    }
}

- (void)clickAction:(UIButton *)btn {
    for (UIButton * button in self.subviews) {
        button.selected=NO;
    }
    btn.selected=YES;
    if (self.clickTagFinish) {
        self.clickTagFinish(btn);
    }
}

- (void)showTagArray:(NSArray *)array {
    self.tags = array;
    [self makeUI];
    if (self.finish) {
        self.finish(self.contentHeight);
    }
}



@end
