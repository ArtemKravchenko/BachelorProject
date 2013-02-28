//
//  VGTableView.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

@interface VGTableView : UIScrollView

@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, assign) id<VGTableAddDelegate> tableDetegate;

@end

@interface VGTableCell : NSObject

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger colIndex;
@property (nonatomic, retain) NSString  *value;

@end