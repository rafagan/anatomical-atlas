//
//  Teacher.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Teacher.h"
#import <RestKit/RestKit.h>
#import "Organization.h"
#import "TeacherClass.h"
#import "QuizTest.h"
#import "RestKitDynamicMappings.h"

#import "TrueOrFalse.h"

#define kIdTeacherKey @"IdTeacher"
#define kNameKey @"Name"
#define kPhotoKey @"Photo"
#define kResumeKey @"Resume"
#define kSexKey @"Sex"
#define kBirthdayKey @"Bithday"
#define kCountryKey @"Country"
#define kScholarityKey @"Scholarity"
#define kWorkingOrgazinationsKey @"WorkingOrganizations"
#define kOwnerOfOrgazinationsKey @"OwnerOfOrganizations"
#define kOwnerOfClassesKey @"OwnderOfClasses"
#define kMonitoratedClassesKey @"MonitoratedClasses"
#define kMyQuizTestsKey @"MyQuizTests"
#define kMyQuestionskey @"MyQuestions"

static RKObjectMapping *mapping;

@implementation Teacher

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idTeacher = [coder decodeObjectForKey:kIdTeacherKey];
        self.photo = [coder decodeObjectForKey:kPhotoKey];
        self.resume = [coder decodeObjectForKey:kResumeKey];
        self.sex = [coder decodeObjectForKey:kSexKey];
        self.birthday = [coder decodeObjectForKey:kBirthdayKey];
        self.country = [coder decodeObjectForKey:kCountryKey];
        self.scholarity = [coder decodeObjectForKey:kScholarityKey];
        self.workingOrganizations = [coder decodeObjectForKey:kWorkingOrgazinationsKey];
        self.ownerOfOrganizations = [coder decodeObjectForKey:kOwnerOfOrgazinationsKey];
        self.ownerOfClasses = [coder decodeObjectForKey:kOwnerOfClassesKey];
        self.monitoratedClasses = [coder decodeObjectForKey:kMonitoratedClassesKey];
        self.myQuizTests = [coder decodeObjectForKey:kMyQuizTestsKey];
        self.myQuestions = [coder decodeObjectForKey:kMyQuestionskey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idTeacher forKey:kIdTeacherKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_photo forKey:kPhotoKey];
    [coder encodeObject:_resume forKey:kResumeKey];
    [coder encodeObject:_sex forKey:_sex];
    [coder encodeObject:_birthday forKey:kBirthdayKey];
    [coder encodeObject:_country forKey:kCountryKey];
    [coder encodeObject:_scholarity forKey:kScholarityKey];
    [coder encodeObject:_workingOrganizations forKey:kWorkingOrgazinationsKey];
    [coder encodeObject:_ownerOfOrganizations forKey:kOwnerOfOrgazinationsKey];
    [coder encodeObject:_ownerOfClasses forKey:kOwnerOfClassesKey];
    [coder encodeObject:_monitoratedClasses forKey:kMonitoratedClassesKey];
    [coder encodeObject:_myQuizTests forKey:kMyQuizTestsKey];
    [coder encodeObject:_myQuestions forKey:kMyQuestionskey];
}

+ (RKMapping *)teacherMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[Teacher class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idTeacher", @"name", @"photo", @"resume", @"sex", @"birthday", @"country", @"scholarity"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"workingOrganizations" mapping:[Organization organizationMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"ownerOfOrganizations" mapping:[Organization organizationMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"ownerOfClasses" mapping:[TeacherClass teacherClassMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"monitoratedClasses" mapping:[TeacherClass teacherClassMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"myQuizTests" mapping:[QuizTest quizTestMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"myQuestions" mapping:[TrueOrFalse trueOrFalseMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, resume: %@, sex: %@, birthday: %@, country: %@, scholarity: %@, working at: %@, organization owner of: %@, class owner of: %@, monitorated classes: %@, my quiz tests: %@, my questions: %@",
            (long)_idTeacher, _name, _resume, _sex, _birthday, _country, _scholarity, _workingOrganizations, _ownerOfOrganizations, _ownerOfClasses, _monitoratedClasses, _myQuizTests, _myQuestions];
}

@end
