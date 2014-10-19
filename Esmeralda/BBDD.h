//
//  BBDD.h
//  Esmeralda
//
//  Created by Marc on 17/10/14.
//  Copyright (c) 2014 Marc Exposito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBDD : NSObject 

+ (instancetype) sharedBBDD;

- (NSDictionary *) getGestureBBDDAtIndex:(int)index;

- (int) getNumberGestures;

@end
