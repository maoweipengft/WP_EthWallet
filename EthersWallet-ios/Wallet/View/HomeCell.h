//
//  HomeCell.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *UnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong ,nonatomic) AccountModel *model;

@end
