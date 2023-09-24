CREATE TABLE public.family_finances_archive (
    id integer NOT NULL,
    date DATE,
    title varchar(20),
    memo varchar(100),
    deposits integer,
    amount integer
);
