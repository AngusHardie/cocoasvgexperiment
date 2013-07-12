//
//  MHSVGPath.m
//  SVGExporter
//
//  Created by Angus Hardie on 29/03/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import "MHSVGPath.h"

@implementation MHSVGPath

@synthesize segments;
@synthesize fill;
@synthesize stroke;

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        
        self.segments = [NSMutableArray arrayWithCapacity:1];
        
        
    }
    return self;
}


- (void)dealloc
{
    
    self.segments = nil;
    
    [super dealloc];
}

- (NSXMLElement*)xmlElement
{
    
    
    MHSVGElement* element = [MHSVGElement elementWithName:@"path"];
    
    
    
    id attributes = [NSMutableDictionary dictionaryWithCapacity:4];
    
    
    id pathString = [self.segments componentsJoinedByString:@" "];

    [attributes setObject:pathString forKey:@"d"];


    [element setAttributesWithDictionary:attributes];
    
    return element;
}


- (void)moveToPoint:(NSPoint)point
{
    
    [self.segments addObject:[NSString stringWithFormat:@"M%.0f %.0f ",point.x,point.y]];
    
}
- (void)lineToPoint:(NSPoint)point
{
    
    [self.segments addObject:[NSString stringWithFormat:@"L%.0f %.0f ",point.x,point.y]];
}
- (void)curveToPoint:(NSPoint)endPoint controlPoint1:(NSPoint)controlPoint1 controlPoint2:(NSPoint)controlPoint2
{
    
    [self.segments addObject:[NSString stringWithFormat:@"C %.0f %.0f, %.0f %.0f, %.0f %.0f ",controlPoint1.x,controlPoint1.y,controlPoint2.x,controlPoint2.y,endPoint.x,endPoint.y]];
}



@end
