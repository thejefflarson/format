#ifndef LIST_H
#define LIST_H

#include "arena.h"

typedef struct list_node {
  struct list_node *next;
  void *data;
} list_node_t;

typedef struct list {
  list_node_t *head;
  list_node_t *tail;
  uint32_t length;
  arena_t *arena;
} list_t;

list_t *
list_new(arena_t *arena);

void
list_push(list_t *list, void *item);

#endif
