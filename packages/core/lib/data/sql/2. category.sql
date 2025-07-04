create table public.categories (
    id uuid not null default uuid_generate_v4 (),
    code character varying(255) null,
    icon character varying(255) null,
    status integer null,
    constraint categories_pkey primary key (id)
) tablespace pg_default;