//
//  MHSVGExporter.m
//  SVGExporter
//
//  Created by Angus Hardie on 29/03/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import "MHSVGExporter.h"


#import "MHSVGPath.h"



#import "SQLObject.h"
#import "SQLCanvasArea.h"
#import "SQLContainer.h"




#ifndef NS_ENUM
#	define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, MHConnectablePointType) {
	MHConnectablePointTop,
	MHConnectablePointLeft,
	MHConnectablePointBottom,
	MHConnectablePointRight
};


#define OBJECT_LINE_SPACE 25

@implementation MHSVGExporter

@synthesize container = _container;
@synthesize imageBounds = _imageBounds;

- (id)init
{
    
    self = [super init];
    
    return self;
}


// converts a NSPoint into a dictionary x and y coordinates as string values
- (NSDictionary*)dictionaryForLocation:(NSPoint)location
{
    
    id attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString* xLocationString = [NSString stringWithFormat:@"%.0f",location.x];
    NSString* yLocationString = [NSString stringWithFormat:@"%.0f",location.y];
    
    
    [attributes setObject:xLocationString forKey:@"x"];
    [attributes setObject:yLocationString forKey:@"y"];
    
    
    return attributes;
}
// converts a NSSize into a dictionary width and height values as string values
- (NSDictionary*)dictionaryForSize:(NSSize)size
{
    
    id attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString* widthString = [NSString stringWithFormat:@"%.0f",size.width];
    NSString* heightString = [NSString stringWithFormat:@"%.0f",size.height];
    
    [attributes setObject:widthString forKey:@"width"];
    [attributes setObject:heightString forKey:@"height"];
    
    return attributes;
}

// returns a MHSVGElement representing a line from point start to point end
// default stroke witdth of 1, color black
- (MHSVGElement*)lineElement:(NSPoint)start end:(NSPoint)end
{
    id dividerLine = [MHSVGElement elementWithName:@"line"];
    
    id lineAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    
    [lineAttributes setObject:[NSString stringWithFormat:@"%.0f", start.x] forKey:@"x1"];
    [lineAttributes setObject:[NSString stringWithFormat:@"%.0f", start.y] forKey:@"y1"];
    [lineAttributes setObject:[NSString stringWithFormat:@"%.0f", end.x] forKey:@"x2"];
    [lineAttributes setObject:[NSString stringWithFormat:@"%.0f", end.y] forKey:@"y2"];
    [lineAttributes setObject:@"black" forKey:@"stroke"];
    [lineAttributes setObject:@"1" forKey:@"stroke-width"];
    
    [dividerLine setAttributesWithDictionary:lineAttributes];
    return dividerLine;
}

// returns a MHSVGElement representing the text in the supplied string,
// located at textLocation
- (MHSVGElement*)textElement:(NSString *)text atPoint:(NSPoint)textLocation
{
    id titleText = [MHSVGElement elementWithName:@"text"];
    
    id titleAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    
    
    [titleAttributes addEntriesFromDictionary:[self dictionaryForLocation:textLocation]];
    [titleAttributes setObject:@"10" forKey:@"dx"];
    [titleAttributes setObject:@"14" forKey:@"dy"];
    [titleAttributes setObject:@"black" forKey:@"fill"];
    [titleAttributes setObject:@"13" forKey:@"font-size"];
    [titleAttributes setObject:@"Lucida Grande" forKey:@"font-family"];
    [titleAttributes setObject:@"optimizeLegibility" forKey:@"text-rendering"];
    
    
    [titleText setAttributesWithDictionary:titleAttributes];
    
    [titleText setStringValue:text];
    return titleText;
}

// returns MHSVGElement representing a rectangle
- (MHSVGElement*)rectangleElement:(NSRect)objectRect
             fillColor:(NSColor*)color
           strokeColor:(NSColor*)strokeColor
          cornerRadius:(NSUInteger)radius
{
    id mainFrame = [MHSVGElement elementWithName:@"rect"];

    
    id attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [attributes addEntriesFromDictionary:[self dictionaryForLocation:objectRect.origin]];
    [attributes addEntriesFromDictionary:[self dictionaryForSize:objectRect.size]];
    [attributes setObject:[NSNumber numberWithInteger:radius] forKey:@"rx"];
    [attributes setObject:[NSNumber numberWithInteger:radius] forKey:@"ry"];
    
    
    id strokeColorString = @"none";
    
    if (strokeColor) {
        strokeColorString = [self svgColor:strokeColor];
        [attributes setObject:@"1" forKey:@"stroke-width"];
        [attributes setObject:strokeColorString forKey:@"stroke"];
    }
    
    
    
    
    //[attributes setObject:@"rgb(79,0,97)" forKey:@"fill"];
    
    //id color = [self labelColorForObject:object];
    
    
    NSString* fillColorString = [self svgColor:color];
    
    [attributes setObject:fillColorString forKey:@"fill"];
    [attributes setObject:[NSString stringWithFormat:@"%f",[color alphaComponent]] forKey:@"fill-opacity"];
    
    
    [mainFrame setAttributesWithDictionary:attributes];
    
    
    return mainFrame;
}


