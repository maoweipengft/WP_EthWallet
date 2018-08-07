//
//  HHShowView.h
//  Alert
//
//  Created by 花花 on 2017/12/9.
//  Copyright © 2017年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>
#define showView_Width [UIScreen mainScreen].bounds.size.width * 0.8
#define showView_Height 225

//按钮
typedef NS_ENUM(NSUInteger, HHAlertActionStyle) {
    HHAlertActionCancel, //取消
    HHAlertActionConfirm, //确认
    
};
@interface HHAlertAction:NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) HHAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@property(nonatomic,copy)void(^handler)(HHAlertAction *);
+ (instancetype)actionTitle:(NSString *)title style:(HHAlertActionStyle)style handler:(void(^)(HHAlertAction *action))handler;

@end

@interface HHShowView : UIView

//btn Color
@property(nonatomic,strong)UIColor *butttonCancelBgColor;
@property(nonatomic,strong)UIColor *butttonConfirmBgColor;
// Method
+ (instancetype)alertTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(HHAlertAction *)action;

-(void)show;

-(void)hide;

@end


