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

@class MSGraphDirectoryObject;

#import <Foundation/Foundation.h>
#import "MSGraphDirectoryObject.h"

/**
* The header for type DirectoryRole.
*/

@interface MSGraphDirectoryRole : MSGraphDirectoryObject

@property (copy, nonatomic, readwrite, getter=description, setter=setDescription:) NSString *$$__$$description;
@property (copy, nonatomic, readwrite, getter=displayName, setter=setDisplayName:) NSString *displayName;
@property (nonatomic, getter=isSystem, setter=setIsSystem:) BOOL isSystem;
@property (nonatomic, getter=roleDisabled, setter=setRoleDisabled:) BOOL roleDisabled;
@property (copy, nonatomic, readwrite, getter=roleTemplateId, setter=setRoleTemplateId:) NSString *roleTemplateId;
@property (copy, nonatomic, readwrite, getter=members, setter=setMembers:) NSMutableArray *members;
@property (copy, nonatomic, readwrite, getter=memberOf, setter=setMemberOf:) NSMutableArray *memberOf;
@property (copy, nonatomic, readwrite, getter=owners, setter=setOwners:) NSMutableArray *owners;
@property (copy, nonatomic, readwrite, getter=ownedObjects, setter=setOwnedObjects:) NSMutableArray *ownedObjects;

@end