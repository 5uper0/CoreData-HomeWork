# CoreData-Test
 ![Alt Text](https://github.com/5uper0/CoreData-Test/blob/master/Screenshots/CoreData-Test.gif)


// Annotation

The app is done as iOS Beginner Course CoreData homework with 4 level of difficulty. So I made all the tasks programmatically and will introduce You what I have done overall:

1. Created screen with students. By tapping plus button You create new student. With adding or editing student You goes to the screen where You can edit fields with name, lastname and email in dynamic table.

2. You can add, remove or edit students.

3. Added UITabBarController to the project. App starts from it and the screen with students is first tab. Had done this with Storyboard. For each controller in tab exists navigation bar (TabController -> Tab -> Navigation -> Screen).

4. Added screen with courses. With that screen You can add, edit or delete courses. The editing controller will help You, just tap in the course.  It is also dynamic table.

5. First section has fields with course name, subject, branch and teacher (name and lastname).

6. Second section has list of students, who are signed for this course. You can remove student, though he is not deleted at all, but just from the course.

7. If You tap students cell, You will come to his profile page.

8. If You tap add students button, You will get to all students list where students who are signed for course are shown with marks. So You can choose who 9. You want to be with that course.

10. So is with teacher cell too. If You tap on it, You will see the teacher list, but You will able to choose only one person for this case.

11. If teacher for this course is chosen, You will see his name and lastname. If not, You will see “Choose teacher” title.

12. The same is done on students page. You will see section with courses students teaches and section with courses he learns. If sections are empty, they will not appear.

13. Added third tab with teachers, detail label contains number of courses each of them teaches. If You tap on teachers cell, You will get to his profile.


// Аннотация 

Приложение создавалось как домашнее задание к уроку по CoreData из iOS Beginner Course и имело 4 уровня сложности. Я справился со всем с помощью кода и опишу, что получилось по итогу:

1. Создал экран со списком студентов. На пенели навигации есть кнопка плюс, которая добавляет нового юзера. При добавлении либо редактировании юзера мы переходим на экран, где можем вводить его данные в динамической таблице: имя, фамилия, почтовый ящик.

2. Юзеров можно добавлять, удалять и редактировать.

3. Добавил UITabBarController к проекту. Приложение стартует с него и экран со студентами это всего лишь один из табов. Реализовано в Storyboard. Для каждого контроллера в табах сделан Navigation Bar (TabController -> Tab -> Navigation -> Screen).
4. Добаллен экран с курсами. На этом экране вы можете добавить, редактировать и удалить курс. Так же, как и в случае со студентами у вас открывается контроллер редактирования. Также динамическая таблица.

5. В первой секции идут поля "название курса", "предмет", "отрасль" и преподаватель (имя и фамилия). 

6. Во второй секции идет список юзеров, которые подписаны на курс. Студента можно удалить, тогда он удаляется из общего списка - он удаляется из курса. Также есть ячейка доваления новых студентов.

7. По нажатии на ячейке студента, происходит переход к его профайлу.

8. Если нажать на ячейке добавления студентов, появляется список всех юзеров, причем юзеры которые выбрали этот курс имеют галочки. Тут возможно убирать студентов с курса либо добавлять на этот курс новых.

9. Так же и для преподавателя: если нажать на ячейку с преподавателем - происходит переход к экрану юзеров, но тут можно выбрать только одного. 

10. Если преподаватель выбран, то ячейка "преподаватель" на экране редактирования курса содержит его имя и фамилию, если нет - появляется текст "выберите преподавателя".

11. Тоже самое реализовано и на экране юзеров. Добавлена секция "курсы, которые ведет" со списком соответствующих курсов. А также секция "курсы, которые изучает". Если у студента нет курсов в какой-либо из этих секций - секция не будет показана.

13. Добавлен третий экран - преподаватели. На этом экране выводится список всех преподавателей. У каждого преподавателя видно количество курсов (просто цифра) и если нажать на преподавателя, происходит переход к его профайлу.
