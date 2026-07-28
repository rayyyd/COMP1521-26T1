#include <stdio.h>
#include <stdint.h>

int number = 0b00001010010101011010110101010010;
int six_middle_bits(int x);
// expect answer to be 101101
int main() {
    printf("0b%b\n", six_middle_bits(number));
}

int six_middle_bits(int x) {
    uint32_t mask = 0b00000000000001111110000000000000;
    // uint32_t mask = 0b111111 << 13;  (same as line above)
    return (x & mask) >> 13;
}

// 0b00001010010101011010110101010010   x
// 0b00000000000001111110000000000000   mask
// -----------------------------------  &
// 0b00000000000001011010000000000000

// >>13
// 0b00000000000000000000000000101101


// 12700
// 00127