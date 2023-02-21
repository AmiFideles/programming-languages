#include "file/file.h"
#include "bmp/bmp_utils.h"
#include "console_printer/printer.h"
#include "image/image.h"
#include "transformer/rotate.h"


void destroy_images(struct image *pImage, struct image *pImage1);

int main(int argc, char** argv ) {
    if (argc!=3){
        print_error("Incorrect number of arguments");
        return 1;
    }

    FILE* input_file = NULL;
    if (file_open(&input_file, argv[1], "rb")!= FILE_OPEN_OK){
        print_error(" Unable to open the input file ");
        return  1;
    }

    struct image img ={0};
    if (from_bmp(input_file, &img)!=READ_OK){
        print_error("Unable to read the input file ");
        file_close(input_file);
        return 1;
    }

    FILE* output_file = NULL;
    if (file_open(&output_file, argv[2], "wb")!= FILE_OPEN_OK){
        print_error("Unable to open the output file ");
        file_close(input_file);
        return 1;
    }

    struct image rotated_image = rotate(&img);
    if (to_bmp(output_file, &rotated_image)!=WRITE_OK){
        print_error("Unable to write to the output file");
        image_destroy(&img);
        image_destroy(&rotated_image);
        file_close(input_file);
        file_close(output_file);
        return 1;
    }

    if(file_close(input_file)){
        print_error("Can't close the input file");
        destroy_images(&img, &rotated_image);
        return 1;
    }
    if(file_close(output_file)){
        print_error("Can't close the output file");
        destroy_images(&img, &rotated_image);
        return 1;
    }
    destroy_images(&img, &rotated_image);
}

void destroy_images(struct image *pImage, struct image *pImage1) {
    image_destroy(pImage);
    image_destroy(pImage1);
}


