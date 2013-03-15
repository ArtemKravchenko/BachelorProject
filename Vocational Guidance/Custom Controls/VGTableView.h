//
//  VGTableView.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGAppDelegate.h"
#import "VGAddToTableViewController.h"
#import "VGDetailViewController.h"

typedef void (^addToTableBlockType)(NSString*, UIPopoverController* popover);

typedef enum VGButtonClickedType : NSInteger VGButtonClickedType;
enum VGButtonClickedType : NSInteger {
    VGButtonClickedTypeRow,
    VGButtonClickedTypeCol
};

@protocol VGTableAddDelegate <NSObject>

@optional
- (void) rowDidAddWithName:(VGObject*)object;
- (void) colDidAddWithName:(VGObject*)object;
- (void) cellDidChangedAtRow:(VGObject*)row andColIndex:(VGObject*)col withValue:(NSString*)value  andWithOldValue:(NSString*)oldValue;
- (void) cellWillChanging;
- (void) objectWillAdding;

@end

@interface VGTableView : UIScrollView <UITextFieldDelegate>

- (void) reloadData;
- (void) edtiMode:(BOOL)canEdit;
- (id)initWithFrame:(CGRect)frame andUser:(VGUser*) user;

@property (nonatomic, retain) VGUser* user;
@property (nonatomic, assign) id<VGTableAddDelegate> tableDetegate;
@property (nonatomic, retain) UIViewController* parentViewController;

@end