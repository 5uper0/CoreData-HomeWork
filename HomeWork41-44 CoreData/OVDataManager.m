//
//  OVDataManager.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVDataManager.h"
#import "OVUser.h"
#import "OVCourse.h"

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

typedef enum : NSUInteger {
    OVSubjectNameAgriculture,
    OVSubjectNameArchaelogy,
    OVSubjectNameBiology,
    OVSubjectNameChemistry,
    OVSubjectNameEarth,
    OVSubjectNameFood,
    OVSubjectNameCss,
    OVSubjectNameEngagement,
    OVSubjectNameGeographic,
    OVSubjectNameGeos,
    OVSubjectNameInformationSystems,
    OVSubjectNameMath,
    OVSubjectNamePhysics,
    OVSubjectNamePsychology,
    OVSubjectNameSciense,
    OVSubjectNameVeterinary
} OVSubjectName;

typedef enum : NSUInteger {
    OVCoursePropertyNameSubject,
    OVCoursePropertyNameBranch
} OVCoursePropertyName;

@implementation OVDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (OVDataManager *)sharedManager {
    
    static OVDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OVDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Private Methods

- (void)changeCourse:(OVCourse *)course
            withName:(NSString *)name
             subject:(NSString *)subject
              branch:(NSString *)branch
             teacher:(OVUser *)teacher {
    
    course.name = name;
    course.subject = subject;
    course.branch = branch;
    course.teacher = teacher;
    
    [self saveContext];
}

- (void)changeCourse:(OVCourse *)course
       byAddingUsers:(NSArray *)students {
    
    NSInteger count = [course.students count];
    
    [course addStudents:[NSSet setWithArray:students]];
    
    [self saveContext];
}

- (void)changeCourse:(OVCourse *)course
     byRemovingUsers:(NSArray *)students {
    
    NSInteger count = [course.students count];

    [course removeStudents:[NSSet setWithArray:students]];
    
    [self saveContext];
}

- (void)changeCourse:(OVCourse *)course
    bySettingTeacher:(OVUser *)teacher {
    
    course.teacher = teacher;
    
    [self saveContext];
}

- (void)insertCourseWithName:(NSString *)name
                     subject:(NSString *)subject
                      branch:(NSString *)branch
                     teacher:(OVUser *)teacher {
    
    OVCourse *course =
    [NSEntityDescription insertNewObjectForEntityForName:@"OVCourse"
                                  inManagedObjectContext:self.managedObjectContext];
    
    course.name = name;
    course.subject = subject;
    course.branch = branch;
    course.teacher = teacher;
    
    [self saveContext];
}

- (void)changeUser:(OVUser *)student
    withFirstName:(NSString *)firstName
         lastName:(NSString *)lastName
         andEmail:(NSString *)email {
    
    student.firstName = firstName;
    student.lastName = lastName;
    student.email = email;
    
    [self saveContext];
}

- (void)insertUserWithFirstName:(NSString *)firstName
                      lastName:(NSString *)lastName
                      andEmail:(NSString *)email {
    
    OVUser *student =
    [NSEntityDescription insertNewObjectForEntityForName:@"OVUser"
                                  inManagedObjectContext:self.managedObjectContext];
    
    student.firstName = firstName;
    student.lastName = lastName;
    student.email = email;
    
    [self saveContext];
}

- (void)addRandomStudent {
    
    OVUser *student =
    [NSEntityDescription insertNewObjectForEntityForName:@"OVUser"
                                  inManagedObjectContext:self.managedObjectContext];
    
    student.firstName = firstNames[arc4random_uniform(51)];
    student.lastName = lastNames[arc4random_uniform(51)];
    student.email = [self getRandomEmail];
}

- (void)addAllCourses {
    
    // [Subject objectAtIndex:0] is the Name of the Subject
    // [Subject objectAtIndex:1] is the Name of the Branch
    // All String objects goes after are names of the Courses.
    
    NSArray *agriculture = @[
        @"Agriculture",
        @"Humanitarian Sciense",
        
        @"Applied Biology II",
        @"Australia's Bio-Physical Environment",
        @"Food for a Healthy Planet",
        @"Cell and Tissue Biology for Agriculture and Veterinary Science"
    ];
    
    NSArray *archaeology = @[
        @"Archaeology",
        @"Humanitarian Sciense",
        
        @"Discovering Archaeology",
        @"Doing Archaeology",
    ];
    
    NSArray *biology = @[
        @"Biology",
        @"Humanitarian Sciense",
        
        @"Genes, Cells & Evolution",
        @"Global Challenges in Biology",
        @"Cells to Organisms"
    ];
    
    NSArray *chemistry = @[
        @"Chemistry",
        @"Natural Science",
        
        @"Introductory Chemistry",
        @"Chemistry 1",
        @"Chemistry 2",
        @"General, Organic & Biological Chemistry"
    ];
    
    NSArray *earth = @[
        @"Earth",
        @"Humanitarian Sciense",
        
        @"Planet Earth: The Big Picture"
    ];
    
    NSArray *food = @[
        @"Food",
        @"Humanitarian Sciense",
        
        @"Principles of Food Preservation"
    ];
    
    NSArray *css = @[
        @"CSS",
        @"Computer Sciense",
                     
        @"Introduction to Software Engineering"
    ];
    
    NSArray *engagement = @[
        @"Engagement",
        @"Humanitarian Sciense",
                            
        @"Introduction to Research Practices - The Big Issues"
    ];
    
    NSArray *geographic = @[
        @"Geographic",
        @"Humanitarian Sciense",
                            
        @"Geographical Information and Data Analysis"
    ];
    
    NSArray *geos = @[
        @"Geos",
        @"Humanitarian Sciense",
                      
        @"Environment & Society"
    ];
    
    NSArray *informationSystems = @[
        @"Information Systems",
        @"Computer Sciense",
                                    
        @"Introduction to Information Systems"
    ];
    
    NSArray *math = @[
        @"Math",
        @"Formal Science",
                      
        @"Mathematical Foundations",
        @"Calculus & Linear Algebra I",
        @"Multivariate Calculus & Ordinary Differential Equations",
        @"Discrete Mathematics"
    ];
    
    NSArray *physics = @[
        @"Physics",
        @"Natural Science",
                         
        @"Mechanics & Thermal Physics I",
        @"Electromagnetism and Modern Physics",
        @"Physical Basis of Biological Systems"
    ];
    
    NSArray *psychology = @[
        @"Psychology",
        @"Humanitarian",
                            
        @"Introduction to Psychology: Physiological & Cognitive Psychology",
        @"Introduction to Psychology: Developmental, Social & Clinical Psychology",
        @"Psychological Research Methodology I",
    ];
    
    NSArray *science = @[
        @"Science",
        @"Natural Science",
                         
        @"Theory & Practice in Science",
    ];
    
    NSArray *veterinary = @[
        @"Veterinary",
        @"Medicine",
                            
        @"One Health: Animals, the Environment and Human Disease",
        @"Animal and Veterinary Biology"
    ];
    
    NSArray *subjectsArray = @[
       agriculture, archaeology, biology, chemistry,
       earth, food, css, engagement, geographic, geos,
       informationSystems, math, physics, psychology,
       science, veterinary];
    
    for (NSArray *coursesNames in subjectsArray) {
        
        for (int i = 2; i < [coursesNames count]; i++) {
            
            OVCourse *course =
            [NSEntityDescription insertNewObjectForEntityForName:@"OVCourse"
                                          inManagedObjectContext:self.managedObjectContext];
            
            course.name = [coursesNames objectAtIndex:i];
            course.subject = [coursesNames objectAtIndex:OVCoursePropertyNameSubject];
            course.branch = [coursesNames objectAtIndex:OVCoursePropertyNameBranch];
            course.teacher = nil;
        }
    }
    
    [self saveContext];
    
}

- (NSArray *)getAllCourses {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OVCourse"];

    NSError *requestError = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request
                                                                    error:&requestError];
    
    if (requestError) {
        NSLog(@"--------------- %@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (NSArray *)getAllUsers {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OVUser"];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request
                                                                    error:&requestError];
    
    if (requestError) {
        NSLog(@"--------------- %@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (OVUser *)getUserByEmail:(NSString *)email {
        
    NSArray *allStudents = [self getAllUsers];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
    
    NSArray *filteredStudents = [allStudents filteredArrayUsingPredicate:predicate];
    
    return [filteredStudents firstObject];
}

- (void)deleteAllUsers {
    
    for (OVUser *user in [self getAllUsers]) {
        [self.managedObjectContext deleteObject:user];
    }
    
    [self.managedObjectContext save:nil];
}

- (void)deleteAllCourses {
    
    for (OVCourse *course in [self getAllCourses]) {
        [self.managedObjectContext deleteObject:course];
    }
    
    [self.managedObjectContext save:nil];
}


- (void)generateNewDataBase {
    
    NSError *error = nil;
    
    [self addAllCourses];
    
    NSArray *allCourses = [self getAllCourses];
    
    for (int i = 0; i < 1000; i++) {
        
        [self addRandomStudent];
    }
    
    NSArray *allUsers = [self getAllUsers];
    
    for (OVCourse *course in allCourses) {
        
        for (OVUser *user in [self getAllUsers]) {
            
            if (arc4random_uniform(101) > 90) {
                
                NSMutableArray *tempCourses = [NSMutableArray arrayWithArray:[user.learningCourses allObjects]];
                
                [tempCourses addObject:course];
                
                user.learningCourses = [NSSet setWithArray:tempCourses];
            }
            
        }
        
        NSUInteger randomUserNumber = arc4random_uniform((unsigned int)[allUsers count] + 1);
        course.teacher = [allUsers objectAtIndex:randomUserNumber];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"--------------- %@", [error localizedDescription]);
    }
}

- (NSString*)getRandomEmail {
    return [NSString stringWithFormat:@"%@@%@.com", [self getRandomString], [self getRandomString]];
}

- (NSString*)getRandomString {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    int length = arc4random_uniform(7) + 1;
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i=0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (void)printAllUsers {
    
    for (OVUser *user in [self getAllUsers]) {
        NSLog(@"%@ %@ - %@", user.firstName, user.lastName, user.email);
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.olehveheria.HomeWork41_44_CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HomeWork41_44_CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HomeWork41_44_CoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
