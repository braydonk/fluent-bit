/*  Fluent Bit
 *  ==========
 *  Copyright (C) 2015-2023 The Fluent Bit Authors
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/**
 * This file provides windows wrappers for libc's setenv and unsetenv by using
 * the equivalent functions from winbase.h
 *
 * setenv man page: 
 * https://man7.org/linux/man-pages/man3/setenv.3.html
 * SetEnvironmentVariable docs: 
 * https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setenvironmentvariable
 * 
 * I am not sure why these aren't in Windows' libc.
 * - Braydon Kains, @braydonk
 */

#ifndef SET_ENV_H_
#define SET_ENV_H_

#include <stdlib.h>

/**
 * Just in case some silly goose includes it in a non-Windows build.
 */
#ifdef _WIN32

int setenv(char *name, char *value, int overwrite) 
{
    return _putenv_s(name, value);
}

int unsetenv(char *name)
{
    return _putenv_s(name, "");
}

#endif

#endif