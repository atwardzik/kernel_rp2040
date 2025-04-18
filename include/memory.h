//
// Created by Artur Twardzik on 30/12/2024.
//

#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>

// TODO: dynamic heap size and start determination
#define FIXED_HEAP_START_ADDRESS ((void *) 0x2001'0000) // 65 [KB] for kernel code
constexpr size_t HEAP_SIZE = 100 * 1024; // 100 [KB]

void *kmalloc(size_t size);

void *krealloc(void *ptr, size_t size);

void kfree(void *ptr);

size_t get_allocated_size(void);

size_t get_current_heap_size(void);

void memset(void *dst, int value, size_t count);

void memcpy(void *dst, const void *src, size_t count);

#endif //MEMORY_H
