// src/main.c

#include <generated/csr.h>

int main(void) {
    while (1) {
        leds_out_write(0xAA);
        for(int i = 0; i < 1000000; i++);
        leds_out_write(0x55);
        for(int i = 0; i < 1000000; i++);
    }
    return 0;
}
