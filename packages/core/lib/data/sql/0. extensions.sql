CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE appointment_state AS ENUM (
    'pending',
    'canceled',
    'finished',
    'pending_to_reschedule'
);