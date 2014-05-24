//
//  TSTRuntime.h
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  This is the runtime that objects register with in the implementation

#import <Foundation/Foundation.h>


@interface TSTRuntime : NSObject

// registration
+ (void)registerWithRuntime:(id)instance;
+ (void)removeFromRuntime:(id)instance;

// other useful methods here

// Debug
+ (void)logMetadata:(id)instance;

@end
