//
//  RBTIssue.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTIssue.h"

@implementation RBTIssue

@synthesize crash;
@synthesize stackTrace;
@synthesize projectId;
@synthesize traker;
@synthesize status;
@synthesize subjectInfo;

- (void)sendIssue{
    
    [UIDevice currentDevice];
    
    //Formatting Json Error to Post ======
    NSMutableDictionary *customInfo = [NSMutableDictionary dictionaryWithObject:[[UIDevice currentDevice]systemVersion] forKey:@"SystemVersion"];
    [customInfo setObject:[[UIDevice currentDevice] description] forKey:@"Local"];

    NSLog(@"%@",customInfo);
    
    if (stackTrace)
        NSLog(@"%@",stackTrace);
        [customInfo setObject:stackTrace forKey:@"Stack Trace"];
    
    NSLog(@"%@",customInfo);
    
    NSArray *objInfos = [NSArray arrayWithObjects:projectId, subjectInfo, customInfo, traker, status, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"project_id", @"subject", @"description", @"traker", @"status", nil];
    
    NSDictionary *descDict = [NSDictionary dictionaryWithObjects:objInfos forKeys:keys];
    
    NSDictionary *issueDict = [NSDictionary dictionaryWithObject:descDict forKey:@"issue"];
    
    if ([NSJSONSerialization isValidJSONObject:issueDict]) {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:issueDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        jsonRequest = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", jsonRequest);
    }
    
    NSString *redmineProjectIdentifier = @"bugtrackertap4-ios";
    
    NSString *redmineURL = [NSString stringWithFormat:@"http://192.168.20.18:3000/projects/%@/issues.json",redmineProjectIdentifier];
    
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
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@", dic);
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
