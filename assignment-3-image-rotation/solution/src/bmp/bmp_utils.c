#include "bmp_utils.h"

#define SIGNATURE 19778
#define BIT_COUNT 24

#include "bmp_header.h"

static uint8_t calculate_padding(uint64_t const width){
    return (4 - (uint8_t)(( width*sizeof(struct pixel))%4));
}

static enum read_status read_bmp_header(struct bmp_header* const header, FILE * const input_file){
    if (!(fread(header, sizeof( struct bmp_header ),1,input_file))){
        return READ_INVALID_BITS;
    } 
    return READ_OK;
}


static enum read_status read_pixels(struct  bmp_header const * header, struct image * img, FILE * const input_file){
    *img  = image_init(header->biWidth, header->biHeight);
    uint8_t padding = calculate_padding(img->width);
    for (size_t i=0; i<img->height; i++){
        if ((fread(img->data+(i*img->width), sizeof (struct pixel),img->width, input_file)!=img->width)  || (fseek(input_file, padding, SEEK_CUR))){
            free(img->data);
            return READ_INVALID_BITS;
        }

    }
    return READ_OK;
}

static enum read_status validate_bmp_header(struct bmp_header*  const header){
    if (header->bfType !=SIGNATURE){
        return READ_INVALID_SIGNATURE;
    }else if (header->biBitCount != BIT_COUNT) {
        return READ_INVALID_HEADER;
    }
    else {
        return READ_OK;
    }
}


enum read_status from_bmp( FILE* const input_file, struct image* const img ){
    struct bmp_header header = {0};
    enum read_status status = read_bmp_header(&header, input_file);
    if (status!=READ_OK) {
        return status;
    }
    enum read_status readStatus = validate_bmp_header(&header);
    if (readStatus!=READ_OK){
        return readStatus;
    }
    return read_pixels(&header, img, input_file);
}

static enum write_status write_header( struct bmp_header const * const header, FILE* const output_file){
    if (header!=NULL){
        if (fwrite(header, sizeof(struct bmp_header), 1, output_file) == 1){
            return WRITE_OK;
        }
    }
    return WRITE_ERROR;
}

static enum write_status write_pixels(struct image const * const img, FILE* const output_file){
    uint8_t padding = calculate_padding(img->width);
    for(uint64_t y=0; y<img->height; y++){
        if (fwrite(img->data+(img->width*y), sizeof(struct pixel), img->width, output_file) != img->width){
            return WRITE_ERROR;
        }
        if (fseek(output_file, padding, SEEK_CUR)){
            return WRITE_ERROR;
        }
    }
    return WRITE_OK;
}

enum write_status to_bmp(FILE* const outputFile,  struct image const*  const img){
    struct  bmp_header header = create_bmp_header(img);
    if (write_header(&header, outputFile) == WRITE_OK){
        return write_pixels(img, outputFile);
    }
    return WRITE_ERROR;
}
