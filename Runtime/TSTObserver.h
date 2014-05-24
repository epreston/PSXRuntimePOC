//
//  TSTObserver.h
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  The observer does the book keeping and tracking for a model object for the
//  runtime. It is tied to the lifetime of the model object unless removed.

#import <Foundation/Foundation.h>


@interface TSTObserver : NSObject

- (instancetype)initWithObject:(id)object;

+ (instancetype)observerWithObject:(id)object;


// Debug
- (void)logMetadata;

@end
