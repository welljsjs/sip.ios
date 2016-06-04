/*******************************************************************************
**NOTE** This code was generated by a tool and will occasionally be
overwritten. We welcome comments and issues regarding this code; they will be
addressed in the generation tool. If you wish to submit pull requests, please
do so for the templates in that tool.

This code was generated by Vipr (https://github.com/microsoft/vipr) using
the T4TemplateWriter (https://github.com/msopentech/vipr-t4templatewriter).

Copyright (c) Microsoft Open Technologies, Inc. All Rights Reserved.
Licensed under the Apache License 2.0; see LICENSE in the source repository
root for authoritative license information.﻿
******************************************************************************/
@class MSOneNoteNotebookFetcher;
@class MSOneNoteSectionGroupFetcher;
@class MSOneNoteSectionFetcher;
@class MSOneNoteSectionCollectionFetcher;
@class MSOneNoteSectionGroupCollectionFetcher;
@class MSOneNoteSectionGroupOperations;

#import <core/core.h>
#import "MSOneNoteModels.h"

/**
* The header for type MSOneNoteSectionGroupFetcher.
*/


@interface MSOneNoteSectionGroupFetcher : MSOrcEntityFetcher

@property (copy, nonatomic, readonly) MSOneNoteSectionGroupOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void) readWithCallback:(void (^)(MSOneNoteSectionGroup *sectionGroup, MSOrcError *error))callback;
- (void)update:(MSOneNoteSectionGroup *)sectionGroup callback:(void(^)(MSOneNoteSectionGroup *sectionGroup, MSOrcError *error))callback;
- (void)delete:(void(^)(int status, MSOrcError *error))callback;
- (MSOneNoteSectionGroupFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOneNoteSectionGroupFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSOneNoteSectionGroupFetcher *)select:(NSString *)params;
- (MSOneNoteSectionGroupFetcher *)expand:(NSString *)value;

@property (retain, nonatomic, readonly, getter=parentNotebook) MSOneNoteNotebookFetcher *parentNotebook;

@property (retain, nonatomic, readonly, getter=parentSectionGroup) MSOneNoteSectionGroupFetcher *parentSectionGroup;
@property (retain, nonatomic, readonly, getter=sections) MSOneNoteSectionCollectionFetcher *sections;

- (MSOneNoteSectionFetcher *)getSectionsById:(NSString*)id;

@property (retain, nonatomic, readonly, getter=sectionGroups) MSOneNoteSectionGroupCollectionFetcher *sectionGroups;

- (MSOneNoteSectionGroupFetcher *)getSectionGroupsById:(NSString*)id;


@end