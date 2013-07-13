//
//  SQLObject.h
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLObject : NSObject
{
    
    NSMutableDictionary* _properties;
}

@property (assign) NSPoint location;
@property (assign) NSSize size;

@property (copy) NSString* name;

@property (retain) NSColor* color;

- (void)setProperty:(NSString*)key value:(id)value;
- (id)label;
- (BOOL)hasProperty:(NSString*)key;
- (NSString*)getProperty:(NSString*)key;
- (BOOL)getPropertyAsBoolean:(NSString*)key;
@end
