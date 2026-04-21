#include <stdio.h>
#include <stdlib.h>

int main() {
    

    posix_spawn(&pid, "/bin/1521", NULL, NULL, {"/bin/1521", "autotest", "stdio", NULL}, environ);
    
}
