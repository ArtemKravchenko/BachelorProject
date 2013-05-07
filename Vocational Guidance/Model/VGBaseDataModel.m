//
//  VGBaseDataModel.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseDataModel.h"

static NSString* const kDataId = @"data id";
static NSString* const kDataValue = @"data value";
static NSString* const kDataRow = @"data row";
static NSString* const kDataCol = @"data col";

@implementation VGBaseDataModel

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kDataId : self.dataId,
                               kDataValue : self.value,
                               kDataCol : self.col,
                               kDataRow : self.row
                               };
    return jsonInfo;
}

- (void)dealloc
{
    self.dataId = nil;
    self.value = nil;
    self.row = nil;
    self.col = nil;
    [super dealloc];
}

@end
