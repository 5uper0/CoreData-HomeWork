//
//  OVCoursesEditingTableViewController.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/9/16.
//  Copyright © 2016 Selfie. All rights reserved.
//
#import "OVDataManager.h"
#import "OVCoursesEditingTableViewController.h"
#import "OVCourse.h"
#import "OVUsersTableViewController.h"
#import "OVUserEditingViewController.h"

@interface OVCoursesEditingTableViewController () <UITableViewDataSource, UITabBarControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *subjectField;
@property (strong, nonatomic) UITextField *branchField;
@property (strong, nonatomic) UILabel *teacherLabel;

@property (strong, nonatomic) NSArray *allStudents;

@end

typedef enum : NSUInteger {
    
    OVTextFieldName     = 0,
    OVTextFieldSubject  = 1,
    OVTextFieldBranch   = 2,
    OVTextFieldTeacher  = 3
    
} OVTextField;

@implementation OVCoursesEditingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (self.course) {
        self.navigationItem.title = self.course.name;
        
    } else {
        
        self.navigationItem.title = @"Add New Course";
    }
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(actionCheckIfDone)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.nameField becomeFirstResponder];
    
    self.teacher = self.course.teacher;
    
    self.nameField = [self createAndSetTextField];
    self.nameField.text = self.course.name;
    self.nameField.tag = OVTextFieldName;

    self.subjectField = [self createAndSetTextField];
    self.subjectField.text = self.course.subject;
    self.subjectField.tag = OVTextFieldSubject;
    
    self.branchField = [self createAndSetTextField];
    self.branchField.text = self.course.branch;
    self.branchField.tag = OVTextFieldBranch;
    
    self.teacherLabel = [self createAndSetLabel];
    self.teacherLabel.textAlignment = NSTextAlignmentLeft;
    
    [self setArrayOfStudents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.course.teacher) {
        
        OVUser *teacher = self.course.teacher;
        
        self.teacherLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
        self.teacherLabel.textColor = [UIColor blackColor];

    } else {
        
        self.teacherLabel.text = @"Select New One";
        self.teacherLabel.textColor = [UIColor lightGrayColor];
    }

    [self setArrayOfStudents];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionCheckIfDone {
    
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
    }
    
    NSString *name = self.nameField.text;
    NSString *subject = self.subjectField.text;
    NSString *branch = self.branchField.text;
    
    if (![name isEqualToString:@""] && ![subject isEqualToString:@""] && ![branch isEqualToString:@""]) {
        
        if ([self.course.name isEqualToString:name] &&
            [self.course.subject isEqualToString:subject] &&
            [self.course.branch isEqualToString:branch] &&
            [self.course.students isEqualToSet:self.course.students]) {
            
        } else if (self.course) {
            
            [[OVDataManager sharedManager] changeCourse:self.course
                                               withName:name
                                                subject:subject
                                                 branch:branch
                                                teacher:self.teacher];
            
        } else {
            
            [[OVDataManager sharedManager] insertCourseWithName:name
                                                        subject:subject
                                                         branch:branch
                                                        teacher:self.teacher];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self animateAlertWithTextField:self.nameField];
        [self animateAlertWithTextField:self.subjectField];
        [self animateAlertWithTextField:self.branchField];
        
    }
    

}

- (void)actionAddStudents:(id)sender {
    
    OVUsersTableViewController *vc = [[OVUsersTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.course = self.course;
    
    if ([sender isKindOfClass:[UIButton class]]) {

        vc.isTeachersView = NO;

    } else  {
        
        vc.isTeachersView = YES;
    }
    
}

- (void)actionSaveChanges:(id)sender {

    [self.tableView setEditing:NO animated:YES];
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *deleteButton = (UIButton *)sender;
        [deleteButton setTitle:@"Delete From Course" forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5f]];
        [deleteButton addTarget:self action:@selector(actionDeleteStudents:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)actionDeleteStudents:(id)sender {
    
    [self.tableView setEditing:YES animated:YES];
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *currentButton = (UIButton *)sender;
        [currentButton setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5f]];
        [currentButton setTitle:@"Save Marked" forState:UIControlStateNormal];
        [currentButton addTarget:self action:@selector(actionSaveChanges:) forControlEvents:UIControlEventTouchUpInside];

    }
}

#pragma mark - Private Methods

- (void)setArrayOfStudents {
    
    NSSortDescriptor *firstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastName = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    self.allStudents = [[self.course.students allObjects] sortedArrayUsingDescriptors:@[firstName, lastName]];
        
    NSLog(@"self.allStudents = allStudents");
}

- (UITextField *)createAndSetTextFieldFromRect:(CGRect)rect andText:(NSString *)text {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.text = text;
    textField.delegate = self;
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enablesReturnKeyAutomatically = YES;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeyNext;

    
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    return textField;
}

- (UITextField *)createAndSetTextField {
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enablesReturnKeyAutomatically = YES;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeyNext;
    
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    return textField;
}

- (UILabel *)createAndSetLabelFromRect:(CGRect)rect andText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.text = text;
    label.numberOfLines = 0;
    
    return label;
}

