#include "bmp_header.h"

#define INFO_SIZE 40
#define SIGNATURE 19778
#define PLANES 1
#define BIT_COUNT 24
#define ZERO 0

struct bmp_header create_bmp_header(const struct image* img){
    uint64_t img_size = img->height * img->width * sizeof(struct pixel);
    return (struct bmp_header) {
            .bfType = SIGNATURE,
            .bfileSize = sizeof(struct bmp_header) + img_size,
            .bfReserved = ZERO,
            .bOffBits = sizeof(struct bmp_header),
            .biSize = INFO_SIZE,
            .biWidth = img->width,
            .biHeight = img->height,
            .biPlanes = PLANES,
            .biBitCount = BIT_COUNT,
            .biCompression = ZERO,
            .biSizeImage = img_size,
            .biXPelsPerMeter = ZERO,
            .biYPelsPerMeter = ZERO,
            .biClrUsed = ZERO,
            .biClrImportant = ZERO
    };
}

