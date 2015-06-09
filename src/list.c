#include "arena.h"

typedef struct list_node {
  struct list_node *next;
  void *data;
} list_node_t;

typedef struct list {
  list_node_t *head;
  list_node_t *tail;
  arena_t *arena;
} list_t;

list_t *
list_new(arena_t *arena) {
  list_t *list = (list_t *) arena_malloc(arena, sizeof(list_t));
  list->arena = arena;
  return list;
}

void
list_push(list_t *list, void *item) {
  list_node_t *node = (list_node_t *) arena_malloc(list->arena, sizeof(list_node_t));
  node->data = item;
  if(list->head == NULL) {
    list->head = list->tail = node;
  } else {
    list->tail->next = node;
  }
}

