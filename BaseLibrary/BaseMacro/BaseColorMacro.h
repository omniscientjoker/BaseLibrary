//
//  BaseColorMacro.h
//  BaseLibrary
//
//  Created by joker on 2018/11/26.
//  Copyright © 2018 joker. All rights reserved.
//

#ifndef BaseColorMacro_h
#define BaseColorMacro_h
//color macro
#define HeadTitleFont    [UIFont fontWithName:@"Helvetica-Bold" size:17.0]
#define PickListFont     [UIFont fontWithName:@"Helvetica-Bold" size:13.0]
//计算颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 calpha:alphaValue]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//默认颜色
#define COMMON_COLOR       RGBA(12, 212, 152, 1)
#define COMMON_GREEN       RGB(43, 188, 157)
#define COMMON_NAV_COLOR   RGB(37, 193, 206)
#define COMMON_DEFULT_BACK RGB(244, 244, 244)
#define PNTitleColor       RGB(0, 189, 133)
#define PNButtonGrey       RGB(141, 141, 141)

#define COMMON_TOP_COLOR   RGBA(18, 215, 138, 1)
#define COMMON_BOTTOM_COLOR  RGBA(2, 207, 173, 1)

//自定义颜色
#define PNGrey         RGBA(246, 246, 246, 1)
#define PNSilver       RGBA(192, 192, 192, 1)
#define PNDimGray      RGBA(102, 102, 102, 1)
#define PNDeepGrey     RGBA(162, 162, 162, 1)
#define PNLightGrey    RGBA(201, 201, 201, 1)
#define PNPinkGrey     RGBA(200, 193, 193, 1)
#define PNCleanGrey    RGBA(251, 251, 251, 1)

#define PNOrange       RGBA(243, 152, 0, 1)
#define PNDeepOrange   RGBA(247, 133, 51, 1)

#define PNYellow       RGBA(242, 197, 117, 1)
#define PNHealYellow   RGBA(245, 242, 238, 1)
#define PNLightYellow  RGBA(241, 240, 240, 1)
#define PNDarkYellow   RGBA(152, 150, 159, 1)
#define PNStarYellow   RGBA(252, 223, 101, 1)

#define PNBlue         RGBA(82, 116, 188, 1)
#define PNSkyBlue      RGBA(0, 191, 255, 1)
#define PNDarkBlue     RGBA(121, 134, 142, 1)
#define PNLightBlue    RGBA(94, 147, 296, 1)
#define PNSlateBlue    RGBA(106, 90, 205, 1)

#define PNGreen        RGBA(77, 186, 122, 1)
#define PNLeafGreen    RGBA(64, 207, 148, 1)
#define PNFreshGreen   RGBA(77, 196, 122, 1)
#define PNiOSGreen     RGBA(98, 247, 77, 1)
#define PNDeepGreen    RGBA(77, 176, 122, 1)
#define PNDarkGreen    RGBA(43, 188, 157, 1)

#define PNDarkCyan     RGBA(0,139,139,1)

#define PNRed          RGBA(245, 94, 78, 1)
#define PNDeepRed      RGBA(199, 13, 23, 1)

#define PNBlack        RGBA(45, 45, 45, 1)

#define PNPureClear    RGBA(0, 0, 0, 0)

#define PNWhite        RGBA(255,255,255,1.0)

#define PNMauve        RGBA(88,75,103,1.0)
#define PNBrown        RGBA(119,107,95,1.0)

#define PNPinkDark     RGBA(170,165,165,1.0)
#define PNCloudWhite   RGBA(244,355,344,1.0)

#define PNTwitterColor RGBA(0,171,243,1.0)
#define PNWeiboColor   RGBA(250,0,33,1)

#endif /* BaseColorMacro_h */
