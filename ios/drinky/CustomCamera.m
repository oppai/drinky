//
//  CustomCamera.m
//  DBCamera
//
//  Created by iBo on 05/02/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "CustomCamera.h"

@interface CustomCamera (){
}
@property (nonatomic, strong) UIButton *triggerButton,*closeButton;
@property (nonatomic, strong) CALayer *focusBox, *exposeBox;
@property (nonatomic, strong) UILabel *levelLabel;
@end

@implementation CustomCamera

- (void) buildIntarface
{
    //[self addSubview:self.closeButton];
    [self addSubview:self.triggerButton];
    [self addSubview:self.levelLabel];
    
    [self.previewLayer addSublayer:self.focusBox];
    [self.previewLayer addSublayer:self.exposeBox];
    
    [self createGesture];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(detectFace:)
                                   userInfo:nil
                                    repeats:YES];
}


- (void)detectFace:(NSTimer*)timer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_sync(dispatch_get_main_queue(), ^{
//            DrunkDetector *beer = [[DrunkDetector alloc] init];
//            NSArray *array = [beer calcDrunkess:[self convertView:self.previewLayer]];
//            NSLog(@"%@",[array description]);
        });
    });
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

- (UILabel *) levelLabel
{
    if( !_levelLabel ){
        NSInteger level = 0;
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.font = [UIFont systemFontOfSize:24];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _levelLabel.text = [NSString stringWithFormat:@"NomBay Level  ?"];
        [_levelLabel setFrame:(CGRect){ CGRectGetMidX(self.bounds) - 150, CGRectGetMaxY(self.frame) - 85 - 100, 300, 80 }];
    }
    return _levelLabel;
}

- (UIButton *) triggerButton
{
    if ( !_triggerButton ) {
        _triggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_triggerButton setBackgroundColor:[UIColor whiteColor]];
        [_triggerButton setImage:[UIImage imageNamed:@"trigger"] forState:UIControlStateNormal];
        [_triggerButton setFrame:(CGRect){ CGRectGetMidX(self.bounds) - 35, CGRectGetMaxY(self.frame) - 85, 70, 70 }];
        [_triggerButton.layer setCornerRadius:35.0f];
        [_triggerButton addTarget:self action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _triggerButton;
}

- (UIButton *) closeButton
{
    if ( !_closeButton ) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundColor:[UIColor redColor]];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton setFrame:(CGRect){ CGRectGetMidX(self.bounds) - 15, 17.5f, 30, 30 }];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (void) close
{
    if ( [self.delegate respondsToSelector:@selector(closeCamera)] )
        [self.delegate closeCamera];
}

#pragma mark - Focus / Expose Box

- (CALayer *) focusBox
{
    if ( !_focusBox ) {
        _focusBox = [[CALayer alloc] init];
        [_focusBox setCornerRadius:45.0f];
        [_focusBox setBounds:CGRectMake(0.0f, 0.0f, 90, 90)];
        [_focusBox setBorderWidth:5.f];
        [_focusBox setBorderColor:[[UIColor whiteColor] CGColor]];
        [_focusBox setOpacity:0];
    }
    
    return _focusBox;
}

- (CALayer *) exposeBox
{
    if ( !_exposeBox ) {
        _exposeBox = [[CALayer alloc] init];
        [_exposeBox setCornerRadius:55.0f];
        [_exposeBox setBounds:CGRectMake(0.0f, 0.0f, 110, 110)];
        [_exposeBox setBorderWidth:5.f];
        [_exposeBox setBorderColor:[[UIColor redColor] CGColor]];
        [_exposeBox setOpacity:0];
    }
    
    return _exposeBox;
}

- (void) drawFocusBoxAtPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    [super draw:_focusBox atPointOfInterest:point andRemove:remove];
}

- (void) drawExposeBoxAtPointOfInterest:(CGPoint)point andRemove:(BOOL)remove
{
    [super draw:_exposeBox atPointOfInterest:point andRemove:remove];
}

#pragma mark - Gestures

- (void) createGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( tapToFocus: )];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( tapToExpose: )];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void) tapToFocus:(UIGestureRecognizer *)recognizer
{
    CGPoint tempPoint = (CGPoint)[recognizer locationInView:self];
    if ( [self.delegate respondsToSelector:@selector(cameraView:focusAtPoint:)] && CGRectContainsPoint(self.previewLayer.frame, tempPoint) )
        [self.delegate cameraView:self focusAtPoint:(CGPoint){ tempPoint.x, tempPoint.y - CGRectGetMinY(self.previewLayer.frame) }];
}

- (void) tapToExpose:(UIGestureRecognizer *)recognizer
{
    CGPoint tempPoint = (CGPoint)[recognizer locationInView:self];
    if ( [self.delegate respondsToSelector:@selector(cameraView:exposeAtPoint:)] && CGRectContainsPoint(self.previewLayer.frame, tempPoint) )
        [self.delegate cameraView:self exposeAtPoint:(CGPoint){ tempPoint.x, tempPoint.y - CGRectGetMinY(self.previewLayer.frame) }];
}

#pragma mar - Trigger

- (void) triggerAction:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(cameraViewStartRecording)] )
        [self.delegate cameraViewStartRecording];
}

@end
