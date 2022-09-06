//
//  JHHotSearchCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SearchWordsType) {
    SearchWordsTypeHistory = 0, // 历史搜索
    SearchWordsTypeHot          // 热门搜索
};

@class JHHotSearchCell;
@protocol JHHotSearchCellDelegate <NSObject>
@optional
- (void)clickHotLabelChangeValue:(NSString*)hotTitle searchWordsType:(SearchWordsType)searchWordsType andindex:(NSInteger)index;
- (void)deleteHotKey:(NSInteger)index;
- (void)expandBtnAction;
@end

@interface JHHotSearchCell : UITableViewCell{
    CGSize sizeFit;

}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) NSIndexPath * indexpath;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withArr:(NSMutableArray*_Nullable)arr withHotTagArr:(NSMutableArray *_Nullable)hotTagArr andSearchType:(SearchWordsType)type andisexpandL:(BOOL)isexpand;
@property (nonatomic,weak)id<JHHotSearchCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
