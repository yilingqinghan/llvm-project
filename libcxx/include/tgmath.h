// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP_TGMATH_H
#define _LIBCPP_TGMATH_H

/*
    tgmath.h synopsis

#include <ctgmath>

*/

#include <__configuration/language.h>

#if defined(_LIBCPP_CXX03_LANG) && !defined(_LIBCPP_USE_CXX03_HEADERS)
#  include <__cxx03/tgmath.h>
#else
#  if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#    pragma GCC system_header
#  endif

#  ifdef __cplusplus
#    include <cmath>
#    include <complex>
#  else
#    include <__config>

#    if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#      pragma GCC system_header
#    endif

#    ifdef __cplusplus
#      include <ctgmath>
#    else
#      if __has_include_next(<tgmath.h>)
#        include_next <tgmath.h>
#      endif
#    endif
#  endif
#endif // _LIBCPP_CXX03_LANG

#endif // _LIBCPP_TGMATH_H
