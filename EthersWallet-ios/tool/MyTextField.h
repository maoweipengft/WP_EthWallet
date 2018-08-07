//
//  MyTextField.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextField : UITextField

@property (nonatomic , copy) NSString *leftTitle;

@property (nonatomic , strong) UIColor *leftTitleColor;

@property (nonatomic , strong) UIColor *placeholderColor;

@property (nonatomic , strong) UIFont *placeholderFont;

@end
