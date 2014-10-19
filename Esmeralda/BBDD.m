//
//  BBDD.m
//  Esmeralda
//
//  Created by Marc on 17/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import "BBDD.h"

@implementation BBDD {
    
    NSArray *array;
    int numberGestures;
    
}

+ (instancetype) sharedBBDD {
    
    static BBDD *sharedBBDD = nil;
    
    if (!sharedBBDD) {
        
        sharedBBDD = [[self alloc] initPrivate];
    }
    
    return sharedBBDD;
}

- (id)          init {
    
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [MEGBBDD sharedBBDD]" userInfo:nil];
    
    return nil;
    
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    
    if (self) {
        
        NSLog (@"BBDD created");
        
        // Read data from file
        [self readDataFromFile];
        
    }
    
    return self;
}

- (void) readDataFromFile {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource: @"Gestures-BBDD" ofType: @"json"];
 
    // Read JSON
    NSData *jsonData = [NSData dataWithContentsOfFile:myFile];
    
    NSError *error = nil;
    
    // Get JSON data into a Foundation object
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    // Verify object retrieved is dictionary
    if ([object isKindOfClass:[NSDictionary class]] && error == nil)
    {
        
        // Get the value (an array) for key 'results'
        // Get the 'results' array
        if ([[object objectForKey:@"Gestures"] isKindOfClass:[NSArray class]])
        {
            array = [object objectForKey:@"Gestures"];
            numberGestures = (int)[array count];
        }
       
    }
    
    
}

- (NSDictionary *) getGestureBBDDAtIndex:(int)index {
    
    return [array objectAtIndex:index];
    
}

- (int) getNumberGestures {
    
    return numberGestures;
}

@end
