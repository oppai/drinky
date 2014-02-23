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
        faceHighDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                          context:nil
                                          options:@{
                              CIDetectorTracking:@YES,
                              CIDetectorAccuracy:CIDetectorAccuracyHigh,
                              }];
        faceLowDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                        context:nil
                                        options:@{
                            CIDetectorTracking:@YES,
                            CIDetectorAccuracy:CIDetectorAccuracyLow,
                            }];
    }
    return self;
}

/**
 *  (NSArray *)calcDrunkess:(UIImage *)_image
 *    return ex:
 *    ({
 *      bounds = "NSRect: {{1638.375, 376.125}, {828.75, 828.75}}";
 *      level = 0;
 *    })
 */
- (NSArray *)calcDrunkess:(UIImage *)_image
{
    NSMutableArray *result = [NSMutableArray array];
    CIImage *image = [[CIImage alloc] initWithImage:_image];
    
    NSDictionary *detect_option = @{
        CIDetectorImageOrientation:[NSNumber numberWithInt:PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP],
        CIDetectorSmile:@YES,
        CIDetectorEyeBlink:@YES
    };
    
    NSArray *features_h = [faceHighDetector
                         featuresInImage:image
                         options:detect_option];
    NSArray *features_l = [faceLowDetector
                           featuresInImage:image
                           options:detect_option];

    if ([features_h count] == [features_l count]){
        for (CIFaceFeature *hf in features_h) {
            NSInteger i = [features_h indexOfObject:hf];
            CIFaceFeature *lf = [features_l objectAtIndex:i];
            int accuracy = 0, blind = 0, smile = 0;
            
            if( (hf.hasLeftEyePosition && hf.hasRightEyePosition) ||
               (hf.hasLeftEyePosition && hf.hasMouthPosition) ||
               (hf.hasRightEyePosition && hf.hasMouthPosition) ){
                accuracy += 1;
            }
            
            if( (lf.hasLeftEyePosition && lf.hasRightEyePosition) ||
               (lf.hasLeftEyePosition && lf.hasMouthPosition) ||
               (lf.hasRightEyePosition && lf.hasMouthPosition) ){
                accuracy += 1;
            }
            
            if ( hf.rightEyeClosed ){
                blind += 1;
            }
            
            if ( lf.rightEyeClosed ){
                blind += 1;
            }
            
            if ( hf.hasSmile ){
                smile += 1;
            }
            
            if ( lf.hasSmile ){
                smile += 1;
            }
            
            NSDictionary *data = @{
                @"level":[NSNumber numberWithInt:1+(2-accuracy)+blind+smile],
                @"bounds":[NSValue valueWithCGRect:hf.bounds]
            };
            [result addObject:data];
        }
    }

    return result;
}

@end
