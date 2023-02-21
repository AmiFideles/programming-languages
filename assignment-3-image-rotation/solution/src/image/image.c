#include "image.h"

struct image image_init(uint64_t const width, uint64_t const height){
    struct image img={
            .height=height,
            .width=width,
            .data=malloc(height*width*sizeof(struct pixel))
    };
    return img;
}

struct pixel get_pixel(const struct image* img, uint64_t const x, uint64_t const y){
    return *(img->data+(img->width)*y+x);
}

void set_pixel(struct image* img, uint64_t const x, uint64_t const y, struct pixel  pixel){
    *(img->data+(img->width)*y+x)=pixel;
}

void image_destroy( struct image* const img){
    free(img->data);
}
