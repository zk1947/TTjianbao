//
//  JHRecycleOrderDetailAddressViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailAddressViewModel.h"

@implementation JHRecycleOrderDetailAddressViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions
- (void)setupWithUserName : (NSString *)name phone : (NSString *)phone {
    self.userText = [name stringByAppendingFormat:@"  %@", phone];
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailAddressCell;
    
}
- (void)setupHeight {
    if (self.addressText == nil) {
        self.height = 65;
        return;
    }
    
    CGFloat width = ScreenW - LeftSpace * 2 - ContentLeftSpace * 2 - IconWidth - AddressLeftSpace;
    
    CGFloat height = [self.addressText heightForFont:[UIFont fontWithName:kFontNormal size:AddressFontSize] width:width];
    self.height = height + 65 - 20;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setAddressText:(NSString *)addressText {
    _addressText = addressText;
    
    [self setupHeight];
}
@end
