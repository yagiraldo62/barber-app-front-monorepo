create table public.appointments (
    id uuid not null default uuid_generate_v4 (),
    client_id uuid null,
    artist_id uuid null,
    category_id uuid null,
    start_time timestamp with time zone null,
    create_time timestamp with time zone not null default now(),
    modify_time timestamp with time zone not null default now(),
    client_info jsonb null,
    end_time timestamp with time zone null,
    state public.appointment_state null default 'pending' :: appointment_state,
    constraint appointments_pkey primary key (id),
    constraint appointments_artist_id_fkey foreign key (artist_id) references artists (id),
    constraint appointments_category_id_fkey foreign key (category_id) references categories (id),
    constraint appointments_client_id_fkey foreign key (client_id) references users (id)
) tablespace pg_default;