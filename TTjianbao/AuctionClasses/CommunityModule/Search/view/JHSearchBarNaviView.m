//
//  JHSearchBarNaviView.m
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSearchBarNaviView.h"

@interface JHSearchBarNaviView ()
@property (weak, nonatomic) IBOutlet UILabel *searchNavTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *searchBarPlaceholderLab;

@end

@implementation JHSearchBarNaviView
- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)onclickBackBtn:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}
- (IBAction)didClickJumpSearch:(id)sender {
    if (self.jumpBlock) {
        self.jumpBlock();
    }
}

- (void)setPlaceHoder:(NSString *)placeHoder {
    _placeHoder = placeHoder;
    self.searchBarPlaceholderLab.text = placeHoder;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.searchNavTitleLab.text = title;
}
@end
