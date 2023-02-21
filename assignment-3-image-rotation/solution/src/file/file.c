#include "file.h"


enum file_close_status file_close(FILE* file_name) {
    if (!fclose(file_name)){
        return FILE_CLOSE_OK;
    }
    return FILE_CLOSE_ERROR;
}

enum file_open_status file_open(FILE** const file,  char*  file_name,  char* const mode) {
    *file = fopen(file_name, mode);
    if (*file) {
        return FILE_OPEN_OK;
    }
    return FILE_OPEN_ERROR;
}
