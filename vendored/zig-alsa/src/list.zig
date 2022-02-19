pub const list_head = extern struct {
    next: ?*list_head,
    prev: ?*list_head,
};
