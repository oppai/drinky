//
//  CustomCamera.h
//  DBCamera
//
//  Created by iBo on 05/02/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBCameraView.h"
#import "DrunkDetector.h"

@interface CustomCamera : DBCameraView
<DBCameraViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
- (void) buildIntarface;
@end