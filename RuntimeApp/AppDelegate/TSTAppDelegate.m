//
//  TSTAppDelegate.m
//  transparent runtime concept
//
//  Created by Ed Preston on 5/23/14.
//  Copyright (c) 2014 Ed Preston. All rights reserved.
//

#import "TSTAppDelegate.h"

// the data model objects
#import "TSTSubject.h"

// debug: to request the runtime to log metadata
#import "TSTRuntime.h"


// see pch file for definition of - PSCLog Macro


@implementation TSTAppDelegate {
    // holding onto objects to observe thier lifetime and interact with them
    NSMutableArray * _subjects;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // initialize member variables
    _subjects = [NSMutableArray array];
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    logStep(@"Create some objects.");
    // ------------------------------------------------------------------------
    
    TSTSubject * watcher = [self subject:@"Eddie"
                                  secret:@5555];
    
    TSTSubject * creeper = [self subject:@"Lana"
                                  secret:@1234];
    
    TSTSubject * stalker = [self subject:@"Tim"
                                  secret:@8080];
    
    logAll(_subjects);      // log initial state
    
    
    logStep(@"Make some changes.");
    // ------------------------------------------------------------------------
    
    watcher.name = @"Ed";
    
    creeper.status = kSubjectStatusWaiting;
    creeper.listIndex = 9001;
    
    stalker.secretKey = @9999;
    
    
    logStep(@"Review the state and metadata.");
    // ------------------------------------------------------------------------
    
    logAll(_subjects);      // log changed state
    
    
    logStep(@"Create and change a short-lived object.");
    // ------------------------------------------------------------------------
    
    // create an object that has a short lived object
    TSTSubject * onlooker = [TSTSubject subjectWithName:@"Ken"
                                              secretKey:@411];
    
    onlooker.status = kSubjectStatusObserving;
    
    
    logStep(@"Review state of short-lived object.");
    // ------------------------------------------------------------------------
    logSubject(onlooker);   // log the onlookers state
    
}


#pragma mark - TSTSubject Modification

- (IBAction)makeChanges:(id)sender {
    
    if ((_subjects != nil) && _subjects.count) {
        TSTSubject * element = _subjects[0];
        
        logStep(@"Change state of the first subject.");
        // --------------------------------------------------------------------
        
        element.name = @"Edward";
        logSubject(element);
    }
}


#pragma mark - TSTSubject Creation

- (TSTSubject *)subject:(NSString *)name secret:(NSNumber *)key {
    
    TSTSubject * object = [TSTSubject subjectWithName:name
                                            secretKey:key];
    [_subjects addObject:object];
    
    return object;
}


#pragma mark - Logging

void logStep(NSString * message) {
    static NSString *separator =
    @"------------------------------------------------------------------------";
    
    PSCLog(@"\n%@", message);
    PSCLog(@"%@", separator);
}

void logAll(NSArray * listSubjects) {
    for (TSTSubject *subject in listSubjects) {
        logSubject(subject);
    }
}

void logSubject(TSTSubject *subject) {
    PSCLog(@"\nTSTSubject: %@", subject.description);
    [TSTRuntime logMetadata:subject];
}


#pragma mark - NSAppDelegate

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
