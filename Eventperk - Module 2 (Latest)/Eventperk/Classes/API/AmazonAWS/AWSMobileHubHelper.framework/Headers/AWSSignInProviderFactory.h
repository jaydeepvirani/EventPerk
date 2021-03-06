//
//  AWSSignInProviderFactory.h
//  AWSMobileHubHelper
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//

#import <Foundation/Foundation.h>
#import "AWSSignInProvider.h"

NS_ASSUME_NONNULL_BEGIN

/*
 `AWSSignInProviderFactory` stores the instances of the sign in providers implemented using the protocol `AWSSignInProvider`. The instances registered with `AWSSignInProviderFactory` are fetched by `AWSIdentityManager` when `interceptApplication:didFinishLaunchingWithOptions` is called from `AWSMobileClient`.
 */
@interface AWSSignInProviderFactory : NSObject

// Fetches the shared instance of `AWSSignInProviderFactory`.
+(instancetype)sharedInstance;

/**
 Registers the shared instance of sign in provider implementing `AWSSignInProvider` with specified key.
 
 @param  signInProvider    The shared instance of sign in provider implementing `AWSSignInProvider` protocol.
 @param  key               A string to identify the signInProvider.
 **/
-(void)registerAWSSignInProvider:(id<AWSSignInProvider>)signInProvider
                          forKey:(NSString *)key NS_SWIFT_NAME(register(signInProvider:forKey:));

/**
 Fetches the shared instance of sign in provider implementing `AWSSignInProvider` with specified key.
 
 @param  key               A string to identify the signInProvider.
 
 @return The shared instance of sign in provider implementing `AWSSignInProvider` registered with specified key.
 **/
-(id<AWSSignInProvider>)signInProviderForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
