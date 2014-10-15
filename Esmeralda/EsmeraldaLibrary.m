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
    
    NSLog(@"Punts negres inicials : %d",[pointsGesture count]);
    
    // We need to frame the image
    [self getBoundsFromPoints];
    
    newPointsGesture = (CGPoint *) malloc((sizeof(CGPoint)*[pointsGesture count]));
    
    if (newPointsGesture == NULL) {
        
        NSLog(@"Error in getting memory ...");
    
    } else {
        
        // Assign points
        [self assignPoints];
        
        // Change points coordinates
        [self changePoints];
        
        // Create matrix
        int error = [self createMatrix];
        
        if (error == 1) {
            
            NSLog(@"Error in getting memory for matrix");
        
        } else {
            
           // [self drawMatrix];
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
    
    //[self addCustomPoints];
    
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
    
    NSLog(@"Rect : %f,%f %f-%f",rectDraw.origin.x,rectDraw.origin.y,(rectDraw.origin.x+rectDraw.size.width),rectDraw.origin.y+rectDraw.size.height);
    
}

- (void) addCustomPoints {
    
    [pointsGesture removeAllObjects];
    
    CGPoint pointTest;
    pointTest.x = 1;
    pointTest.y = 3;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 0;
    pointTest.y = 4;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 1;
    pointTest.y = 4;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 2;
    pointTest.y = 4;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 1;
    pointTest.y = 5;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 1;
    pointTest.y = 6;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
    pointTest.x = 1;
    pointTest.y = 7;
    
    [pointsGesture addObject:[NSValue valueWithCGPoint:pointTest]];
    
}

- (void) assignPoints {
    
    for (int i = 0 ; i < [pointsGesture count]; i++) {
        
        newPointsGesture[i] = [[pointsGesture objectAtIndex:i]CGPointValue];
        
    }
    
    NSLog(@"Points changed");
    
}

- (void) changePoints {
    
    NSLog(@"Changing points...");
    
    for (int i = 0; i < [pointsGesture count]; i++) {
        
        newPointsGesture[i].x = newPointsGesture[i].x - rectDraw.origin.x;
        newPointsGesture[i].y = newPointsGesture[i].y - rectDraw.origin.y;

    }
}

/*- (int)  createMatrix {
    
    int error = 0;
    
    int lines = ((int)rectDraw.size.height+1);
    int columns = (((int)rectDraw.size.width+1));
    
    // Define matrixDraw from rectDraw (lines*columns)
    matrixDraw = (int *)malloc((lines * lines +  columns) * sizeof(int));
    
    NSLog(@"Total caselles : %d",lines*columns);
    
    if (matrixDraw == NULL) {
        
        error = 1;
        
    } else {
        
        NSLog(@"Matrix [%d][%d]",lines,columns);
        
       // NSLog(@"-----------------------------------------------");
   
        int i = 0,j = 0;
        
        for (i = 0; i < lines; i++)
        {
            for (j = 0; j < columns; j++)
            {
               //NSLog(@"i : %d j: %d total : %d",i,j,i*lines+j);
                
                if ([self isPoint:i andJ:j] == 1) {
                    
                    matrixDraw[i*lines + j] = 1;
                    
                } else {
                    
                    matrixDraw[i*lines + j] = 0;

                }
             //   printf("%d",matrixDraw[i*lines + j]);

            }
            
          //  printf("\n");
        }
        
       // NSLog(@"-----------------------------------------------");


        
    }
    
    return error;

}*/

- (int) createMatrix {
    
    
    CGSize size = CGSizeMake((int)rectDraw.size.width+1, (int)rectDraw.size.height+1);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGMutablePathRef path = CGPathCreateMutable();
    
    UIBezierPath *bp = [UIBezierPath bezierPath];
    [bp moveToPoint:(CGPoint){newPointsGesture[0].x, newPointsGesture[0].y}];
    
    for (int i = 1; i < [pointsGesture count]; i++) {
        [bp addLineToPoint:(CGPoint){newPointsGesture[i].x, newPointsGesture[i].y}];
    }
    
    CGPathAddPath(path, nil, bp.CGPath);
    
   // CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddPath(context, path);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);

    //CGContextAddPath(context, path);
    

    //CGContextFillPath(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, 1.0f);
    
    UIImage *imageFinal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImage:imageFinal];
    
    return 0;
}
- (int)  isPoint:(int)pointI andJ:(int)pointJ {
    
    int ok = 0;
    
    for (int u = 0; u < [pointsGesture count] && ok == 0; u++) {
        
        if ((int)newPointsGesture[u].y == pointI && (int)newPointsGesture[u].x == pointJ) {
            
            ok = 1;
            
        } else {
            
            ok = 0;
        }
    }
    
    return ok;
}

#pragma mark - Drawing methods
- (void) drawMatrix {
    
    NSLog(@"Drawing matrix...");
    
    int lines = ((int)rectDraw.size.height+1);
    int columns = (((int)rectDraw.size.width+1));
    
    CGSize size = CGSizeMake(lines, columns);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    int puntsNegres = 0;
    for (int i = 0; i < lines; i++)
    {
        for (int j = 0; j < columns; j++)
        {
            // Draw current point
            if ( matrixDraw[i*lines + j] == 1 ) {
                
                puntsNegres = puntsNegres + 1;
                [[UIColor blackColor] setFill];
                UIRectFill(CGRectMake(i, j, 1, 1));
                
            } else {
                
                [[UIColor whiteColor] setFill];
                UIRectFill(CGRectMake(i, j, 1, 1));
                
            }
            
        }
    }
    
    
    NSLog(@"Punts negre : %d",puntsNegres);
    
    UIImage *imageFinal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImage:imageFinal];
    
    }

- (CGPoint) midPoint:(CGPoint)p1 with2:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (CGPoint) returnMidPointWitX1:(int)x1 Y1:(int)y1 X2:(int)x2 Y2:(int)y2 {
    
    return CGPointMake((x1 + x2) * 0.5, (y1+ y2) * 0.5);
}
- (void) saveImage: (UIImage *)myImage{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *myImageData = UIImageJPEGRepresentation(myImage, 1.0);
    [fileManager createFileAtPath:@"/Users/Marc/Desktop/tryImage.jpg" contents:myImageData attributes:nil];
}
@end
