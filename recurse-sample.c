#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>

void recurse(char *pathname);

int main(int argc, char *argv[] ) {
    char *dir_pathname = getenv("PWD");
    printf("%s", dir_pathname);

    // part 1: print out all files in the current directory
    recurse(dir_pathname);
}

void recurse(char *pathname) {
    // part 2: print out files in subdirectories as well.

    DIR *dirp = opendir(pathname);
    struct dirent *de;
    while ((de = readdir(dirp)) != NULL) {
        // the name of the entry is de->d_name
        // if its a file -> print

        // combine the pathnames
        char *new_path = malloc(sizeof(pathname) + sizeof(de->d_name) + 2);
        // directory'/'file'\0'
        sprintf(new_path, "%s/%s", pathname, de->d_name);
        struct stat s;
        stat(new_path, &s);
        if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..")) {
            continue;
        }
        if (!S_ISDIR(s.st_mode)) {
            // file
            if (strstr(new_path, "hello") == NULL) {
                // no hello found in the pathname
                continue;
            }
            printf("%s\n", new_path);
        } else {
            // directory
            recurse(new_path);
        }
        // if its a directory -> recurse into it.
        // recurse("new_directory_pathname")
    }


}