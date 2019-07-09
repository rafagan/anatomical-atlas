//
//  Organization.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Organization.h"
#import "Student.h"
#import "RestKitDynamicMappings.h"
#import "Teacher.h"

#define kIdOrganizationKey @"IdOrganizationKey"
#define kNameKey @"Name"
#define kAcronymKey @"Acronym"
#define kCountryKey @"Country"
#define kTeachersKey @"Teachers"
#define kOwnerKey @"Owner"
#define kOwnerOfClassesKey @"OwnerOfClasses"
#define kStudentsKey @"Students"

static RKObjectMapping* mapping;

@implementation Organization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idOrganization = [coder decodeIntegerForKey:kIdOrganizationKey];
        self.name = [coder decodeObjectForKey:kNameKey];
        self.acronym = [coder decodeObjectForKey:kAcronymKey];
        self.country = [coder decodeObjectForKey:kCountryKey];
        self.teachers = [coder decodeObjectForKey:kTeachersKey];
        self.owner = [coder decodeObjectForKey:kCountryKey];
        self.ownerOfClasses = [coder decodeObjectForKey:kOwnerOfClassesKey];
        self.students = [coder decodeObjectForKey:kStudentsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idOrganization forKey:kIdOrganizationKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_acronym forKey:kAcronymKey];
    [coder encodeObject:_country forKey:kCountryKey];
    [coder encodeObject:_teachers forKey:kTeachersKey];
    [coder encodeObject:_owner forKey:kOwnerKey];
    [coder encodeObject:_ownerOfClasses forKey:kOwnerOfClassesKey];
    [coder encodeObject:_students forKey:kStudentsKey];
}

+ (RKMapping *)organizationMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[Organization class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idOrganization", @"name", @"acronym", @"country"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"teachers" mapping:[Teacher teacherMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"owner" mapping:[Teacher teacherMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"students" mapping:[Student studentMapping]];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"ownerOfClasses" mapping:[RestKitDynamicMappings classDynamicMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, acronym: %@, country: %@, teachers: %@, owner: %@, owning classes: %@, my students: %@",
            (long)_idOrganization, _name, _acronym, _country, _teachers, _owner, _ownerOfClasses, _students];
}

@end
