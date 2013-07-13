//
//  SQLContainer.m
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import "SQLContainer.h"

// stub implementation of SQLContainer - for svg test app only

@implementation SQLContainer

@synthesize objectList = _objectList;

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        _objectList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)dealloc
{
    [_objectList release];
    [super dealloc];
}

// add object
- (void)addObject:(id)object
{
    
    
    [self.objectList addObject:object];
    
}

// remove object if it is in this container
- (void)removeObject:(id)object
{
    
    if ([self.objectList containsObject:object]) {
        
        [self.objectList removeObject:object];
    }
    
}
//return a drawable list of objects
//note this is not actually sorted by zorder in this simplified version
- (NSArray*)objectListByZOrder
{
    
    
    return [[self.objectList copy] autorelease];
    
}


@end
