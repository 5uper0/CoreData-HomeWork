//
//  OVCoursesEditingTableViewController.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/9/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OVCourse;
@class OVUser;

@interface OVCoursesEditingTableViewController : UITableViewController

@property (strong, nonatomic) OVCourse *course;
@property (strong, nonatomic) OVUser *teacher;

@end
