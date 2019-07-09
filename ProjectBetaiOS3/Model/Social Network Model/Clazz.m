//
//  Clazz.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Clazz.h"

#define kIdClassKey @"IdClass"
#define kNameKey @"Name"
#define kClassSizeKey @"ClassSize"
#define kMonitorsKey @"Monitors"
#define kClassStudentsKey @"ClassStudents"

@implementation Clazz

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idClass = [coder decodeObjectForKey:kIdClassKey];
        self.name = [coder decodeObjectForKey:kNameKey];
        self.classSize = [coder decodeObjectForKey:kClassSizeKey];
        self.monitors = [coder decodeObjectForKey:kMonitorsKey];
        self.classStudents = [coder decodeObjectForKey:kClassStudentsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:_idClass forKey:kIdClassKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_classSize forKey:kClassSizeKey];
    [coder encodeObject:_monitors forKey:kMonitorsKey];
    [coder encodeObject:_classStudents forKey:kClassStudentsKey];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, class size: %ld, monitors: %@, class students: %@",
            (long)_idClass, _name, (long)_classSize, _monitors, _classStudents];
}

@end