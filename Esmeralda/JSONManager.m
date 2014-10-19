//
//  JSONManager.m
//  Esmeralda
//
//  Created by Marc on 17/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import "JSONManager.h"

@implementation JSONManager

- (void) createJSONWithImages:(NSMutableArray*) images andType:(int) typeGesture {
    
    NSLog(@"Creating JSON...");
    
    EsmeraldaLibrary *eRecognizer = [[EsmeraldaLibrary alloc]init];
    
    
    NSMutableArray *profilesTotal = [[NSMutableArray alloc]init];
        
    for (int  nGestures = 0; nGestures < [images count]; nGestures++) {
        
        ProfilesImage profilesImg = [eRecognizer getProfilesForJSON:[images objectAtIndex:nGestures]];

        
        NSMutableArray *profilesWithX = [[NSMutableArray alloc]initWithCapacity:MAX_WIDTH];
        NSMutableArray *profilesWithY = [[NSMutableArray alloc]initWithCapacity:MAX_HEIGHT];
        NSNumber *newNum = [NSNumber numberWithInt:typeGesture];
        
        
        for (int i = 0 ; i < MAX_WIDTH; i++) {
                
            [profilesWithX addObject:[NSNumber numberWithInt:profilesImg.profilesX[i]]];
            [profilesWithY addObject:[NSNumber numberWithInt:profilesImg.profilesY[i]]];
                
        }
            
            NSDictionary *dictionary = @{@"ProfilesX" : profilesWithX,
                                         @"ProfilesY" : profilesWithY,
                                         @"Type"      : newNum};
            
            [profilesTotal addObject:dictionary];
            
        }
        
        // Dictionary with several kay/value pairs and the above array of arrays
        NSDictionary *dict = @{@"Squares" : profilesTotal};
        
        NSError *error = nil;
        NSData *json;
        
        // Dictionary convertable to JSON ?
        if ([NSJSONSerialization isValidJSONObject:dict])
        {
            // Serialize the dictionary
            json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            
            
            // If no errors, let's view the JSON
            if (json != nil && error == nil)
            {
                NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSON: %@", jsonString);
                
                NSError *error = nil;
                NSString *path=@"/Users/Marc/Desktop/Square-100.json";
                
                [json writeToFile:path options:NSDataWritingAtomic error:&error];
                
            }
            
        } else {
            
            NSLog(@"Can't serialize!");
        }
        
    }

@end
