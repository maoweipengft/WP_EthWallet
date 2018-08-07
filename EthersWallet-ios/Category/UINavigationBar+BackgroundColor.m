//
//  UINavigationBar+BackgroundColor.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"

@implementation UINavigationBar (BackgroundColor)


-(void)setNavColor:(UIColor *)color
{
    UIView *colorView = [[UIView alloc]initWithFrame:self.bounds];
    colorView.backgroundColor = color;
    [self setBackgroundImage:[self convertViewToImage:colorView] forBarMetrics:UIBarMetricsDefault];
    
}


- (UIImage*)convertViewToImage:(UIView *)_tempView {
    CGSize s = _tempView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [_tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
