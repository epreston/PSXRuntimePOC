//
//  TSTSubject.h
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//
//  This object should look and be used like any other.

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, kSubjectStatus) {
    kSubjectStatusUnknown = 1,
    kSubjectStatusObserving = 2,
    kSubjectStatusIgnoring = 3,
    kSubjectStatusWaiting = 4,
    kSubjectStatusERROR = 5,
};

NSString * subjectStatusToString(kSubjectStatus);

@interface TSTSubject : NSObject

+(instancetype) subjectWithName:(NSString *)name
                      secretKey:(NSNumber *)secretKey;

@property (copy) NSString *name;
@property NSNumber *secretKey;
@property uint32_t listIndex;
@property kSubjectStatus status;

@end
