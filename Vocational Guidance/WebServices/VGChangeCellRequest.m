//
//  VGChangeCellRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChangeCellRequest.h"
#import "VGAlertView.h"
#import "VGRequestQueue.h"

static NSString* const kChangeCellUrlRoute =              @"executetransactions";

@interface VGChangeCellRequest ()

@property (nonatomic, assign) id<VGBaseRequestDelegate> target;
@property (nonatomic, assign) NSInteger personId;
@property (nonatomic, assign) NSInteger index;

@end

@implementation VGChangeCellRequest

- (id)initWithPersonId:(NSString*)personId andDelegate:(id<VGBaseRequestDelegate>)target {
    self = [super init];
    if (self) {
        self.target = target;
        if ([VGAppDelegate getInstance].transactionsList.count > 0) {
            self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%d&%@=%d&%@=%d&%@=%@",
                           kChangeCellUrlRoute,
                           @"rowId", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[0])[VG_ROW_OBJECT] intValue],
                           @"colId", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[0])[VG_COL_OBJECT] intValue],
                           @"value", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[0])[VG_CELL_VALUE] intValue],
                           kPersonId, [personId intValue],
                           @"isLast", ([VGAppDelegate getInstance].transactionsList.count == 1) ? 1 : 0,
                           kToken, [VGAppDelegate getInstance].token];
            self.personId = [personId intValue];
            self.delegate = ([VGAppDelegate getInstance].transactionsList.count == 1) ? self.target : self;
            self.index = 1;
        }
    }
    return self;
}

#pragma mark - Request delegate

- (void)requestDidFinishFail:(NSError *)error {
    if ([VGAlertView isShowing]) {
        [VGAlertView hidePleaseWaitState];
    }
    [VGAlertView showError: [NSString stringWithFormat:@"%@", error]];
}

-(void)requestDidFinishSuccessful:(NSData *)data {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%d&%@=%d&%@=%d&%@=%@",
                       kChangeCellUrlRoute,
                       @"rowId", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[self.index])[VG_ROW_OBJECT] intValue],
                       @"colId", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[self.index])[VG_COL_OBJECT] intValue],
                       @"value", [((NSDictionary*)[VGAppDelegate getInstance].transactionsList[self.index])[VG_CELL_VALUE] intValue],
                       kPersonId, self.personId,
                       @"isLast", ([VGAppDelegate getInstance].transactionsList.count - 1 == self.index) ? 1 : 0,
                       kToken, [VGAppDelegate getInstance].token];
        
        self.delegate = ([VGAppDelegate getInstance].transactionsList.count - 1 == self.index) ? self.target : self;
        self.index++;
    }
    [[VGRequestQueue queue] addRequest:self];
}



@end
