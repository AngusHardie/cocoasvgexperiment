//
//  MHAppDelegate.h
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>

@interface MHAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (retain) IBOutlet WebView* webView;

@property (copy) NSString* svgSource;

@property (retain) IBOutlet NSTextView* sourceView;

@end
