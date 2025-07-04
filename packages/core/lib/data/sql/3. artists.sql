create table public.artists (
    id uuid not null default uuid_generate_v4 (),
    owner_id uuid null,
    name character varying(255) null,
    photo_url character varying(255) null,
    is_establishment boolean null,
    availability jsonb null,
    constraint artists_pkey primary key (id),
    constraint artists_owner_id_fkey foreign key (owner_id) references users (id)
) tablespace pg_default;

create table public.artist_category (
    artist_id uuid not null,
    category_id uuid not null,
    constraint artist_category_artist_id_fkey foreign key (artist_id) references artists (id),
    constraint artist_category_category_id_fkey foreign key (category_id) references categories (id)
) tablespace pg_default;