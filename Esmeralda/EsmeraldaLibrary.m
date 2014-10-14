//
//  EsmeraldaLibrary.m
//  Esmeralda
//
//  Created by Marc on 14/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import "EsmeraldaLibrary.h"

@implementation EsmeraldaLibrary {
    
    NSMutableArray *pointsGesture;
    CGPoint *newPointsGesture;
    int *matrixDraw;
    NSMutableArray *prova; //PROVA
    CGRect rectDraw;

}


- (id) init {
    
    if (self = [super init]) {
        
        NSLog(@"2 - Init Esmeralda Library");
        [self configure];
    }
    
    return self;
}

#pragma mark - Recognizer configuration methods
- (void) configure {
    
    pointsGesture = [[NSMutableArray alloc]init];
}

- (void) addPointGesture:(CGPoint) pointGesture {
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointGesture]];
    
}

- (void) finishGesture {
    
    [pointsGesture removeAllObjects];
    rectDraw.origin.x = 0;
    rectDraw.origin.y = 0;
    rectDraw.size.width = 0;
    rectDraw.size.height = 0;
    
    free(newPointsGesture);
    free(matrixDraw);
}

#pragma mark - Recognizer
- (void) startRecognizer {
    
    // We need to frame the image
    [self getBoundsFromPointsProva];
    
    newPointsGesture = (CGPoint *) malloc((sizeof(CGPoint)*[prova count]));
    
    if (newPointsGesture == NULL) {
        
        NSLog(@"Error in getting memory ...");
    
    } else {
        
        // Assign points
        [self assignPoints];
        
        // Change points coordinates
        [self changePoints];
        
        NSLog(@"New points...");
        
        for (int i = 0; i < [prova count]; i++) {
            
            NSLog(@"%d %d",(int)newPointsGesture[i].x,(int)newPointsGesture[i].y);
        
        }
        
        NSLog(@"Drawing matrix..");
        
        
        // Create matrix
        int error = [self createMatrix];
        
        if (error == 1) {
            NSLog(@"Error in getting memory for matrix");
        } else {
            
            [self scaleMatrix];
        }
    }
    
    [self finishGesture];
}

#pragma mark - Auxiliar methods for image recognition
- (void) getBoundsFromPoints {
    
    CGPoint start,end;
    int  i = 0;
        
    start.x = 9999; // x1
    start.y = 9999; // y1
        
    end.x = 0;      // x2
    end.y = 0;      // y2
        
    for (i = 0; i < [pointsGesture count]; i++)
    {
        // Get current point of the drawing
        CGPoint currentPoint = [[pointsGesture objectAtIndex:i]CGPointValue];
            
        // Determine x1,y1 and x2,y2
        if (currentPoint.x < start.x)   start.x = currentPoint.x;
            
        if (currentPoint.x > end.x)     end.x = currentPoint.x;
            
        if (currentPoint.y < start.y)   start.y = currentPoint.y;
            
        if (currentPoint.y > end.y)     end.y = currentPoint.y;
            
    }
        
    rectDraw = CGRectMake(start.x, start.y, (end.x - start.x), (end.y - start.y));
    
    NSLog(@"Rect : %f %f %f %f",rectDraw.origin.x,rectDraw.origin.y,(rectDraw.origin.x+rectDraw.size.width),rectDraw.origin.y+rectDraw.size.height);
    
}

