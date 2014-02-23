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
}


- (UIImage*)convertView:(UIView*)sourceView
{
    sourceView.layer.borderWidth = 1.0f;
    sourceView.layer.borderColor = [UIColor blackColor].CGColor;
    sourceView.layer.backgroundColor = [UIColor clearColor].CGColor;
    sourceView.layer.cornerRadius = 4.0f;
    
    // UIView を変換して UIView（resultImage）を取得
    UIGraphicsBeginImageContext(sourceView.frame.size);
    [sourceView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

-(UIImage*)getWImage:(UIImage*)bottomImage frontImage:(UIImage*)frontImage{
    int width = bottomImage.size.width;
    int height = bottomImage.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [frontImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    NSInteger level = 0;
    DrunkDetector *beer = [[DrunkDetector alloc] init];
    NSArray *items = [beer calcDrunkess:image];
    for (NSDictionary *item in items) {
        NSLog(@"%@",[item description]);
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont systemFontOfSize:24];
//        label.textColor = [UIColor whiteColor];
//        label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:60];
//        label.text = [NSString stringWithFormat:@"LEVEL %@",[item valueForKey:@"level"]];
//        label.frame = CGRectMake(label.frame.origin.x, , <#CGFloat width#>, <#CGFloat height#>)
//        CGRect rect = [[item valueForKey:@"bounds"] CGRectValue];
//        image = [self pressImage:image composeImage:[self convertView:label]
//                       x:rect.origin.x y:(rect.origin.y - rect.size.height)];
        level += [[item valueForKey:@"level"] integerValue];
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:200];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    label.text = [NSString stringWithFormat:@"NomBay LEVEL %u",level];
    [label setFrame:(CGRect){ image.size.width*0.1, image.size.height*0.8,image.size.width *0.8, image.size.height*0.2}];
    
    UIView *view2 = [[UIView alloc] initWithFrame:(CGRect){ 0, 0,image.size.width, image.size.height}];
    [view2 setBackgroundColor:[UIColor clearColor]];
    [view2 addSubview:label];
    
    UIImage *new_image = [self getWImage:image frontImage:[self convertView:view2]];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
#endif
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    _editorController = [[AFPhotoEditorController alloc] initWithImage:new_image];
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