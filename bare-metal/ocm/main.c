#include <stdint.h>
#include <stdlib.h>

#include "common.h"
#include "kprintf.h"

#define DDR_BASE_ADDR 0x80000000
#define OCM_BASE_ADDR (DDR_BASE_ADDR + 0x40000000)

#define OCM_SRC_LOCATION (OCM_BASE_ADDR+0x100000)
#define OCM_DST_LOCATION (OCM_BASE_ADDR+0x140000)

#define DDR_SRC_LOCATION (DDR_BASE_ADDR+0x1000)
#define DDR_DST_LOCATION (DDR_BASE_ADDR+0x20000)

#define ARRAY_SIZE 1024

uint32_t src_array[ARRAY_SIZE];

uintptr_t read_csr(void)
{
    uintptr_t value;
    asm volatile("csrr %0, mcycle" : "=r"(value));
    return value;
}

void mem_copy(uint32_t *dst, uint32_t *src, size_t n){
    for (size_t i = 0; i < n; i++){
        dst[i] = src[i];
    }
}

static void usleep(unsigned us) {
    uintptr_t cycles0;
    uintptr_t cycles1;
    asm volatile ("csrr %0, 0xB00" : "=r" (cycles0));
    for (;;) {
        asm volatile ("csrr %0, 0xB00" : "=r" (cycles1));
        if (cycles1 - cycles0 >= us * 100) break;
    }
}

int main(void) {

    uintptr_t start_cycles, end_cycles;

    // Initialize the source array
    for (size_t i = 0; i < ARRAY_SIZE; i++)
    {
        src_array[i] = i;
    }
    kprintf("Address src_array = 0x%x\n", (void *)src_array);
    
    kprintf("\n");
    uint32_t *dst_array = (uint32_t *)OCM_DST_LOCATION;
    for (size_t j = 0; j < 5; j++)
    {
        start_cycles = read_csr();

        // Perform the memory copy
        mem_copy(dst_array, src_array, ARRAY_SIZE);

        end_cycles = read_csr();
        kprintf("OCM latency: %ld cycles\n", end_cycles - start_cycles);

        usleep(1000000);
    }


    kprintf("\n");
    uint32_t *dst1_array = (uint32_t *)DDR_DST_LOCATION;
    for (size_t j = 0; j < 5; j++)
    {
        start_cycles = read_csr();

        // Perform the memory copy
        mem_copy(dst1_array, src_array, ARRAY_SIZE);

        end_cycles = read_csr();
        kprintf("DDR latency: %ld cycles\n", end_cycles - start_cycles);

        usleep(1000000);
    }

    return 0;
}
