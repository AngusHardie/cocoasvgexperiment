//
//  SQLObject.m
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import "SQLObject.h"

@implementation SQLObject

@synthesize location = _location;
@synthesize size = _size;
@synthesize color = _color;


- (id)init
{
    self = [super init];
    if (self) {
        
        _properties = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (void)dealloc
{
    
    [_properties release];
    
    [super dealloc];
}



// empty label method - override elsewhere
- (id)label
{
    
    return nil;
}


/// return property value associated with key
/// returns empty string @"" if not found (it won't return nil)
- (NSString*)getProperty:(NSString*)key
{

	
	id result = [_properties valueForKey:key];
	
	
	if (nil == result) {
		result = @"";
	}
	
	return result;
}

/// set property value 
- (void)setProperty:(NSString*)key value:(id)value
{
    NSAssert(_properties, @"Properties should not be nil");
    
	if (nil == key) {
		NSLog(@"attempted to set nil key for property");
		return;
	}
	
	if (nil == value) {
		NSLog(@"attempted to set nil value for property: %@",key);
		return;
	}
	
	
	
	[_properties setValue:value forKey:key];
}

/// returns YES if there is a property value associated with key
- (BOOL)hasProperty:(NSString*)key
{
	
	return ([[_properties allKeys] containsObject:key]);
	//return ([_properties objectForKey:key] != nil);
}

/// removes property value associated with key
- (void)removeProperty:(NSString*)key
{
	[_properties removeObjectForKey:key];
	
}


/// sets the property associated with key to boolean value
- (void)setPropertyAsBoolean:(NSString*)key value:(BOOL)value
{
	[self setProperty:key value:((value==YES)?@"1":@"0") ];
}

// returns property associated with key as a boolean value (by calling boolValue) on it
- (BOOL)getPropertyAsBoolean:(NSString*)key
{
	
	return [[self getProperty:key] boolValue];
}
// returns the underlying properties dictionary
- (id)properties
{
	return _properties;
}

@end
