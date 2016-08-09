//
//  OVCourse+CoreDataProperties.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/13/16.
//  Copyright © 2016 Selfie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OVCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface OVCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *branch;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSSet<OVUser *> *students;
@property (nullable, nonatomic, retain) OVUser *teacher;

@end

@interface OVCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(OVUser *)value;
- (void)removeStudentsObject:(OVUser *)value;
- (void)addStudents:(NSSet<OVUser *> *)values;
- (void)removeStudents:(NSSet<OVUser *> *)values;

@end

NS_ASSUME_NONNULL_END
