//
//  JHMallCateViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallCateViewModel.h"
#import "JHMallCateModel.h"
@implementation JHMallCateViewModel
+(JHMallCateViewModel *)setViewModelWithModel:(JHMallCateModel *)model
{
    
    JHMallCateViewModel *vm = [JHMallCateViewModel new];
    vm.Id = model.Id;
    vm.name = model.name;
    UIFont *titleFont = [UIFont fontWithName:kFontNormal size:12.0];
    NSDictionary *attributes = @{NSFontAttributeName:titleFont};
    CGSize textSize = [model.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 26) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    vm.cellWidth = textSize.width+26.0;
    vm.cellHeight = 26;
    vm.titleFont = titleFont;

    return vm;
}
@end
