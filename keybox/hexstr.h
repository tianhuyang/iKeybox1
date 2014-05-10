//
//  hexstr.h
//  keybox
//
//  Created by Tianhu Yang on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef keybox_hexstr_h
#define keybox_hexstr_h
//Function to convert unsigned char to string of length 2
void Char2Hex(unsigned char ch, char* szHex);

//Function to convert string of length 2 to unsigned char;   

//Function to convert string of unsigned chars to string of chars
void CharStr2HexStr(unsigned char const* pucCharStr, char* pszHexStr, int iSize);

//Function to convert string of chars to string of unsigned chars
void HexStr2CharStr(char const* pszHexStr, unsigned char* pucCharStr, int iSize);

#endif
