typedef struct list_node {
  struct list_node *next;
  void *data;
} list_node_t;

typedef struct list {
  list_node_t *head;
  list_node_t *tail;
} list_t;