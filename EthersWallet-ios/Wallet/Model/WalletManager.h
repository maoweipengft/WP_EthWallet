//
//  WalletManager.h
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/27.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WalletManager : NSObject


/**
 * 新建钱包
 */
+(void)createWithPassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block;



/**
 *使用助记词导入钱包 (不需要用到原密码,这里用的是一个新密码)
 *mnemonics 助记词 12个英文单词 空格分割
 */
+(void)inportMnemonics:(NSString *)mnemonics PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block;



/**
 *使用KeyStore导入钱包 (需要用到原密码来进行解密)
 *keyStore keyStore
 */
+(void)importKeyStore:(NSString *)keyStore PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block;



/**
 *使用私钥导入钱包 (不需要用到原密码,这里用的是一个新密码)
 */
+(void)importWalletForPrivateKey:(NSString *)privateKey PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block;




/**
 *查询余额
 *address 钱包地址
 */
+(void)getBalancewithAddress:(NSString *)address block:(void(^)(NSString *))block;



/**
 *查询交易记录
 */
+(void)getTransactionwithAddress:(NSString *)address block:(void(^)(NSArray *))block;

/**
 *转账
 *toAddress 转入地址
 *amount 数量
 *tokenETH 代币token 传nil为eth
 *decimal 小数位数
 *keyStore keyStore
 *gasPrice gasPrice （建议10-20）建议传nil，默认位当前节点安全gasPrice
 *gasLimit gasLimit 不传 默认eth 21000 token 60000
 */
+(void)sendToAssress:(NSString *)toAddress amount:(NSString *)amount tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal currentKeyStore:(NSString *)keyStore PassWord:(NSString *)pwd gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr,BOOL success,NSString *ErrorMessage))block;



@end

