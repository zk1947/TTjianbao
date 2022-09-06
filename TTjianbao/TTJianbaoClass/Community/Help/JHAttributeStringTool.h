//
//  JHAttributeStringTool.h
//  test
//
//  Created by 王记伟 on 2020/11/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kCallStringRegex = @"@[^\\s]{1,20}+";

#define kHighLightColor  HEXCOLOR(0x408FFE)

static NSInteger const kMax_CallTextCount = 21;

typedef NS_ENUM(NSInteger, JHAttributePageFrom) {
    JHAttributePageFromList = 0,
    JHAttributePageFromComment,
    JHAttributePageFromPostDetail,
};

typedef NS_ENUM(NSInteger, LinkResourceType) {
    ///文字
    LinkResourceTypeText = 1,
    ///图片
    LinkResourceTypeImage = 2,
    ///视频
    LinkResourceTypeVideo = 3,
};

#define kToUserInfoPage  @"kToUserInfoPage"

@interface LinkStringModel : NSObject
/** 名字*/
@property (nonatomic, copy) NSString *sub_text;
/** 是否是跳转链接*/
@property (nonatomic, copy) NSString *sub_type;
/** 跳转对象*/
@property (nonatomic, copy) NSString *data_value;
@end

@interface LinkResourceModel : NSObject
///资源类型
@property (nonatomic, assign) LinkResourceType type;
@property (nonatomic, copy) NSDictionary *data;

@end


@interface JHAttributeStringTool : NSObject

/// mark - 该工具适合特定数据下,将数组内的数据组合成富文本格式,分为单段落和多段落,传入的数据格式不一样,请知晓

/// 单段落富文本
/// @param array 数组
/// @param normalColor 颜色
/// @param font 字体
/// @param logoSize logo的size
+ (NSMutableAttributedString *)getOneParagraphAttributeStringWithArray:(NSArray *)array
                                                           normalColor:(UIColor *)normalColor
                                                                  font:(UIFont *)font
                                                              logoSize:(CGSize )logoSize;

/// 多段落富文本
/// @param array 数组
/// @param normalColor 颜色
/// @param font 字体
/// @param logoSize logo的size
+ (NSMutableAttributedString *)getMoreParagraphAttributeStringWithArray:(NSArray *)array
                                                            normalColor:(UIColor *)normalColor
                                                                   font:(UIFont *)font
                                                               logoSize:(CGSize )logoSize;


/// 给@后面的文字加高亮显示
/// @param attributedString 传入富文本
+ (NSMutableAttributedString *)markAtBlue:(NSMutableAttributedString *)attributedString;
+ (NSMutableAttributedString *)markAtBlueForPostDetail:(NSMutableAttributedString *)attributedString;

+ (NSMutableAttributedString *)getOneParagraphAttrForPostDetail:(NSArray *)array normalColor:(UIColor *)normalColor font:(UIFont *)font logoSize:(CGSize )logoSize;

+ (NSMutableAttributedString *)getMoreParagraphAttributeStringWithArray:(NSArray *)array
                                                            normalColor:(UIColor *)normalColor
                                                                   font:(UIFont *)font
                                                               logoSize:(CGSize )logoSize
                                                               pageFrom:(JHAttributePageFrom)pageFrom;

+ (void)matchHighLightText:(NSMutableAttributedString *)text;


/// 判断文字内是否有输入@
/// @param callString 需要校验的文字
+ (BOOL)hasCallUser:(NSString *)callString;

@end


