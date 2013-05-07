//
//  VGStudentsCell.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGStudentsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (retain, nonatomic) IBOutlet UILabel *lblFirstName;
@property (retain, nonatomic) IBOutlet UILabel *lblSecondName;
@property (retain, nonatomic) IBOutlet UILabel *lblAge;
@property (retain, nonatomic) IBOutlet UILabel *lblSide;

@end
