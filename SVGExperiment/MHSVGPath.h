//
//  MHSVGPath.h
//  SVGExporter
//
//  Created by Angus Hardie on 29/03/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHSVGElement.h"
@interface MHSVGPath : MHSVGElement
{
    
    NSMutableArray* segments;
    NSColor* fill;
    NSColor* stroke;
    
}

@property (retain) NSMutableArray* segments;

@property (copy) NSColor* fill;

@property (copy) NSColor* stroke;

- (NSXMLElement*)xmlElement;


- (void)moveToPoint:(NSPoint)point;
- (void)lineToPoint:(NSPoint)point;
- (void)curveToPoint:(NSPoint)endPoint controlPoint1:(NSPoint)controlPoint1 controlPoint2:(NSPoint)controlPoint2;



@end
