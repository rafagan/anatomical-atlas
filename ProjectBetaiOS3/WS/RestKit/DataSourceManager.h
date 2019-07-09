//
//  DataSourceManager.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 11/12/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATA_SRC [DataSourceManager getInstance]

@class Bone;
@class BoneSet;
@class QuizTest;

@interface DataSourceManager : NSObject

+(DataSourceManager*)getInstance;

//Pega todos os ossos do banco de dados (utilize para testes, pois é relativamente rápido)
@property (nonatomic, strong, getter=getBones) NSArray *bones;

//Pega todos os conjuntos de ossos do banco de dados
@property (nonatomic, strong, getter=getBoneSets) NSArray *boneSets;

//Utilize para a árvore do Quiz Library
@property (nonatomic, strong, getter=getBoneSetsHierarchical) BoneSet *boneSetsHierarchical;

//Utilize para a árvore do Atlas
@property (nonatomic, strong, getter=getFullBoneLibrary) BoneSet *fullBoneLibrary;

//Utilize para os quizzes públicos
@property (nonatomic, strong, getter=getPublicQuizLibrary) NSArray *publicQuizLibrary;

//Baixa um osso em específico
-(void)downloadBone:(long)boneId withCallback:(void (^)(Bone* b))success;

//Baixa um conjunto de osso em específico
-(void)downloadBoneSet:(long)boneSetId withCallback:(void (^)(BoneSet* bs))success;

//Baixa um quiz test com todas as questões
-(void)downloadQuizTest:(long)quizTestId withCallback:(void (^)(QuizTest* qs))success;

//Baixa toda a hierarquia de ossos
-(void)downloadFullBoneLibraryWithCallback:(void (^)(BoneSet* fullBoneLibrary))success;

//Baixa todos os quiz publicos
-(void)downloadPublicQuizLibraryWithCallback:(void (^)(NSArray* publicQuizLibrary))success;

@end
