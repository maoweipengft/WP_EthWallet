//
//  WalletManager.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/7/27.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "WalletManager.h"
#import <ethers/ethers.h>
#import "NSString+judge.h"
#import "MJExtension.h"
#import "WHC_ModelSqlite.h"
#import "AccountModel.h"
#import "KeychainItemWrapper.h"
#import "SimpleManager.h"
@implementation WalletManager

#pragma mark - 创建钱包

+(void)createWithPassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block
{
    
    if (pwd.length <6)
    {
        block(nil,nil,nil,nil,NO,@"密码长度不对");
        return;
    }
    
    //生成随意密钥
    Account *account = [Account randomMnemonicAccount];
    
    [WHC_ModelSqlite delete:[AccountModel class] where:nil];
    __weak typeof(self)weakSelf = self;
    //keystore
    [account encryptSecretStorageJSON:pwd callback:^(NSString *json)
     {
         NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
         //地址
         NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
         
         //私钥
         NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
         
         [weakSelf StorageAccount:account password:pwd];//储存账户信息
    
         KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
         [keychain setObject:json forKey:(id)kSecValueData]; //存储keystore
         
         //回调
         block(addressStr,json,account.mnemonicPhrase,privateKeyStr,YES,nil);
     }];
    
}



#pragma mark - 导入钱包
//助记词导入
+(void)inportMnemonics:(NSString *)mnemonics PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block
{
    //没有输入
    if ([mnemonics isBlank] || mnemonics.length< 1)
    {
        block(@"",@"",@"",@"",NO,@"请输入助记词");
        return;
    }
    
    //密码长度不对
    if (pwd.length <6)
    {
        block(@"",@"",@"",@"",NO,@"请输入6位以上的密码");
        return;
    }
    
    //助记词不完整
    NSArray *arrayMnemonics = [mnemonics componentsSeparatedByString:@" "];
    if (arrayMnemonics.count != 12)
    {
        block(@"",@"",@"",@"",NO,@"助记词错误:12个英文单词,空格分割");
        return;
    }
    
    
    //检验助记词是否符合标准
    for (NSString *m in arrayMnemonics)
    {
        if (![Account isValidMnemonicWord:m])
        {
            NSString *msg = [NSString stringWithFormat:@"助记词 %@ 有误", m];
           
            block(@"",@"",@"",@"",NO,msg);
            return;
        }
    }
    
    
    //检验助记词对错
    if (![Account isValidMnemonicPhrase:mnemonics])
    {
        block(@"",@"",@"",@"",NO,@"助记词错误");
        return;
    }
    
    
    //根据助记词生成钱包
     Account *account = [Account accountWithMnemonicPhrase:mnemonics];
    
    [WHC_ModelSqlite delete:[Account class] where:nil];
    
    __weak typeof(self)weakSelf = self;
    //生成keystore
    [account encryptSecretStorageJSON:pwd callback:^(NSString *json)
     {
         NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
         //地址
         NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
         
         //私钥
         NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
         
         [weakSelf StorageAccount:account password:pwd];//储存账户信息
         
         KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
         [keychain setObject:json forKey:(id)kSecValueData]; //存储keystore
         
         
         //回调
         block(addressStr,json,account.mnemonicPhrase,privateKeyStr,YES,nil);
         
     }];
    
    
}


//使用keystore导入钱包
+(void)importKeyStore:(NSString *)keyStore PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block;
{
    if (pwd.length < 6)
    {
        block(@"",@"",@"",@"",NO,@"请输入6位以上的密码");
        return;
    }
    
    if (keyStore.length < 1)
    {
        block(@"",@"",@"",@"",NO,@"keystore错误:内容有误");
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    
    //解密
    [Account decryptSecretStorageJSON:keyStore password:pwd callback:^(Account *account, NSError *NSError)
    {
        if (!NSError)
        {
            [WHC_ModelSqlite delete:[Account class] where:nil];
            //加密并且保存
            [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
                
                NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
                
                //地址
                NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
                
                //私钥
                NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
                
                [weakSelf StorageAccount:account password:pwd];//储存账户信息
                
                KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
                [keychain setObject:json forKey:(id)kSecValueData]; //存储keystore
                
                //回调
                block(addressStr,json,account.mnemonicPhrase,privateKeyStr,YES,nil);
                
            }];
        }
        
        else
        {
            block(@"",@"",@"",@"",NO,@"keyStore解密失败");
        }
        
        
        
    }];

}