- (UILabel *)createAndSetLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    
    return label;
}

- (void)animateAlertWithTextField:(UITextField *)textField {
    
    [UITextField animateWithDuration:0.5f
                               delay:0.0f
                             options:0
                          animations:^{
                              textField.backgroundColor = [UIColor redColor];
                          }
                          completion:^(BOOL finished) {
                              if (finished) {
                                  [UITextField animateWithDuration:0.5f
                                                             delay:0.0f
                                                           options:0
                                                        animations:^{
                                                            textField.backgroundColor = [UIColor whiteColor];
                                                        }
                                                        completion:nil];
                                  
                              }
                          }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Course Info";
        
    } else {
        return @"Course Students";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;

    }
        
    NSUInteger count = [self.course.students count] + 1;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"CourseEditingCell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
          
        }
        
        CGRect labelRect = CGRectMake(0, 8, CGRectGetWidth(self.view.bounds) / 4 - 10, 30);
        CGRect textFieldRect = CGRectMake(CGRectGetWidth(self.view.bounds) / 4 + 10, 8, CGRectGetWidth(self.view.bounds) - CGRectGetWidth(labelRect) * 1.5f, 30);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        
        if (indexPath.row == OVTextFieldName) {
            
            label.text = @"Name";
            
            self.nameField.frame = textFieldRect;
            //cell.accessoryView = self.firstNameField;
            [cell addSubview:self.nameField];
            
        } else if (indexPath.row == OVTextFieldSubject) {
            
            label.text = @"Subject";
            
            self.subjectField.frame = textFieldRect;
            [cell addSubview:self.subjectField];
            
        } else if (indexPath.row == OVTextFieldBranch) {
            
            label.text = @"Branch";

            self.branchField.frame = textFieldRect;
            [cell addSubview:self.branchField];
            
        } else if (indexPath.row == OVTextFieldTeacher) {
            
            label.text = @"Teacher";
            
            self.teacherLabel.frame = textFieldRect;
            [cell addSubview:self.teacherLabel];
            
        }
        
        [cell addSubview:label];
        
        return cell;
        
    } else {
        
        if (indexPath.row == 0) {
            
            static NSString *identifier = @"AddNewStudentCell";
            
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
                
                UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.view.frame) / 2 - 8, 30)];
                [deleteButton setTitle:@"Delete From Course" forState:UIControlStateNormal];
                [deleteButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5f]];
                [deleteButton addTarget:self action:@selector(actionDeleteStudents:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:deleteButton];
                
                UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 8 + 10, 5, CGRectGetWidth(self.view.bounds) / 2 - 8,  + 30)];
                addButton.backgroundColor = [UIColor lightGrayColor];
                
                [addButton setTitle:@"Add To Course" forState:UIControlStateNormal];
                [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                [addButton setTitle:@"Correct" forState:UIControlStateSelected];
                [addButton addTarget:self action:@selector(actionAddStudents:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:addButton];
                
            }
            
            
            return cell;
   
        } else {
            
            static NSString *identifier = @"CourseStudentsCell";
            
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:identifier];
            }
            
            OVUser *student = [self.allStudents objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            cell.detailTextLabel.text = student.email;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            return cell;
        }
        

    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OVUser *user = [self.allStudents objectAtIndex:indexPath.row - 1];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.allStudents];
    
    NSLog(@"[tempArray count] = %ld", [tempArray count]);
    
    [tempArray removeObject:user];

    self.allStudents = [NSArray arrayWithArray:tempArray];

    NSLog(@"[self.allStudents count] = %ld", [self.allStudents count]);
    
    [self.course removeStudents:self.course.students];
    [self.course addStudents:[NSSet setWithArray:self.allStudents]];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}*/


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        
        [self actionAddStudents:nil];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
    
        OVUsersTableViewController *vc = [[OVUsersTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.course = self.course;
        
    } else if (indexPath.section == 1 && indexPath.row > 0) {
        
        OVUserEditingViewController *vc = [[OVUserEditingViewController alloc] init];
        
        OVUser *student = [self.allStudents objectAtIndex:indexPath.row - 1];
        vc.user = student;
        
        vc.modalPresentationStyle = UIModalPresentationPopover;
        
        UIPopoverPresentationController *popController = [vc popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
        popController.canOverlapSourceViewRect = NO;
        popController.sourceView = [self.view superview];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 1 && indexPath.row > 0) || (indexPath.section == 0 && indexPath.row == 3)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case OVTextFieldName:
            [self.subjectField becomeFirstResponder];
            break;
            
        case OVTextFieldSubject:
            [self.branchField becomeFirstResponder];
            break;
            
        case OVTextFieldBranch:
            [self.branchField resignFirstResponder];
            break;

        default:
            break;
    }
    
    return NO;
}

@end
