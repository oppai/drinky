//
//  ViewController.m
//  drinky
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import "ViewController.h"
#import "CustomCamera.h"

@interface ViewController ()<DBCameraViewControllerDelegate>
- (void)detectFace:(NSTimer*)timer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [camera buildIntarface];
    
    _cameraController = [[DBCameraViewController alloc] initWithDelegate:self cameraView:camera];

    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(detectFace:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)detectFace:(NSTimer*)timer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            // TODO:諦めない
            UIView *preview = [[UIView alloc] initWithFrame:[camera.previewLayer frame]];
            [preview.layer insertSublayer:camera.layer atIndex:0];
            UIImage *image = [self convert:preview];

            DrunkDetector *beer = [[DrunkDetector alloc] init];
            [beer calcDrunkess:image];
        });
    });
}

- (UIImage*)convert:(UIView*)sourceView
{
    sourceView.layer.borderWidth = 1.0f;
    sourceView.layer.borderColor = [UIColor blackColor].CGColor;
    sourceView.layer.backgroundColor = [UIColor redColor].CGColor;
    sourceView.layer.cornerRadius = 4.0f;
    
    // UIView を変換して UIView（resultImage）を取得
    UIGraphicsBeginImageContext(sourceView.frame.size);
    [sourceView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_cameraController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mrak - DBCameraViewControllerDelegate

- (void) captureImageDidFinish:(UIImage *)image
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
#endif
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    [detail setDetailImage:image];
    [self.navigationController pushViewController:detail animated:NO];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end