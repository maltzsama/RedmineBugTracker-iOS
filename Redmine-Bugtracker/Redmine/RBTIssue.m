//
//  RBTIssue.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTIssue.h"
#import <sys/utsname.h>

@implementation RBTIssue

@synthesize crash;
@synthesize stackTrace;
@synthesize projectId;
@synthesize traker;
@synthesize status;
@synthesize subjectInfo;
@synthesize server;

/**
 Return the OS kind;
 */
NSString* machineName()
{
    /*
     @"i386"      on the simulator
     @"iPod1,1"   on iPod Touch
     @"iPod2,1"   on iPod Touch Second Generation
     @"iPod3,1"   on iPod Touch Third Generation
     @"iPod4,1"   on iPod Touch Fourth Generation
     @"iPhone1,1" on iPhone
     @"iPhone1,2" on iPhone 3G
     @"iPhone2,1" on iPhone 3GS
     @"iPad1,1"   on iPad
     @"iPad2,1"   on iPad 2
     @"iPad3,1"   on iPad 3 (aka new iPad)
     @"iPhone3,1" on iPhone 4
     @"iPhone4,1" on iPhone 4S
     @"iPhone5,1" on iPhone 5
     @"iPhone5,2" on iPhone 5
     */
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
- (NSDictionary *)formatDeviceInformations{
    
    NSArray *languageArray = [NSLocale preferredLanguages];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];

    NSString *appVersion = [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];

    
    NSMutableDictionary *customInfo = [[NSMutableDictionary alloc]init];

    [customInfo setObject:[[UIDevice currentDevice]systemVersion] forKey:@"System Version"];
    [customInfo setObject:machineName() forKey:@"Operation System"];
    //[customInfo setObject:[[UIDevice currentDevice] description] forKey:@"Local"];
    [customInfo setObject:[languageArray objectAtIndex:0] forKey:@"Language"];
    [customInfo setObject:country forKey:@"Country"];
    [customInfo setObject:appVersion forKey:@"App Version"];
    
    if (stackTrace)
        [customInfo setObject:stackTrace forKey:@"Stack Trace"];

    return customInfo;
}

- (NSDictionary *)formatIssueJsonInformations{
    
    NSDictionary *description = [self formatDeviceInformations];
    
    NSArray *objInfos = [NSArray arrayWithObjects:projectId, subjectInfo, description, traker, status, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"project_id", @"subject", @"description", @"traker", @"status", nil];
    
    NSDictionary *descDict = [NSDictionary dictionaryWithObjects:objInfos forKeys:keys];
    
    NSDictionary *issueDict = [NSDictionary dictionaryWithObject:descDict forKey:@"issue"];
    
    return issueDict;
}

- (void)sendIssuetoRedmine{
    
    NSDictionary *issueDict = [self formatIssueJsonInformations];
    
    if ([NSJSONSerialization isValidJSONObject:issueDict]) {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:issueDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        jsonRequest = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *redmineURL = [NSString stringWithFormat:@"%@/projects/%@/issues.json",server,projectId];
    
    NSURL *url = [NSURL URLWithString:redmineURL];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];

	[request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    
    if (connection) {
        receivedData = [NSMutableData data];
    }
}

/**
 Connection Delegate functions.
*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    return;
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount] > 1)
    {
        //[urlConnection release];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                        message:@"Too many unsuccessul login attempts."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        // Answer the challenge
        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:@"testuser" password:@"testuser"
                                                           persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

@end
