//
//  OVStudentsViewController.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVCoreDataTableViewController.h"

@class OVCourse;

@interface OVUsersTableViewController : OVCoreDataTableViewController

@property (strong, nonatomic) OVCourse *course;
@property (assign, nonatomic) BOOL isTeachersView;

@end
