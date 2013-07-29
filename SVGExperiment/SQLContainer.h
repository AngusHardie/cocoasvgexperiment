//
//  SQLContainer.h
//  SVGExperiment
//
//  Created by Angus Hardie on 12/07/2013.
//  Copyright (c) 2013 Angus Hardie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLObject.h"

@interface SQLContainer : SQLObject

{
    
    NSMutableArray* _objectList;
}

@property (retain) NSMutableArray* objectList;

- (void)addObject:(id)object;

- (NSArray*)objectListByZOrder;

@end
