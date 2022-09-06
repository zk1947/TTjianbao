//
//  JHLiveScrollLabelView.m
//  TTjianbao
//
//  Created by apple on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveScrollLabelView.h"
#import "NSString+Extension.h"

@interface JHLiveScrollLabelView()
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UILabel * label;
@end

@implementation JHLiveScrollLabelView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self creatUIView];
    }
    return self;
}
-(void)creatUIView{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.layer.cornerRadius = 8;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.label = [[UILabel alloc] init];
    self.label.backgroundColor = HEXCOLORA(0x000000, 0.35);
    self.label.layer.cornerRadius = 8;
    self.label.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.label];
    self.label.textColor = HEXCOLOR(0xffffff);
    self.label.font = JHFont(10);
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.left.equalTo(@0);
        make.top.equalTo(@8);
    }];
}
-(void)setLabelText:(NSString *)text{
    
    CGSize size = [text sizeWithFont:JHFont(10) maxSize:CGSizeMake(2000, 30)];
    size.width = size.width + 10;
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(size.width);
    }];
    self.label.text = text;
    self.scrollView.contentSize = CGSizeMake(size.width, self.height);
}
@end
