//
//  KPIOSInformation.m
//  Kuiper-iOS
//
//  Created by demetrius albuquerque on 06/03/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "KPIOSInformation.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation KPIOSInformation
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

    NSArray *modelTypeArray = [[NSArray alloc] initWithObjects: @"i386",@"iPod1,1", @"iPod2,1", @"iPod3,1", @"iPod4,1", @"iPhone1,1", @"iPhone1,2", @"iPhone2,1", @"iPad1,1", @"iPad2,1", @"iPad3,1", @"iPhone3,1", @"iPhone4,1", @"iPhone5,1", @"iPhone5,2", nil];
    NSArray *modelNameArray = [[NSArray alloc] initWithObjects: @"simulator", @"iPod Touch", @"iPod Touch Second Generation", @"iPod Touch Third Generation", @"iPod Touch Fourth Generation", @"iPhone", @"iPhone 3G", @"iPhone 3GS", @"iPad", @"iPad 2", @"iPad 3", @"iPhone 4", @"iPhone 4S", @"iPhone 5", @"iPhone 5", nil];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *model = [NSString stringWithCString:systemInfo.machine
                                         encoding:NSUTF8StringEncoding];
    NSString *name = nil;
    if ([modelTypeArray containsObject:model]){
        name = [modelNameArray objectAtIndex:[modelTypeArray indexOfObject:model]];
        
    } else{
        name = model;
    }
    
    return name;
}

+ (NSString *)deviceType{
    
    return machineName();
}

+ (NSString *)appVersion{
    return [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleName"];
}

+ (NSString *)soVersion{
    return [[UIDevice currentDevice]systemVersion];
}

+ (NSString *)imei{
    NSString *udid;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    else
        udid = [UIDevice currentDevice].uniqueIdentifier;
    
    NSLog(@"%@", udid);

    return udid;
}

+ (NSDictionary *)paramPost{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[self imei] forKey:@"imei"];
    [dic setObject:[self appName] forKey:@"appName"];
    [dic setObject:[self appVersion] forKey:@"appVersion"];
    [dic setObject:[self deviceType] forKey:@"deviceName"];
    [dic setObject:[self soVersion] forKey:@"soVersion"];
    return dic;
}

@end