- (void) getBoundsFromPointsProva {
    
    CGPoint start,end;
    int  i = 0;
    
    start.x = 9999; // x1
    start.y = 9999; // y1
    
    end.x = 0;      // x2
    end.y = 0;      // y2
    
    prova = [[NSMutableArray alloc]init];
    CGPoint pointTest;
    pointTest.x = 5;
    pointTest.y = 3;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 5;
    pointTest.y = 4;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 6;
    pointTest.y = 4;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 7;
    pointTest.y = 4;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 8;
    pointTest.y = 4;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 8;
    pointTest.y = 5;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 8;
    pointTest.y = 6;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 8;
    pointTest.y = 7;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 7;
    pointTest.y = 7;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 6;
    pointTest.y = 7;
    
    [prova addObject:[NSValue valueWithCGPoint:pointTest]];
    
    
    for (i = 0; i < [prova count]; i++)
    {
        // Get current point of the drawing
        CGPoint currentPoint = [[prova objectAtIndex:i]CGPointValue];
        
        NSLog(@"Prova %d : %f %f",i,currentPoint.x,currentPoint.y);
        
        // Determine x1,y1 and x2,y2
        if (currentPoint.x < start.x)   start.x = currentPoint.x;
        
        if (currentPoint.x > end.x)     end.x = currentPoint.x;
        
        if (currentPoint.y < start.y)   start.y = currentPoint.y;
        
        if (currentPoint.y > end.y)     end.y = currentPoint.y;
        
    }
    
    rectDraw = CGRectMake(start.x, start.y, (end.x - start.x), (end.y - start.y));
    
    NSLog(@"Rect : %f %f %f %f",rectDraw.origin.x,rectDraw.origin.y,(rectDraw.origin.x+rectDraw.size.width),rectDraw.origin.y+rectDraw.size.height);
    
}

- (void) assignPoints {
    
    for(int i = 0 ; i < [prova count]; i++) {
        
        newPointsGesture[i] = [[prova objectAtIndex:i]CGPointValue];
        
        NSLog(@"New points gesture %i : %f %f",i,newPointsGesture[i].x,newPointsGesture[i].y);
    }
    
    NSLog(@"Points changed");
    
}

- (void) changePoints {
    
    NSLog(@"Changing points...");
    
    for (int i = 0; i < [prova count]; i++) {
        
        newPointsGesture[i].x = newPointsGesture[i].x - rectDraw.origin.x;
        newPointsGesture[i].y = newPointsGesture[i].y - rectDraw.origin.y;

    }
}

- (int)  createMatrix {
    
    int error = 0;
    
    // Define matrixDraw from rectDraw (lines*columns)
    matrixDraw = (int *)malloc(((int)rectDraw.size.height+1) * (((int)rectDraw.size.width+1) * sizeof(int)));
    
    if (matrixDraw == NULL) {
        
        error = 1;
        
    } else {
        
        NSLog(@"Matrix created : fila %d   columna %d ",(int)rectDraw.size.height,(int)rectDraw.size.width);
        
        int i = 0;
        int j = 0;
        for (int i = 0; i < ((int)rectDraw.size.height+1); i++)
        {
            for (int j = 0; j < ((int)rectDraw.size.width+1); j++)
            {
                if ([self isPoint:i andJ:j] == 1) {
                    
                    matrixDraw[i*(int)rectDraw.size.height + j] = 1;
                    
                } else {
                    matrixDraw[i*(int)rectDraw.size.height + j] = 0;

                }
            }
        }
        
        // Assign points to matrix
        for (i = 0; i < ((int)rectDraw.size.height+1); i++)
        {
            for (j = 0; j < ((int)rectDraw.size.width+1); j++)
            {
                printf("%d",matrixDraw[i*(int)rectDraw.size.height + j]);
            }
            printf("\n");
        }
        
        
        
        
    }
    
    return error;

}

- (int) isPoint:(int)pointI andJ:(int)pointJ {
    
    int ok = 0;
    
    for (int u = 0; u < [prova count] && ok == 0; u++) {
        
        NSLog(@"Comparing %d-%d / %d-%d", (int)newPointsGesture[u].x,pointI,(int)newPointsGesture[u].y,pointJ);
        
        if ((int)newPointsGesture[u].y == pointI && (int)newPointsGesture[u].x == pointJ) {
            
            ok = 1;
            
        } else {
            
            ok = 0;
        }
    }
    return ok;
}
- (void) scaleMatrix {
    
    NSLog(@"Scaling matrix...");
}

@end
