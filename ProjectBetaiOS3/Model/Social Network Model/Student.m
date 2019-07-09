//
//  Student.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Student.h"
#import <RestKit/RestKit.h>
#import "OrganizationClass.h"
#import "TeacherClass.h"
#import "Resolution.h"
#import "RestKitDynamicMappings.h"
#import "Organization.h"

#define kIdStunderKey @"IdStudent"
#define kNameKey @"Name"
#define kGeneralKnowledgeKey @"GeneralKnowledge"
#define kPhotoKey @"Photo"
#define kResumeKey @"Resume"
#define kSexKey @"Sex"
#define kBirthdayKey @"Birthday"
#define kCountryKey @"Country"
#define kScholarityKey @"Scholarity"
#define kMyClassesKey @"MyClasses"
#define kMyResolutionsKey @"MyResolutions"
#define kStundentOrganizationKey @"StudentOrganization"

static RKObjectMapping* mapping;

@implementation Student

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idStudent = [coder decodeIntegerForKey:kIdStunderKey];
        self.name = [coder decodeObjectForKey:kNameKey];
        self.generalKnowledge = [coder decodeFloatForKey:kGeneralKnowledgeKey];
        self.photo = [coder decodeObjectForKey:kPhotoKey];
        self.resume = [coder decodeObjectForKey:kResumeKey];
        self.sex = [coder decodeObjectForKey:kSexKey];
        self.birthday = [coder decodeObjectForKey:kBirthdayKey];
        self.country = [coder decodeObjectForKey:kCountryKey];
        self.scholarity = [coder decodeObjectForKey:kScholarityKey];
        self.myClasses = [coder decodeObjectForKey:kMyClassesKey];
        self.myResolutions = [coder decodeObjectForKey:kMyResolutionsKey];
        self.studentOrganization = [coder decodeObjectForKey:kStundentOrganizationKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_idStudent forKey:kIdStunderKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeFloat:_generalKnowledge forKey:kGeneralKnowledgeKey];
    [coder encodeObject:_photo forKey:kPhotoKey];
    [coder encodeObject:_resume forKey:kResumeKey];
    [coder encodeObject:_sex forKey:kSexKey];
    [coder encodeObject:_birthday forKey:kBirthdayKey];
    [coder encodeObject:_country forKey:kCountryKey];
    [coder encodeObject:_scholarity forKey:kScholarityKey];
    [coder encodeObject:_myClasses forKey:kMyClassesKey];
    [coder encodeObject:_myResolutions forKey:kMyResolutionsKey];
    [coder encodeObject:_studentOrganization forKey:kStundentOrganizationKey];
}

+ (RKMapping *)studentMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[Student class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idStudent", @"name", @"generalKnowledge", @"photo", @"resume", @"sex", @"birthday", @"country", @"scholarity"]];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"myClasses" mapping:[RestKitDynamicMappings classDynamicMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"myResolutions" mapping:[Resolution resolutionMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"studentOrganization" mapping:[Organization organizationMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, general knowledge: %f, resume: %@, sex: %@, birthday: %@, country: %@, scholarity: %@, my classes: %@, my resolutions: %@, student organization: %@",
            (long)_idStudent, _name, _generalKnowledge, _resume, _sex, _birthday, _country, _scholarity, _myClasses, _myResolutions, _studentOrganization];
}

@end
