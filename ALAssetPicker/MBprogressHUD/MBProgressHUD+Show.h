//
//  MBProgressHUD+Show.h
//  WeiBo
//
//  Created by sandArt on 14-11-6.
//  Copyright (c) 2014年 sandArt. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Show)
+(void)showErrorWithText:(NSString *)text ToView:(UIView *)view;
+(void)showSuccessWithText:(NSString *)text ToView:(UIView *)view;

+(void)showErrorToWindowWithText:(NSString *)text;
+(void)showSuccessToWindowWithText:(NSString *)text;
@end
