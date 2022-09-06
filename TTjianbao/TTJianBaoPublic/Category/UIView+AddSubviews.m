//
//  UIView+AddSubviews.m
//  TTjianbao
//
//  Created by plz on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIView+AddSubviews.h"

@implementation UIView (AddSubviews)

- (void)addSubviews:(NSArray<UIView *> *)subviews {
    
    NSOrderedSet<UIView *> *orderViews = [NSOrderedSet orderedSetWithArray:subviews];
    
    [orderViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
    }];
}

- (UIView *)renderCornerRadiusWithCell:(UITableViewCell *)cell
                             indexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView {
    return [self renderCornerRadiusWithCell:cell indexPath:indexPath tableView:tableView cornerRadius:8];
}
//渲染 tableview cell 卡片式圆角样式
- (UIView *)renderCornerRadiusWithCell:(UITableViewCell *)cell
                             indexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                             cornerRadius:(CGFloat)cornerRadius{

    // 0.cell背景透明，否则不会出现圆角效果
    cell.backgroundColor = [UIColor clearColor];

    // 1.创建path,保存绘制的路径
    CGMutablePathRef pathRef = CGPathCreateMutable();

    // cell的bounds
    CGRect bounds = cell.bounds;

    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 1.既是第一行又是最后一行
        // 1.1.底端中点 -> cell左下角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
        // 1.2.左下角 -> 左端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 1.3.左上角 -> 顶端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        // 1.4.cell右上角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 1.5.cell右下角 -> 底端中点
        CGPathAddArcToPoint(pathRef, nil,   CGRectGetMaxX(bounds), CGRectGetMaxY(bounds),CGRectGetMidX(bounds), CGRectGetMaxY(bounds),cornerRadius);

    } else if (indexPath.row == 0) {
        // 2.每组第一行cell
        // 2.1.起点： 左下角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 2.2.cell左上角 -> 顶端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        // 2.3.cell右上角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 2.4.cell右下角
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));

    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 3.每组最后一行cell
        // 3.1.初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        // 3.2.cell左下角 -> 底端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        // 3.3.cell右下角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 3.4.cell右上角
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));

    }else if (indexPath.row != 0 && indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 4.每组的中间行
        CGPathAddRect(pathRef, nil, bounds);
    }

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    // 绘制完毕，路径信息赋值给layer
    layer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    layer.fillColor = [UIColor whiteColor].CGColor;

    // 创建和cell尺寸相同的view
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    // 添加layer给backView
    [backView.layer addSublayer:layer];
    // backView的颜色
    backView.backgroundColor = [UIColor clearColor];
    // 把backView添加给cell
    return backView;

}

- (UIView *)renderAllCornerRadiusWithCell:(UITableViewCell *)cell{
    return [self renderAllCornerRadiusWithCell:cell cornerRadius:8];
}

- (UIView *)renderAllCornerRadiusWithCell:(UITableViewCell *)cell cornerRadius:(CGFloat)cornerRadius{
    
    // 0.cell背景透明，否则不会出现圆角效果
    cell.backgroundColor = [UIColor clearColor];
    
    // 1.创建path,保存绘制的路径
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    // cell的bounds
    CGRect bounds = cell.bounds;
    
    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    // 绘制完毕，路径信息赋值给layer
    layer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // 创建和cell尺寸相同的view
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    // 添加layer给backView
    [backView.layer addSublayer:layer];
    // backView的颜色
    backView.backgroundColor = [UIColor clearColor];
    // 把backView添加给cell
    return backView;
}

@end
