//
//  OVCoursesViewController.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/8/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVCoursesViewController.h"
#import "OVCoursesEditingTableViewController.h"
#import "OVCourse.h"
#import "OVCoursesEditingTableViewController.h"

@interface OVCoursesViewController ()

@end

@implementation OVCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Courses";
    
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(actionEdit:)];
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(actionAddNewCourse:)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

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

- (void)actionAddNewCourse:(UIBarButtonItem *)sender {
        
    OVCoursesEditingTableViewController *vc = [[OVCoursesEditingTableViewController alloc] init];
    vc.course = nil;
    
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
    [NSEntityDescription entityForName:@"OVCourse"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor *subjectDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[subjectDescriptor, nameDescriptor]];
    
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
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}
*/
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    OVCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
     
    cell.detailTextLabel.text = course.subject;    
    cell.textLabel.text = course.name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"OVCourse"
                                   inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:NO];
    
    NSError *error = nil;
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    
    if(count == NSNotFound) {
        NSLog(@"------------- Error couinting objects");
    }
    
    return count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OVCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    OVCoursesEditingTableViewController *vc = [[OVCoursesEditingTableViewController alloc] init];
    vc.course = course;
    
    [self.navigationController pushViewController:vc animated:YES];
     
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
@end
