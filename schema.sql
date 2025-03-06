--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    client_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    other_client_attributes jsonb
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: coordinatoreventpackages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordinatoreventpackages (
    package_id uuid DEFAULT gen_random_uuid() NOT NULL,
    coordinator_id uuid NOT NULL,
    package_details text NOT NULL,
    package_budget numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.coordinatoreventpackages OWNER TO postgres;

--
-- Name: coordinatorpackagesuppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordinatorpackagesuppliers (
    package_supplier_id uuid DEFAULT gen_random_uuid() NOT NULL,
    package_id uuid NOT NULL,
    supplier_id uuid NOT NULL
);


ALTER TABLE public.coordinatorpackagesuppliers OWNER TO postgres;

--
-- Name: coordinators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordinators (
    coordinator_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    experience text,
    specialization character varying(255),
    other_coordinator_attributes jsonb
);


ALTER TABLE public.coordinators OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    coordinator_id uuid,
    event_details text NOT NULL,
    budget numeric(10,2) NOT NULL,
    status character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT events_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Accepted'::character varying, 'Declined'::character varying])::text[])))
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: eventsuppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventsuppliers (
    event_supplier_id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid NOT NULL,
    supplier_id uuid NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT eventsuppliers_status_check CHECK (((status)::text = ANY ((ARRAY['Accepted'::character varying, 'Declined'::character varying])::text[])))
);


ALTER TABLE public.eventsuppliers OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    CONSTRAINT roles_role_name_check CHECK (((role_name)::text = ANY ((ARRAY['Client'::character varying, 'Coordinator'::character varying, 'Supplier'::character varying])::text[])))
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: suppliereventpackages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliereventpackages (
    supplier_package_id uuid DEFAULT gen_random_uuid() NOT NULL,
    supplier_id uuid NOT NULL,
    package_details text NOT NULL,
    package_budget numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.suppliereventpackages OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplier_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    service_type character varying(255),
    rating numeric(3,2),
    other_supplier_attributes jsonb
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: userroles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userroles (
    user_role_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role_id integer NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.userroles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);


--
-- Name: clients clients_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_user_id_key UNIQUE (user_id);


--
-- Name: coordinatoreventpackages coordinatoreventpackages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinatoreventpackages
    ADD CONSTRAINT coordinatoreventpackages_pkey PRIMARY KEY (package_id);


--
-- Name: coordinatorpackagesuppliers coordinatorpackagesuppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinatorpackagesuppliers
    ADD CONSTRAINT coordinatorpackagesuppliers_pkey PRIMARY KEY (package_supplier_id);


--
-- Name: coordinators coordinators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinators
    ADD CONSTRAINT coordinators_pkey PRIMARY KEY (coordinator_id);


--
-- Name: coordinators coordinators_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinators
    ADD CONSTRAINT coordinators_user_id_key UNIQUE (user_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: eventsuppliers eventsuppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventsuppliers
    ADD CONSTRAINT eventsuppliers_pkey PRIMARY KEY (event_supplier_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: suppliereventpackages suppliereventpackages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliereventpackages
    ADD CONSTRAINT suppliereventpackages_pkey PRIMARY KEY (supplier_package_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);


--
-- Name: suppliers suppliers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_user_id_key UNIQUE (user_id);


--
-- Name: userroles userroles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT userroles_pkey PRIMARY KEY (user_role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: clients clients_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coordinatoreventpackages coordinatoreventpackages_coordinator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinatoreventpackages
    ADD CONSTRAINT coordinatoreventpackages_coordinator_id_fkey FOREIGN KEY (coordinator_id) REFERENCES public.coordinators(coordinator_id) ON DELETE CASCADE;


--
-- Name: coordinatorpackagesuppliers coordinatorpackagesuppliers_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinatorpackagesuppliers
    ADD CONSTRAINT coordinatorpackagesuppliers_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.coordinatoreventpackages(package_id) ON DELETE CASCADE;


--
-- Name: coordinatorpackagesuppliers coordinatorpackagesuppliers_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinatorpackagesuppliers
    ADD CONSTRAINT coordinatorpackagesuppliers_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id) ON DELETE CASCADE;


--
-- Name: coordinators coordinators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinators
    ADD CONSTRAINT coordinators_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: events events_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON DELETE CASCADE;


--
-- Name: events events_coordinator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_coordinator_id_fkey FOREIGN KEY (coordinator_id) REFERENCES public.coordinators(coordinator_id) ON DELETE SET NULL;


--
-- Name: eventsuppliers eventsuppliers_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventsuppliers
    ADD CONSTRAINT eventsuppliers_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id) ON DELETE CASCADE;


--
-- Name: eventsuppliers eventsuppliers_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventsuppliers
    ADD CONSTRAINT eventsuppliers_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id) ON DELETE CASCADE;


--
-- Name: suppliereventpackages suppliereventpackages_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliereventpackages
    ADD CONSTRAINT suppliereventpackages_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id) ON DELETE CASCADE;


--
-- Name: suppliers suppliers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: userroles userroles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT userroles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: userroles userroles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userroles
    ADD CONSTRAINT userroles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

