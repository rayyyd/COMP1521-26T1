#include <stdio.h>
#include <stdlib.h>

//read from a file alphabets.txt and swap the first 13 letters with the last 13 letters.
int main() {
    // fopen
    FILE *fs = fopen("alphabets.txt", "r");
    if (fs == NULL) {
        perror("alphabets.txt");
        exit(1);
    }


    // fseek


    // fread
    char first_13[13];
    char last_13[13];

    if (fread(first_13, 1, 13, fs) != 13) {
        fprintf(stderr, "failed to read first 13");
        exit(1);
    }   //this automatically advances our pointer 13 characters forward.
    if (fread(last_13, 1, 13, fs) != 13) {
        fprintf(stderr, "failed to read last 13");
        exit(1);
    };

    // fclose
    fclose(fs);

    FILE * fs2 = fopen("alphabets.txt", "w");
    fwrite(last_13, 1, 13, fs2);
    fwrite(first_13, 1, 13, fs2);
    fclose(fs2);


    return 0;
}