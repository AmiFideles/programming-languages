#ifndef IMAGE_TRANSFORMER_IMAGE_H
#define IMAGE_TRANSFORMER_IMAGE_H
#include <stdint.h>
#include <stdlib.h>


struct pixel{
    uint8_t b,g,r;
};

struct image {
    uint64_t width, height;
    struct pixel* data;
};

struct image image_init(uint64_t const width, uint64_t const height);


void image_destroy(struct image* const img);

struct pixel get_pixel(const struct image* img, uint64_t x, uint64_t y);

void set_pixel(struct image* img, uint64_t x, uint64_t y, struct pixel const pixel);

#endif
