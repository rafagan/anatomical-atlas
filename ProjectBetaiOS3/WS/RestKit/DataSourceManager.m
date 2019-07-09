//
//  DataSourceManager.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 11/12/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "DataSourceManager.h"
#import "Bone.h"
#import "QuizTest.h"
#import "QuizTestDto.h"
#import "RestKitBuilder.h"

@interface DataSourceManager ()
-(void)downloadBones;
-(void)downloadBoneSets;
-(void)donwloadBoneSetHierarchical;
@end

@implementation DataSourceManager
{
    NSString* failureDownloadMessage;
}

static DataSourceManager* instance;
+ (DataSourceManager*) getInstance
{
    if(!instance) instance = [DataSourceManager new];
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        failureDownloadMessage = @"There's some problem to connect with web service, try again later': %@";
        [RestKitBuilder new];
    }
    return self;
}

- (NSArray*)getBones
{
    if (!_bones) [self downloadBones];
    return _bones;
}

- (NSArray *)getBoneSets
{
    if (!_boneSets) [self downloadBoneSets];
    return _boneSets;
}

- (BoneSet *)getBoneSetsHierarchical
{
    if (!_boneSetsHierarchical) [self downloadBoneSets];
    return _boneSetsHierarchical;
}

- (BoneSet *)getFullBoneLibrary
{
    return _fullBoneLibrary;
}

- (NSArray *)getPublicQuizLibrary
{
    if (!_publicQuizLibrary) [self downloadPublicQuizLibraryWithCallback:nil];
    return _publicQuizLibrary;
}

-(void)downloadBone:(long)boneId withCallback:(void (^)(Bone* b))success
{
    [RestKitBuilder sendRequestAtPath:[NSString stringWithFormat:@"api/v1/bones/%ld",boneId] withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        for (Bone* b in mappingResult.array[0]) {
                            NSLog(@"%@",b);
                        }
                        
                        success(mappingResult.array[0]);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

-(void)downloadBoneSet:(long)boneSetId withCallback:(void (^)(BoneSet* bs))success
{
    [RestKitBuilder sendRequestAtPath:[NSString stringWithFormat:@"api/v1/bonesets/%ld",boneSetId] withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        for (BoneSet* b in mappingResult.array) {
                            NSLog(@"%@",b);
                        }
                        
                        success(mappingResult.array[0]);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

-(void)downloadBones
{
    [RestKitBuilder sendRequestAtPath:@"api/v1/bones" withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        DATA_SRC.bones = mappingResult.array;
        
        for (Bone* b in DATA_SRC.bones) {
            NSLog(@"%@",b);
        }
    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(failureDownloadMessage, error);
    }];
}

- (void)downloadBoneSets
{
    [RestKitBuilder sendRequestAtPath:@"api/v1/bonesets" withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        DATA_SRC.boneSets = mappingResult.array;
                        
                        for (BoneSet* b in DATA_SRC.boneSets) {
                            NSLog(@"%@",b);
                        }
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

- (void)donwloadBoneSetHierarchical
{
    [RestKitBuilder sendRequestAtPath:@"api/v1/bonesets/hierarchical" withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        DATA_SRC.boneSetsHierarchical = mappingResult.array[0];
                        //NSLog(@"%@", DATA_SRC.boneSetsHierarchical);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

- (void)downloadFullBoneLibraryWithCallback:(void (^)(BoneSet* fullBoneLibrary))success
{
    [RestKitBuilder sendRequestAtPath:@"api/v1/bonesets/full" withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        DATA_SRC.fullBoneLibrary = mappingResult.array[0];
                        success(mappingResult.array[0]);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

-(void)downloadPublicQuizLibraryWithCallback:(void (^)(NSArray* publicQuizLibrary))success
{
    [RestKitBuilder sendRequestAtPath:@"api/v1/quiztests" withQueryParameters:nil
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        DATA_SRC.publicQuizLibrary = mappingResult.array;
                        success(mappingResult.array);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

- (void)downloadQuizTest:(long)quizTestId withCallback:(void (^)(QuizTest* qs))success
{
    [RestKitBuilder sendRequestAtPath:[NSString stringWithFormat:@"api/v1/quiztests/%ld", quizTestId] withQueryParameters:@{@"full" : @"true"}
                    andCallForSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        success(mappingResult.array[0]);
                    } andForFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSLog(failureDownloadMessage, error);
                    }];
}

@end
