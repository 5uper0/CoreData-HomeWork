//
//  OVStudentEditingViewController.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

// Controller for editing existing user or adding information about new one

#import "OVCoreDataTableViewController.h"

@class OVUser;

@interface OVUserEditingViewController : UITableViewController

@property (strong, nonatomic) OVUser *user;

@end
