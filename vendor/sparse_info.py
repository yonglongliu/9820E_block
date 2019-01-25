#!/usr/bin/env python

# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.kaiostech.com/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Parse a sparse image, get its info.

Usage:  sparse_info.py <input, sparse image> <output, info file>

"""

import os
import sys
import struct

def main(argv):
 
  if len(argv) != 2:
    print __doc__
    sys.exit(1)

  simg = argv[0]
  info = argv[1]

  f = open(simg, "rb")

  header_bin = f.read(28)
  header = struct.unpack("<I4H4I", header_bin)

  magic = header[0]
  major_version = header[1]
  minor_version = header[2]
  file_hdr_sz = header[3]
  chunk_hdr_sz = header[4]
  blk_sz = header[5]
  total_blks = header[6]
  total_chunks = header[7]

  if magic != 0xED26FF3A:
    raise ValueError("Magic should be 0xED26FF3A but is 0x%08X" % (magic,))
  if major_version != 1 or minor_version != 0:
    raise ValueError("I know about version 1.0, but this is version %u.%u" %
                     (major_version, minor_version))
  if file_hdr_sz != 28:
    raise ValueError("File header size was expected to be 28, but is %u." %
                     (file_hdr_sz,))
  if chunk_hdr_sz != 12:
    raise ValueError("Chunk header size was expected to be 12, but is %u." %
                     (chunk_hdr_sz,))

  pos = 0   # in blocks
  ext4_pos = 0   # in blocks
  care_data = []
  offset_map = []

  for i in range(total_chunks):
    header_bin = f.read(12)
    header = struct.unpack("<2H2I", header_bin)
    chunk_type = header[0]
    chunk_sz = header[2]
    total_sz = header[3]
    data_sz = total_sz - 12

    if chunk_type == 0xCAC1:
      if data_sz != (chunk_sz * blk_sz):
        raise ValueError(
            "Raw chunk input size (%u) does not match output size (%u)" %
            (data_sz, chunk_sz * blk_sz))
      else:
        care_data.append(pos)
        care_data.append(pos + chunk_sz)
        offset_map.append((pos, chunk_sz, ext4_pos, None))
        pos += chunk_sz
        f.seek(data_sz, os.SEEK_CUR)
        ext4_pos += data_sz

    elif chunk_type == 0xCAC2:
      fill_data = f.read(4)
      care_data.append(pos)
      care_data.append(pos + chunk_sz)
      offset_map.append((pos, chunk_sz, None, fill_data))
      pos += chunk_sz
      ext4_pos += (chunk_sz * blk_sz)

    elif chunk_type == 0xCAC3:
      if data_sz != 0:
        raise ValueError("Don't care chunk input size is non-zero (%u)" %
                         (data_sz))
      else:
        pos += chunk_sz
        ext4_pos += (chunk_sz * blk_sz)

    elif chunk_type == 0xCAC4:
      raise ValueError("CRC32 chunks are not supported")

    else:
      raise ValueError("Unknown chunk type 0x%04X not supported" %
                       (chunk_type,))
  f.close()

  ## output info
  fo = open(info, "w")
  fo.write("Sparse_Header\n")
  fo.write("0x%x, %d, %d, %d, %d, %d, %d, %d\n" % 
           (magic, major_version, minor_version, 
           file_hdr_sz, chunk_hdr_sz, 
           blk_sz, total_blks, total_chunks))

  fo.write("Care_Data\n")
  for i in care_data:
    fo.write("%d\n" % i)

  fo.write("Offset_Map\n")
  for i in offset_map:
    ls = ""
    ls += ("%d, %d, " % (i[0:2]))
    if i[2] == None: ## filepos
      ls += "None, "
    else:
      ls += ("%d, " % i[2])
    if i[3] == None: ## fill data
      ls += "None"
    else:
      for fx in i[3]: ## fill data is a raw str.
        ls += "%02X" % ord(fx)
    ls += "\n"
    fo.write(ls)

  fo.write("Sparse_End\n")
  fo.close()

if __name__ == '__main__':
  main(sys.argv[1:])

