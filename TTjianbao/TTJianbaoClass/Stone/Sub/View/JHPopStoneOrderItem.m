//
//  JHPopStoneOrderItem.m
//  TTjianbao
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPopStoneOrderItem.h"
#import "JHUIFactory.h"
#import "JHStoneMessageModel.h"
@interface JHPopStoneOrderItem ()

@property (nonatomic, assign)BOOL isVer;

@end
@implementation JHPopStoneOrderItem

- (void)awakeFromNib {
    [super awakeFromNib];
}




- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeUI];
        [self makeLayout];
    }
    return self;
}
- (void)makeUI {

    self.coverImg = [JHUIFactory createImageView];
    self.coverImg.image = kDefaultCoverImage;
    self.titleLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.numberOfLines = 2;
    
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"买入价格："];
    
    self.codeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"编号："];
    
    [self addSubview:self.codeLabel];
    [self addSubview:self.coverImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    
    
  

}

- (instancetype)initVer
{
    self = [super init];
    if (self) {
        self.isVer = YES;
        [self makeUI];
        self.shelveLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"货架："];
        [self addSubview:self.shelveLabel];
        [self remakeLayout];
        
        
           
    }
    return self;
}
- (void)makeLayout {
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
          make.leading.top.equalTo(self).offset(10);
          make.width.height.offset(87);
          make.bottom.equalTo(self).offset(-15);
      }];

      [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         
          make.centerY.equalTo(self);
          make.leading.equalTo(self.coverImg.mas_trailing).offset(10);
          make.trailing.equalTo(self).offset(-10);
      }];

      [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
          make.leading.equalTo(self.titleLabel);
      }];

      [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.equalTo(self.titleLabel.mas_top).offset(-5);
          make.leading.equalTo(self.titleLabel);
      }];
      
}
- (void)remakeLayout {
    
    self.priceLabel.preTitle = @"";
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.height.equalTo(self.coverImg.mas_width);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.coverImg.mas_bottom).offset(5);
           make.leading.equalTo(self.coverImg);
        make.height.offset(18);
       }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.coverImg);
    }];
        
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.coverImg);
        make.bottom.equalTo(self).offset(-10);
        make.height.offset(20);
    }];
    
    [self.shelveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeLabel);
        make.leading.equalTo(self.codeLabel.mas_trailing).offset(30);
    }];
       
}

- (void)setModel:(JHStoneMessageModel *)model {
    if ([model isKindOfClass:[JHStoneMessageModel class]]) {
        self.codeLabel.text = model.goodsCode;
        self.titleLabel.text = model.goodsTitle;
        [self.coverImg jhSetImageWithURL:[NSURL URLWithString:model.coverUrl]];
        if (self.shelveLabel) {
            self.shelveLabel.text = model.depositoryLocationCode;
        }
    }else if ([model isKindOfClass:[JHLastSaleGoodsModel class]]) {
        JHLastSaleGoodsModel *m = (JHLastSaleGoodsModel *)model;
        self.codeLabel.text = m.goodsCode;
        self.titleLabel.text = m.goodsTitle;
               
        [self.coverImg jhSetImageWithURL:[NSURL URLWithString:m.goodsUrl]];
               if (self.shelveLabel) {
                   self.shelveLabel.text = model.depositoryLocationCode;
               }
    }
    
//    if (model.dealPrice) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.dealPrice];
//    }
//
//    if (model.salePrice) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.salePrice];
//    }
    
    if (model.purchasePrice) {
           
           if (self.isVer) {
               [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",model.purchasePrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];

           } else {
               self.priceLabel.text = [NSString stringWithFormat:@"%@",model.purchasePrice];

           }
           
       }

    if (model.salePrice) {
        if (self.isVer) {
            [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",model.salePrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];
        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%@",model.salePrice];
        }

    }
    
    if (model.dealPrice) {
        if (self.isVer) {
            [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",model.dealPrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];

        } else {
            self.priceLabel.text = [NSString stringWithFormat:@"%@",model.dealPrice];

        }
           
    }
    
}


@end
