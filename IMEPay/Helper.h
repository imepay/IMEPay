//
//  Helper.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#import "Config.h"

#ifndef Helper_h
#define Helper_h

static inline  NSString* url(NSString *endpoint) {
  return [NSString stringWithFormat:@"%@%@",URL_BASE,endpoint];
}

#endif /* Helper_h */
