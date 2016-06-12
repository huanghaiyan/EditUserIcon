//
//  ViewController.m
//  EditUserIcon
//
//  Created by 黄海燕 on 16/6/12.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "RSKImageCropper.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define HEIGHT [[UIScreen mainScreen]bounds].size.height
#define KWIDTH [[UIScreen mainScreen]bounds].size.width

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
{
    UIImagePickerControllerSourceType _sourceType;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)senderPhoto:(id)sender {
    UIAlertController * alertCtroller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //do something
        // 拍照
        _sourceType = UIImagePickerControllerSourceTypeCamera;
        [self selectPhoto];

    }];
 
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      
        //do something
        // 相册
        _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self selectPhoto];

      
    }];
   
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      
        //do something
      
    }];
   
    [alertCtroller addAction:firstAction];
 
    [alertCtroller addAction:secondAction];

    [alertCtroller addAction:thirdAction];
    
    [self presentViewController:alertCtroller animated:YES completion:nil];
    
}

#pragma mark - 照片选择
- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
        // 照片的选择工作
        
        // 实例化照片选择控制器
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        // 设置选择控制器的属性

        // 设置照片源
        [picker setSourceType:_sourceType];
        NSMutableArray * mediaTypes = [[NSMutableArray alloc]init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        picker.mediaTypes = mediaTypes;
        [picker setDelegate:self];
        
        // 显示选择控制器
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        NSLog(@"照片源不可用");
    }
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage * portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:portraitImg cropMode:RSKImageCropModeCircle];
        imageCropVC.delegate = self;
        [self presentViewController:imageCropVC animated:YES completion:nil];
    }];
    
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    [self.iconImage setImage:croppedImage];
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
