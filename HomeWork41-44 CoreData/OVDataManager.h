//
//  OVDataManager.h
//  HomeWork41-44 CoreData
//
//  Created by Oleh Veheria on 7/6/16.
//  Copyright © 2016 Selfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "OVUser.h"

@interface OVDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (OVDataManager *)sharedManager;

- (void)changeCourse:(OVCourse *)course
            withName:(NSString *)name
             subject:(NSString *)subject
              branch:(NSString *)branch
             teacher:(OVUser *)teacher;

- (void)changeCourse:(OVCourse *)course
    byAddingUsers:(NSArray *)students;

- (void)changeCourse:(OVCourse *)course
     byRemovingUsers:(NSArray *)students;

- (void)changeCourse:(OVCourse *)course
    bySettingTeacher:(OVUser *)teacher;

- (void)insertCourseWithName:(NSString *)name
                     subject:(NSString *)subject
                      branch:(NSString *)branch
                     teacher:(OVUser *)teacher;

- (void)insertUserWithFirstName:(NSString *)firstName
                       lastName:(NSString *)lastName
                       andEmail:(NSString *)email;

- (void)changeUser:(OVUser *)student
     withFirstName:(NSString *)firstName
          lastName:(NSString *)lastName
          andEmail:(NSString *)email;

- (void)generateNewDataBase;

- (NSArray *)getAllUsers;
- (OVUser *)getUserByEmail:(NSString *)email;

- (void)deleteAllUsers;
- (void)deleteAllCourses;

@end

/*
 
 Ученик.
 
 1. Делаем экран со списком юзеров. На пенели навигации есть плюсик, который добавляет нового юзера. При добавлении либо редактировании юзера мы переходим на экран, гдето можем вводить его данные в динамической(!) таблице: имя, фамилия, почтовый ящик.
 
 2. Юзеров можно добавлять, удалять и редактировать.
 
 3. Добавляем UITabBarController к проекту! Приложение стартует с него и наш экран с юзерами это всего лишь один из табов. Разберитесь с этим контроллером самостоятельно. Делайте его в сториборде. Для каждого контроллера в табах делайте навигейшн, чтобы была у всех панелька навигации. То есть идет так ТабКонтроллер -> таб-> Навигейшн -> наш экран
 
 Студент.
 
 4. Добавте экран с курсами. На этом экране вы можете добавить, редактировать и удалить курс. Так же само как и в случае с юзерами у вас открывается контроллер редактирования. Также динамическая таблица
 
 5. Впервой секции идут поля "название курса", "предмет", "отрасль" и преподаватель (имя и фамилия).
 
 6. Во второй секции идет список юзеров, которые подписаны на курс. Можно юзера удалить, тогда он не удаляется из юзеров - он удаляется из курса. Также есть ячейка добавить студентов. (например первая ячейка в секции)
 
 7. если я нажимаю на ячейку студента, то перехожу к его профайлу.
 
 Мастер
 
 8. Если я нажимаю на ячейке добавить сдудентов, то мне выходит модальный контроллер либо поповер, содержащий список всех юзеров, причем юзеры которые выбрали этот курс имеют галочки. Тут я могу снимать студентов с курса либо добавлять на этот курс новых студентов.
 
 9. Так же и для преподавателя: если нажать на ячейку с преподавателем - переходишь к экрану юзеров, но тут можно выбрать только одного на этот раз.
 
 10. Если преподаватель выбран, то ячейка "преподаватель" на экране редактирования курса должна содержать его имя и фамилию, если нет - должен быть текст "выберите преподавателя"
 
 11. Тоже самое сделайте на экране юзеров, мы ведь там сделали динамическую таблицу также. Добавте секцию "курсы, которые ведет" и добавьте туда все его курсы. Также добавьте секцию "курсы, которые изучает". Если у студента нет курсов в какой-либо из этих секций - не показывайте секцию :)
 
 Супермен.
 
 12. Сделать все вышеперечисленное
 
 13. Сделайте третий экран - преподаватели. На этом экране будет выводиться список всех преподавателей сгрупированных по "предмету" (например программирование). У каждого преподавателя видно количество курсов (просто цифра) и если нажать на преподавателя, то переходишь в его профайл.

 */