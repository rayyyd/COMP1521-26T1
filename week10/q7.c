#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void *print_feed(void *message) {
    char *str = message;
    while (1) {
        printf("%s\n", str);
        sleep(1);
    }

}

int main() {
    char *msg = "feed me input\n";
    pthread_t id;
    pthread_create(&id, NULL, print_feed, msg);

    while (1) {

        char c;
        scanf(" %c\n", &c);
        printf("scanned in %c\n", c);
    }
}