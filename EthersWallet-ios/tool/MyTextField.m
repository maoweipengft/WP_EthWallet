//
//  MyTextField.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/30.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "MyTextField.h"

@interface MyTextField()
@property (nonatomic , strong) UILabel *textLabel;


@end
@implementation MyTextField

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.];
        
        self.leftView = label;
        
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.textLabel = label;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.];
        self.leftView = label;
        
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.textLabel = label;
    }
    return self;

}


- (CGRect)leftViewRectForBounds:(CGRect)bounds

{
    [super leftViewRectForBounds:bounds];
    
    CGRect frame = bounds;
    
    frame.size.width = bounds.size.width * 0.3;
    
    
    
    return frame;
    
}

- (void)drawRect:(CGRect)rect

{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] set];
    
    CGFloat y = CGRectGetHeight(self.frame);
    
    CGContextMoveToPoint(context, 0, y);
    
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), y);
    
    //设置线的宽度
    
    CGContextSetLineWidth(context, 2);
    
    //渲染 显示到self上
    
    CGContextStrokePath(context);
    
}


#pragma mark - set
- (void)setPlaceholderColor:(UIColor *)placeholderColor

{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[NSForegroundColorAttributeName] = placeholderColor;
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    
    [self setAttributedPlaceholder:attribute];
    
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont

{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[NSFontAttributeName] = placeholderFont;
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    
    [self setAttributedPlaceholder:attribute];
    
}

- (void)setLeftTitleColor:(UIColor *)leftTitleColor

{
    
    _leftTitleColor = leftTitleColor;
    
    [_textLabel setTextColor:leftTitleColor];
    
}

- (void)setLeftTitle:(NSString *)leftTitle

{
    
    _leftTitle = leftTitle;
    
    [_textLabel setText:leftTitle];
    
}

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//
//}



@end
