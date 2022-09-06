//
//  JHChatBaseCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatBaseCell.h"

@implementation JHChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
//    self.userInteractionEnabled = false;
    self.contentView.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (RACSubject *)clickSubject {
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}
@end
