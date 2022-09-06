//
//  JHLiveRoomPKHeaderView.h
//  TTjianbao
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomPKHeaderButton : UIButton

@end

@protocol JHLiveRoomPKHeaderViewDelegate <NSObject>
-(void)categoryBtnAction:(UIButton*)button andTypeStr:(NSString*)typeStr;

@end
@interface JHLiveRoomPKHeaderView : UIImageView
@property (nonatomic,strong)NSMutableArray *categoryTitleArray;
@property (nonatomic,strong)NSMutableArray *categoryTypeArray;
@property(nonatomic,weak)id <JHLiveRoomPKHeaderViewDelegate>delegate;

- (void)creatCategoryViwe;
- (void)resetBgViewimage:(NSString*)typeStr;
- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
