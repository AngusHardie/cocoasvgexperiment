//
//  MHAppDelegate.m
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import "MHAppDelegate.h"
#import "MHSVGExporter.h"
#import "SQLCanvasArea.h"
#import "SQLContainer.h"

@implementation MHAppDelegate
@synthesize svgSource = _svgSource;
@synthesize dumpToFile = _dumpToFile;


- (id)init
{
    self = [super init];
	
    if (self) {
        _dumpToFile = YES;
    }
	
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
        
   
}

- (void)awakeFromNib
{
    // reconfigure source view
    
    

    
    // set up some objects first
    
    SQLContainer* container = [[[SQLContainer alloc] init] autorelease];
    
    
    SQLCanvasArea* canvasArea = [[[SQLCanvasArea alloc] init] autorelease];
    canvasArea.location = NSMakePoint(100, 100);
    canvasArea.size = NSMakeSize(100, 100);
    canvasArea.name = @"test";
    [container addObject:canvasArea];
    
    SQLCanvasArea* canvasArea2 = [[[SQLCanvasArea alloc] init] autorelease];
    canvasArea2.location = NSMakePoint(320, 100);
    canvasArea2.size = NSMakeSize(100, 100);
    canvasArea2.name = @"test2";
    
    [canvasArea2 setColor:[NSColor colorWithCalibratedRed:0.6 green:0 blue:0 alpha:0.5]];
    
    [container addObject:canvasArea2];
    
    
    MHSVGExporter* exporter = [[MHSVGExporter alloc] init];
    [exporter setContainer:container];

    
    // set exporter bounds - otherwise nothing gets displayed
    // real app would calculate this
    exporter.imageBounds = NSMakeRect(0, 0, 500, 500);
    
    
    NSData* data = [exporter xmlData];
    
    
    self.svgSource = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    
    
    [[self.webView mainFrame]  loadData:data
                               MIMEType:@"image/svg+xml"
                       textEncodingName:@"UTF-8"
                                baseURL:[NSURL URLWithString:@"http://localhost/"]];
    
	
    if (self.dumpToFile) {
		[data writeToFile:@"test.svg" atomically:YES];
	}
    

    [exporter release];
}

@end
