//
//  RBTIssue.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTIssue.h"
#import "DAIOSInformation.h"
#import <sys/utsname.h>

NSString *const RBTCrashSystem = @"Crash";

NSString *const RMProjectId = @"project_id";
NSString *const RMSubject = @"subject";
NSString *const RMDescription = @"description";
NSString *const RMTraker = @"traker";
NSString *const RMStatus = @"status";

NSString *const IssueJSON = @"issue";

@implementation RBTIssue

@synthesize crash;
@synthesize projectId;
@synthesize priority;
@synthesize status;
@synthesize subjectInfo;
@synthesize server;
@synthesize userName;
@synthesize passwd;
@synthesize timeout;

/**
 Format device iformation
 @return NSDictionary
 */
- (NSDictionary *)formatDeviceInformations{
    
    NSMutableDictionary *customInfo = [[NSMutableDictionary alloc]init];

    [customInfo setObject:[DAIOSInformation paramPost] forKey:@"Device Information"];
    
    if (crash)
        [customInfo setObject:crash forKey:RBTCrashSystem];

    return customInfo;
}

/** Format issue information to format the JSON
 @return NSDictionary
 */
- (NSDictionary *)formatIssueJsonInformations{
    
    NSDictionary *description = [self formatDeviceInformations];
    
    NSArray *objInfos = [NSArray arrayWithObjects:projectId, subjectInfo, description, priority, status, nil];
    NSArray *keys = [NSArray arrayWithObjects:RMProjectId, RMSubject, RMDescription, RMTraker, RMStatus, nil];
    
    NSDictionary *descDict = [NSDictionary dictionaryWithObjects:objInfos forKeys:keys];
    
    NSDictionary *issueDict = [NSDictionary dictionaryWithObject:descDict forKey:IssueJSON];
    
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
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    
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
        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:userName password:passwd
                                                           persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

@end
