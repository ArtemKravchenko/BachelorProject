//
//  VGTableView.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGAppDelegate.h"

typedef void (^addToTableBlockType)(NSString*, UIPopoverController* popover);

typedef enum VGButtonClickedType : NSInteger VGButtonClickedType;
enum VGButtonClickedType : NSInteger {
    VGButtonClickedTypeRow,
    VGButtonClickedTypeCol
};

@protocol VGTableAddDelegate <NSObject>

@optional
- (void) rowDidAddWithName:(NSString*)name;
- (void) colDidAddWithName:(NSString*)name;
- (void) cellDidChangedAtRow:(NSInteger)rowIndex andColIndex:(NSInteger)colIdex withValue:(NSString*)value;

@end

@interface VGTableView : UIScrollView <UITextFieldDelegate>

- (void) reloadData;
@property (nonatomic, assign) id<VGTableAddDelegate> tableDetegate;

- (void) edtiMode:(BOOL)canEdit;

@end