//
//  OVTeachersViewController.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/14/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVTeachersViewController.h"
#import "OVUserEditingViewController.h"
#import "OVUser.h"

@interface OVTeachersViewController ()

@end

@implementation OVTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.title = @"Teachers";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"teachingCourses.@count > 0"];
    
    [fetchRequest setPredicate:predicate];
    
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", [[user.teachingCourses allObjects] count]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"OVUser" inManagedObjectContext:self.managedObjectContext]];
        
    [fetchRequest setIncludesSubentities:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"teachingCourses.@count > 0"];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if (count == NSNotFound) {
        NSLog(@"------------- Error couinting objects");
    }
    
    return count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OVUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    //[tableView reloadData];
    
    OVUserEditingViewController *vc = [[OVUserEditingViewController alloc] init];
    vc.user = user;

    [self.navigationController pushViewController:vc animated:YES];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
