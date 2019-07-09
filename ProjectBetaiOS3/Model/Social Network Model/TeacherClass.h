//
//  TeacherClass.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Clazz.h"

@class Teacher;

@interface TeacherClass : Clazz <NSCoding>

+(RKObjectMapping*)teacherClassMapping;

@property (nonatomic, strong) Teacher* creator;

@end