+(void)importWalletForPrivateKey:(NSString *)privateKey PassWord:(NSString *)pwd block:(void(^)(NSString *address,NSString *keyStore,NSString *mnemonicPhrase,NSString *privateKey,BOOL success,NSString *ErrorMessage))block
{
    if (privateKey.length < 1)
    {
        block(@"",@"",@"",@"",NO,nil);
        return;
    }
    
    if (pwd.length < 6)
    {
        block(@"",@"",@"",@"",NO,@"请输入6位以上的密码");
        return;
    }
    
    //解密私钥
    Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[privateKey hasPrefix:@"0x"]?privateKey:[@"0x" stringByAppendingString:privateKey]]];
    
    [WHC_ModelSqlite delete:[Account class] where:nil];

    __weak typeof(self)weakSelf = self;
    //生成keystore
    [account encryptSecretStorageJSON:pwd callback:^(NSString *json)
     {
         NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
         //地址
         NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
         
         //私钥
         NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
         
         
         [weakSelf StorageAccount:account password:pwd];//储存账户信息
         
         KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"ethers.mwp" accessGroup:nil];
         [keychain setObject:json forKey:(id)kSecValueData]; //存储keystore
         
         //回调
         block(addressStr,json,account.mnemonicPhrase,privateKeyStr,YES,nil);
     }];
}

#pragma mark - 查询余额
+(void)getBalancewithAddress:(NSString *)address block:(void(^)(NSString *))block
{
    //校验地址长度
    if (address.length != 42)
    {
        NSLog(@"%@ 地址错误",address);
        block(@"0");
        return;
    }
    
    //初始化查询器
    EtherscanProvider * scanner = [[EtherscanProvider alloc]initWithChainId:ChainIdHomestead];
    
    //初始化ETH地址
    Address * addressObjc = [Address addressWithString:address];
    [[scanner getBalance:addressObjc] onCompletion:^(BigNumberPromise *promise)
    {
         NSString *balance = [Payment formatEther:promise.value
                     options:(EtherFormatOptionCommify | EtherFormatOptionApproximate)];
        
        block(balance);
        
    }];
}

+(void)getTransactionwithAddress:(NSString *)address block:(void(^)(NSArray *))block
{
    //校验地址长度
    if (address.length != 42)
    {
        NSLog(@"%@ 地址错误",address);
        block(nil);
        return;
    }
    
    __weak typeof(self)weakself = self;
    Provider *provider = [[Provider alloc]initWithChainId:ChainIdHomestead];
    Address * addressObjc = [Address addressWithString:address];
    ArrayPromise *transactionPromise = [provider getTransactions:addressObjc startBlockTag:0];
    
    [transactionPromise onCompletion:^(ArrayPromise *promise)
    {
        if (!promise.result || promise.error)
        {
            block(nil);
            return;
        }
      NSArray *allTransaction = [weakself _setTransactionHistory:promise.value];
        
        block(allTransaction);
    }];
    
    
    
}


