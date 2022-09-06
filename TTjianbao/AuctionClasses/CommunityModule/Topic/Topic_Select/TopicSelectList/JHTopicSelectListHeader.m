//
//  JHTopicSelectListHeader.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSelectListHeader.h"
#import "TTjianbaoHeader.h"

@interface JHTopicSelectListHeader ()
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation JHTopicSelectListHeader

+ (CGFloat)headerHeight {
    return 44.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_titleLabel) {
            _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14.0] textColor:kColor666];
            _titleLabel.frame = CGRectMake(15, 0, 200, [[self class] headerHeight]);
            _titleLabel.text = @"热门话题";
            [self addSubview:_titleLabel];
        }
    }
    return self;
}

@end
