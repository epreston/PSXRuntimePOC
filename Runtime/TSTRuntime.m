//
//  TSTRuntime.m
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  The runtime book keeping and tracking of the data model objects is done
//  through an associated observer.

#import "TSTRuntime.h"

// the observer to associate
#import "TSTObserver.h"

// used to assocaite the observer object
#import <objc/runtime.h>



#pragma mark - TSTRuntime

@implementation TSTRuntime

// associated object key
static char kAssociatedObjectKey;

+ (void)registerWithRuntime:(id)instance {
    
    NSParameterAssert(instance);
    
    // external KVO object to observe "instance"
    TSTObserver *observer = [TSTObserver observerWithObject:instance];
    
    if (observer != nil) {
        // tie the observer to the lifetime of the instance
        // with OBJC_ASSOCIATION_RETAIN_NONATOMIC. KVO does not retain but,
        // associated objects can.  When "instance" is released, it will
        // in turn release the observer.
        objc_setAssociatedObject(instance, &kAssociatedObjectKey,
                                 observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        NSLog(@"Runtime could not register object: %@",
              NSStringFromClass([instance class]));
    }
}

+ (void)removeFromRuntime:(id)instance {
    
    NSParameterAssert(instance);
    
    // clear the associated object
    objc_setAssociatedObject(instance, &kAssociatedObjectKey,
                             nil, OBJC_ASSOCIATION_ASSIGN);
    
}


#pragma mark - Debugging Methods

+ (void)logMetadata:(id)instance {
    
    NSParameterAssert(instance);
    
    // retreave the associated object
    TSTObserver *observer = objc_getAssociatedObject(instance, &kAssociatedObjectKey);
    
    // ask it to log
    if (observer != nil) {
        [observer logMetadata];
    } else {
        NSLog(@"Runtime could not log metadata for object: %@",
              NSStringFromClass([instance class]));
    }
}

@end
