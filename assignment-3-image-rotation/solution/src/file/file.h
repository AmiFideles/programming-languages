#ifndef IMAGE_TRANSFORMER_FILE_H
#define IMAGE_TRANSFORMER_FILE_H

#include <bits/types/FILE.h>
#include <stdio.h>
enum file_open_status {
    FILE_OPEN_OK=0,
    FILE_OPEN_ERROR
};

enum file_close_status {
    FILE_CLOSE_OK=0,
    FILE_CLOSE_ERROR
};

enum file_open_status file_open(FILE** const file,  char*  file_name,  char* const mode);

enum file_close_status file_close(FILE* file_name);
#endif
