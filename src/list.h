#ifndef LIST_H
#define LIST_H

#include "arena.h"

typedef struct list list_t;

list_t *
list_new(arena_t *arena);

#endif
