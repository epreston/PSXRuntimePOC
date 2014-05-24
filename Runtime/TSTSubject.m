//
//  TSTSubject.m
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  The object implementation is normal except for one call in the default
//  init method.  This counld be a macro so it counld conditionally use the
//  runtime.

#import "TSTSubject.h"

// required to access the runtime's interface
#import "TSTRuntime.h"


NSString * subjectStatusToString(kSubjectStatus status) {
    switch (status) {
        case kSubjectStatusUnknown:
            return @"unknown";
            break;
        case kSubjectStatusObserving:
            return @"observing";
            break;
        case kSubjectStatusIgnoring:
            return @"ignoring";
            break;
        case kSubjectStatusWaiting:
            return @"waiting";
            break;
        case kSubjectStatusERROR:
            return @"error";
            break;
    }
    
    // update enumeration above
    return @"undefined";
};


#pragma mark - TSTSubject

@implementation TSTSubject

static uint32_t _nextIndex = 0;

- (instancetype)initWithName:name secretKey:(NSNumber *)secretKey {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // register with runtime to build the observer
    [TSTRuntime registerWithRuntime:self];
    
    // private member storage defaults
    _name = (name == nil) ? @"" : name;
    _secretKey = (secretKey == nil) ? @([self hash]) : secretKey;
    _listIndex = _nextIndex++;
    _status = kSubjectStatusUnknown;
    
    return self;
}

+ (instancetype)subjectWithName:(NSString *)name
                      secretKey:(NSNumber *)secretKey {
    
    
    TSTSubject * subject = [[TSTSubject alloc] initWithName:name
                                                  secretKey:secretKey];
    
    return subject;
}

-(NSString *)description {
    
    // resolve the status to a readable value.
    NSString *statusString = subjectStatusToString(_status);
    
    // build the summary string
    NSString * summaryString =
    [NSString stringWithFormat:@"<subject name:%@ secretkey:%@ listindex:%u status:%@>\n",
     _name, _secretKey, _listIndex, statusString];
    
    return summaryString;
}

-(void)dealloc {
    // debug
    NSLog(@"subject deallocated");
}


@end
