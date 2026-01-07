// src/main.c

#include <generated/csr.h>
#include "main.h"

#define wait(x) for(int w = 0; w < (x); w++)

void main(void) {
    while (1) {
        for (uint32_t led = 0xFF; led > 0x00; led--) {
            leds_out_write(led);
            wait(WAIT_TIME);
        }
    }
}
