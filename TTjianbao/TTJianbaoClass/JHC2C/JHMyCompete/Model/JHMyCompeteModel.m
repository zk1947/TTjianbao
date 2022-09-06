//
//  JHMyCompeteModel.m
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteModel.h"
#import "NSString+JHCoreOperation.h"

@implementation JHMyCompeteModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productTagList" : [NSString class],
        @"coverImage" : [JHMyCompeteImageInfoModel class],
        @"wantToModel" : [JHMyCompeteWantToModel class],
    };
}

- (CGFloat)itemHeight {

    CGFloat needHeight = !self.coverImage ? 171.0f : 0.0f;
    /// 图片
    needHeight += self.coverImage.aNewHeight;
    /// 标题
//    if (!isEmpty(self.productDesc)) {
        needHeight += self.descHeight;
        
//    }
    /// 标签
//    if (self.labels.count >0) {
//        needHeight += (5.f + 14.f);
//    }
    
    if (self.productTagList.count >0) {
        needHeight += (5.f + 14.f);
    }
    /// 价格
    needHeight += (6.f + 21.f);
    /// 立即付款
    if (self.immediatePaymentHidden == NO || self.auctionStatus == 2 || self.auctionStatus == 3) {
        needHeight += (7.f + 28.f);
    } else {
//        needHeight += self.wantToModel ? (9.f + 14.0f) :  0.0f;
    }
    needHeight += 10.0f;
    return needHeight;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (CGFloat)imageNeedWidth {
    return floor((ScreenW - 12.f*2 - 9.f)/2.f);
}

- (NSString *)jhPrice {
    return self.price;
}

- (NSMutableAttributedString *)attriProductDesc {
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.productDesc];
    if (self.productAuctionStatus == 1) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"c2c_class_publish_logo"];
        attch.bounds = CGRectMake(0, -4, 30, 16);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];
    }
    return attri;
}

- (void)setProductDesc:(NSString *)productDesc {
    _productDesc = [NSString safeGet_ttjb:productDesc];
    CGSize size = [self calculationTextWidthWithWidth:([self imageNeedWidth] - 16.f - 30.f) string:self.productDesc font:[UIFont fontWithName:kFontNormal size:14.f]];
    CGFloat height = floor(size.height) ;
    height = height > 58 ? 58 : height;
    _descHeight = height + 9; // > 18.f ? 48.f : 28.f;
}

- (void)setAuctionStatus:(NSInteger)auctionStatus {
    _auctionStatus = auctionStatus;
    switch (auctionStatus) {
        case 0:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_Stateless;
            break;
        case 1:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_Failure;
            break;
        case 2:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_Out;
            break;
        case 3:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_Leading;
            break;
        case 4:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_InThePat;
            break;
        case 5:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_HasEnded;
            break;
        case 6:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_XiaJia;
            break;
            
        default:
            _auctionStatusType = JHC2CMyCompeteAuctionStatus_Stateless;
            break;
    }
}
- (BOOL)auctionStatusViewHidden {
    if (self.auctionStatusType == JHC2CMyCompeteAuctionStatus_Out ||
        self.auctionStatusType == JHC2CMyCompeteAuctionStatus_Leading ||
        self.auctionStatusType == JHC2CMyCompeteAuctionStatus_InThePat) {
        return NO;
    }
    return YES;
}

- (NSAttributedString *)auctionStatusText {
    
    NSString *title = @"";
    NSString *dec = @"";
    
    if (self.auctionStatusType == JHC2CMyCompeteAuctionStatus_Out) {
        if (self.productAuctionStatus == 1) {
//            dec = @"再出价";
            dec = @"";
        }else {
            dec = @"";
        }
        title = @"出局";
    } else if (self.auctionStatusType == JHC2CMyCompeteAuctionStatus_Leading) {
        title = @"领先";
    } else if (self.auctionStatusType == JHC2CMyCompeteAuctionStatus_InThePat) {
        title = @"成交";
    }
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.0f]};
    NSDictionary *dict = @{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11.0f]};
    
    NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:title attributes:dic];
    if (dec.length > 0) {
        NSMutableAttributedString *cr = [[NSMutableAttributedString alloc] initWithString: @"\n"];
        
        NSMutableAttributedString *adec = [[NSMutableAttributedString alloc] initWithString:dec attributes:dict];
        
        [muta appendAttributedString:cr];
        [muta appendAttributedString:adec];
    }
    
    return muta;
}

