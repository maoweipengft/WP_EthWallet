//
//  WalletDetailsViewController.m
//  EthersWallet-ios
//
//  Created by weipeng.mao on 2018/8/3.
//  Copyright © 2018年 weipeng.mao. All rights reserved.
//

#import "WalletDetailsViewController.h"
#import "WHC_ModelSqlite.h"
#import "AccountModel.h"
#import "WalletManager.h"
@interface WalletDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIImageView *QrcodeImgaeView;

@end

@implementation WalletDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
        AccountModel * account =_model;
        [_addressButton setTitle:account.address.checksumAddress forState:UIControlStateNormal];
    self.title = [NSString stringWithFormat:@"%@ eth",_balnce];
        if (!account.QrCodeDate)
        {
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            NSString *urlStr = [NSString stringWithFormat:@"eth:%@",account.address.checksumAddress];
            NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
            [filter setValue:data forKey:@"inputMessage"];
            CIImage *outputImage = [filter outputImage];
            
            self.QrcodeImgaeView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.view.frame.size.width-140];
            account.QrCodeDate = UIImageJPEGRepresentation(self.QrcodeImgaeView.image,1);
            [WHC_ModelSqlite update:account where:nil];
            
            
        }
        else
        {
            self.QrcodeImgaeView.image = [UIImage imageWithData:account.QrCodeDate];
        }
    
    [WalletManager getBalancewithAddress:account.address.checksumAddress block:^(NSString *balnce) {
        self.title = [NSString stringWithFormat:@"%@ eth",balnce];
    }];
        
        
        

    
    
}



- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
