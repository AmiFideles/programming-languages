#ifndef IMAGE_TRANSFORMER_BMP_UTILS_H
#define IMAGE_TRANSFORMER_BMP_UTILS_H
#include "../image/image.h"
#include "bmp_header.h"
#include <bits/types/FILE.h>
#include <stdio.h>

enum read_status  {
    READ_OK = 0,
    READ_INVALID_SIGNATURE,
    READ_INVALID_BITS,
    READ_INVALID_HEADER
};

enum  write_status  {
    WRITE_OK = 0,
    WRITE_ERROR
};


enum read_status from_bmp(FILE* const input_file, struct image* const img);

enum write_status to_bmp(FILE* const outputFile,  struct image const*  const img);
#endif
