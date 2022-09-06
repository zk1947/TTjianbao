//
//  NSMutableAttributedString+Html.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Html)

+ (NSMutableAttributedString *)yd_loadHtmlString:(NSString *)htmlString;

@end

NS_ASSUME_NONNULL_END
