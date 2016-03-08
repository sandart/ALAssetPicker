//
//  MBProgressHUD+Show.m
//  WeiBo
//
//  Created by sandArt on 14-11-6.
//  Copyright (c) 2014年 sandArt. All rights reserved.
//

#import "MBProgressHUD+Show.h"

@implementation MBProgressHUD (Show)

+ (void)setMBProgressHUDImageWithName:(NSString *)name andMessage:(NSString *) message ToView:(UIView *)view
{
    MBProgressHUD * hud=  [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    //mode必须写在customView设置之前，MBProgressHUD的小BUG
    hud.mode = MBProgressHUDModeCustomView;
    name = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@",name];
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
}
+(void)showErrorWithText:(NSString *)text ToView:(UIView *)view
{
    [self setMBProgressHUDImageWithName:@"error.png" andMessage:text ToView:view];
}

+(void)showSuccessWithText:(NSString *)text ToView:(UIView *)view
{
    [self setMBProgressHUDImageWithName:@"success.png" andMessage:text ToView:view];
}

+(void)showErrorToWindowWithText:(NSString *)text
{
    [self setMBProgressHUDImageWithName:@"error.png" andMessage:text ToView:[UIApplication sharedApplication].keyWindow];
}

+(void)showSuccessToWindowWithText:(NSString *)text
{
    [self setMBProgressHUDImageWithName:@"success.png" andMessage:text ToView:[UIApplication sharedApplication].keyWindow];
}
@end
