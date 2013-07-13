//
//  MHSVGExporter.h
//  SVGExporter
//
//  Created by Angus Hardie on 29/03/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLContainer.h"

@interface MHSVGExporter : NSObject
{
    
    SQLContainer* _container;
    NSRect _imageBounds;
}
@property (retain) SQLContainer* container;

@property (assign) NSRect imageBounds;

- (NSString*) exportToXML;
- (NSData*) xmlData;
@end
