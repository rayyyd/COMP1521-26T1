// COMP1521 Assignment 2: stdio
//
// Name: [zID]
// Date: [...]
//

#include "cs1521_stdio.h"

#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdbool.h>
#include <sys/stat.h>

struct file {
    /* TODO: fill this out (SUBSET 0)*/
};

/* TODO: set these up (SUBSET 1)*/
cs1521_FILE *cs1521_stdin = NULL;
cs1521_FILE *cs1521_stdout = NULL;
cs1521_FILE *cs1521_stderr = NULL;

////////////////////////////////
// HELPER FUNCTION PROTOTYPES //
////////////////////////////////

/* TODO: write some helper functions? */

//////////////
// SUBSET 0 //
//////////////

cs1521_FILE *cs1521_fopen(char *pathname, char *mode) {
    (void) pathname;
    (void) mode;

    cs1521_printf("TODO: implement cs1521_fopen (SUBSET 0)\n");

    return NULL;
}

int cs1521_fclose(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fclose (SUBSET 0)\n");

    return -1;
}

int cs1521_fileno(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fileno (SUBSET 0)\n");
    
    return -1;
}

int cs1521_fgetc(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fgetc (SUBSET 0)\n");

    return cs1521_EOF;
}

int cs1521_fputc(int c, cs1521_FILE *stream) {
    (void) c;
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fputc (SUBSET 0)\n");

    return cs1521_EOF;
}

//////////////
// SUBSET 1 //
//////////////

size_t cs1521_fread(void *ptr, size_t size, size_t nitems, cs1521_FILE *stream) {
    (void) ptr;
    (void) size;
    (void) nitems;
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fread (SUBSET 1)\n");

    return 0;
}

size_t cs1521_fwrite(void *ptr, size_t size, size_t nitems, cs1521_FILE *stream) {
    (void) ptr;
    (void) size;
    (void) nitems;
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fwrite (SUBSET 1)\n");

    return 0;
}

char *cs1521_fgets(char *ptr, size_t size, cs1521_FILE *stream) {
    (void) ptr;
    (void) size;
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fgets (SUBSET 1)\n");

    return NULL;
}

int cs1521_fputs(char *s, cs1521_FILE *stream) {
    (void) s;
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fputs (SUBSET 1)\n");

    return -1;
}


//////////////
// SUBSET 2 //
//////////////

int cs1521_fseek(cs1521_FILE *stream, long offset, int whence) {
    (void) stream;
    (void) offset;
    (void) whence;

    cs1521_printf("TODO: implement cs1521_fseek (SUBSET 2)\n");

    return -1;
}

long cs1521_ftell(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_ftell (SUBSET 2)\n");

    return -1;
}

void cs1521_perror(char *msg) {
    (void) msg;

    cs1521_printf("TODO: implement cs1521_perror (SUBSET 2)\n");

    return;
}

int cs1521_feof(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_feof (SUBSET 2)\n");

    return -1;
}

int cs1521_ferror(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_ferror (SUBSET 2)\n");

    return -1;
}

void cs1521_clearerr(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_clearerr (SUBSET 2)\n");

    return;
}

//////////////
// SUBSET 3 //
//////////////

cs1521_wchar_t cs1521_fgetwc(cs1521_FILE *stream) {
    cs1521_printf("TODO: implement cs1521_fgetwc (SUBSET 3)\n");

    return cs1521_WEOF; 
}

cs1521_wchar_t cs1521_fputwc(cs1521_wchar_t wc, cs1521_FILE *stream) {
    cs1521_printf("TODO: implement cs1521_fputwc (SUBSET 3)\n");

    return cs1521_WEOF;
}

int cs1521_posix_spawnp(pid_t *pid, char *file, 
                       cs1521_posix_spawn_file_actions_t *file_actions,
                       cs1521_posix_spawnattr_t * attrp, char *argv[], char *envp[]) {
    (void) pid;
    (void) file;
    (void) file_actions;
    (void) attrp;
    (void) argv;
    (void) envp;

    cs1521_printf("TODO: implement cs1521_posix_spawnp (SUBSET 3)\n");

    return -1;
}

//////////////
// SUBSET 4 //
//////////////

int cs1521_fflush(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fflush (SUBSET 4)\n");

    return -1;
}

int cs1521_fpurge(cs1521_FILE *stream) {
    (void) stream;

    cs1521_printf("TODO: implement cs1521_fpurge (SUBSET 4)\n");

    return -1;
}

int cs1521_setvbuf(cs1521_FILE *stream, char *buf, int type, size_t size) {
    (void) stream;
    (void) buf;
    (void) type;
    (void) size;

    cs1521_printf("TODO: implement cs1521_setvbuf (SUBSET 4)\n");

    return -1;
}

