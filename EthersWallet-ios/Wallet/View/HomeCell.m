//
//  HomeCell.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "HomeCell.h"
#import "WalletManager.h"
@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.layer.shadowOpacity = 0.6;
    
    self.layer.shadowRadius = 2.0;
    
    self.layer.shouldRasterize = YES;
    
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CGPathRef path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height, [UIScreen mainScreen].bounds.size.width,2)].CGPath;
    
    [self.layer setShadowPath:path];
    
}

-(void)setModel:(AccountModel *)model
{
    _model = model;
    __weak typeof(self)weakself = self;
    [WalletManager getBalancewithAddress:model.address.checksumAddress block:^(NSString *balance) {
        NSLog(@"balance:%@",balance);
        weakself.numberLabel.text = balance;
    }];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    
    
//    CGContextSetStrokeColorWithColor(context,  [UIcolor Extern hexStringToColor:@"e5e5e5"].CGColor);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:243/255. green:243/255. blue:243/255. alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(14, rect.size.height - 0.5, rect.size.width-14, 0.5));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
