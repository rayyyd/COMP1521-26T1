#include <stdio.h>
#include <errno.h>
#include <stdlib.h>






int main(int argc, char* argv[]) {
    // open the file
    if (argc != 2) {
        fprintf(stderr, "arguments not correct\n");
        exit(1);
    }
    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        perror(argv[1]);
        exit(1);
    }



    char read_input[1024] = {0};
    // read the first line   <- how would we do this
    int i = 0;
    int c;
    while ((c = fgetc(fp)) != EOF) {
        read_input[i] = c;
        i++;
        if (c == '\n') {
            break;
        }
    }
    read_input[i] = '\0';

    // print it out
    printf("%s", read_input);

    // close the file
    fclose(fp);


}