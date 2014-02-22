//
//  ViewController.h
//  drinky
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCameraViewController.h"

@interface ViewController : UIViewController
<DBCameraViewControllerDelegate>
{
    UIImageView *_imageView;
    DBCameraViewController *_cameraController;
}
@property (nonatomic, strong) UIImage *detailImage;
@end
