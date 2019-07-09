//
//  TeacherClass.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "TeacherClass.h"
#import "Student.h"
#import "Teacher.h"

#define kCreatorKey @"Creator"

static RKObjectMapping* mapping;

@implementation TeacherClass

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.creator = [coder decodeObjectForKey:kCreatorKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_creator forKey:kCreatorKey];
}

+(RKObjectMapping*)teacherClassMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[TeacherClass class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idClass", @"name", @"classSize"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"monitors" mapping:[Teacher teacherMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"classStudents" mapping:[Student studentMapping]];
    
//    [mapping addRelationshipMappingWithSourceKeyPath:@"creator" mapping:[Teacher teacherMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", [super description], [NSString stringWithFormat:@"creator: %@",_creator]];
}

@end
