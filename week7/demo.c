#include <stdio.h>
#include <stdint.h>

uint32_t num = 0b01000000001000000000000000000000;

struct float_bits {
    uint8_t sign;
    uint8_t exp;
    uint32_t frac;
};

// print out the various bitwise portions of num.
int main() {
    struct float_bits fbits; 
    // sign first
    // bitwise 2 parts: mask and operation
    uint32_t mask_sign = 1u << 31;  // (0b10000...)  
    fbits.sign = (num & mask_sign) >> 31;

    // exp
    uint32_t exp_mask = 0b11111111 << 23;
    fbits.exp = (num & exp_mask) >> 23;

    // frac
    uint32_t frac_mask = 0x7FFFFF;
    fbits.frac = (num & frac_mask);

    printf("%b", fbits.sign);
    printf("%8b", fbits.exp);
    printf("%23b", fbits.frac);
    printf("\n");

}