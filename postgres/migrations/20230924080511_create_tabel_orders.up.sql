CREATE TABLE public.orders (
    id serial PRIMARY KEY,
    date DATE,
    order_number integer,
    order_number_child integer,
    name varchar(40),
    kind char(1),
    size char(1),
    price integer,
    count integer,
    order_price integer
);
