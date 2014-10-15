//
//  EsmeraldaView.m
//  Esmeralda
//
//  Created by Marc on 14/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import "EsmeraldaView.h"

@implementation EsmeraldaView {
    
    EsmeraldaLibrary *recognizer;
}

- (id) init {
    
    if (self = [super init]) {
    
        NSLog(@"1 - Init Esmeralda View normal");
        
        [self configure];
    }
    
    return self;
}

#pragma mark - Configuration
- (void) configure {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // Esmeralda library init
    recognizer = [[EsmeraldaLibrary alloc]init];
    
}

#pragma mark - Touches methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *firstTouch = [touches anyObject];
    
    // Location point
    CGPoint firstPoint = [firstTouch locationInView:self];
    
    firstPoint.x = (int)firstPoint.x;
    firstPoint.y = (int)firstPoint.y;
    
    [recognizer addPointGesture:firstPoint];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *movedTouch = [touches anyObject];
    
    CGPoint movedPoint = [movedTouch locationInView:self];
    
    movedPoint.x = (int)movedPoint.x;
    movedPoint.y = (int)movedPoint.y;
    

    
    [recognizer addPointGesture:movedPoint];

    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *endTouch = [touches anyObject];
    
    CGPoint endPoint = [endTouch locationInView:self];
    endPoint.x = (int)endPoint.x;
    endPoint.y = (int)endPoint.y;

    [recognizer addPointGesture:endPoint];
    [recognizer startRecognizer];
    
}





@end
