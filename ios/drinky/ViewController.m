//
//  ViewController.m
//  drinky
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import "ViewController.h"
#import "CustomCamera.h"

@interface ViewController ()
<DBCameraViewControllerDelegate,AFPhotoEditorControllerDelegate>
- (void)detectFace:(NSTimer*)timer;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [camera buildIntarface];
    
    _cameraController = [[DBCameraViewController alloc] initWithDelegate:self cameraView:camera];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:_cameraController animated:NO];
    
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRunning"];
    if(!([value isKindOfClass:[NSString class]] && [value isEqualToString:@"NO"])){
        [self showIntro];
    }
    
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
//            UIView *preview = [[UIView alloc] initWithFrame:[camera.previewLayer frame]];
//            [preview.layer insertSublayer:camera.layer atIndex:0];
//            UIImage *image = [self convert:preview];
//
//            DrunkDetector *beer = [[DrunkDetector alloc] init];
//            [beer calcDrunkess:image];
        });
    });
}

- (UIImage*)convertView:(UIView*)sourceView
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

-(UIImage*)pressImage:(UIImage*)background
          composeImage:(UIImage*)stamp
                 x:(NSInteger)x
                y:(NSInteger)y
{
    CGFloat backWidth = CGImageGetWidth(background.CGImage);
    CGFloat backHeight = CGImageGetHeight(background.CGImage);
    
    CGFloat stampWidth = CGImageGetWidth(stamp.CGImage);
    CGFloat stampHeight = CGImageGetHeight(stamp.CGImage);
    
    
    UIGraphicsBeginImageContext(CGSizeMake(backWidth, backHeight));
    [background drawInRect:CGRectMake(0, 0, backWidth, backHeight)];
    [stamp drawInRect:CGRectMake(0, 0, stampWidth, stampHeight)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)showIntro {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.titleColor = [UIColor blackColor];
    page1.title = @"NomBay.net";
    page1.titlePositionY = 340;
    page1.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:40];
    page1.descColor = [UIColor whiteColor];
    page1.desc = @"酔っぱらって..\n もっと盛り上げる!";
    page1.descPositionY = 210;
    page1.descFont = [UIFont fontWithName:@"HiraKakuProN-W3" size:20];
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"酔っぱらってる?";
    page2.titlePositionY = 240;
    page2.titleFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:35];
    page2.desc =  @"友達にカメラをかざすと... \n どれだけ酔っぱらっているかわかる!";
    page2.descPositionY = 200;
    page2.descFont = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"簡単に編集して...";
    page3.titlePositionY = 240;
    page3.titleFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:35];
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"SNSで共有しよう!";
    page4.titlePositionY = 140;
    page4.titleFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:32];
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds];
    [intro setDelegate:self];
    [intro setPages:@[page1,page2,page3,page4]];
    [intro showInView:_cameraController.view animateDuration:0.0];
}

# pragma mmark - EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO"
                                              forKey:@"FirstRunning"];
}

# pragma mmark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mrak - DBCameraViewControllerDelegate

- (void) captureImageDidFinish:(UIImage *)image
{
//    DrunkDetector *beer = [[DrunkDetector alloc] init];
//    NSArray *items = [beer calcDrunkess:image];
//    for (NSDictionary *item in items) {
//        NSLog(@"%@",[item description]);
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:24];
//        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:60];
//        label.text = [NSString stringWithFormat:@"LEVEL %@",[item valueForKey:@"level"]];
//        
//        CGRect rect = [[item valueForKey:@"bounds"] CGRectValue];
//        image = [self pressImage:image composeImage:[self convertView:label]
//                       x:rect.origin.x y:(rect.origin.y - rect.size.height)];
//    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
#endif
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    _editorController = [[AFPhotoEditorController alloc] initWithImage:image];
    [_editorController setDelegate:self];
    [self presentViewController:_editorController animated:YES completion:nil];
}

#pragma mark - AFPhotoEditorControllerDelegate

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [_editorController dismissViewControllerAnimated:YES
                                          completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    [detail setDetailImage:image];
    [self.navigationController pushViewController:detail animated:NO];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancellation here
    [_editorController dismissViewControllerAnimated:YES
                                          completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end