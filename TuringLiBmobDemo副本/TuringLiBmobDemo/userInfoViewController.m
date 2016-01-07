//
//  userInfoViewController.m
//  TuringLiBmobDemo
//
//  Created by 千锋 on 16/1/7.
//  Copyright (c) 2016年 TuringLi. All rights reserved.
//

#import "userInfoViewController.h"
#import <BmobSDK/BmobProFile.h>
#import <UIImageView+WebCache.h>
typedef NS_ENUM(NSInteger, chosePhotoType) {
    ChosePhotoTypeAlbum,
    ChosePhotoTypeCamera
};

@interface userInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userInfo;
@property (weak, nonatomic) IBOutlet UIButton *loginOut;

@end

@implementation userInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *urlStr = [user objectForKey:@"userIconUrl"];
    [self.userInfo sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginOut:(UIButton *)sender {
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你真的要退？" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *quit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancel];
    [alert addAction:quit];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (IBAction)userInfoTapAction:(UITapGestureRecognizer *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chosePhoto:ChosePhotoTypeAlbum];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chosePhoto:ChosePhotoTypeCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)chosePhoto:(chosePhotoType)type
{
    UIImagePickerController *piker = [[UIImagePickerController alloc] init];
    piker.delegate = self;
    if (type == ChosePhotoTypeAlbum) {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (type == ChosePhotoTypeCamera)
    {
        piker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        [SVProgressHUD showErrorWithStatus:@"相机不可用"];
        return;
    }
    [self presentViewController:piker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImageWithImage:img];
    }];
}

- (void)uploadImageWithImage:(UIImage *)img
{
    NSData *data = UIImagePNGRepresentation(img);
    [SVProgressHUD showWithStatus:@"上传图片..."];
    [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            NSLog(@"url=%@",url);
            NSLog(@"file = %@", file);
            
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:file.url forKey:@"userIconUrl"];
            
            [user updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
                if (isSuc) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    [self.userInfo sd_setImageWithURL:[NSURL URLWithString:file.url]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:[err localizedDescription]];
                }
            }];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    } progress:^(CGFloat progress) {
        // 上传进度
        [SVProgressHUD showProgress:progress];
    }];
    
}
@end
