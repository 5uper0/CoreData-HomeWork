//
//  OVUsersViewController.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVUserEditingViewController.h"
#import "OVUsersTableViewController.h"
#import "OVUser.h"
#import "OVDataManager.h"
#import "OVCourse.h"

@interface OVUsersTableViewController ()

@property (strong, nonatomic) NSMutableArray *cellsSelected;
@property (strong, nonatomic) NSMutableArray *cellsDeselected;

@property (strong, nonatomic) NSIndexPath *selectedTeacherPath;

@end

@implementation OVUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.course && !self.isTeachersView) {
        
        self.navigationItem.title = @"Choose Students";
        
        UIBarButtonItem *saveButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                      target:self
                                                      action:@selector(actionSaveMarked:)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
    
    } else if (!self.course && !self.isTeachersView) {
        
        self.navigationItem.title = @"Students";
        
        UIBarButtonItem *editButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                      target:self
                                                      action:@selector(actionEdit:)];
        
        self.navigationItem.leftBarButtonItem = editButton;
        
        UIBarButtonItem *addButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(actionAddNewUser:)];
        self.navigationItem.rightBarButtonItem = addButton;
        

    } else if (self.isTeachersView) {
        
        self.navigationItem.title = @"Choose Teacher";
        
        UIBarButtonItem *saveButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                      target:self
                                                      action:@selector(actionSaveTeacher:)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cellsSelected = [NSMutableArray array];
    self.cellsDeselected = [NSMutableArray array];
    
    NSIndexPath *indexPath = nil;
    OVUser *user = nil;
    
    if (self.course && self.isTeachersView) {
        
        user = [self.course teacher];
        indexPath = [self.fetchedResultsController indexPathForObject:user];
        
        
    } else if (self.course && !self.isTeachersView) {
        
        NSSortDescriptor *firstNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *lastNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
        
        NSArray *tempArray = [NSArray arrayWithArray:[self.course.students allObjects]];
        
        OVUser *user = [[tempArray sortedArrayUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]] firstObject];
                
        indexPath = [self.fetchedResultsController indexPathForObject:user];

    }
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    
}

- (void)dealloc {
    
    self.course = nil;
    self.isTeachersView = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionSaveMarked:(UIBarButtonItem *)sender {
    
    NSMutableArray *selectedStudents = [NSMutableArray array];
    NSMutableArray *deselectedStudents = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.cellsSelected) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *emailKey = cell.detailTextLabel.text;
        
        NSArray *allUsers = [[OVDataManager sharedManager] getAllUsers];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", emailKey];
        
        NSArray *filteredStudents = [allUsers filteredArrayUsingPredicate:predicate];
        
        if ([filteredStudents count] > 0) {
            
            [selectedStudents addObject:[filteredStudents firstObject]];
        }
    }
    
    for (NSIndexPath *indexPath in self.cellsDeselected) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *emailKey = cell.detailTextLabel.text;
        
        NSArray *allUsers = [[OVDataManager sharedManager] getAllUsers];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", emailKey];
        
        NSArray *filteredStudents = [allUsers filteredArrayUsingPredicate:predicate];
        
        if ([filteredStudents count] > 0) {
            
            [deselectedStudents addObject:[filteredStudents firstObject]];
        }
    }
    
    [[OVDataManager sharedManager] changeCourse:self.course
                                  byAddingUsers:selectedStudents];
    
    [[OVDataManager sharedManager] changeCourse:self.course
                                byRemovingUsers:deselectedStudents];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSaveTeacher:(UIBarButtonItem *)sender {
    
    if (self.selectedTeacherPath) {
        
        OVUser *newTeacher = [self.fetchedResultsController objectAtIndexPath:self.selectedTeacherPath];
        
        [self.course setTeacher:newTeacher];
        
    } else {
        
        [self.course setTeacher:nil];
    }
    
    [[OVDataManager sharedManager] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionEdit:(UIBarButtonItem *)sender {
    
    UIBarButtonItem *button = nil;
    
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                               target:self
                                                               action:@selector(actionEdit:)];

    } else {
        [self.tableView setEditing:YES animated:YES];
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:self
                                                               action:@selector(actionEdit:)];
    }
    
    self.navigationItem.leftBarButtonItem = button;
}

- (void)actionAddNewUser:(UIBarButtonItem *)sender {
    
    OVUserEditingViewController *vc = [[OVUserEditingViewController alloc] init];
    vc.user = nil;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Fetched results controller

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *description =
    [NSEntityDescription entityForName:@"OVUser"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    OVUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.detailTextLabel.text = user.email;
    
    if (self.course && !self.isTeachersView) {
        
        if ([user.learningCourses containsObject:self.course] || [self.cellsSelected containsObject:indexPath]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
    
    } else if (!self.course && !self.isTeachersView) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else if (self.isTeachersView) {
        
        if (!self.selectedTeacherPath && [user.teachingCourses containsObject:self.course]) {
            
            self.selectedTeacherPath = indexPath;
        }
        
        if ([self.selectedTeacherPath isEqual:indexPath]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"OVUser" inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO];
    
    NSError *error = nil;
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    
    if (count == NSNotFound) {
        NSLog(@"------------- Error couinting objects");
    }
    
    return count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OVUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.course && !self.isTeachersView) {
        
        if ([self.cellsSelected containsObject:indexPath] || [user.learningCourses containsObject:self.course]) {
        
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.cellsDeselected addObject:indexPath];
            
            if ([self.cellsSelected containsObject:indexPath]) {
                [self.cellsSelected removeObject:indexPath];
            }
            
        } else {
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [self.cellsSelected addObject:indexPath];
            
            if ([self.cellsDeselected containsObject:indexPath]) {
                [self.cellsDeselected removeObject:indexPath];
            }
            
        }

        //[tableView reloadData];
         
    } else if (!self.course && !self.isTeachersView) {
    
        OVUserEditingViewController *vc = [[OVUserEditingViewController alloc] init];
        vc.user = user;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (self.isTeachersView) {
        
        if (self.selectedTeacherPath) {
            
            UITableViewCell *uncheckedCell = [tableView cellForRowAtIndexPath:self.selectedTeacherPath];
            uncheckedCell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        if ([self.selectedTeacherPath isEqual:indexPath]) {
            
            self.selectedTeacherPath = nil;
            UITableViewCell *uncheckedCell = [tableView cellForRowAtIndexPath:indexPath];
            uncheckedCell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            
            self.selectedTeacherPath = indexPath;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
