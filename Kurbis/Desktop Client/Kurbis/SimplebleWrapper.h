//
//  SimplebleWrapper.hpp
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//


#import <Foundation/Foundation.h>

@interface SimplebleClassWrapper : NSObject
{
    NSString *lastValue; // Instance variable declaration
}

- (NSString *)getNewValue;

- (void)sendMessage:(NSString *)message;

- (bool)isConnected;

- (bool)tryToReconnect;

@end


