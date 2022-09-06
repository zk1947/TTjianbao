//
//  JHNewFansLevelCell.m
//  TTjianbao
//
//  Created by Paros on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewFansLevelCell.h"
@interface JHNewFansLevelCell()
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;

@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) CAShapeLayer * topLayer;
@property(nonatomic, strong) CAShapeLayer * bottomLayer;

@end

@implementation JHNewFansLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellType:(JHNewFansLevelCellType)cellType{
    _cellType = cellType;
    switch (cellType) {
        case JHNewFansLevelCellType_Normal :
        {
            self.leftLine.hidden = NO;
            self.rightLine.hidden = NO;
            self.bottomLine.hidden = NO;
            self.topLayer.hidden = YES;
            self.bottomLayer.hidden = YES;
        }
            break;
        case JHNewFansLevelCellType_NearBottom :
        {
            self.leftLine.hidden = NO;
            self.rightLine.hidden = NO;
            self.bottomLine.hidden = YES;
            self.topLayer.hidden = YES;
            self.bottomLayer.hidden = YES;
        }
            break;

        case JHNewFansLevelCellType_Top :
        {
            self.leftLine.hidden = YES;
            self.rightLine.hidden = YES;
            self.bottomLine.hidden = YES;
            self.leftLbl.text = @"等级";
            self.rightLbl.text = @"经验值";
            self.topLayer.hidden = NO;
            self.bottomLayer.hidden = YES;
            [self.contentView.layer  insertSublayer:self.topLayer atIndex:0];

        }
            break;
        case JHNewFansLevelCellType_Bottom :
        {
            self.leftLine.hidden = YES;
            self.rightLine.hidden = YES;
            self.bottomLine.hidden = YES;
            self.topLayer.hidden = YES;
            self.bottomLayer.hidden = NO;
            [self.contentView.layer  insertSublayer:self.bottomLayer atIndex:0];
        }
            break;

        default:
            break;
    }
}

- (void)refreshLeftText:(NSString *)left andRightText:(NSString *)right{
    self.leftLbl.text = left;
    self.rightLbl.text = right;
}
- (CAShapeLayer *)topLayer{
    if (!_topLayer) {
        CGFloat radius = 5;
        UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 24, 35) byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = path.CGPath;
        maskLayer.strokeColor = HEXCOLOR(0xeeeeee).CGColor;
        maskLayer.fillColor = HEXCOLOR(0xfafafa).CGColor;
        maskLayer.frame = CGRectMake(12, 0, kScreenWidth - 24, 35);
        _topLayer = maskLayer;
    }
    return _topLayer;
}

- (CAShapeLayer *)bottomLayer{
    if (!_bottomLayer) {
        CGFloat radius = 5;
        UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 24, 35) byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = path.CGPath;
        maskLayer.strokeColor = HEXCOLOR(0xeeeeee).CGColor;
        maskLayer.fillColor = HEXCOLOR(0xffffff).CGColor;
        maskLayer.frame = CGRectMake(12, 0, kScreenWidth - 24, 35);
        _bottomLayer = maskLayer;
    }
    return _bottomLayer;
}

@end
