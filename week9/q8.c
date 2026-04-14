#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

void DoTraverseDirectory(char *path);

// code to print out all the entries in one directory.
int main() {
    char *path = getenv("PWD");
    // printf("%s\n", path);
    DoTraverseDirectory(path);

    // DIR *dirp = opendir(path);

    // struct dirent *de;

}

void DoTraverseDirectory(char *path) {
    DIR *dirp = opendir(path);
    if (dirp == NULL) {
        if (strstr(path, "hello") != NULL) {
            printf("%s\n", path);
        }
        return;
    }

    struct dirent *de;
    while ((de = readdir(dirp)) != NULL) {
        // printf("%s\n", de->d_name);
        // everytime we get here
        // we have a new "file" in focus

        //current path is: ..../examples
        // de->d_name is: sub
        //we want .../examples/sub
        // to recurse
        char *new_path = malloc(strlen(path) + strlen(de->d_name) + 2);
        sprintf(new_path, "%s/%s", path, de->d_name);
        if (strcmp(de->d_name, ".") != 0 && strcmp(de->d_name, "..") != 0) {
            DoTraverseDirectory(new_path);
        }
    }
}