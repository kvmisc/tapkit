//
//  TKMacro.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//


// xx nonempty
#define TK_S_NONEMPTY(_a_)  ([_a_ length]>0)
#define TK_D_NONEMPTY(_a_)  ([_a_ length]>0)
#define TK_A_NONEMPTY(_a_)  ([_a_ count]>0)
#define TK_M_NONEMPTY(_a_)  ([_a_ count]>0)

// xx empty
#define TK_S_EMPTY(_a_)  ([_a_ length]<=0)
#define TK_D_EMPTY(_a_)  ([_a_ length]<=0)
#define TK_A_EMPTY(_a_)  ([_a_ count]<=0)
#define TK_M_EMPTY(_a_)  ([_a_ count]<=0)


// xx or later
#define TK_S_OR_LATER(_a_,_b_)  (([_a_ length]>0)?(_a_):(_b_))
#define TK_D_OR_LATER(_a_,_b_)  (([_a_ length]>0)?(_a_):(_b_))
#define TK_A_OR_LATER(_a_,_b_)  (([_a_ count]>0)?(_a_):(_b_))
#define TK_M_OR_LATER(_a_,_b_)  (([_a_ count]>0)?(_a_):(_b_))


// compare
#define TK_NOT_NIL_AND_EQUAL(_a_,_b_)  ((_a_)&&([_a_ isEqual:_b_]))
#define TK_BOTH_NIL_OR_EQUAL(_a_,_b_)  (((!(_a_))&&(!(_b_)))||([_a_ isEqual:_b_]))
#define TK_EQUAL(_a_,_b_)              ([_a_ isEqual:_b_])

#define TK_FLT_EQUAL(_a_,_b_) (fabsf(_a_-_b_)<FLT_EPSILON)
#define TK_DBL_EQUAL(_a_,_b_) (fabs(_a_-_b_)<DBL_EPSILON)
