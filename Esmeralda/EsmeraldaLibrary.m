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
    CGRect rectDraw;
    int profilesX[400];
    int profilesY[400];
    Coincidence bestMatches[kNN];
    int numberEntries;
    int typeGesture;
    NSMutableArray *arrayX;
    NSMutableArray *arrayY;

}

#pragma mark - Init 

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
    
    // Init best matches for kNN
    numberEntries = 0;
    int i = 0;
    for (i = 0 ; i < kNN; i++) {
        bestMatches[i].distance = -1;
        bestMatches[i].tipus = -1;
    }
    
    typeGesture = -1;
    
    arrayX = [[NSMutableArray alloc]init];
    arrayY = [[NSMutableArray alloc]init];
    

    
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
    
    // Init arrays for profiles
    for (int i = 0; i < MAX_WIDTH; i++)
        profilesX[i] = 0;
    
    for (int i = 0; i < MAX_HEIGHT; i++)
        profilesY[i] = 0;
    
    free(newPointsGesture);
    
    // Init best matches for kNN
    numberEntries = 0;
    int i = 0;
    for (i = 0 ; i < kNN; i++) {
        bestMatches[i].distance = -1;
        bestMatches[i].tipus = -1;
    }
    
    typeGesture = -1;
    
    
}


#pragma mark - Recognizer

- (void) startRecognizerWithCompletion:(void (^)(int))completionBlock {
    
    
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
        
        // Create image
        UIImage *imageDraw = [self createImage];
        
        // For checking creating
       // [self saveImage:imageDraw withName:@"/Users/Marc/Desktop/creating.jpg"];
        
        // Resize image to MAX_WIDTH MAX_HEIGTH
        UIImage *imageResized = [self resizeImage:imageDraw];
        
        // For checking resizing
        //[self saveImageInAlbum:imageResized];
        //[self saveImage:imageResized withName:@"/Users/Marc/Desktop/resizing.jpg"];
        

        [self getProfiles:imageResized];
        
        NSLog(@"Type gesture no recognised : %d",typeGesture);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            typeGesture = [self startAnalysis];
            completionBlock(typeGesture);
            [self finishGesture];

        });
       
        
        
    }
    
    
}


#pragma mark - Auxiliar methods

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
    
   // NSLog(@"Rect : %f,%f %f-%f",rectDraw.origin.x,rectDraw.origin.y,(rectDraw.origin.x+rectDraw.size.width),rectDraw.origin.y+rectDraw.size.height);
    
}

- (void) assignPoints {
    
    for (int i = 0 ; i < [pointsGesture count]; i++) {
        
        newPointsGesture[i] = [[pointsGesture objectAtIndex:i]CGPointValue];
        
    }
    
}

- (void) changePoints {
    
    for (int i = 0; i < [pointsGesture count]; i++) {
        
        newPointsGesture[i].x = newPointsGesture[i].x - rectDraw.origin.x;
        newPointsGesture[i].y = newPointsGesture[i].y - rectDraw.origin.y;
        
    }
}

- (void) showProfiles {
    
    
    NSLog(@"------------ X -------------");
    for (int i = 0; i < MAX_WIDTH; i++) {
        
        NSLog(@"%d",profilesY[i]);
        
    }
    
    NSLog(@"------------ Y -------------");
    for (int i = 0; i < MAX_HEIGHT; i++) {
        
        NSLog(@"%d",profilesX[i]);
        
    }
    
    
}


#pragma mark - Image methods

- (UIImage *) createImage {
    
    
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
    CGContextAddPath(context, path);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, 1.0f);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (void) saveImage:(UIImage *) myImage  withName:(NSString *)imageName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *myImageData = UIImageJPEGRepresentation(myImage, 1.0);
    [fileManager createFileAtPath:imageName contents:myImageData attributes:nil];
}

- (void)    saveImageInAlbum:(UIImage *) myImage {
    
    // Save image in photo album
    UIImageWriteToSavedPhotosAlbum(myImage,
                                   nil,
                                   nil,
                                   nil);
    
    
    
}

