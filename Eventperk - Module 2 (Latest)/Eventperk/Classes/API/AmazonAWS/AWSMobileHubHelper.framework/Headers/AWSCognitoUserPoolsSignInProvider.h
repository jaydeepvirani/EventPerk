//
//  AWSCognitoUserPoolsSignInProvider.h
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
#import <Foundation/Foundation.h>
#import "AWSSignInProvider.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const AWSCognitoUserPoolsSignInProviderKey;

@protocol AWSCognitoUserPoolsSignInHandler

/**
 *  This method is called when `loginWithSignInProvider` is called by `AWSIdentityManager`.
 *  This method should handle the input from the user and set the `taskCompletionSournce` result required by Cognito Idp SDK.
 */
- (void)handleUserPoolSignInFlowStart;

@end

/**
 * `AWSCognitoUserPoolsSignInProvider` adopts the `AWSSignInProvider` protocol.
 *
 * It works with the AWS Cognito User Pools SDK internally.
 */
@interface AWSCognitoUserPoolsSignInProvider : NSObject <AWSSignInProvider>

/**
 *  Registers the cognito pool with specified configuration. The pool object can be accessed by using the `CognitoIdentityUserPoolForKey:` method using `AWSCognitoUserPoolsSignInProviderKey` as the identifier key.
 *
 *  @param cognitoIdentityUserPoolId              The Cognito Identity User Pool Id
 *  @param cognitoIdentityUserPoolAppClientId     The Cognito Identity User Pool Client Id
 *  @param cognitoIdentityUserPoolAppClientSecret The Cognito Identity User Pool Client Secret
 *  @param region                                 The Cognito Identity User Pool Service Region
 */
+ (void)setupUserPoolWithId:(NSString *)cognitoIdentityUserPoolId
cognitoIdentityUserPoolAppClientId:(NSString *)cognitoIdentityUserPoolAppClientId
cognitoIdentityUserPoolAppClientSecret:(NSString *)cognitoIdentityUserPoolAppClientSecret
                        region:(AWSRegionType)region;

/**
 Fetches the shared instance for AWSCognitoUserPoolsSignInProvider. The method `setupUserPoolWithId:cognitoIdentityUserPoolAppClientId:cognitoIdentityUserPoolAppClientSecret:region` has to be called once before accessing the shared instance.
 
 @return the single instance of AWSCognitoUserPoolsSignInProvider
 */
+ (instancetype)sharedInstance;

/**
 *  Set the instance of the class adopting the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol of Cognito Idp SDK.
 *
 *  @param interactiveAuthDelegate A class adopting the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol
 */
- (void)setInteractiveAuthDelegate:(id)interactiveAuthDelegate;

/**
 *  Returns the status of the current user pool user.
 *
 *  @return `YES` if the user is signed in.
 */
- (BOOL)isLoggedIn;

/**
 *  Sets the userName value of the signed-in user into a persistent store.
 *  Should be called on a successful login to set the user name which is used by `AWSIdentityManager`.
 *
 *  @param userName the user name of the signed-in user
 */
- (void)setUserName:(NSString *)userName;

/**
 *  Sets the imageURL value of the signed-in user into a persistent store.
 *  Should be called on a successful login to set the user name which is used by `AWSIdentityManager`.
 *
 *  @param imageURL the image URL for a picture of the signed-in user
 */
- (void)setImageURL:(NSURL *)imageURL;


@end

NS_ASSUME_NONNULL_END
