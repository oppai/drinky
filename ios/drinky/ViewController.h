//
//  ViewController.h
//  drinky
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCameraViewController.h"
#import "CustomCamera.h"
#import "EAIntroView.h"
#import "DrunkDetector.h"
#import "AFPhotoEditorController.h"
#import "AFPhotoEditorCustomization.h"

#import "ZYInstapaperActivity.h"
#import "LINEActivity.h"
#import "DMActivityInstagram.h"

@interface ViewController : UIViewController
<EAIntroDelegate>
{
    DBCameraViewController *_cameraController;
    AFPhotoEditorController *_editorController;
    CustomCamera *camera;
}
@end


///////////////////////////////////////////////////
///////////////////////////////////////////////////

@interface DetailViewController : UIViewController {
    UIImageView *_imageView;
}
@property (nonatomic, strong) UIImage *detailImage;
@end

@implementation DetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
#endif
    
    _imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_imageView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.764 blue:0.0 alpha:1.0]];
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
    
    UIButton *back_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back_button setTitle:@"Close" forState:UIControlStateNormal];
    [back_button addTarget:self
                    action:@selector(closeAction)
          forControlEvents:UIControlEventTouchDown];
    back_button.frame = CGRectMake(-20.0, 0.0, 150, 80);
    
    UIButton *share_button = [UIButton buttonWithType:UIButtonTypeSystem];
    [share_button setTitle:@"Share NomBay Photo!" forState:UIControlStateNormal];
    [share_button addTarget:self
                    action:@selector(shareButtonAction)
          forControlEvents:UIControlEventTouchDown];
    share_button.frame = CGRectMake( 0.0,  _imageView.frame.size.height - 80, 300, 80);

    
    [self.view addSubview:back_button];
    [self.view addSubview:share_button];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_imageView setImage:_detailImage];
}

- (void) closeAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAction
{
    // activityItems
    NSString *text  = @"Share your #NomBay - http://nombay.net";
    NSURL    *url   = [NSURL URLWithString:@"http://nombay.net"];
    UIImage  *image = [_imageView image];
    NSArray *activityItems = @[text, url, image];
    
    
    // activities
    DMActivityInstagram  *instagram  = [[DMActivityInstagram alloc] init];
    ZYInstapaperActivity *instapaper = [[ZYInstapaperActivity alloc] init];
    LINEActivity         *line       = [[LINEActivity alloc] init];
    
    NSArray *activities = @[
                            instagram,
                            instapaper,
                            line,
                            ];
    
    // UIActivityViewController
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                               applicationActivities:activities];
    
    // show
    [self presentViewController:activityView animated:YES completion:nil];
}


@end
