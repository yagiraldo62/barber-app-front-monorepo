create table public.users (
    id uuid not null default uuid_generate_v4 (),
    name character varying(255) null,
    username character varying(255) null,
    email character varying(255) null,
    is_first_login boolean null default false,
    phone_number character varying(50) null,
    photo_url character varying(255) null,
    created_at timestamp with time zone null,
    last_sign_in_time timestamp with time zone null,
    location jsonb null,
    constraint users_pkey primary key (id)
) tablespace pg_default;