//
//  TSTObserver.m
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  The observer registers for KVO notifications and contains data members
//  for book keeping information.

#import "TSTObserver.h"

// used for property inspection, enumeration
#import <objc/runtime.h>


@implementation TSTObserver {
    // a reference to the object that wont get zero'd out too early in the
    // deallocation process for us to unregister objects.
    id __unsafe_unretained _objectObserved;
    
    // represents the state that has changed, contains the keyPath of only
    // the observed property changes. For one system, this is the "has"
    // registry to note if the backing store contains this data. For this
    // example, it could mean "has changed".
    NSMutableSet *_hasRegistry;
    
    // this is a test variable which might represent the cached size of a
    // data model object.
    int32_t _cachedSerializedSize;
}

// context parameter
static void * TSTContext = &TSTContext;

-(instancetype)initWithObject:(id)object {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // initialize data members
    _cachedSerializedSize = -1;
    _hasRegistry = [NSMutableSet set];
    _objectObserved = object;
    
    // register for property KVO
    [self addPropertyKVO];
    
    return self;
}

+ (instancetype)observerWithObject:(id)object {
    return [[TSTObserver alloc] initWithObject:object];
}

- (void)dealloc {
    // remove KVO on properties
    [self removePropertyKVO];
}


#pragma mark - KVO Methods

- (void)addPropertyKVO {
    
    // enumerate the list of properties to observe in the subject
    unsigned int count;
    objc_property_t *props = class_copyPropertyList([_objectObserved class], &count);
    
    for (int i = 0; i < count; ++i){
        const char *propName = property_getName(props[i]);
        
        [_objectObserved addObserver:self
                          forKeyPath:[NSString stringWithUTF8String:propName]
                             options:NSKeyValueObservingOptionNew
                             context:TSTContext];
    }
    free(props);  // must give back "props"
}

- (void)removePropertyKVO {
    
    if (_objectObserved == nil) {
        return;
    }
    
    // enumerate the list of properties to stop observing in the subject
    unsigned int count;
    objc_property_t *props = class_copyPropertyList([_objectObserved class], &count);
    
    for (int i = 0; i < count; ++i){
        const char *propName = property_getName(props[i]);
        
        @try {
            [_objectObserved removeObserver:self
                                 forKeyPath:[NSString stringWithUTF8String:propName]];
        }
        @catch (NSException * __unused exception) {}
        
    }
    free(props);  // must give back "props"
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == TSTContext) {   // context check
        
        // debug
        PSCLog(@"Observed change to keyPath: %@", keyPath);
        
        // update the "has"
        if (_hasRegistry != nil) {
            [_hasRegistry addObject:keyPath];
        }
        
    } // context
}


#pragma mark - Debugging Methods

- (void)logMetadata {
    
    // log the "has changed" registery
    if (_hasRegistry != nil) {
        for (NSString *path in _hasRegistry) {
            PSCLog(@"hasRegistry: %@", path);
        }
    }
    
}


@end
