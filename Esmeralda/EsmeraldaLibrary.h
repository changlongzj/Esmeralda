//
//  EsmeraldaLibrary.h
//  Esmeralda
//
//  Created by Marc on 14/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBDD.h"

#define MAX_WIDTH 400
#define MAX_HEIGHT 400
#define kNN 8

typedef struct {
    
    float distance;
    int tipus; // 0 - rodona, 1 - triangle ...

} Coincidence;

typedef struct {
    
    int profilesX[MAX_WIDTH];
    int profilesY[MAX_HEIGHT];
    
} ProfilesImage;

@interface EsmeraldaLibrary : NSObject

#pragma mark - Esmeralda settings methods
- (void) addPointGesture:(CGPoint) pointGesture;

- (void) startRecognizerWithCompletion:(void (^)(int))completionBlock;

- (ProfilesImage) getProfilesForJSON: (UIImage *) myImage;

@end
