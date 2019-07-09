//
//  RestKitDynamicMappings.m
//  Unity-iPhone
//
//  Created by Rafagan Abreu on 19/02/15.
//
//

#import "RestKitDynamicMappings.h"
#import "OrganizationClass.h"
#import "TeacherClass.h"
#import "TrueOrFalse.h"
#import "MultipleChoice.h"
#import "Organization.h"
#import "Teacher.h"

static RKDynamicMapping* classMapping, *questionMapping;

@interface RestKitDynamicMappings ()

@end

@implementation RestKitDynamicMappings

+ (RKDynamicMapping *)classDynamicMapping
{
    //TODO: corrigir isto para ficar compatível com o questionDynamicMapping
    
    if(classMapping) return classMapping;
    
    classMapping = [RKDynamicMapping new];
    [[OrganizationClass organizationClassMapping] addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:classMapping]];
    [[TeacherClass teacherClassMapping] addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:classMapping]];
    
    [classMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        if ([[representation valueForKey:@"creator"] isKindOfClass:[Organization class]]) {
            return [OrganizationClass organizationClassMapping];
        } else if ([[representation valueForKey:@"creator"] isKindOfClass:[Teacher class]]) {
            return [TeacherClass teacherClassMapping];
        }
        
        return nil;
    }];
    
    return classMapping;
}

+ (RKDynamicMapping *)questionDynamicMapping
{
    if(questionMapping) return questionMapping;

    questionMapping = [RKDynamicMapping new];
    
    RKObjectMapping* t1 = [RKObjectMapping mappingForClass:[TrueOrFalse class] ];
    RKObjectMapping* t2 = [RKObjectMapping mappingForClass:[MultipleChoice class] ];
    
    [t1 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"correctAnswer" toKeyPath:@"correctAnswer" withMapping:questionMapping]];
    [t2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"correctAnswer" toKeyPath:@"correctAnswer" withMapping:questionMapping]];
    
    [questionMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        NSString* str = [NSString stringWithFormat:@"%@",[representation valueForKey:@"correctAnswer"]];
        
        if ([str isEqualToString:@"0"] || [str isEqualToString:@"1"]) {
            return [TrueOrFalse trueOrFalseMapping];
        } else if ([str isEqualToString:@"A"] || [str isEqualToString:@"B"] || [str isEqualToString:@"C"] || [str isEqualToString:@"D"] || [str isEqualToString:@"E"]) {
            return [MultipleChoice multipleChoiceMapping];
        }
        
        return nil;
    }];
    
    return questionMapping;
}

@end