- (UIImage *) resizeImage:(UIImage *) myImage{
    
    CGSize newSize;
    newSize.width = MAX_WIDTH;
    newSize.height = MAX_HEIGHT;
    
    // 1.0 if we want width height no matter retina
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
   // NSLog(@"Resizing to %f %f",newSize.width,newSize.height);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (void) getProfiles: (UIImage *) myImage{
    
    CGImageRef imageRef = [myImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //NSLog(@"Width %lu Height %lu",(unsigned long)width,(unsigned long)height);
    
    
    // Get profiles
    int sumaX = 0;
    for (int j = 0 ; j < width;j++)
    {
        profilesY[j] = 0;
        profilesX[j] = 0;
    }
    
    for (unsigned int yIndex = 0; yIndex < height; yIndex++)
    {
        sumaX = 0;
        
        for (unsigned int xIndex = 0; xIndex < width; xIndex++)
        {
            
            int r = rawData[yIndex * bytesPerRow + xIndex * 4];
            int g = rawData[yIndex * bytesPerRow + xIndex * 4 + 1];
            int b = rawData[yIndex * bytesPerRow + xIndex * 4 + 2];
            
          //  NSLog(@"r: %d g: %d  b: %d",r,g,b);
            if (r != 0 && g != 0 && b != 0)
            {
                sumaX = sumaX + 1;
                profilesY[xIndex] = profilesY[xIndex] + 1;
                
            }
            
        }
        
        profilesX[yIndex] = sumaX;
    }
    
    
    
    //[self showProfiles];
 
}

- (ProfilesImage) getProfilesForJSON: (UIImage *) myImage{
    
    CGImageRef imageRef = [myImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //NSLog(@"Width %lu Height %lu",(unsigned long)width,(unsigned long)height);
    
    ProfilesImage profilesImage;
    
    // Get profiles
    int sumaX = 0;
    for (int j = 0 ; j < width;j++)
    {
        profilesImage.profilesY[j] = 0;
        profilesImage.profilesX[j] = 0;
    }
    
    for (unsigned int yIndex = 0; yIndex < height; yIndex++)
    {
        sumaX = 0;
        
        for (unsigned int xIndex = 0; xIndex < width; xIndex++)
        {
            
            int r = rawData[yIndex * bytesPerRow + xIndex * 4];
            int g = rawData[yIndex * bytesPerRow + xIndex * 4 + 1];
            int b = rawData[yIndex * bytesPerRow + xIndex * 4 + 2];
            
            //  NSLog(@"r: %d g: %d  b: %d",r,g,b);
            if (r != 0 && g != 0 && b != 0)
            {
                sumaX = sumaX + 1;
                profilesImage.profilesY[xIndex] = profilesImage.profilesY[xIndex] + 1;
                
            }
            
        }
        
        profilesImage.profilesX[yIndex] = sumaX;
    }
    
    return profilesImage;
    
}

#pragma mark - kNN

- (int) startAnalysis {
    
    NSLog(@"Starting analysis...");
    
    int numberTests = [[BBDD sharedBBDD] getNumberGestures];
    
   // NSLog (@"BBDD image samples: %d",numberTests);
    
    int i = 0;
    float distance = -1.0;
    
    NSDictionary *currentProfile = [[NSDictionary alloc]init];
    

    for (i = 0; i < numberTests; i++) {
        
       // NSLog (@"%d ) Getting info ",i);
        
        // Get i-BBDD profile
        currentProfile = [[BBDD sharedBBDD] getGestureBBDDAtIndex:i];
        
       // NSLog(@"Type of the shape : %d",(int)[[currentProfile valueForKey:@"Type"]intValue]);
        
        // Calculate distance
        distance = [self compareOriginalProfileWithCurrentProfile:currentProfile];
        
       // NSLog(@"Distance of this shape : %f",distance);
        
        // Check distance
       [self checkBestDistance:distance withType:[[currentProfile valueForKey:@"Type"]intValue]];
        
    }
        
    // Determine best match
    return [self getBestMatch];
    
}

# pragma mark - Distance methods
- (float)       compareOriginalProfileWithCurrentProfile:(NSDictionary *)profileToCompare {
    
    // Here we calculate the distance (euclidian distance)
    
   // NSLog(@"Getting profiles X Y of BBDD");
   // NSLog(@"ofType : %d",[[profileToCompare valueForKey:@"Type"]intValue]);
    arrayX = [profileToCompare valueForKey:@"ProfilesX"];
    
    arrayY = [profileToCompare valueForKey:@"ProfilesY"];
   // NSLog(@"Array X: %@",arrayX);
    //NSLog(@"Array Y: %@",arrayY);

    
    float finalX[MAX_WIDTH];
    float finalY[MAX_HEIGHT];
    
   // NSLog(@"Final x y created arrays");
    
    int i = 0;
    float restX = 0;
    float restY = 0;
    for ( i = 0; i < MAX_WIDTH; i++) {
        
        restX = [[arrayX objectAtIndex:i] intValue] - profilesX[i];
        restY = [[arrayY objectAtIndex:i] intValue] - profilesY[i];
        
      //  NSLog(@"Rest X : %f Rest Y : %f",restX,restY);
        
        finalX[i] = restX*restX;
        finalY[i] = restY*restY;
        
    }
    
    float totalX = 0.0;
    float totalY = 0.0;
    for ( i = 0; i < MAX_WIDTH; i++) {
        
        totalX = totalX + finalX[i];
        totalY = totalX + finalY[i];
        
    }
    
    float totalDistance = sqrt(totalX + totalY);
    
   // NSLog (@"--->Distance  : %f",totalDistance);
    
    return totalDistance;
}

- (void)        checkBestDistance: (float) currentDistance withType:(int)currentType {
    
    // Check if its a best distance and save the type
    if (numberEntries >= 8) {
        
        int i = 0;
        int max = 0;
        int posMax = 0;
        for (i = 0; i < kNN; i++) {
            
            if (bestMatches[i].distance > max) {
                max = bestMatches[i].distance;
                posMax = i;
            }
            
        }
        
        if (bestMatches[posMax].distance > currentDistance) {
            
            numberEntries = numberEntries + 1;
            
            bestMatches[posMax].distance = currentDistance;
            bestMatches[posMax].tipus = currentType;
            
        }
        
        
    } else {
        
        int i = 0;
        int done = 0;
        for (i = 0; i < kNN && done == 0; i++) {
            
            if (bestMatches[i].distance == -1) {
                
                numberEntries = numberEntries + 1;
                
                bestMatches[i].distance = currentDistance;
                bestMatches[i].tipus = currentType;
                done = 1;
            }
            
        }
        
    }
    
}

- (int)         getBestMatch {
    
    // Check in the structure best match
    
    int i = 0;
    int max = 999999999;
    int posMatch = -1;

    for (i = 0; i < kNN; i++) {
        
        NSLog(@"Candidat %d. Type  %d. Distance %f",i,bestMatches[i].tipus,bestMatches[i].distance);
        
        if (bestMatches[i].distance < max) {
            max = bestMatches[i].distance;
            posMatch = i;
        }
        
    }
    
    
    return bestMatches[posMatch].tipus;
}



@end