+(void)sendToAssress:(NSString *)toAddress amount:(NSString *)amount tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal currentKeyStore:(NSString *)keyStore PassWord:(NSString *)pwd gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr,BOOL success,NSString *ErrorMessage))block
{
    //创建账号
    __block Account * senderAccount;
    __block EtherscanProvider * queryManager = [[EtherscanProvider alloc]initWithChainId:ChainIdRopsten apiKey:@"EnzWrJh0nqFufb0bv2ka"];
    
    //从keystore获取发送人地址
    NSData *jsonData = [keyStore dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    __block NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
    
    
    //从发送人地址，创建交易对象
    __block Transaction * transactionManager = [Transaction transactionWithFromAddress:[Address addressWithString:addressStr]];
    
    
    //获取私钥
    [Account decryptSecretStorageJSON:keyStore password:pwd callback:^(Account *account, NSError *NSError)
    {
        if (!NSError)
        {
            
            NSLog(@"查看错误信息:%@",NSError);
            senderAccount = account;
            
            //查询交易记录
            [[queryManager getTransactionCount:transactionManager.fromAddress] onCompletion:^(IntegerPromise *pro) {
                if (pro.error != nil)
                {
                    NSLog(@"%@获取nonce失败",pro.error);
                    
                    block(@"",NO,@"创建交易失败");
                }
                
                else
                {
                    NSLog(@"获取nonce成功 值为%ld",pro.value);
                    transactionManager.nonce = pro.value;
                    
                    //查询Gas
                    [[queryManager getGasPrice] onCompletion:^(BigNumberPromise *proGasPrice) {
                        if (!proGasPrice.error)
                        {
                            if (gasPrice == nil)
                            {
                                NSLog(@"使用默认的GAS");
                                transactionManager.gasPrice = proGasPrice.value;
                            }
                            else
                            {
                                NSLog(@"手动设置了gasPrice = %@",gasPrice);
                                
                                transactionManager.gasPrice = [[BigNumber bigNumberWithDecimalString:gasPrice] mul:[BigNumber bigNumberWithDecimalString:@"1000000000"]];;
                                
                            }
                            
                            //设置chainID
                            transactionManager.chainId = queryManager.chainId;
                            
                            //设置收件人地址
                            transactionManager.toAddress = [Address addressWithString:toAddress];
                            
                            //设置转账数量
                            NSInteger i = amount.doubleValue * pow(10.0, decimal.integerValue);
                            BigNumber *b = [BigNumber bigNumberWithInteger:i];
                            transactionManager.value = b;
                            
                            //默认ETH币
                            if (tokenETH == nil)
                            {
                                
                                if (gasLimit == nil)
                                {
                                    
                                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
                                }
                                else
                                {
                                    
                                    NSLog(@"手动设置了gasLimit = %@",gasLimit);
                                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                                }
                                
                                
                                transactionManager.data = [SecureData secureDataWithCapacity:0].data;
                                
                            }
                            
                            else
                            {
                                if (gasLimit == nil)
                                {
                                    
                                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];
                                }
                                else
                                {
                                    NSLog(@"手动设置了gasLimit = %@",gasLimit);
                                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                                }
                                
                                
                                
                                SecureData *data = [SecureData secureDataWithCapacity:68];
                                [data appendData:[SecureData hexStringToData:@"0xa9059cbb"]];
                                
                                NSData *dataAddress = transactionManager.toAddress.data;//转入地址（真实代币转入地址添加到data里面）
                                for (int i=0; i < 32 - dataAddress.length; i++)
                                {
                                    [data appendByte:'\0'];
                                }
                                
                                [data appendData:dataAddress];
                                
                                NSData *valueData = transactionManager.value.data;//真实代币交易数量添加到data里面
                                for (int i=0; i < 32 - valueData.length; i++)
                                {
                                    [data appendByte:'\0'];
                                }
                                [data appendData:valueData];
                                
                                transactionManager.value = [BigNumber constantZero];
                                transactionManager.data = data.data;
                                transactionManager.toAddress = [Address addressWithString:tokenETH];//合约地址（代币交易 转入地址为合约地址）
                            }
                            
                            //设置签名
                            [senderAccount sign:transactionManager];
                            
                            NSData * signedTransaction = [transactionManager serialize];
                            
                            //转账
                            [[queryManager sendTransaction:signedTransaction] onCompletion:^(HashPromise *pro)
                            {
                                 NSLog(@"CloudKeychainSigner: Sent - signed=%@ hash=%@ error=%@", signedTransaction, pro.value, pro.error);
                                if (!pro.error)
                                {
                                    NSLog(@"\n---------------【生成转账交易成功！！！！】--------------\n哈希值 = %@\n",transactionManager.transactionHash.hexString);
                                    NSLog(@"哈希值 =  %@",pro.value.hexString);
                                     block(pro.value.hexString,YES,@"发送成功");
                                    
                                }
                                else
                                {
                                    block(@"",NO,@"发送失败");
                                }
                                
                            }];
                            
                            
                        }
                        else
                        {
                             block(@"",NO,@"发送失败");
                        }
                        
                    }];
                    
                }
                
            }];
        }
        else
        {
            NSLog(@"密码错误%@",NSError);
            block(@"",NO,@"密码错误");
        }
    }];
    
    
    
}

+(NSArray *)_setTransactionHistory:(NSArray<TransactionInfo*>*)transactionHistory
{
    NSMutableArray<TransactionInfo*> *transactions = [transactionHistory mutableCopy];
    
    //这里按照时间排序
    [transactions sortUsingComparator:^NSComparisonResult(TransactionInfo *a, TransactionInfo *b) {
        if (a.timestamp > b.timestamp) {
            return NSOrderedAscending;
        } if (a.timestamp < b.timestamp) {
            return NSOrderedDescending;
        } else if (a.timestamp == b.timestamp) {
            if (a.hash < b.hash) {
                return NSOrderedAscending;
            } if (a.hash > b.hash) {
                return NSOrderedDescending;
            }
        }
        return NSOrderedSame;
    }];
    
      BOOL truncatedTransactionHistory = NO;
    if (transactions.count > 100) {
        truncatedTransactionHistory = YES;
        [transactions removeObjectsInRange:NSMakeRange(100, transactions.count - 100)];
    }
    
     NSMutableArray *changedTransactions = [NSMutableArray array];
     NSMutableArray *serialized = [NSMutableArray arrayWithCapacity:transactions.count];
    
    for (TransactionInfo *entry in transactions) {
        
        [serialized addObject:[entry dictionaryRepresentation]];
        
        [changedTransactions addObject:entry];
    }
    if (changedTransactions.count)
    {
        return [changedTransactions copy];
    }
    return nil;
    
}




+(void)StorageAccount:(Account *)account password:(NSString *)pwd
{
    AccountModel *model = [[AccountModel alloc]init];
    AddressModel *address =[[AddressModel alloc]init];
    model.password = pwd;
    model.privateKey = account.privateKey;
    model.mnemonicPhrase = account.mnemonicPhrase;
    model.mnemonicData = account.mnemonicData;
    address.checksumAddress = account.address.checksumAddress;
    address.icapAddress = account.address.icapAddress;
    address.data = account.address.data;
    model.address = address;
    [WHC_ModelSqlite insert:model];
    
    SimpleManager *simple=[SimpleManager shareInstance];
    simple.Unlock = YES;
    
    
    
}


@end
