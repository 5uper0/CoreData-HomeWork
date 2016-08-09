//
//  OVUser+CoreDataProperties.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/13/16.
//  Copyright © 2016 Selfie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OVUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface OVUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<OVCourse *> *learningCourses;
@property (nullable, nonatomic, retain) NSSet<OVCourse *> *teachingCourses;

@end

@interface OVUser (CoreDataGeneratedAccessors)

- (void)addLearningCoursesObject:(OVCourse *)value;
- (void)removeLearningCoursesObject:(OVCourse *)value;
- (void)addLearningCourses:(NSSet<OVCourse *> *)values;
- (void)removeLearningCourses:(NSSet<OVCourse *> *)values;

- (void)addTeachingCoursesObject:(OVCourse *)value;
- (void)removeTeachingCoursesObject:(OVCourse *)value;
- (void)addTeachingCourses:(NSSet<OVCourse *> *)values;
- (void)removeTeachingCourses:(NSSet<OVCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
