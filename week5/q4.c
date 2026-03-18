//  Write a C function, six_middle_bits, which, given a uint32_t, extracts and returns the middle six bits. 
#include <stdint.h>
#include <stdio.h>

uint32_t six_middle_bits(uint32_t bits) {
    // what mask?
    uint32_t mask = 0b00000000000001111110000000000000;

    // what operation?
    // 0b01010101010101100111010101010101           subject
    // 0b00000000000001111110000000000000           mask
    // ---------------------------------------       &
    // 0b00000000000001100110000000000000


    return (bits & mask) >> 13;
}

int main() {
    uint32_t number = 0b01010101010101100111010101010101;
    // expected ans: 110011
    printf("0b%b\n", six_middle_bits(number));
    return 0;
}