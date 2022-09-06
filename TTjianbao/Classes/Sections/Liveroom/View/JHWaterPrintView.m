//
//  JHWaterPrintView.m
//  TTjianbao
//
//  Created by mac on 2019/5/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHWaterPrintView.h"

@interface JHWaterPrintView ()

///房间ID
@property (nonatomic, strong) UILabel *roomIdLabel;

@end

@implementation JHWaterPrintView

- (instancetype)initWithImage:(UIImage *)image roomId:(NSString *)roomid
{
    self = [super initWithImage:image];
    if (self) {
        [self addSubview:self.roomIdLabel];
        self.roomIdLabel.attributedText = [self getShadowWithText:roomid];
        [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-4);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)roomIdLabel
{
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roomIdLabel.backgroundColor = [UIColor clearColor];
    }
    return _roomIdLabel;
}

-(void)setText:(NSString *)text
{
    if(text)
    {
        _roomIdLabel.attributedText = [self getShadowWithText:text];
    }
}

- (NSAttributedString *)getShadowWithText:(NSString *)text {
    if (isEmpty(text)) {
        return nil;
    }
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2.5;
    shadow.shadowColor = RGBA(0, 0, 0, 0.2);
    shadow.shadowOffset =CGSizeMake(0,1);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:7],NSForegroundColorAttributeName: UIColor.whiteColor, NSShadowAttributeName: shadow}];
    return string;
}


- (void)dealloc {
    NSLog(@"JHWaterPrintViewDealloc");
}
@end
