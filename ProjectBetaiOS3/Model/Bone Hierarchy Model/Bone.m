//
//  Bone.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bone.h"
#import "BonePart.h"
#import "BoneSet.h"

//Keys para coding
#define kIdBoneKey @"IdBone"
#define kNameKey @"Name"
#define kDescriptKey @"Descript"
#define kSynonimousKey @"Synonimous"
#define kTotalBonesPartsKey @"TotaBonesParts"
#define kBonePartsKey @"BoneParts"
#define kNeighborsKey @"Neightbors"
#define kParentBoneSetKey @"ParentBoneSet"

static RKObjectMapping *mapping;

@implementation Bone

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idBone = [coder decodeIntegerForKey:kIdBoneKey];
        self.name = [coder decodeObjectForKey:kNameKey];
        self.descript = [coder decodeObjectForKey:kDescriptKey];
        self.synonimous = [coder decodeObjectForKey:kSynonimousKey];
        self.totalBoneParts = [coder decodeIntegerForKey:kTotalBonesPartsKey];
        self.boneParts = [coder decodeObjectForKey:kBonePartsKey];
        self.neighbors = [coder decodeObjectForKey:kNeighborsKey];
        self.parentBoneSet = [coder decodeObjectForKey:kParentBoneSetKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idBone forKey:kIdBoneKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_descript forKey:kDescriptKey];
    [coder encodeObject:_synonimous forKey:kSynonimousKey];
    [coder encodeInteger:_totalBoneParts forKey:kTotalBonesPartsKey];
    [coder encodeObject:_boneParts forKey:kBonePartsKey];
    [coder encodeObject:_neighbors forKey:kNeighborsKey];
    [coder encodeObject:_parentBoneSet forKey:kParentBoneSetKey];
}

+ (RKMapping *)boneMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[Bone class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idBone", @"name", @"synonimous", @"totalBoneParts"]];
    [mapping addAttributeMappingsFromDictionary:@{@"description": @"descript"}];
    [mapping addRelationshipMappingWithSourceKeyPath:@"boneParts" mapping:[BonePart bonePartMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"neighbors" mapping:mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"parentBoneSet" mapping:[BoneSet boneSetMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, description: %@, synonimous: %@, totalBoneParts: %ld, boneParts: %@, neighbors: %@, parent set: %@",
            (long)_idBone, _name, _descript, _synonimous, (long)_totalBoneParts, _boneParts, _neighbors, _parentBoneSet];
}

@end