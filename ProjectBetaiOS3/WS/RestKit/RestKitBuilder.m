//
//  RestKitBuilder.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKitBuilder.h"

#import "Bone.h"
#import "BoneSet.h"
#import "QuizTest.h"
#import "QuizTestDTO.h"

//Tutorial importante: http://www.raywenderlich.com/58682/introduction-restkit-tutorial
//Outro exemplo: http://www.nsscreencast.com/episodes/51-intro-to-restkit-mapping?player=alternate&autoplay=true
//Documentação oficial: https://github.com/RestKit/RestKit/wiki/Object-Mapping
//RestKit - CoreData: http://www.nsscreencast.com/episodes/52-restkit-coredata

@interface RestKitBuilder ()
- (void)configureRestMappingResource:(NSString*)resource orKeyPath:keyPath withAttributes:(RKMapping*)mapping;
@end

@implementation RestKitBuilder : NSObject 

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Definição da URL onde serão feitas as requisições
        _baseURL = [NSURL URLWithString:@"http://rafagan.com.br"];
        _client = [[AFHTTPClient alloc] initWithBaseURL:_baseURL];
        
        // initialize RestKit
        objectManager = [[RKObjectManager alloc] initWithHTTPClient:_client];
        
        [self configureRestMappingResource:nil orKeyPath:@"bones" withAttributes:[Bone boneMapping]];
        [self configureRestMappingResource:nil orKeyPath:@"boneSets" withAttributes:[BoneSet boneSetMapping]];
        [self configureRestMappingResource:nil orKeyPath:@"quizTests" withAttributes:[QuizTest quizTestMapping]];
        [self configureRestMappingResource:nil orKeyPath:@"quizTestsDto" withAttributes:[QuizTestDTO quizTestMapping]];
    }
    return self;
}


- (void)configureRestMappingResource:(NSString*)resource orKeyPath:keyPath withAttributes:(RKMapping*)mapping
{
    // Mapeamento entre JSON e o Objeto
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping
                                                method:RKRequestMethodGET
                                                pathPattern:resource
                                                keyPath:keyPath
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

+ (void)sendRequestAtPath:(NSString*)path withQueryParameters:(NSDictionary*)params
        andCallForSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))successDelegate
            andForFailure:(void (^)(RKObjectRequestOperation *, NSError *))failDelegate
{
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:params
                                              success:successDelegate
                                              failure:failDelegate
     ];
}

@end