//////////////////////
// HELPER FUNCTIONS //
//////////////////////

/* TODO: write some helper functions? */

//////////////
// PROVIDED //
//////////////

#define BYTES_IN_UNSIGNED_INT 4
#define BYTES_IN_UNSIGNED_LL 8
#define HEX_DIGITS_IN_BYTE 2
#define BITS_IN_HEX_DIGIT 4

void print_string(char *s);
void print_char(char c);
void print_dec(int x);
void print_hex(unsigned int x);
void print_ptr(unsigned long long ptr);

/** 
 * Basic implementation of printf. Supports format specifiers 
 * %d, %c, %x, %p, and %s. Padding is NOT supported.
 * 
 * This is used by autotests, so feel free to change or improve it but don't break 
 * the existing functionality. Do NOT implement buffering for printf. Do NOT use cs1521_stdout for printf.
 *
 * You may use this to debug your code but not to implement any functionality.
 * 
 * @param format        the format string
 * @param ...           variable number of format arguments
 */
void cs1521_printf(char *format, ...) {
    va_list args;
    va_start(args, format);

    char *s = format;
    while (*s) {
        if (*s != '%') {
            print_char(*s);
            s++;
            continue;
        }

        /* handle %% */
        if (*(s + 1) == '%') {
            print_char('%');
            s += 2;
            continue;
        }
        
        /* %d */
        if (*(s + 1) == 'd') {
            print_dec(va_arg(args, int));
            s += 2;
            continue;
        }

        /* %c */
        if (*(s + 1) == 'c') {
            print_char(va_arg(args, int));
            s += 2;
            continue;
        }

        /* %s */
        if (*(s + 1) == 's') {
            print_string(va_arg(args, char*));
            s += 2;
            continue;
        }

        /* %x */
        if (*(s + 1) == 'x') {
            print_hex(va_arg(args, unsigned int));
            s += 2;
            continue;
        }

        /* %p */
        if (*(s + 1) == 'p') {
            print_ptr(va_arg(args, unsigned long long));
            s += 2;
            continue;
        }
        
        /* bad specifier: fail loudly */
        cs1521_printf("\nprintf: bad format string: \"%s\"\n", format, s);
        va_end(args);
        exit(1);
    }

    va_end(args);
}

void print_string(char *s) {
    if (s == NULL) {
        print_string("(null)");
        return;
    }

    for (; *s; s++) {
        print_char(*s);
    }
}

void print_dec(int x) {
    long long magnitude = 1;

    /* find magnitude of x */
    while (x / magnitude) {
        magnitude *= 10;
    }
    magnitude /= 10;


    if (magnitude == 0) {
        print_char('0');
        return;
    }

    if (x < 0) {
        print_char('-');
        x *= -1;
    }

    /* print each decimal digit, largest to smallest */
    while (magnitude > 0) {
        int digit = x / magnitude;
        x -= (digit * magnitude);
        print_char(digit + '0');
        magnitude /= 10;
    }
}


void print_hex(unsigned int x) {
    int printed_something = false;
    
    /* loop from left to right over each hex digit */
    int num_digits = BYTES_IN_UNSIGNED_INT * HEX_DIGITS_IN_BYTE;
    for (int i = 0; i < num_digits; i++) {
        int shift = (num_digits - i - 1) * BITS_IN_HEX_DIGIT;
        uint32_t mask = 0xFu << shift;
        int digit = (x & mask) >> shift;

        if (digit == 0 && !printed_something) {
            continue;
        }

        if (digit < 10) {
            print_char(digit + '0');
        } else {
            print_char(digit + 'a' - 10);
        }

        printed_something = true;
    }

    if (!printed_something) {
        print_char('0');
    }
}

void print_ptr(unsigned long long ptr) {
    print_char('0');
    print_char('x');

    int printed_something = false;
    
    /* loop from left to right over each hex digit */
    int num_digits = BYTES_IN_UNSIGNED_LL * HEX_DIGITS_IN_BYTE;
    for (int i = 0; i < num_digits; i++) {
        int shift = (num_digits - i - 1) * BITS_IN_HEX_DIGIT;
        uint64_t mask = 0xFllu << shift;
        int digit = (ptr & mask) >> shift;

        if (digit == 0 && !printed_something) {
            continue;
        }

        if (digit < 10) {
            print_char(digit + '0');
        } else {
            print_char(digit + 'a' - 10);
        }

        printed_something = true;
    }

    if (!printed_something) {
        print_char('0');
    }
}

void print_char(char c) {
    /* write to stdout (file descriptor 1)*/
    write(1, &c, 1);
}