#pragma mark - component drawing
// export SQLCanvas area to SVG,
- (MHSVGElement*)exportSQLCanvasAreaToSVG:(SQLCanvasArea*)object
{
    
    id commentGroup = [MHSVGElement elementWithName:@"g"];
    
    [commentGroup addAttribute:[NSXMLNode attributeWithName:@"class" stringValue:@"SQLCanvasArea"]];
    

    
    NSRect areaRect;
    areaRect.origin = [object location];
    areaRect.size = [object size];
    
    id mainFrame = [self rectangleElement:areaRect
                                fillColor:[self labelColorForObject:object]
                              strokeColor:[NSColor blackColor]
                             cornerRadius:5];
    
    
    [commentGroup addChild:mainFrame];
    
    
    id titleText = [self textElement:[object name] atPoint:[object location]];
    [titleText addAttribute:[NSXMLElement attributeWithName:@"font-family" stringValue:@"Lucida Grande"]];
    [titleText addAttribute:[NSXMLElement attributeWithName:@"font-weight" stringValue:@"bold"]];
    
    [commentGroup addChild:titleText];
    
    
    return commentGroup;
}






#pragma mark - colors

/**
 convert NSColor to svg style rbg(r,g,b) string representation
 note, output is always in device RGB space
**/
- (NSString*)svgColor:(NSColor*)color
{
    
    id rgbColor = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    
    CGFloat redComponent = [rgbColor redComponent]*255.0;
    CGFloat greenComponent = [rgbColor greenComponent]*255.0;
    CGFloat blueComponent = [rgbColor blueComponent]*255.0;
    
    return [NSString stringWithFormat:@"rgb(%.0f,%.0f,%.0f)",redComponent,greenComponent,blueComponent];
    
}


// return default label color for object
// this version returns the same color for all objects
- (NSColor*)defaultLabelColorForObject:(SQLObject*)object
{
    
    return [NSColor colorWithCalibratedRed:0 green:0.7 blue:0 alpha:0.5];
}
// return default titlebar color for object
// this version returns the same color for all objects
- (NSColor*)titleBarColorForObject:(SQLObject*)object
{
	return [[self labelColorForObject:object] highlightWithLevel:0.7];
		

}


#pragma mark - Sizing


// titlebar height
- (CGFloat)titleBarHeight
{
    
    return 19;
}


#pragma mark - Drawing




// returns a label color for the object by trying different possible
// values, if everything is nil, return a default color
- (NSColor*)labelColorForObject:(SQLObject*)object
{
	
	id labelColor = nil;
	
	if ([object color]) {
        
        labelColor = [object color];
    }
	
	if (nil == labelColor) {
		
		return [self defaultLabelColorForObject:object];
	}
	
	return labelColor;
    
}


// export the specified object to svg, returning a MHSVGElement object
- (NSXMLNode*)exportObjectToSVG:(SQLObject*)object
{
    
    
      
    if ([object isKindOfClass:[SQLCanvasArea class]]) {
        
        return [self exportSQLCanvasAreaToSVG:(SQLCanvasArea*)object];
    }
    

    
    return nil;
}

- (NSXMLNode*)exportToXMLNode
{
    
    
    id exportNode = [NSXMLElement elementWithName:@"svg"];
    
    
    id viewBoxString = [NSString stringWithFormat:@"%.0f %.0f %.0f %.0f",_imageBounds.origin.x,_imageBounds.origin.y,_imageBounds.size.width,_imageBounds.size.height];
    
    [exportNode addAttribute:[NSXMLNode attributeWithName:@"viewBox" stringValue:viewBoxString]];
    
    
    [exportNode addAttribute:[NSXMLNode attributeWithName:@"width"
                                              stringValue:[NSString stringWithFormat:@"%.0f",_imageBounds.size.width]]];

    [exportNode addAttribute:[NSXMLNode attributeWithName:@"height"
                                              stringValue:[NSString stringWithFormat:@"%.0f",_imageBounds.size.height]]];
    
    id namespace = [NSXMLNode namespaceWithName:@"" stringValue:@"http://www.w3.org/2000/svg"];
    
    [exportNode setNamespaces:[NSArray arrayWithObject:namespace]];
    
    
    id transformGroup = [NSXMLNode elementWithName:@"g"];
    
    // transform is used to improve onscreen appearance, alignment with pixels mainly
    [transformGroup addAttribute:[NSXMLNode attributeWithName:@"transform" stringValue:@"translate(0.5,0.5)"]];
    
    
    [exportNode addChild:transformGroup];
    
    
    for (id entry in [self.container objectListByZOrder]) {
        
        
        
        if ([entry isKindOfClass:[SQLObject class]]) {
            
            
            if (![entry getPropertyAsBoolean:@"hidden"]) {
                id newNode = [self exportObjectToSVG:entry];
                
                if (newNode) {
                    [transformGroup addChild:newNode];
                }
            }
        }
    }
    
    
    return exportNode;
}

- (NSXMLDocument*)xmlDocument
{
    
    id rootNode = [self exportToXMLNode];
    
    id xmlDocument = [[[NSXMLDocument alloc] initWithRootElement:rootNode] autorelease];
    
    [xmlDocument setVersion:@"1.0"];
    
    [xmlDocument setCharacterEncoding:@"UTF-8"];
	
	return xmlDocument;
}


/** export to XML **/
- (NSString*) exportToXML
{
    
    return [[self xmlDocument] XMLStringWithOptions:NSXMLDocumentTidyXML|NSXMLNodePrettyPrint];
    
}

- (NSData*) xmlData
{
	
	return [[self xmlDocument] XMLDataWithOptions:NSXMLDocumentTidyXML|NSXMLNodePrettyPrint];
	
	
	
	
}

@end
