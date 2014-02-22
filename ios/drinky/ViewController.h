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
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_imageView];
    
    UIButton *back_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back_button setTitle:@"Close" forState:UIControlStateNormal];
    [back_button addTarget:self
                    action:@selector(closeAction)
          forControlEvents:UIControlEventTouchDown];
    back_button.frame = CGRectMake(-20.0, 0.0, 150, 80);
    
    [self.view addSubview:back_button];
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

@end
