//
//  TKMacro.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

// compare
#define TK_NOT_NIL_AND_EQUAL(_a_,_b_)  ((_a_)&&([_a_ isEqual:_b_]))
#define TK_BOTH_NIL_OR_EQUAL(_a_,_b_)  (((!(_a_))&&(!(_b_)))||([_a_ isEqual:_b_]))
#define TK_EQUAL(_a_,_b_)              ([_a_ isEqual:_b_])

#define TK_FLT_EQUAL(_a_,_b_) (fabsf(_a_-_b_)<FLT_EPSILON)
#define TK_DBL_EQUAL(_a_,_b_) (fabs(_a_-_b_)<DBL_EPSILON)
