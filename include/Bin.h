/*
 *
 * (C) 2020 - ntop.org
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */

#ifndef _BIN_H_
#define _BIN_H_

#include "ntop_includes.h"

/* #define BIN_DEBUG 1 */

/* ******************************* */

#define MAX_NUM_BINS      8
#define BIN_MASK          (MAX_NUM_BINS-1)

class Bin {
 private:
  u_int32_t bins[MAX_NUM_BINS];

protected:
  inline void incBin(u_int32_t value) {
    if(value <= 1)        bins[0]++;
    else if(value <= 3)   bins[1]++;
    else if(value <= 5)   bins[2]++;
    else if(value <= 10)  bins[3]++;
    else if(value <= 30)  bins[4]++;
    else if(value <= 60)  bins[5]++;
    else if(value <= 300) bins[6]++;
    else                  bins[7]++;
  }

public:
  Bin() { memset(bins, 0, sizeof(bins)); }
  void lua(lua_State* vm, const char *bin_label) const;
};

#endif /* _BIN_H_ */
