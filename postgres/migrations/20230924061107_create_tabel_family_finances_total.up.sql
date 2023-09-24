CREATE TABLE public.family_finances_total (
    id serial PRIMARY KEY,
    title varchar(20),
    sum integer,
    avg integer,
    max integer,
    min integer,
    count integer
);
