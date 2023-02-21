#include "rotate.h"

struct image rotate(struct image const * const img){
    struct image new_image = image_init(img->height, img->width);
    for (size_t i=0; i<img->height;i++){
        for(size_t j=0; j<img->width; j++){
            set_pixel(&new_image,  img->height-i-1, j, get_pixel(img, j, i));
        }
    }
    return new_image;
}
