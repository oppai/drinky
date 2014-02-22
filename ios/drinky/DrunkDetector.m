//
//  DrunkDetector.m
//  drinky
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import "DrunkDetector.h"

@implementation DrunkDetector

- (id)init
{
    if(self = [super init]){
        NSDictionary *detectorOptions = @{
            CIDetectorTracking:@YES,
            CIDetectorAccuracy:CIDetectorAccuracyLow,
        };
        faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                          context:nil
                                          options:detectorOptions];
    }
    return self;
}

- (CGFloat)calcDrunkess:(UIImage *)_image
{
    CIImage *image = [[CIImage alloc] initWithImage:_image];
    
    NSDictionary *detect_option = @{
        CIDetectorImageOrientation:[NSNumber numberWithInt:PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP],
        CIDetectorSmile:@YES,
        CIDetectorEyeBlink:@YES
    };
    
    NSArray *features = [faceDetector featuresInImage:image options:detect_option];
    for (CIFaceFeature *ff in features) {
        NSLog(@"---------------------------");
        NSLog(@"%d",ff.trackingID);
        NSLog(@"%u",ff.hasRightEyePosition);
        NSLog(@"%u",ff.hasLeftEyePosition);
        NSLog(@"%u",ff.rightEyeClosed);
        NSLog(@"%u",ff.leftEyeClosed);
        NSLog(@"%u",ff.hasMouthPosition);
        NSLog(@"%u",ff.hasSmile);
    }

    return 0.0f;
}
@end
