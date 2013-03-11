//
//  KPIOSInformation.h
//  Kuiper-iOS
//
//  Created by demetrius albuquerque on 06/03/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>


@interface DAIOSInformation : NSObject

+ (NSString *)deviceType;
+ (NSString *)appVersion;
+ (NSString *)appName;
+ (NSString *)soVersion;
+ (NSDictionary *)paramPost;

@end
