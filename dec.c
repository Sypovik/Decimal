#include <stdio.h>
#include <limits.h>
char* bool_format(unsigned int number, char* str) {
    for (int i = 0; i < 32; i++) {
        str[i] = number >> 31 - i << 31 ? '1' : '0';
    }
    return str;
}
int main(void) {
    char str[32] = {0};
    printf("%s", bool_format(-2, str));
    return 0;
}