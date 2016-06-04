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
@class MSGraphMessageFetcher;
@class MSGraphEventFetcher;
@class MSGraphOutlookItemOperations;

#import <core/core.h>
#import "MSGraphModels.h"

/**
* The header for type MSGraphOutlookItemFetcher.
*/


@interface MSGraphOutlookItemFetcher : MSOrcEntityFetcher

@property (copy, nonatomic, readonly) MSGraphOutlookItemOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void) readWithCallback:(void (^)(MSGraphOutlookItem *outlookItem, MSOrcError *error))callback;
- (void)update:(MSGraphOutlookItem *)outlookItem callback:(void(^)(MSGraphOutlookItem *outlookItem, MSOrcError *error))callback;
- (void)delete:(void(^)(int status, MSOrcError *error))callback;
- (MSGraphOutlookItemFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSGraphOutlookItemFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSGraphOutlookItemFetcher *)select:(NSString *)params;
- (MSGraphOutlookItemFetcher *)expand:(NSString *)value;
- (MSGraphMessageFetcher *)asMessage;	
- (MSGraphEventFetcher *)asEvent;	

@end