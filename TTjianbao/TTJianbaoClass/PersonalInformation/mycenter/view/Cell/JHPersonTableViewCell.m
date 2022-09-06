//
//  JHPersonTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHMyCenterDotModel.h"
#import "JHPersonTableViewCell.h"
#import <NSString+YYAdd.h>
#import "JHMySectionModel.h"
#import "JHMyCenterDotNumView.h"

@interface JHPersonTableViewCell ()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UILabel *redPoint;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *rightLine;
@property (nonatomic, weak) JHMyCenterDotNumView *dotView;

@end

@implementation JHPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _imageIcon = [UIImageView new];
        _imageIcon.contentMode = UIViewContentModeScaleAspectFit;
                
        self.labelTitle = [UILabel new];
        self.labelTitle.font = [UIFont fontWithName:kFontMedium size:11];
        self.labelTitle.textColor = HEXCOLOR(0x333333);
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        self.labelTitle.numberOfLines = 2;
        
        self.countLabel = [UILabel new];
        self.countLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        self.countLabel.textColor = HEXCOLOR(0x666666);
                
        self.redPoint = [UILabel new];
        self.redPoint.backgroundColor = HEXCOLOR(0xFE4200);
        self.redPoint.layer.cornerRadius = 3.5;
        self.redPoint.layer.masksToBounds = YES;
        self.redPoint.hidden = YES;

        ///订单需要加竖线
        UIImageView * line = [[UIImageView alloc] init];
        line.image = [UIImage imageNamed:@"icon_my_left_line"];
        line.contentMode = UIViewContentModeScaleAspectFit;
        _rightLine.hidden = YES;
        _rightLine = line;
        
        [self.contentView addSubview:line];
        [self.contentView addSubview:_imageIcon];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.redPoint];
        
        [_imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];

        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageIcon.mas_bottom).offset(6);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.mas_greaterThanOrEqualTo(-2);
        }];

        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.labelTitle.mas_bottom).offset(2);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(7));
            make.bottom.equalTo(self.imageIcon.mas_top);
            make.centerX.equalTo(self.imageIcon.mas_right).offset(4);
        }];
         
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(30, 80));
        }];
        
        JHMyCenterDotNumView *dotView = [JHMyCenterDotNumView new];
        [self.contentView addSubview:dotView];
        _dotView = dotView;
        [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageIcon.mas_centerX).offset(4);
            make.top.equalTo(_imageIcon.mas_centerY).offset(-20);
        }];
        dotView.hidden = YES;
        
    }
    return self;
}

- (void)setModel:(JHMyCellModel *)model {
    _model = model;
    self.labelTitle.text = model.title;
    self.imageIcon.image = [UIImage imageNamed:model.iconName];
    self.imageIcon.hidden = ![model.iconName isNotBlank];
    self.countLabel.text = model.countString;
    
    self.rightLine.hidden = !model.isShowRightLine;
    
    self.redPoint.hidden = YES;
    self.dotView.hidden = YES;
    if (model.isUpdateIconSize) {
        [_imageIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(8);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        self.dotView.hidden = !model.isShowRedDot;
    }else{
        [_imageIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        self.redPoint.hidden = NO;
    }
    

    
    switch (_model.redMessageType) {
            //待付款
            case JHMyCenterRedPointWillPay:
            {
                self.dotView.number = [JHMyCenterDotModel shareInstance].buyerWaitPayCount;
            }
                break;
            //待收货
            case JHMyCenterRedPointWillReceive:
            {
                self.dotView.number = [JHMyCenterDotModel shareInstance].waitReceivedCount;
            }
                break;
            //待评价
            case JHMyCenterRedPointWillComment:
            {
                self.dotView.number = [JHMyCenterDotModel shareInstance].waitEvaluateCount;
            }
                break;
            
            case JHMyCenterRedPointOtherBid:
            {
                self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].offerCount <= 0);
            }
                break;
            
            case JHMyCenterRedPointMyBid:
            {
                self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].myOfferCount <= 0);
            }
                break;
        
            //定制订单
        case JHMyCenterCustomRedPointWaitPay:
        {
            self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].customRedPointWaitPayCount <= 0);
        }
            break;
        case JHMyCenterCustomRedPointInProcess:
        {
            self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].customRedPointInProcessCount <= 0);
        }
            break;
        case JHMyCenterCustomRedPointWaitReceive:
        {
            self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].customRedPointWaitReceiveCount <= 0);
        }
            break;
        case JHMyCenterCustomRedPointFinish:
        {
            self.redPoint.hidden = ([JHMyCenterDotModel shareInstance].CustomRedPointFinishCount <= 0);
        }
            break;
        case JHMyCenterMerchantRecycleMySoldCount:
        {
            self.redPoint.hidden = YES;
            self.dotView.number =  [JHMyCenterDotModel shareInstance].recycleMySoldCount;
        }
            break;
        case JHMyCenterMerchantRecycleMyPublishCount:
        {
            self.redPoint.hidden = YES;
            self.dotView.number = [JHMyCenterDotModel shareInstance].recycleMyPublishCount;
        }
            break;
        default:
        {
            self.redPoint.hidden = YES;
        }
            break;
    }
}
@end
