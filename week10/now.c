#include <stdio.h>
#include <stdlib.h>
#include <spawn.h>
#include <sys/wait.h>

//run : date +%d-%m-%Y
extern char **environ;
int main() {
    char *argv[3] = {"/bin/date", "+%d-%m-%y", NULL};
    pid_t pid;
    posix_spawn(&pid, "/bin/date", NULL, NULL, argv, environ);
    int spawn_exit_status;
    waitpid(pid, &spawn_exit_status, 0 );
    printf("hi\n");
    return 0;
}