//
//  Bone.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#ifndef ProjectModel_Bone_h
#define ProjectModel_Bone_h

#import <RestKit/RestKit.h>

@class BoneSet;

@interface Bone : NSObject <NSCoding>

@property (nonatomic) NSInteger idBone;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *synonimous;
@property (nonatomic) NSInteger totalBoneParts;

@property (nonatomic, strong) NSArray *boneParts;
@property (nonatomic, strong) NSArray *neighbors;
@property (nonatomic, strong) BoneSet *parentBoneSet;

+ (RKMapping*)boneMapping;

@end

#endif
