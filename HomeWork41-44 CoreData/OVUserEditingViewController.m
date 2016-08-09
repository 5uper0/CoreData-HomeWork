//
//  OVStudentEditingViewController.m
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import "OVDataManager.h"
#import "OVCourse.h"
#import "OVCoursesViewController.h"
#import "OVUser.h"
#import "OVUserEditingViewController.h"


@interface OVUserEditingViewController () <UITableViewDataSource, UITabBarControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *emailField;

@property (strong, nonatomic) NSArray *learningCourses;
@property (strong, nonatomic) NSArray *teachingCourses;

@end

typedef enum : NSUInteger {
    
    OVTextFieldFirstName    = 0,
    OVTextFieldLastName     = 1,
    OVTextFieldEmail        = 2
    
} OVTextField;

@implementation OVUserEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.user) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];

    } else {
        
        self.navigationItem.title = @"Add New Student";
    }
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(checkSelfTextFieldsIfCorrect)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.firstNameField = [self createAndSetTextField];
    self.firstNameField.text = self.user.firstName;
    [self.firstNameField becomeFirstResponder];

    self.lastNameField = [self createAndSetTextField];
    self.lastNameField.text = self.user.lastName;

    self.emailField = [self createAndSetTextField];
    self.emailField.text = self.user.email;
    self.emailField.returnKeyType = UIReturnKeyDone;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyDone;
    
    self.firstNameField.tag = OVTextFieldFirstName;
    self.lastNameField.tag  = OVTextFieldLastName;
    self.emailField.tag     = OVTextFieldEmail;
    
    [self setArraysOfCourses];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setArraysOfCourses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (BOOL)checkSelfTextFieldsIfCorrect {
    
    BOOL ifCorrect = YES;

    if ([self.firstNameField.text length] < 3) {
        
        [self animateAlertWithTextField:self.firstNameField];
        ifCorrect = NO;

    }

    if ([self.lastNameField.text length] < 3) {
        
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self animateAlertWithTextField:self.lastNameField];
        });
        
        ifCorrect = NO;

    }
    
    if (![self validateEmail:self.emailField.text]) {
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self animateAlertWithTextField:self.emailField];
        });
        
        ifCorrect = NO;
        
    }
    
    if (ifCorrect) {
        
        [self actionDone];
        return YES;
        
    } else {
        
        return NO;
    }
}

- (void)actionDone {

    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    NSString *email = self.emailField.text;
    
    if (self.user) {
        
        if (![self.user.firstName isEqualToString:firstName] ||
            ![self.user.lastName isEqualToString:lastName] ||
            ![self.user.email isEqualToString:email]) {
            
            [[OVDataManager sharedManager] changeUser:self.user
                                        withFirstName:firstName
                                             lastName:lastName
                                             andEmail:email];
        }
        
    } else {

        [[OVDataManager sharedManager] insertUserWithFirstName:firstName
                                                         lastName:lastName
                                                         andEmail:email];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Private Methods

- (UITextField *)createAndSetTextFieldFromRect:(CGRect)rect text:(NSString *)text AndIfIsEmail:(BOOL)isEmail {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.text = text;
    textField.delegate = self;
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.enablesReturnKeyAutomatically = YES;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    if (isEmail) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.returnKeyType = UIReturnKeyDone;
    
    } else {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeyNext;
    }
    
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

- (void)setArraysOfCourses {
    
    NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    self.teachingCourses = [[self.user.teachingCourses allObjects] sortedArrayUsingDescriptors:@[name]];
    self.learningCourses = [[self.user.learningCourses allObjects] sortedArrayUsingDescriptors:@[name]];
    
    NSLog(@"\n__________________________\nteachingCourses\n\n%@\n\n\n\n\n______________________________\nlearningCourses\n\n%@", self.teachingCourses, self.learningCourses);
}

- (BOOL)validateEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:string];
}

- (void)animateAlertWithTextField:(UITextField *)textField {
    
    [UITextField animateWithDuration:0.5f
                               delay:0.0f
                             options:0
                          animations:^{
                              textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Student Info";
        
    } else if (section == 1 && [self.teachingCourses count] > 0) {
        return @"Teaching Courses";
        
    } else if ([self.learningCourses count] > 0) {
        return @"Learning Courses";
    }
    
    return @"Oops";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = 1;
    
    if ([self.teachingCourses count] > 0) {
        count++;
        
    }
    
    if ([self.learningCourses count] > 0) {
        count++;
    }
    
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;

    } else if (section == 1 && [self.teachingCourses count] > 0) {
        return [self.teachingCourses count];
        
    } else if ([self.learningCourses count] > 0) {
        return [self.learningCourses count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"UserEditingCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        if (indexPath.section == 0) {
            
            CGRect labelRect = CGRectMake(0, 8, CGRectGetWidth(self.view.bounds) / 4 - 10, 30);
            CGRect textFieldRect = CGRectMake(CGRectGetWidth(self.view.bounds) / 4 + 10, 8, CGRectGetWidth(self.view.bounds) - CGRectGetWidth(labelRect) * 1.5f, 30);
            
            UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = [UIColor grayColor];
            
            UITextField *textField = nil;
            
            if (indexPath.row == OVTextFieldFirstName) {
                
                label.text = @"First Name";
                
                //cell.accessoryView = self.firstNameField;
                self.firstNameField.frame = textFieldRect;
                textField = self.firstNameField;
                
            } else if (indexPath.row == OVTextFieldLastName) {
                
                label.text = @"Last Name";
                
                self.lastNameField.frame = textFieldRect;
                textField = self.lastNameField;
                
            } else if (indexPath.row == OVTextFieldEmail) {
                
                label.text = @"E-mail";

                self.emailField.frame = textFieldRect;
                textField = self.emailField;
            }
            
            [cell addSubview:label];
            [cell addSubview:textField];
            
        } else {
            
            OVCourse *course = nil;
            
            if (indexPath.section == 1) {
                
                if ([self.teachingCourses count] > 0) {
                    course = [self.teachingCourses objectAtIndex:indexPath.row];
                    
                } else if ([self.learningCourses count] > 0) {
                    course = [self.learningCourses objectAtIndex:indexPath.row];
                }
                
            } else if (indexPath.section == 2) {
                
                course = [self.learningCourses objectAtIndex:indexPath.row];
            }
            
            cell.textLabel.text = course.name;
            cell.detailTextLabel.text = course.subject;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == OVTextFieldFirstName) {
        
        [self.lastNameField becomeFirstResponder];
        
    } else if (textField.tag == OVTextFieldLastName) {
        
        [self.emailField becomeFirstResponder];
        
    } else if (textField.tag == OVTextFieldEmail) {
        
        if([self checkSelfTextFieldsIfCorrect]) {
            
            [self.emailField resignFirstResponder];

        }
    }

    return NO;
}

@end
