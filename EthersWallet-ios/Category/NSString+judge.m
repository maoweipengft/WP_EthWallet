//
//  NSString+judge.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/27.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "NSString+judge.h"

@implementation NSString (judge)


-(BOOL)isBlank
{
    NSString *str = [self copy];
   // NSLog(@"验证字符串:%@",str);
    if (!str) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

//-(BOOL)isConformPws
//{
//     NSString *str = [self copy];
//   // NSLog(@"密码字符串:%@",str);
//    if ([str isBlank])
//    {
//        NSLog(@"空的");
//        return NO;
//    }
//    
//    if (str.length < 6)
//    {
//        NSLog(@"短的");
//        return NO;
//    }
//    
//    return YES;
//}


-(int)blackClassLblText

{
    NSString *str = [self copy];
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a",@"b", @"c",@"d", @"e",@"f", @"g",@"h", @"i",@"j", @"k",@"l", @"m",@"n", @"o",@"p", @"q",@"r", @"s",@"t", @"u",@"v", @"w",@"x", @"y",@"z", nil];
    
    
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1",@"2", @"3",@"4", @"5",@"6", @"7",@"8", @"9",@"0", nil];
    
    
    
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A",@"B", @"C",@"D", @"E",@"F", @"G",@"H", @"I",@"J", @"K",@"L", @"M",@"N", @"O",@"P", @"Q",@"R", @"S",@"T", @"U",@"V", @"W",@"X", @"Y",@"Z", nil];
    
    
    
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、",nil];
    
    
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:str]];
    
    
    
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:str]];
    
    
    
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:str]];
    
    
    
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:str]];
    
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    
    
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    
    
    
    int intResult=0;
    
    
    
    for (int j=0; j<[resultArray count]; j++)
        
        
        
    {
        
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
            
            
            
        {
            
            intResult++;
            
        }
        
        
        
    }
    
    return intResult;
}

-(BOOL)judgeRange:(NSArray*) _termArray Password:(NSString*) _password

{
    
    NSRange range;
    
    
    
    BOOL result =NO;
    
    
    
    for(int i=0; i<[_termArray count]; i++)
        
        
        
    {
        
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        
        
        
        if(range.location !=NSNotFound)
           
           {
               
               result =YES;
               
           }
           
        }
           
           return result;
           
}
           



@end
