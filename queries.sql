-- DROP TABLE IF EXISTS public.books;
CREATE TABLE IF NOT EXISTS public.books
(
    id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    author text COLLATE pg_catalog."default",
    summary text COLLATE pg_catalog."default",
    image text COLLATE pg_catalog."default",
    link text COLLATE pg_catalog."default",
    rating numeric,
    user_id integer NOT NULL,
    CONSTRAINT books_pkey PRIMARY KEY (id, user_id),
    CONSTRAINT books_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.users (user_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

-- DROP TABLE IF EXISTS public.users;
CREATE TABLE IF NOT EXISTS public.users
(
    user_id integer NOT NULL DEFAULT nextval('users_user_id_seq'::regclass),
    email character varying(255) COLLATE pg_catalog."default" NOT NULL,
    password text COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (user_id),
    CONSTRAINT users_email_key UNIQUE (email)
)

TABLESPACE pg_default;