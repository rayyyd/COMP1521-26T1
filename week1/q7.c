#include <stdio.h>

int sum(int n);

int main(int argc, char *argv[]) {
        int n;
        printf("Enter a number: ");
        scanf("%d", &n);

        int result = sum(n);
        printf("Sum of all numbers up to %d = %d\n", n, result);

        return 0;
}

// int sum(int n) {
//     int result = 0;
//     for (int i = 0; i <= n; i++) {
//         result += i;
//     }
//     return result;
// }


int sum(int n) {
    // set the stop condition
    if (n == 0) {
        return 0;
    }


    // somehow call itself to progress
    return n + sum(n - 1);
        10   + sum(9);
             +   9 + sum(8);
                   + 8 + sum(7)
                    + ...
                       + 1 + 0
}