- (UIColor *)auctionStatusBackgroundColor {
    
    return self.auctionStatusType == JHC2CMyCompeteAuctionStatus_Leading || self.auctionStatusType == JHC2CMyCompeteAuctionStatus_InThePat ?  HEXCOLORA(0xFF6A00, 0.8) : HEXCOLORA(0x000000, 0.5);
}

- (NSString *)appraisalPictureName {
    NSString *pictureName = @"";
    if (!self.appraisalResult) {
        return pictureName;
    }
    switch (self.appraisalResult) {
          case 0:
            pictureName = @"c2c_goods_zhen_icon";
              break;
          case 1:
            pictureName = @"c2c_goods_fang_icon";
             
              break;
          case 2:
            pictureName = @"c2c_goods_yi_icon";
           
              break;
          case 3:
            pictureName = @"c2c_goods_gongyipin_icon";
              break;
          default:
              break;
      }
    return pictureName;
}

- (JHMyCompeteWantToModel *)wantToModel {
    if (isEmpty(self.userName) && isEmpty(self.userImg) && self.wantCount == 0) {
        return nil;
    }
    JHMyCompeteWantToModel *wantModel = [[JHMyCompeteWantToModel alloc]init];
    wantModel.userName = self.userName;
    wantModel.userImg = self.userImg;
    NSString *wanStr = [NSString stringWithFormat:@"%.1ldw人想要",self.wantCount / 10000];
    NSString *originalStr = [NSString stringWithFormat:@"%ld人想要",self.wantCount];
    wantModel.wantCountStr = self.wantCount > 9999 ? wanStr : originalStr;
    return wantModel;
}

- (BOOL)immediatePaymentHidden {
    
    return (self.auctionStatusType == JHC2CMyCompeteAuctionStatus_InThePat && self.productAuctionStatus == 2 && self.orderStatus < 4) ? NO : YES;
}

///价格处是否一行显示
- (BOOL)isOnelineOfMoney{
    //价格
    CGSize moneySize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:self.price.length>0 ? self.price : @"" font:JHDINBoldFont(18)];
    //出价次数
    NSString *bidNumStr = [self showPriceNumber];
    CGSize bidNumSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:bidNumStr font:JHFont(10)];

    if (moneySize.width + bidNumSize.width > ([self imageNeedWidth]-25)) {
        return YES;
    }
    return NO;
}

- (NSString *)showPriceNumber {
    
    NSString *bidNumTitle = [NSString stringWithFormat:@"已出价%ld次",self.priceNumber];
    NSString *bidNumWan = [NSString stringWithFormat:@"已出价%.1ldw次",self.priceNumber / 10000];
    return self.priceNumber  > 9999 ? bidNumWan : bidNumTitle;
}

- (NSArray<NSString *> *)labels {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    if (self.needFreight == 0) {
        [result addObject:@"包邮"];//arrayByAddingObject:@"包邮"
    }
    if (self.auctionEndStatus == 1) {
         [result addObject:@"即将截拍"];//arrayByAddingObject:@"即将截拍"
    }
    return [result copy];
}

@end

@implementation JHMyCompeteImageInfoModel

- (CGFloat)aNewHeight {
    if (self.width <= 0 || self.height <= 0) {
        return [self imageNeedWidth]*4/3;
    }
    if (self.width == self.height) {
        return [self imageNeedWidth];
    }
    CGFloat whRatio = (self.width / self.height);
    whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
    if (whRatio >= 1) {
        return [self imageNeedWidth];
    } else if (whRatio < 0.75) {
        return [self imageNeedWidth]*4/3;
    } else {
        return [self imageNeedWidth]/whRatio;
    }
}

- (CGFloat)imageNeedWidth {
    return (ScreenW - 12.f*2 - 9.f)/2.f;
}

@end

@implementation JHMyCompeteWantToModel

///用户信息处是否一行显示
- (BOOL)isOnelineOfUserInfo {
    //名字
    CGSize nameSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:self.userName.length > 0 ? self.userName : @"" font:JHFont(10)];
    CGSize wantNumSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:self.wantCountStr font:JHFont(10)];
    if (nameSize.width + wantNumSize.width > ((ScreenW - 12.f*2 - 9.f)/2.f - 43)) {
        return YES;
    }
    return NO;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

@end
