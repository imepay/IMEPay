//
//  Config.h
//  IMEPay
//
//  Created by Manoj Karki on 7/12/17.
//  Copyright © 2017 Manoj Karki. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define URL_BASE_TEST @"http://202.166.194.123:7979/api/Web" // Staging
#define URL_BASE_LIVE @"https://payment.imepay.com.np:7979/api/Web" // Live

#define EP_GET_TOKEN @"/GetToken"
#define EP_POST_TO_MERCHANT @"http://202.166.194.126:6060/api/special/startinitialpayment"
#define EP_PAYMENT @"/Payment"
#define EP_CONFIRM @"/Confirm"
#define EP_VALIDATE_USER @"/ValidateUser"

#define NOTIF_SHOULD_QUIT @"NOTIF_SHOULD_QUIT"

#endif /* Config_h */
