--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:9gAswMf7vBaMMTG1lVYumw==$NKsxoE6UvEu0OMJZj1b5400El7UubHkkDnMNOPXjXQs=:csJ9d9jTkq7VOHBaqMvU1onxkkiUcfbg0yk4rcsZl5g=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

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

--
-- PostgreSQL database dump complete
--

--
-- Database "golab" dump
--

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

--
-- Name: golab; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE golab WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';


ALTER DATABASE golab OWNER TO postgres;

\connect golab

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amiinformation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amiinformation (
    lab_id uuid,
    ami_id character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.amiinformation OWNER TO postgres;

--
-- Name: aws_ec2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aws_ec2 (
    instance_name character varying(255),
    memory character varying(50),
    vcpu character varying(50),
    storage character varying(50),
    network_performance character varying(50),
    on_demand_windows_base_pricing character varying(50),
    on_demand_ubuntu_pro_base_pricing character varying(50),
    on_demand_suse_base_pricing character varying(50),
    on_demand_rhel_base_pricing character varying(50),
    on_demand_linux_base_pricing character varying(50),
    service character varying(50),
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE public.aws_ec2 OWNER TO postgres;

--
-- Name: awsservices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.awsservices (
    services text,
    description text,
    category text
);


ALTER TABLE public.awsservices OWNER TO postgres;

--
-- Name: azure_vm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.azure_vm (
    id uuid DEFAULT public.uuid_generate_v4(),
    instance character varying(250),
    vcpu character varying(255),
    memory character varying(255),
    storage integer,
    linux_vm_price character varying(255),
    windows character varying(255)
);


ALTER TABLE public.azure_vm OWNER TO postgres;

--
-- Name: certifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.certifications (
    certificationid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    userid uuid NOT NULL,
    certificationname character varying(255) NOT NULL
);


ALTER TABLE public.certifications OWNER TO postgres;

--
-- Name: cloudassignedinstance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cloudassignedinstance (
    id integer NOT NULL,
    username character varying(255),
    user_id character varying(255),
    instance_id character varying(255),
    public_ip character varying(255),
    instance_name character varying(255),
    instance_type character varying(255),
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password character varying(255),
    lab_id uuid,
    isrunning boolean,
    isstarted boolean DEFAULT false
);


ALTER TABLE public.cloudassignedinstance OWNER TO postgres;

--
-- Name: cloudassignedinstance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cloudassignedinstance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cloudassignedinstance_id_seq OWNER TO postgres;

--
-- Name: cloudassignedinstance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cloudassignedinstance_id_seq OWNED BY public.cloudassignedinstance.id;


--
-- Name: cloudslicelab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cloudslicelab (
    labid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    createdat timestamp without time zone DEFAULT now(),
    createdby uuid NOT NULL,
    services jsonb,
    region character varying(255) NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone NOT NULL,
    cleanuppolicy text,
    platform character varying(255) NOT NULL,
    provider character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    rating integer,
    modules text NOT NULL,
    difficultylevel text,
    credits integer
);


ALTER TABLE public.cloudslicelab OWNER TO postgres;

--
-- Name: cloudslicelabwithmodules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cloudslicelabwithmodules (
    labid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    createdat timestamp without time zone DEFAULT now(),
    createdby uuid NOT NULL,
    region character varying(255) NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone NOT NULL,
    cleanuppolicy integer NOT NULL,
    platform character varying(255) NOT NULL,
    provider character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    difficultylevel integer,
    status character varying(255) NOT NULL,
    rating integer,
    modules text NOT NULL
);


ALTER TABLE public.cloudslicelabwithmodules OWNER TO postgres;

--
-- Name: createlab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.createlab (
    lab_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    title character varying(255),
    description character varying(255),
    duration character varying(255),
    type text,
    platform text,
    provider character varying(255),
    cpu numeric(5,0),
    ram numeric(5,0),
    storage numeric(5,0),
    instance character varying(255),
    snapshot_type character varying(255) DEFAULT 'hibernate'::character varying,
    os character varying(255),
    os_version character varying(255),
    difficulty character varying(50) DEFAULT 'beginner'::character varying,
    status character varying(50) DEFAULT 'available'::character varying,
    rating double precision DEFAULT 0.0,
    total_enrollments integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT createlab_snapshot_type_check CHECK (((snapshot_type)::text = ANY ((ARRAY['snapshot'::character varying, 'hibernate'::character varying])::text[])))
);


ALTER TABLE public.createlab OWNER TO postgres;

--
-- Name: ec2_instance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ec2_instance (
    id_serial uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    instancename character varying(255) NOT NULL,
    memory character varying(255) NOT NULL,
    vcpu character varying(255) NOT NULL,
    storage character varying(255) NOT NULL,
    networkperformance character varying(255),
    ondemand_windows_base_pricing character varying(255),
    ondemand_ubuntu_pro_base_pricing character varying(255),
    ondemand_suse_base_pricing character varying(255),
    ondemand_rhel_base_pricing character varying(255),
    ondemand_linux_base_pricing character varying(255)
);


ALTER TABLE public.ec2_instance OWNER TO postgres;

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercises (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    module_id uuid,
    type character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT exercises_type_check CHECK (((type)::text = ANY ((ARRAY['lab'::character varying, 'quiz'::character varying, 'questions'::character varying])::text[])))
);


ALTER TABLE public.exercises OWNER TO postgres;

--
-- Name: golden_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.golden_images (
    id integer NOT NULL,
    ami_id text NOT NULL,
    image_name text NOT NULL
);


ALTER TABLE public.golden_images OWNER TO postgres;

--
-- Name: golden_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.golden_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.golden_images_id_seq OWNER TO postgres;

--
-- Name: golden_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.golden_images_id_seq OWNED BY public.golden_images.id;


--
-- Name: instance_pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instance_pricing (
    instance_name character varying(255),
    memory character varying(50),
    vcpu character varying(50),
    storage character varying(50),
    network_performance character varying(50),
    on_demand_windows_base_pricing character varying(50),
    on_demand_ubuntu_pro_base_pricing character varying(50),
    on_demand_suse_base_pricing character varying(50),
    on_demand_rhel_base_pricing character varying(50),
    on_demand_linux_base_pricing character varying(50),
    service character varying(50)
);


ALTER TABLE public.instance_pricing OWNER TO postgres;

--
-- Name: instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instances (
    id integer NOT NULL,
    lab_id uuid,
    instance_id text NOT NULL,
    created_at timestamp without time zone,
    instance_name character varying(255),
    public_ip character varying(255),
    password character varying(255),
    isrunning boolean,
    isstarted boolean DEFAULT false
);


ALTER TABLE public.instances OWNER TO postgres;

--
-- Name: instances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instances_id_seq OWNER TO postgres;

--
-- Name: instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instances_id_seq OWNED BY public.instances.id;


--
-- Name: lab_batch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_batch (
    batch_id uuid DEFAULT public.uuid_generate_v4(),
    lab_id uuid,
    admin_id uuid,
    org_id uuid,
    config_details json,
    configured_by uuid,
    software text[]
);


ALTER TABLE public.lab_batch OWNER TO postgres;

--
-- Name: lab_configurations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_configurations (
    config_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    lab_id uuid NOT NULL,
    admin_id uuid NOT NULL,
    config_details jsonb NOT NULL,
    configured_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.lab_configurations OWNER TO postgres;

--
-- Name: lab_exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_exercises (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    exercise_id uuid,
    estimated_duration integer,
    instructions text,
    services text[],
    files text[],
    title text,
    cleanuppolicy jsonb
);


ALTER TABLE public.lab_exercises OWNER TO postgres;

--
-- Name: labassignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.labassignments (
    assignment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    lab_id uuid NOT NULL,
    user_id uuid NOT NULL,
    status character varying(20),
    start_date timestamp without time zone DEFAULT now(),
    completion_date timestamp without time zone,
    progress_percentage integer,
    remarks text,
    assigned_admin_id uuid NOT NULL,
    duration integer,
    launched boolean,
    CONSTRAINT labassignments_progress_percentage_check CHECK (((progress_percentage >= 0) AND (progress_percentage <= 100))),
    CONSTRAINT labassignments_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text])))
);


ALTER TABLE public.labassignments OWNER TO postgres;

--
-- Name: modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    lab_id uuid
);


ALTER TABLE public.modules OWNER TO postgres;

--
-- Name: operating_systems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.operating_systems (
    category text,
    name text
);


ALTER TABLE public.operating_systems OWNER TO postgres;

--
-- Name: options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question_id uuid,
    option_text text NOT NULL,
    option_id text
);


ALTER TABLE public.options OWNER TO postgres;

--
-- Name: organization_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    admin_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    organization character varying(255),
    organization_type character varying(255),
    status character varying(255) DEFAULT 'inactive'::character varying,
    lastactive character varying(255),
    org_id uuid,
    CONSTRAINT organization_users_role_check CHECK (((role)::text = ANY (ARRAY[('admin'::character varying)::text, ('trainer'::character varying)::text, ('user'::character varying)::text])))
);


ALTER TABLE public.organization_users OWNER TO postgres;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organizations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    organization_name character varying(255),
    org_email character varying(255),
    org_admin uuid,
    org_type character varying(255),
    admin_name character varying(255),
    phone_number character varying(255),
    address character varying(255),
    website_url character varying(255),
    status character varying(50) DEFAULT 'pending'::character varying,
    org_id text,
    logo text,
    total_users integer DEFAULT 0,
    total_admins integer DEFAULT 0,
    active_workspaces integer DEFAULT 0,
    monthly_usage numeric(10,2) DEFAULT 0.00
);


ALTER TABLE public.organizations OWNER TO postgres;

--
-- Name: processed_labs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.processed_labs (
    lab_id uuid NOT NULL
);


ALTER TABLE public.processed_labs OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    exercise_id uuid,
    question_text text NOT NULL,
    description text,
    correct_answer text,
    title text,
    estimated_duration integer
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    organization character varying(255),
    organization_type character varying(255),
    role character varying(255) DEFAULT 'user'::character varying,
    status character varying(255) DEFAULT 'pending'::character varying,
    created_by uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    lastactive character varying(255),
    org_id uuid
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: userstats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userstats (
    userid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    completedlabs integer NOT NULL,
    activeassessments integer NOT NULL,
    averagescore numeric(5,2) NOT NULL,
    totalpurchases integer NOT NULL,
    learninghours integer NOT NULL
);


ALTER TABLE public.userstats OWNER TO postgres;

--
-- Name: workspace; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspace (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    lab_name text NOT NULL,
    description text,
    lab_type text NOT NULL,
    documents text[] DEFAULT '{}'::text[],
    url text[] DEFAULT '{}'::text[],
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status text DEFAULT 'active'::text,
    created_by uuid NOT NULL,
    last_updated timestamp without time zone,
    org_id text
);


ALTER TABLE public.workspace OWNER TO postgres;

--
-- Name: cloudassignedinstance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudassignedinstance ALTER COLUMN id SET DEFAULT nextval('public.cloudassignedinstance_id_seq'::regclass);


--
-- Name: golden_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.golden_images ALTER COLUMN id SET DEFAULT nextval('public.golden_images_id_seq'::regclass);


--
-- Name: instances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instances ALTER COLUMN id SET DEFAULT nextval('public.instances_id_seq'::regclass);


--
-- Data for Name: amiinformation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.amiinformation (lab_id, ami_id, created_at) FROM stdin;
12ad72b1-e52a-4a4d-a37e-4988d09c5c84	ami-0f71a2d3b9cfd3f53	2025-04-03 17:48:55.996147
\.


--
-- Data for Name: aws_ec2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aws_ec2 (instance_name, memory, vcpu, storage, network_performance, on_demand_windows_base_pricing, on_demand_ubuntu_pro_base_pricing, on_demand_suse_base_pricing, on_demand_rhel_base_pricing, on_demand_linux_base_pricing, service, id) FROM stdin;
t2.micro-Free tier eligible	1 GiB Memory	1 vCPU	ESB Only	Up to 5 Gigabit	0.0162 USD per Hour	0.0134 USD per Hour	0.0116 USD per Hour	0.026 USD per Hour	0.0116 USD per Hour	Amazon EC2	9c8a5d25-a46f-4e45-8578-b0d7731bd7bb
\.


--
-- Data for Name: awsservices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.awsservices (services, description, category) FROM stdin;
Active Directory Connector (AD Connector)	Redirect directory requests to your on-premises Microsoft Active Directory	Security, Identity, & Compliance
Alexa for Business	Empower your organization with Alexa	Business Applications
Amazon API Gateway	Build, deploy, and manage APIs	Front-End Web & Mobile
Amazon AppFlow	No-code integration for SaaS apps & AWS services	Application Integration
Amazon AppStream 2.0	Stream desktop applications securely to a browser	End User Computing
Amazon Athena	Query data in S3 using SQL	Analytics
Amazon Athena for Apache Spark	Run interactive analytics on Apache Spark in under a second	Analytics
Amazon Augmented AI	Easily implement human review of ML predictions	Machine Learning
Amazon Aurora	High performance managed relational database	Databases
Amazon Bedrock	Build with foundation models	Machine Learning
Amazon Braket	Accelerate quantum computing research	Quantum Technologies
Amazon Chime	Frustration-free meetings, video calls, and chat	Business Applications
Amazon Chime SDK	Real-time messaging, audio, video, and screen sharing	Business Applications
Amazon CloudFront	Global content delivery network	Networking & Content Delivery
Amazon CloudSearch	Managed search service	Analytics
Amazon CloudWatch	Monitor resources and applications	Management & Governance
Amazon CloudWatch Internet Monitor	Visualize your application's global internet health and diagnose issues in minutes, not days	Management & Governance
Amazon CodeCatalyst	Unified software development service for faster development and delivery on AWS	Developer Tools
Amazon CodeGuru	Find your most expensive lines of code	Machine Learning
Amazon CodeWhisperer	Build apps faster with ML-powered coding companion	Machine Learning
Amazon Cognito	Identity management for your apps	Security, Identity, & Compliance
Amazon Comprehend	Discover insights and relationships in text	Machine Learning
Amazon Connect	Omnichannel cloud contact center	Business Applications
Amazon Connect Agent Workspace	Resolve contact center customer issues faster and more accurately	Business Applications
Amazon Connect Contact Lens	Generate customer call summaries automatically using machine learning	Business Applications
Amazon Connect Forecasting, Capacity Planning, and Scheduling	Respond faster to capacity and workforce changes with ML-powered contact center capabilities	Business Applications
Amazon Corretto	Production-ready distribution of OpenJDK	Developer Tools
Amazon DataZone	Unlock data across organizational boundaries with built-in governance	Analytics
Amazon Detective	Investigate potential security issues	Security, Identity, & Compliance
Amazon DevOps Guru	ML-powered cloud operations service to improve application availability	Machine Learning
Amazon DevOps Guru for RDS	Detect, diagnose, and remediate performance issues in Amazon RDS	Machine Learning
Amazon DocumentDB	Fully managed document database	Databases
Amazon DynamoDB	Managed NoSQL database	Databases
Amazon EBS Snapshots Archive	Archive EBS Snapshots and save up to 75% in snapshot storage costs	Storage
Amazon EC2	Virtual servers in the cloud	Compute
Amazon EC2 Auto Scaling	Scale compute capacity to meet demand	Compute
Amazon EC2 C7g Instances & Graviton3	Best price performance for compute-intensive workloads in Amazon EC2	Compute
Amazon EC2 C7gn Instances	Graviton compute optimized instances with up to 200 Gbps of networking bandwidth	Compute
Amazon EC2 G5g Instances	Best price performance in Amazon EC2 for Android game streaming	Compute
Amazon EC2 Hpc6id Instances	Amazon EC2 Hpc6id instances deliver cost-effective price performance for data-intensive HPC workloads	Compute
Amazon EC2 Hpc7g Instances	Deliver up to 60% better performance over comparable previous generation instances for compute-intensive workloads	Compute
Amazon EC2 I4i Instances	The highest local storage performance in Amazon EC2	Compute
Amazon EC2 Im4gn/Is4gen Instances	Best price performance and lowest cost SSD-based storage in Amazon EC2	Compute
Amazon EC2 Inf2 Instances	High performance at the lowest cost in Amazon EC2 for the most demanding inference workloads	Compute
Amazon EC2 M1 Mac Instances	Better application build performance and faster tests for macOS	Compute
Amazon EC2 M6a Instances	General purpose instances powered by 3rd generation AMD EPYC processors	Compute
Amazon EC2 Spot Instances	Run workloads for up to 90% off	Compute
Amazon EC2 Trn1 Instances	The best price performance for training deep learning models in the cloud	Compute
Amazon EC2 X2idn/X2iedn Instances	Up to 50% better compute price performance than previous generation instances	Compute
Amazon EC2 X2iezn Instances	The fastest Intel Xeon Scalable processor in the cloud	Compute
Amazon Elastic Block Store (EBS)	EC2 block storage volumes	Storage
Amazon Elastic Container Registry (ECR)	Easily store, manage, and deploy container images	Containers
Amazon Elastic Container Service (ECS)	Highly secure, reliable, and scalable way to run containers	Containers
Amazon Elastic File System (EFS)	Fully managed file system for EC2	Storage
Amazon Elastic Inference	Deep learning inference acceleration	Machine Learning
Amazon Elastic Kubernetes Service (EKS)	The most trusted way to run Kubernetes	Containers
Amazon Elastic Transcoder	Easy-to-use scalable media transcoding	Media Services
Amazon ElastiCache	In-memory caching service	Databases
Amazon EMR	Hosted Hadoop framework	Analytics
Amazon EMR Serverless	Run big data applications using open-source frameworks without managing clusters and servers	Analytics
Amazon EventBridge	Serverless event bus for SaaS apps & AWS services	Application Integration
Amazon FinSpace	Store, catalog, prepare, and analyze financial industry data in minutes	Analytics
Amazon Forecast	Increase forecast accuracy using machine learning	Machine Learning
Amazon Fraud Detector	Detect more online fraud faster	Machine Learning
Amazon FSx	Launch, run, and scale feature-rich and highly-performant file systems with just a few clicks	Storage
Amazon FSx for Lustre	High-performance file system integrated with S3	Storage
Amazon FSx for OpenZFS	Fully managed storage built on the popular OpenZFS file system	Storage
Amazon FSx for Windows File Server	Fully managed Windows native file system	Storage
Amazon GameLift	Simple, fast, cost-effective dedicated game server hosting	Game Tech
Amazon GuardDuty	Managed threat detection service	Security, Identity, & Compliance
Amazon HealthLake	Securely store, transform, query, and analyze health data in minutes	Machine Learning
Amazon Honeycode	Build mobile & web apps without programming	Business Applications
Amazon Inspector	Automated and continual vulnerability management for Amazon EC2 and Amazon ECR	Security, Identity, & Compliance
Amazon Interactive Video Service (IVS)	Build engaging live stream experiences	Media Services
Amazon Kendra	Reinvent enterprise search with ML	Machine Learning
Amazon Keyspaces (for Apache Cassandra)	Managed Cassandra-compatible database	Databases
Amazon Kinesis	Analyze real-time video and data streams	Analytics
Amazon Kinesis Data Streams	Easily stream data at any scale	Analytics
Amazon Kinesis Data Streams On-Demand	\N	Analytics
Amazon Kinesis Video Streams	Process and analyze video streams	Media Services
Amazon Lex	Build voice and text chatbots	Machine Learning
Amazon Lex Automated Chatbot Designer	Design chatbots using existing conversation transcripts	Machine Learning
Amazon Lightsail	Launch and manage virtual private servers	Compute
Amazon Location Service	Securely and easily add location data to applications	Front-End Web & Mobile
Amazon Lookout for Equipment	Detect abnormal equipment behavior by analyzing sensor data	Machine Learning
Amazon Lookout for Metrics	Automatically detect anomalies in metrics and identify their root cause	Machine Learning
Amazon Lookout for Vision	Spot product defects using computer vision to automate quality inspection	Machine Learning
Amazon Lumberyard	A free cross-platform 3D game engine, with Full Source, integrated with AWS and Twitch	Game Tech
Amazon Macie	Discover and protect your sensitive data at scale	Security, Identity, & Compliance
Amazon Managed Blockchain	Create and manage scalable blockchain networks	Blockchain
Amazon Managed Grafana	Scalable, secure, and highly available data visualization for your operational metrics, logs, and traces	Management & Governance
Amazon Managed Service for Prometheus	Highly available, secure, and managed monitoring for your containers	Management & Governance
Amazon Managed Streaming for Apache Kafka (Amazon MSK) Serverless	Easily stream data with Amazon MSK without managing cluster capacity	Analytics
Amazon Managed Streaming for Apache Kafka (MSK)	Fully managed Apache Kafka service	Analytics
Amazon Managed Workflows for Apache Airflow (MWAA)	Highly available, secure, and managed workflow orchestration for Apache Airflow	Application Integration
Amazon MemoryDB for Redis	Redis-compatible, durable, in-memory database service for ultra-fast performance	Databases
Amazon Monitron	Reduce unplanned equipment downtime with predictive maintenance and machine learning	Machine Learning
Amazon MQ	Managed message broker service	Application Integration
Amazon Neptune	Fully managed graph database service	Databases
Amazon Neptune Lab Mode	Enable new Neptune engine features	Databases
Amazon Neptune Streams	Generate a complete sequence of change-log entries for your graph data	Databases
Amazon Nimble Studio	Accelerate content creation in the cloud	Media Services
Amazon Omics	Transform omics data into insights	Machine Learning
Amazon OpenSearch Serverless	Deliver search and log analytics without provisioning and adjusting resources	Analytics
Amazon OpenSearch Service (Amazon Elasticsearch Service)	Search, visualize, and analyze up to petabytes of text and unstructured data	Analytics
Amazon Personalize	Build real-time recommendations into your applications	Machine Learning
Amazon Pinpoint	Multichannel marketing communications	Front-End Web & Mobile
Amazon Polly	Turn text into life-like speech	Machine Learning
Amazon Quantum Ledger Database (QLDB)	Fully managed ledger database	Blockchain
Amazon QuickSight	Fast business analytics service	Analytics
Amazon QuickSight Paginated Reports	Create, schedule, and share reports and data exports	Analytics
Amazon RDS	Managed relational database service for MySQL, PostgreSQL, Oracle, SQL Server, and MariaDB	Databases
Amazon RDS Custom for SQL Server	Managed database services for applications that require operating system and database customization	Databases
Amazon Redshift	Fast, simple, cost-effective data warehousing	Databases
Amazon Redshift Integration for Apache Spark	Build Apache Spark apps that read and write data from Amazon Redshift	Analytics
Amazon Redshift Serverless	Get insights in seconds without having to manage your data warehouse	Analytics
Amazon Rekognition	Analyze image and video	Machine Learning
Amazon Route 53	Scalable domain name system (DNS)	Networking & Content Delivery
Amazon S3 Glacier	Low-cost archive storage in the cloud	Storage
Amazon S3 Glacier Instant Retrieval	Lowest cost storage with milliseconds retrieval for rarely accessed data	Storage
Amazon SageMaker	Build, train, and deploy machine learning models at scale	Machine Learning
Amazon SageMaker Canvas	Generate accurate machine learning predictions - no code required	Machine Learning
Amazon SageMaker Ground Truth	Build accurate ML training datasets	Machine Learning
Amazon SageMaker Ground Truth Plus	Create high-quality datasets for training machine learning models	Machine Learning
Amazon SageMaker Studio Lab	Learn and experiment with ML using free, no-configuration Jupyter Notebooks in the cloud	Machine Learning
Amazon SageMaker Training Compiler	Train ML models quickly and cost-effectively with Amazon SageMaker	Machine Learning
Amazon Security Lake	Automatically centralize your security data with a few clicks	Security, Identity, & Compliance
Amazon Simple Email Service (SES)	High-scale inbound and outbound email	Front-End Web & Mobile
Amazon Simple Notification Service (SNS)	Pub/sub, SMS, email, and mobile push notifications	Application Integration
Amazon Simple Queue Service (SQS)	Managed message queues	Application Integration
Amazon Simple Storage Service (S3)	Object storage built to retrieve any amount of data from anywhere	Storage
Amazon Sumerian	Build and run AR and VR applications	AR & VR
Amazon Textract	Extract text and data from documents	Machine Learning
Amazon Timestream	Fully managed time series database	Databases
Amazon Transcribe	Automatic speech recognition	Machine Learning
Amazon Translate	Natural and fluent language translation	Machine Learning
Amazon Verified Permissions	Fine-grained permissions and authorization for your applications	Security, Identity, & Compliance
Amazon VPC	Isolated cloud resources	Networking & Content Delivery
Amazon VPC Lattice	Simplify service-to-service connectivity, security, and monitoring	Networking & Content Delivery
Amazon WorkDocs	Secure enterprise document storage and sharing	Business Applications
Amazon WorkMail	Secure email and calendaring	Business Applications
Amazon WorkSpaces Family	Virtual desktop services for every use case	End User Computing
Apache MXNet on AWS	Scalable, open-source deep learning framework	Machine Learning
Automated data-prep for Amazon QuickSight Q	Answer your business questions by quickly and easily enabling your data for natural language search	Analytics
AWS Amplify	Build, deploy, host, and manage scalable web and mobile apps	Front-End Web & Mobile
AWS Amplify Studio	Extend AWS Amplify with a visual development environment for creating apps with minimal coding	Front-End Web & Mobile
AWS App Mesh	Monitor and control microservices	Networking & Content Delivery
AWS App Runner	Production web applications at scale made easy for developers	Compute
AWS App2Container	Containerize and migrate existing applications	Containers
AWS Application Composer	Visually design and build serverless applications quickly	Serverless
AWS Application Discovery Service	Discover on-premises applications to streamline migration	Migration
AWS Application Migration Service (AWS MGN, AWS Server Migration Service, AWS SMS)	Automate application migration and modernization	Migration
AWS AppSync	Accelerate app development with fully-managed, scalable GraphQL APIs	Front-End Web & Mobile
AWS Artifact	On-demand access to AWS’ compliance reports	Security, Identity, & Compliance
AWS Audit Manager	Continuously audit your AWS usage to simplify how you assess risk and compliance	Security, Identity, & Compliance
AWS Auto Scaling	Scale multiple resources to meet demand	Compute
AWS Backup	Centralized backup across AWS services	Storage
AWS Backup support for Amazon S3	Centrally manage backup and restore of app data stored in S3	Storage
AWS Backup support for VMware workloads	Centrally protect hybrid VMware environments	Storage
AWS Batch	Run batch jobs at any scale	Compute
AWS Budgets	Set custom cost and usage budgets	Cloud Financial Management
AWS Certificate Manager	Provision, manage, and deploy SSL/TLS certificates	Security, Identity, & Compliance
AWS Chatbot	ChatOps for AWS	Management & Governance
AWS Clean Rooms	Match, analyze, and collaborate on datasets–without sharing or revealing underlying data	Analytics
AWS Cloud Control API	Manage AWS and third-party cloud infrastructure with consistent APIs	Developer Tools
AWS Cloud Development Kit (CDK)	Model cloud infrastructure using code	Developer Tools
AWS Cloud Map	Service discovery for cloud resources	Networking & Content Delivery
AWS Cloud WAN	Easily build, manage, and monitor global wide area networks	Networking & Content Delivery
AWS Cloud9	Write, run, and debug code on a cloud IDE	Developer Tools
AWS CloudFormation	Create and manage resources with templates	Management & Governance
AWS CloudHSM	Hardware-based key storage for regulatory compliance	Security, Identity, & Compliance
AWS CloudShell	Command line access to AWS resources and tools directly from a browser	Developer Tools
AWS CloudTrail	Track user activity and API usage	Management & Governance
AWS CodeArtifact	Secure, scalable, and cost-effective artifact management for software development	Developer Tools
AWS CodeBuild	Build and test code	Developer Tools
AWS CodeCommit	Store code in private Git repositories	Developer Tools
AWS CodeDeploy	Automate code deployments	Developer Tools
AWS CodePipeline	Release software using continuous delivery	Developer Tools
AWS CodeStar	Develop and deploy AWS applications	Developer Tools
AWS Command Line Interface (CLI)	Line Interface Unified tool to manage AWS services	Developer Tools
AWS Compute Optimizer	Identify optimal AWS Compute resources	Compute
AWS Config	Track resources inventory and changes	Management & Governance
AWS Control Tower	Set up and govern a secure, compliant multi-account environment	Management & Governance
AWS Control Tower Data Residency Guardrails	Keep your customer data in specific AWS Regions	Management & Governance
AWS Copilot	AWS Copilot is the easiest way to launch and manage your containerized application on AWS	Containers
AWS Cost and Usage Report	Access comprehensive cost and usage information	Cloud Financial Management
AWS Cost Explorer	Analyze your AWS cost and usage	Cloud Financial Management
AWS Data Exchange	Find, subscribe to, and use third-party data in the cloud	Analytics
AWS Data Pipeline	Orchestration service for periodic, data-driven workflows	Analytics
AWS Database Migration Service (DMS)	Migrate databases with minimal downtime	Migration
AWS DataSync	Simple, fast, online data transfer	Migration
AWS Deep Learning AMIs	Deep learning on Amazon EC2	Machine Learning
AWS Deep Learning Containers	Docker images for deep learning	Machine Learning
AWS DeepComposer	ML enabled musical keyboard	Machine Learning
AWS DeepLens	Deep learning enabled video camera	Machine Learning
AWS DeepRacer	Autonomous 1/18th scale race car, driven by ML	Machine Learning
AWS Device Farm	Test Android, iOS, and web apps on real devices in the AWS cloud	Front-End Web & Mobile
AWS Direct Connect	Dedicated network connection to AWS	Networking & Content Delivery
AWS Directory Service (AWS Directory Service for Microsoft Active Directory, AWS Managed Microsoft Active Directory, AWS Managed Microsoft AD)	Host and manage active directory	Security, Identity, & Compliance
AWS Distro for OpenTelemetry	Secure, production-ready open source distribution with predictable performance	Management & Governance
AWS Elastic Beanstalk	Run and manage web apps	Compute
AWS Elastic Disaster Recovery (DRS)	Scalable, cost-effective application recovery to AWS	Storage
AWS Elemental Appliances & Software	On-premises media solutions	Media Services
AWS Elemental MediaConnect	Reliable and secure live video transport	Media Services
AWS Elemental MediaConvert	Convert file-based video content	Media Services
AWS Elemental MediaLive	Convert live video content	Media Services
AWS Elemental MediaPackage	Video origination and packaging	Media Services
AWS Elemental MediaStore	Media storage and simple http origin	Media Services
AWS Elemental MediaTailor	Video personalization and monetization	Media Services
AWS Fargate	Serverless compute for containers	Containers
AWS Fault Injection Simulator	Improve resiliency and performance with controlled experiments	Developer Tools
AWS Firewall Manager	Central management of firewall rules	Security, Identity, & Compliance
AWS Global Accelerator	Improve global application availability and performance	Networking & Content Delivery
AWS Glue	Simple, scalable, and serverless data integration	Analytics
AWS Glue Data Quality	Deliver high-quality data across your data lakes and pipelines	Analytics
AWS Glue for Ray	Scale and simplify with Python code for ETL, made serverless	Analytics
AWS Ground Station	Fully managed ground station as a service	Satellite
AWS IAM Identity Center (AWS Single Sign-On)	Manage single sign-on access to AWS accounts and apps	Security, Identity, & Compliance
AWS Identity and Access Management (AWS IAM)	Securely manage access to services and resources	Security, Identity, & Compliance
AWS Inferentia	Machine learning inference chip	Machine Learning
AWS IoT 1-Click	One click creation of an AWS Lambda trigger	Internet of Things
AWS IoT Analytics	Analytics for IoT devices	Internet of Things
AWS IoT Button	Cloud programmable dash button	Internet of Things
AWS IoT Core	Connect devices to the cloud	Internet of Things
AWS IoT Device Defender	Security management for IoT devices	Internet of Things
AWS IoT Device Management	Onboard, organize, and remotely manage IoT devices	Internet of Things
AWS IoT EduKit	Learn how to build simple IoT applications with reference hardware and step-by-step tutorials	Internet of Things
AWS IoT Events	IoT event detection and response	Internet of Things
AWS IoT ExpressLink	Quickly and easily develop secure IoT devices	Internet of Things
AWS IoT FleetWise	Easily collect, transform, and transfer vehicle data to the cloud in near-real time	Internet of Things
AWS IoT Greengrass	Local compute, messaging, and sync for devices	Internet of Things
AWS IoT RoboRunner	Build applications that help fleets of robots work together seamlessly	Internet of Things
AWS IoT SiteWise	IoT data collector and interpreter	Internet of Things
AWS IoT TwinMaker (AWS IoT Things Graph)	Optimize operations by easily creating digital twins of real-world systems	Internet of Things
AWS Key Management Service (KMS)	Managed creation and control of encryption keys	Security, Identity, & Compliance
AWS Lake Formation	Build a secure data lake in days	Analytics
AWS Lambda	Run code without thinking about servers	Compute
AWS Lambda SnapStart	Achieve up to 10x faster Java function startup times	Compute
AWS Launch Wizard	Easily size, configure, and deploy third party applications on AWS	Management & Governance
AWS License Manager	Track, manage, and control licenses	Management & Governance
AWS Local Zones	Run latency sensitive applications closer to end users	Compute
AWS Mainframe Modernization	Migrate, modernize, operate, and run mainframe workloads	Migration
AWS Managed Services	Infrastructure operations management for AWS	Management & Governance
AWS Management Console	Web-based user interface	Management & Governance
AWS Management Console Mobile Application	Access resources on the go	Management & Governance
AWS Marketplace for Containers Anywhere	Find, subscribe to, and deploy third-party applications that run in any Kubernetes environment	Containers
AWS Migration Hub	Track migrations from a single place	Migration
AWS Network Firewall	Deploy network security across your Amazon VPCs with just a few clicks	Security, Identity, & Compliance
AWS OpsWorks	Automate operations with Chef and Puppet	Management & Governance
AWS Organizations	Central governance and management across AWS accounts	Management & Governance
AWS Outposts	Run AWS infrastructure on-premises	Compute
AWS Outposts 1U and 2U	Run AWS Outposts in smaller locations	Compute
AWS Panorama	Improve your operations with computer vision at the edge	Machine Learning
AWS Partner Device Catalog	Curated catalog of AWS-compatible IoT hardware	Internet of Things
AWS Personal Health Dashboard	Personalized view of AWS service health	Management & Governance
AWS Private 5G	Easily deploy, manage, and scale a private cellular network	Networking & Content Delivery
AWS PrivateLink	Securely access services hosted on AWS	Networking & Content Delivery
AWS Proton	Automate management for container and serverless deployments	Management & Governance
AWS Resilience Hub	Prepare and protect your applications from disruptions	Management & Governance
AWS Resource Access Manager	Simple, secure service to share AWS resources	Security, Identity, & Compliance
AWS RoboMaker	Develop, test, and deploy robotics applications	Robotics
AWS Secrets Manager	Rotate, manage, and retrieve secrets	Security, Identity, & Compliance
AWS Security Hub	Unified security and compliance center	Security, Identity, & Compliance
AWS Serverless Application Repository	Discover, deploy, and publish serverless applications	Compute
AWS Service Catalog	Create and use standardized products	Management & Governance
AWS Service Management Connector	Provision, manage and operate AWS resources within Service Management Tools	Management & Governance
AWS Shield	DDoS protection	Security, Identity, & Compliance
AWS SimSpace Weaver	Build dynamic, large-scale spatial simulations on AWS managed infrastructure	Compute
AWS Snow Family	Physical edge computing and storage devices for rugged or disconnected environments	Storage
AWS Step Functions	Coordination for distributed applications	Application Integration
AWS Storage Gateway	Hybrid storage integration	Storage
AWS Supply Chain	Mitigate risks and lower costs with an ML-powered supply chain application	Business Applications
AWS Systems Manager	Gain operational insights and take action	Management & Governance
AWS Tools and SDKs	Tools and SDKs for AWS	Developer Tools
AWS Transfer Family	Fully managed SFTP, FTPS, and FTP service	Migration
AWS Transit Gateway	Easily scale VPC and account connections	Networking & Content Delivery
AWS Trusted Advisor	Optimize performance and security	Management & Governance
AWS Verified Access	Provide secure access to corporate applications without a VPN	Networking & Content Delivery
AWS VPN	Securely access your network resources	Networking & Content Delivery
AWS WAF (AWS Web Application Firewall)	Filter malicious web traffic	Security, Identity, & Compliance
AWS Wavelength	Deliver ultra-low latency applications for 5G devices	Compute
AWS Well-Architected Tool	Review and improve your workloads	Architecture Strategy
AWS Wickr	Protect enterprise communications with end-to-end encryption	Business Applications
AWS X-Ray	Analyze and debug your applications	Developer Tools
Elastic Load Balancing (ELB)	Distribute incoming traffic across multiple targets	Networking & Content Delivery
FreeRTOS	Real-time operating system for microcontrollers	Internet of Things
Geospatial ML with Amazon SageMaker	Build, train, and deploy ML models using geospatial data	Machine Learning
Migration Evaluator (formerly TSO Logic)	Create a business case for cloud migration	Migration
ML Governance with Amazon SageMaker	Simplify access control and enhance transparency	Machine Learning
Open 3D Engine (O3DE)	Build games and 3D simulations with O3DE	Game Tech
PyTorch on AWS	Flexible open-source machine learning framework	Machine Learning
Red Hat OpenShift Service on AWS	Managed OpenShift in the cloud	Containers
Reserved Instance (RI) Reporting	Dive deeper into your reserved instances (RIs)	Cloud Financial Management
Savings Plans	Save up to 72% on compute usage with flexible pricing	Cloud Financial Management
TensorFlow on AWS	Open-source machine intelligence library	Machine Learning
VMware Cloud on AWS	Build a hybrid cloud without custom hardware	Compute
\.


--
-- Data for Name: azure_vm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.azure_vm (id, instance, vcpu, memory, storage, linux_vm_price, windows) FROM stdin;
cdd2ee50-e62b-4a54-9f19-032d51728b9f	A0	1	0.75	20	$0.020/hour	$0.020/hour
254181d7-3692-4df9-9d9f-e57f8896858a	A1	1	1.75	70	$0.066/hour	 $0.098/hour
f464be6e-c3bb-4b1c-ad94-ba2a2a2c2a11	A2	2	3.5	135	$0.131/hour	 $0.197/hour
20b097a0-562b-497a-b076-5382d1fa4e50	A3	4	7	285	$0.262/hour	 $0.393/hour
1ecf2c8b-06c9-4dea-b40f-010240092d0b	A4	8	14	605	$0.524/hour	 $0.786/hour
fa4fb995-7506-4987-97e2-6b70edda8330	A5	2	14	135	$0.260/hour	 $0.305/hour
1549cf3e-6134-4033-80f1-954104a9d7e2	A6	4	28	285	$0.520/hour	 $0.610/hour
f88f35ec-799c-4f4d-ae32-997696f2cdc8	A7	8	56	605	$1.040/hour	 $1.220/hour
1bb4086a-a6a2-4918-a70b-10c582c47baf	A1 v2	1	2	10	$0.047/hour	 $0.070/hour
5bbabd64-74ea-4374-a006-e120e5bcfed2	A2 v2	2	4	20	$0.098/hour	 $0.147/hour
dfe93db9-607f-484b-8110-9bece9b2ba16	A4 v2	4	8	40	$0.206/hour	 $0.310/hour
ff30a566-a246-4580-b853-7c66fefbd504	A8 v2	8	16	80	$0.433/hour	 $0.650/hour
2567cf71-8409-4e39-8482-bbb658a888ec	A2m v2	2	16	20	$0.130/hour	 $0.222/hour
c6221285-11a1-45b0-9266-141bc36b4e5d	A4m v2	4	32	40	$0.259/hour	 $0.443/hour
ced36433-bd0a-4384-8f87-00519e9dd01b	A8m v2	8	64	80	$0.519/hour	 $0.887/hour
2c96f2c7-2b83-4244-b8dd-5e80e6ea3caf	B2als v2	2	4	0	$0.025/hour	 $0.034/hour
7d46ac70-ff9c-44d1-b814-bec40afbde6f	B2as v2	2	8	0	$0.049/hour	 $0.058/hour
3994d7a7-029a-4c12-b4fd-3fa0e84c5059	B2ats v2	2	1	0	$0.006/hour	 $0.015/hour
94361207-7427-478e-9e63-5b6371ce63b4	B4als v2	4	8	0	$0.087/hour	 $0.106/hour
8b003600-d8c9-4a36-a0b4-1c13f75e16f9	B4as v2	4	16	0	$0.098/hour	 $0.117/hour
8b398f30-59be-4ba4-ba18-80b9d509280b	B8als v2	8	16	0	$0.174/hour	 $0.211/hour
6d6bb370-44d3-4536-8493-096c01726f51	B8 as v2	8	32	0	$0.197/hour	 $0.234/hour
b8a3edf5-d4b2-45e7-b661-582dcf990eaf	B16als v2	16	32	0	$0.349/hour	 $0.422/hour
4c4d9fdf-b656-4ed4-b75a-ed6420f747d5	B16as v2 	16	64	0	$0.394/hour	 $0.467/hour
5d916896-2c57-477d-bdd4-bb7181e7b9b6	B32als v2	32	64	0	$0.697/hour	 $0.844/hour
9019debe-89b1-45f9-b41a-d5f6b8c7cf60	B32as v2	32	128	0	$0.787/hour	 $0.934/hour
c46210a9-4df2-4918-b5a9-540923d15d29	B2ps v2	2	8	0	$0.045/hour	\N
255c8c0c-409c-49d8-9206-2a11e546ed76	B2pts v2	2	1	0	$0.006/hour	\N
f6dba7b3-ea53-4ab5-8db8-df0cfe60817d	B2pls v2	2	4	0	$0.022/hour	\N
fcdbf8cf-1e86-4401-8a34-64be9fdec838	B4pls v2	4	8	0	$0.079/hour	\N
8c9a0046-8908-4123-b7bd-485973fbb391	B4ps v2	4	16	0	$0.090/hour	\N
d382212c-441d-4a5b-92b4-6cdbe9716eac	B8pls v2	8	16	0	$0.159/hour	\N
9fd21316-35de-42fa-b039-bc358e1dedab	B8ps v2	8	32	0	$0.179/hour	\N
267cf45e-04ac-4d8f-9654-9fa0ced6a8f3	B16pls v2	16	32	0	$0.317/hour	\N
fef7d398-91a1-4635-8c31-231bff9119fb	B16ps v2	16	64	0	$0.358/hour	\N
7bfb9232-1c7a-42ba-898f-ba1c94f0e341	B1s	1	1	0	$0.011/hour	 $0.015/hour
43541949-a2fd-4992-9ea3-e1e5c1dbce7e	B2s	2	4	0	$0.045/hour	 $0.053/hour
4ba4e777-3ced-48bc-ade1-c43e5918a938	B1ls	1	0.5	0	$0.006/hour	\N
2956952e-98eb-43d0-b01b-b7e6be0a3ef9	B1ms	1	2	4	$0.022/hour	 $0.026/hour
09d4307a-ceb8-4940-af11-9c6fa7c18cb3	B2ms	2	8	16	$0.090/hour	 $0.098/hour
550a6bdc-124f-49c2-9acc-ed821188aeeb	B4ms	4	16	32	$0.179/hour	 $0.195/hour
434d706f-6f4e-4244-854e-3e466abe0c8f	B8ms	8	32	64	$0.358/hour	 $0.390/hour
29d0faad-f9eb-4586-b13a-3971ea3e75d9	B12ms	12	48	96	$0.538/hour	 $0.586/hour
73605bd0-ad35-459b-88ca-6f6f4a228f90	B16ms	16	64	128	$0.717/hour	 $0.781/hour
44595a02-9682-42c8-ada6-28478304d2b8	B20ms	20	80	160	$0.896/hour	 $0.976/hour
a0210a3c-e2a8-49c6-9446-8c89dbb069d5	B2ls v2	2	4	0	$0.045/hour	 $0.054/hour
e6b455f1-ca4d-4dad-9418-ac2fe3d86d3d	B2s v2	2	8	0	$0.090/hour	 $0.099/hour
0821c2e8-99ff-419f-9c19-c7bf53b4cf1a	B2ts v2	2	1	0	$0.011/hour	 $0.020/hour
ddd824b5-0288-4e24-bc40-92311f6451e5	B4ls v2	4	8	0	$0.159/hour	 $0.177/hour
d00cec06-3930-4a02-b724-9d165f8c36a8	B4s v2	4	16	0	$0.179/hour	 $0.198/hour
36a352bd-0ab8-40c4-ba18-31fd9026bee8	B8ls v2	8	16	0	$0.317/hour	 $0.354/hour
accba370-3dd9-4104-9bf0-96034b2ac893	B8s v2	8	32	0	$0.358/hour	 $0.395/hour
1a9eb20d-c1f6-4516-851e-f8b890cf0aa3	B16ls v2	16	32	0	$0.635/hour	 $0.708/hour
6fa19ec1-12c4-4c70-89af-41f4390e831f	B16s v2	16	64	0	$0.717/hour	 $0.790/hour
74ee2e10-adf2-41d7-8e4d-66f49f366815	B32ls v2	32	64	0	$1.269/hour	 $1.417/hour
8b9a04ff-03af-4f91-9516-de0f77e89574	B32s v2	32	128	0	$1.434/hour	 $1.581/hour
12a6f3fe-07da-4f13-b0c8-bd0e5d173b87	DS11-1 v2	1	14	28	$0.189/hour	 $0.282/hour
ff26b929-7719-48da-a490-67613f1e2d01	DS12-1 v2	1	28	56	$0.379/hour	 $0.563/hour
690c91e3-917c-4707-b382-63feb9220568	DS12-2 v2	2	28	56	$0.379/hour	 $0.563/hour
ee110580-165c-45a2-9a20-1ac930de9cad	DS13-2 v2	2	56	112	$0.758/hour	 $1.126/hour
105ea90b-bba1-4ee4-a9da-7d78a11896d1	DS13-4 v2	4	56	112	$0.758/hour	 $1.126/hour
df6c5f3a-3418-49b4-8584-9a1d49179f75	DS14-4 v2	4	112	224	$1.516/hour	 $2.252/hour
be257093-984a-42d3-9f8d-f26274f04853	DS14-8 v2	8	112	224	$1.516/hour	 $2.252/hour
cc09b165-e227-4e55-835e-dbe06c6ce0ce	E4-2ads v5	2	32	150	$0.166/hour	 $0.350/hour
7916ff8f-02e1-40ff-9bd9-86a6a99c4497	E8-2ads v5	2	64	300	$ 0.332/hour	 $0.700/hour
ab7b59df-dfef-4848-9bbe-4972772e64fd	E8-4ads v5	4	64	300	$ 0.332/hour	 $0.700/hour
1580d09f-2e69-4cd7-91da-c7ebb97b2f44	E16-4ads v5	4	128	600	$0.664/hour	 $1.400/hour
effe5ca3-965c-47a8-9822-6e92ea127e31	E16-8ads v5	8	128	600	$0.664/hour	 $1.400/hour
4b0acb7f-75b4-4c24-a83d-fb7cddedb788	E32-8ads v5	8	256	1200	$1.329/hour	 $2.801/hour
2afcf3ff-b4a2-4b54-90fd-35ed2167851a	E32-16ads v5	16	256	1200	$1.329/hour	 $2.801/hour
b55d511f-db7e-423d-8af0-496ad815a672	E64-16ads v5	16	512	2400	$2.658/hour	 $5.602/hour
a6038502-7b85-442f-b34d-40e7f2c29526	E64-32ads v5	32	512	2400	$2.658/hour	 $5.602/hour
615f3a69-fae5-4036-98e3-7d16a8345a40	E96-24ads v5	24	672	3600	$3.986/hour	 $8.402/hour
1c3b7271-dfb0-4588-b07a-133ca9690d95	E96-48ads v5	48	672	3600	$3.986/hour	 $8.402/hour
830997fb-d865-4dd4-be2b-ca7f5b50dbb7	E4-2as  v4	2	32	64	$0.260/hour	 $0.444/hour
42bf3611-a5f2-4cb0-88f0-6c8cc9dfbc44	E8-2as v4	2	64	128	$0.520/hour	 $0.888/hour
bb7259ee-af9e-4037-a4f7-7fa2fbfe6fa8	E8-4as v4	4	64	128	$0.520/hour	 $0.888/hour
7cdffdab-3884-40c3-b1b9-683cfdeedef7	E16-4as v4	4	128	256	$1.040/hour	 $1.776/hour
e3e6380d-42e8-4f50-9ba6-13d768bc1b21	E16-8as v4	8	128	256	$1.040/hour	 $1.776/hour
85e0f390-3c33-44ea-8fe3-61479b8744ea	E32-8as v4	8	256	512	$2.080/hour	 $3.552/hour
38e5c695-c568-4dbf-bd2e-2979c1e3181c	E32-16as v4	16	256	512	$2.080/hour	 $3.552/hour
0c1eb673-17d3-4c19-ba16-f2314c86ade5	E64-16as v4	16	512	1024	$4.160/hour	 $7.104/hour
140fd852-6812-4aa0-9afd-bd5bee970dc8	E64-32as v4	32	512	1024	$4.160/hour	 $7.104/hour
ad71d8f6-0767-4d3d-ad10-945e7ad527fa	E96-24as v4	24	672	1344	$6.240/hour	 $10.656/hour
92fdaff5-3bec-46c8-bd00-d95c51d33616	E96-48as v4	48	672	1344	$6.240/hour	 $10.656/hour
840deec2-976c-43ac-8222-725526c62da5	E4-2as v5	2	32	0	$0.143/hour	 $0.327/hour
8d9a2fd3-36f7-47e8-aaf4-11340c1aa1ea	E8-2as v5	2	64	0	$0.286/hour	 $0.654/hour
1d32054b-3be9-4e77-bd1f-7530831f2701	E8-4as v5	4	64	0	$0.286/hour	 $0.654/hour
af66ad0f-b247-42fe-a870-33c543cb9d8d	E16-4as v5	4	128	0	$0.572/hour	 $1.308/hour
70727ec8-5f36-4c3d-9d04-c3d550df5c4f	E16-8as v5	8	128	0	$0.572/hour	 $1.308/hour
6fc93027-3c74-4db2-9ef5-a4a0a15ae3b8	E32-8as v5	8	256	0	$1.144/hour	$2.616/hour
a9d774be-b04e-421f-869c-d966ba5409d5	E32-16as v5	16	256	0	$1.144/hour	 $2.616/hour
ef4d1854-8728-4dec-ba93-b6b488e0b8f7	E64-16as v5	16	256	0	$2.288/hour	 $5.232/hour
c09711a0-e746-4c18-9148-7e6f7e122e3d	E64-32as v5	32	512	0	$2.288/hour	 $5.232/hour
d058949d-06ea-4f6d-8dfd-7de6e9c74299	E96-24as v5	24	672	0	$3.432/hour	 $7.848/hour
388d053b-8768-4bd7-98ec-83a925305519	E96-48as v5	48	672	0	$3.432/hour	 $7.848/hour
04c540fe-c13c-4397-bb06-b59b8e860c85	E4-2ds v4	2	32	150	$0.302/hour	 $0.486/hour
ca666c91-92dc-454e-a01e-cc85577c0d2d	E8-2ds v4	2	64	300	$0.604/hour	 $0.972/hour
113490bd-d9e4-4924-b449-62b895228ed1	E8-4ds v4	4	64	300	$0.604/hour	 $0.972/hour
b7b031df-ac21-4e8d-86fe-752a71c806a1	E16-4ds v4	4	128	600	$1.208/hour	 $1.944/hour
8c1a6b88-8ef1-429a-a6c7-220f681ff91b	E16-8ds v4	8	128	600	$1.208/hour	 $1.944/hour
224c778f-c976-46ca-a420-d65c13e367c6	E32-8ds v4	8	256	1200	$2.416/hour	 $3.888/hour
a9068481-140e-4cef-a149-8305cf835ea9	E32-16ds v4	16	256	1200	$2.416/hour	 $3.888/hour
a87b50be-5663-4a74-b9cf-72038e5e7434	E64-16ds v4	16	504	2400	$4.832/hour	 $7.776/hour
f10af01b-7103-4b1d-ae45-4a42fbcb18ad	E64-32ds v4	32	504	2400	$4.832/hour	 $7.776/hour
18ab564a-a467-4a2d-9a28-7b52156d75f3	E8-2ds v4	2	64	300	$0.604/hour	\N
733374ec-244e-4a56-9b52-9b1955a37078	E8-4ds v4	4	64	300	$0.604/hour	\N
c1f1877e-0876-4f54-8a9c-035e2149b9a0	E16-4ds v4	4	128	600	$1.208/hour	\N
2d5ef3fd-6b72-4f4f-b21d-0b89cabf7b88	E16-8ds v4	8	128	600	$1.208/hour	\N
4eee91b8-e23a-4b21-a946-08c6a1be7865	E32-8ds v4	8	256	1200	$2.416/hour	\N
7d239cd8-be50-48ae-b08e-662c1af063c0	E32-16ds v4	16	256	1200	$2.416/hour	\N
041a36cf-c48c-40c2-a125-777a18218a73	E64-16ds v4	16	504	2400	$4.832/hour	\N
3959f3a9-206a-4e73-bd86-6eb222fc3ae7	E64-32ds v4	32	504	2400	$4.832/hour	\N
3bc87af9-665f-453e-b246-2895ef7f3bff	E4-2ds v5	2	32	150	$0.302/hour	 $0.486/hour
496f55b1-dd12-448c-bf1b-7478ca3fa355	E8-2ds v5	2	64	300	$0.604/hour	 $0.972/hour
808acdd3-a224-420c-9bbf-1da2aa82808b	E8-4ds v5	4	64	300	$0.604/hour	 $0.972/hour
891c1fad-a066-4dbf-9ca5-48f6a7d92d28	E16-4ds v5	4	128	600	$1.208/hour	 $1.944/hour
5d17e8a3-1fd9-432b-a9fc-32d67b705b36	E16-8ds v5	8	128	600	$1.208/hour	 $1.944/hour
3058f155-96fa-4800-865d-5a97d143d54c	E32-8ds v5	8	256	1200	$2.416/hour	 $3.888/hour
432655de-3ab7-402e-b63c-16989a43a66a	E32-16ds v5	16	256	1200	$2.416/hour	 $3.888/hour
deaaa4ee-628b-4057-a6c5-e88862792107	E64-16ds v5	16	512	2400	4.832/hour	 $7.776/hour
d89ffaa1-6660-4eed-8d5a-454018284159	E64-32ds v5	32	512	2400	4.832/hour	 $7.776/hour
e67807c7-0e01-419c-9587-88e22867a06a	E96-24ds v5	24	672	2400	$7.248/hour	 $11.664/hour
bc32a73e-0bf0-4e91-a6d0-f371245649a2	E96-48ds v5	48	672	\N	$7.248/hour	 $11.664/hour
60152995-ed11-4a58-a249-22d65e48890b	E4-2s v3	2	32	64	$0.274/hour	 $0.458/hour
c9d652b8-c45a-4228-bc33-8ffa90ba5034	E8-2s v3	2	64	128	$0.548/hour	 $0.916/hour
30ddf3c2-e01d-4afd-aaa4-299d7cd9ca1a	E8-4s v3	4	64	128	$0.548/hour	 $0.916/hour
1aa4d815-1701-49e1-be8c-7a4b13d734a7	E16-4s v3	4	128	256	$1.096/hour	 $1.832/hour
3bc8d37b-86a4-4ef8-9604-09cfe87eabae	E16-8s v3	8	128	256	$1.096/hour	 $1.832/hour
4ac91f27-e099-41c8-ab0a-d0d254b96f68	E32-8s v3	8	256	512	$2.192/hour	 $3.664/hour
ece35b90-b34f-4918-847a-7c8e27ba6403	E32-16s v3	16	256	512	$2.192/hour	 $3.664/hour
63722748-6008-4235-b811-eacd634d8fc3	E64-16s v3	16	432	864	$3.937/hour	 $6.881/hour
b329a42d-656f-4277-80cd-81938d676368	E64-32s v3	32	432	864	$3.937/hour	 $6.881/hour
05d76688-465f-4350-865c-d3933a329970	E4-2s v4	2	32	0	$0.260/hour	 $0.444/hour
834c3aad-d96f-464e-8a5c-56ca9d0cd921	E8-2s v4	2	64	0	$0.520/hour	 $0.888/hour
7ef2e0b7-a9b7-488b-9d46-7b7fe2ae9a6c	E8-4s v4	4	64	0	$0.520/hour	 $0.888/hour
97c60486-9a3e-49a2-8745-e71e6fb99cef	E16-4s v4	4	128	0	$1.040/hour	 $1.776/hour
254e275f-9f6f-4450-8f24-69ec2770ccc0	E16-8s v4	8	128	0	$1.040/hour	 $1.776/hour
62cff035-b698-48ca-91a4-643ba7e89a06	E32-8s v4	8	256	0	$2.080/hour	 $3.552/hour
2c5cb3d5-1a37-4021-9f69-5e0d2414fa95	E32-16s v4	16	256	0	$2.080/hour	$3.552/hour
c5fa0e7b-b16a-4152-bfb6-4b2b60b89a2b	E64-16s v4	16	504	0	$4.160/hour	$7.104/hour
d76911b0-3a6b-411c-afd5-b289fed72176	E64-32s v4	32	504	0	$4.160/hour	 $7.104/hour
c37ae35d-b13e-432b-b908-0c493cbdf66a	E4-2s v5	2	32	0	$0.260/hour	 $0.444/hour
09e3a769-391f-40b1-8610-f096592a9b8c	E8-2s v5	2	64	0	$0.520/hour	 $0.888/hour
669678ce-e254-4316-bf5a-6d485af042f8	E8-4s v5	4	64	0	$0.520/hour	$0.888/hour
3469c5fa-656e-49e0-b3d9-7a0c4fa54cc7	E16-4s v5	4	128	0	$1.040/hour	 $1.776/hour
240630d7-3d75-4577-aba2-cd7608d81333	E16-8s v5	8	128	0	$1.040/hour	$1.776/hour
2e9b8497-1cdb-4bfd-ab19-49e813828a4a	E32-8s v5	8	256	0	$2.080/hour	 $3.552/hour
9ca66f03-ccd3-4db7-9885-bb1a646d0e5b	E32-16s v5	16	256	0	$2.080/hour	 $3.552/hour
a5840fa1-cf26-482e-b383-b3758eaa2c98	E64-16s v5	16	512	0	$4.160/hour	 $7.104/hour
b16c3427-8a24-42c9-9cf9-c2fc650c44fa	E64-32s v5	32	512	0	$4.160/hour	 $7.104/hour
6bcbee35-5db9-4ff2-b432-cd698547bb8b	E96-24s v5	24	672	3600	$6.240/hour	 $10.656/hour
bcc10032-7785-492d-9e58-a9d9518ba857	E96-48s v5	48	672	3600	$6.240/hour	 $10.656/hour
1f5edffa-37cb-4675-89dc-7bbb83302f2f	HB120-16rs v3	16	456	2100	$5.040/hour	 $10.560/hour
2f8f9106-6abd-4e7a-b233-a63d0e444682	HB120-32rs v3	32	456	2100	$5.040/hour	 $10.560/hour
9ce7f3b8-b7b0-40e7-a2b8-8a93375ce237	HB120-64rs v3	64	456	2100	$5.040/hour	 $10.560/hour
763d43f5-ff21-4772-8476-db35a04ef52c	HB120-96rs v3	96	456	2100	$5.040/hour	 $10.560/hour
ff1a043f-3436-4538-8c9a-0bc0b328fe50	HC44-16rs	16	352	700	$4.435/hour	 $6.459/hour
3e4d8ead-d09d-409a-add3-5e96ab41ee13	HC44-32rs	32	352	700	$4.435/hour	 $6.459/hour
0126b98c-a293-4825-9832-15c4ca1305dd	M8-2ms	2	218.75	256	$1.585/hour	 $1.953/hour
1c3f2bfb-1add-46c7-ad63-d0e610bf137c	M8-4ms	4	437.5	256	$3.170/hour	 $1.953/hour
a5742bde-1223-44c5-b9c4-63634688682c	M16-4ms	4	437.5	256	$3.170/hour	 $3.907/hour
4ab62e68-9aba-4934-966b-9326db803777	M16-8ms	8	437.5	256	$3.170/hour	 $3.907/hour
0f470db3-0d08-4a62-ac6d-59b1dde43a9c	M32-8ms	8	875	1024	$6.341/hour	 $7.813/hour
5c694a0a-3b8b-4848-8a89-383ef0555c41	M32-16ms	16	875	1024	$6.341/hour	 $7.813/hour
dc463e06-4849-431f-b686-6914035244f3	M64-16ms	16	1792	2048	$10.666/hour	 $13.610/hour
a2fd7da6-9ccd-4083-a9fc-ce90b4570079	M64-32ms	32	1792	2048	$10.666/hour	 $13.610/hour
c0e1dd31-8bbc-46dc-8a6b-8d1be8f55207	M128-32ms	32	3892	4096	$27.524/hour	 $33.424/hour
4d729080-273c-47e7-9bde-d42d708f6f2b	M128-64ms	64	3892	4096	$27.524/hour	 $33.424/hour
6fb160e1-067a-4fa5-898d-ff1648d89a28	D2a v4	2	8	50	$0.062/hour	 $0.164/hour
90cc2f83-9fb2-42aa-8feb-72f71553c213	D4a v4	4	16	100	$0.123/hour	 $0.327/hour
28ea390a-9d27-408e-9d1b-f60e691aa373	D8a v4	8	32	200	$0.246/hour	 $0.655/hour
7330ad74-9c32-4409-b9a0-f795cdcd0a78	D16a v4	16	64	400	$0.493/hour	 $1.311/hour
ab5b24c9-91d4-4b7d-9389-829f5327fb45	D32a v4	32	128	800	$0.987/hour	 $2.623/hour
d5f5a4b2-ad1d-4756-aece-7719aeeac89b	D48a v4	48	192	1200	 $1.481/hour	 $3.934/hour
397719cc-faf9-4fed-a8cc-919f4be3d5fb	D64a v4	64	256	1600	$1.975/hour	 $5.246/hour
c80363c4-61d0-42bd-a2b8-81fb667e9c7e	D96a v4	96	384	2400	$2.962/hour	 $7.868/hour
924198b9-ac5e-42e6-9f0f-29b5b39e27b0	D2ads v5	2	8	75	$0.067/hour	 $0.159/hour
fd76370f-f1c8-4cdb-8fb1-98adfd7c5a52	D4ads v5	4	16	150	$0.134/hour	 $0.318/hour
a23f1870-37ce-4ee4-bfdc-23e29f009f60	D8ads v5	8	32	300	$0.268/hour	 $0.636/hour
d1efa900-b384-44e5-ba2c-24021b108a82	D16ads v5	16	64	600	$0.537/hour	 $1.273/hour
9cd3dd81-269e-457c-bc2b-2e2d2405231b	D32ads v5	32	128	1200	$1.074/hour	 $2.546/hour
f1611eb9-ebfa-41fa-9d44-1629b49990ca	D48ads v5	48	192	1800	$1.610/hour	 $3.818/hour
02145528-c77d-4ccf-8c9d-887ecee4dbb4	D64ads v5	64	256	2400	$2.147/hour	 $5.091/hour
27a43c53-7edd-4f62-8b95-4443491cad1a	D96ads v5	96	384	3600	$3.221/hour	 $7.637/hour
e9c07b24-ed1a-41df-8310-2bc5cc29c3cf	D2as v4	2	8	16	$0.062/hour	 $0.164/hour
c69dfe03-840e-419b-af30-a88644ef6a57	D4as v4	4	16	32	$0.123/hour	 $0.327/hour
364d31de-e27d-40d7-b6ab-4c5ec9f34d4d	D8as v4	8	32	64	$0.246/hour	 $0.655/hour
d12ee54f-2520-49e9-b690-36f016750ad2	D16as v4	16	64	128	$0.493/hour	 $1.311/hour
5806638e-66de-4f0f-8824-625c2040f97c	D32as v4	32	128	256	$0.987/hour	 $2.623/hour
215765ba-07c8-430a-a0aa-5c3f6686a257	D48as v4	48	192	384	$1.481/hour	 $3.934/hour
86fa1a7f-b7db-4b39-9ebc-040716cb040a	D64as v4	64	256	512	$1.975/hour	 $5.246/hour
c5e32a3f-9f56-481b-8490-8cb513aea9d8	D96as v4	96	384	768	$2.962/hour	 $7.868/hour
655b6e83-024a-411e-988a-bf5a26248768	D2as v5	2	8	0	$0.056/hour	 $0.148/hour
7764caa2-c9f3-440b-925c-d810664a0b07	D4as v5	4	16	0	$0.111/hour	 $0.295/hour
1ef8ba94-c5f3-4793-af39-9cf6d8c068ce	D8as v5	8	32	0	$0.222/hour	 $0.590/hour
5fc2c9e1-45f1-432e-9280-024825905c0f	D16as v5	16	64	0	$0.444/hour	 $1.180/hour
dce15e3d-ae60-4714-a1bf-54219a43e467	D32as v5	32	128	0	$0.889/hour	 $2.361/hour
0242d20a-0ba0-47a6-9d8f-74bdc0882cb6	D48as v5	48	192	0	$1.333/hour	 $3.541/hour
cdd45104-b0bb-4ded-ac08-67d7906d80fb	D64as v5	64	256	0	$1.778/hour	 $4.722/hour
61bcbf76-4c1a-438c-a188-40b6b195c387	D96as v5	96	384	0	$2.666/hour	 $7.082/hour
e6ad23c9-6779-4c82-a5a8-9b8a86041c06	DC2ads v5	2	8	75	$0.067/hour	 $0.159/hour
538a4522-026e-4818-a580-99a43e42322a	DC4ads v5	4	16	150	$0.134/hour	 $0.318/hour
fba4b53f-e452-475a-ac9e-a1687cb38732	DC8ads v5	8	32	300	$0.268/hour	 $0.636/hour
00eb7f64-2776-45a3-b3b0-61ae77775bd1	DC16ads v5	16	64	600	$0.537/hour	 $1.273/hour
24cf8bed-9c54-482c-ae46-e4c39459d9f5	DC32ads v5	32	128	1200	$1.074/hour	 $2.546/hour
8a81514b-d921-4efd-b2fa-eaf8e09c6cf4	DC48ads v5	48	192	1800	$1.610/hour	 $3.818/hour
0e6d0cc7-85e1-4d25-8607-ab9f7e63974c	DC64ads v5	64	256	2400	$2.147/hour	 $5.091/hour
efa3f37e-6d1e-4c78-8f7f-a559d87f1335	DC96ads v5	96	384	3600	$3.221/hour	 $7.637/hour
34fd50ee-ffe3-48f6-85b9-98e1af49de3e	DC2as v5	2	8	0	$0.056/hour	 $0.148/hour
87dc69ae-85a3-416b-874a-dcd6e0fc2a95	DC4as v5	4	16	0	$0.111/hour	 $0.295/hour
2b10056e-d5e4-40c7-ad6b-2d0ec632dab6	DC8as v5	8	32	0	$0.222/hour	 $0.590/hour
1d66342c-f31f-4635-a5b3-2ca3fe2fddb0	DC16as v5	16	64	0	$0.444/hour	 $1.180/hour
11427ffa-c1af-41eb-9d5b-74f065e8c22f	DC32as v5	32	128	0	$0.889/hour	 $2.361/hour
c344c7a8-0846-4227-9c9a-eceac7c47353	DC48as v5	48	192	0	$1.333/hour	 $3.541/hour
86bdf971-8d05-48e8-84e9-c82a5e576fcf	DC64as v5	64	256	0	$1.778/hour	 $4.722/hour
bfdbe542-e473-4e30-b478-f9e279f5f969	DC96as v5	96	384	0	$2.666/hour	 $7.082/hour
9f6a6bd6-6f12-4e47-9d0f-ce71e89b1a2e	DC1ds v3	1	8	75	$0.120/hour	 $0.166/hour
57825a7f-709e-4db0-869a-c3cbd21334bc	DC2ds v3	2	16	150	$0.240/hour	 $0.332/hour
f1c8c248-6395-402a-b8ec-7337f06d3d13	DC4ds v3	4	32	300	$0.480/hour	 $0.664/hour
0a8dac03-39f7-450b-a689-6dd112a5b1ad	DC8ds v3	8	64	600	$0.960/hour	 $1.328/hour
adbe3013-ddec-4afd-b68e-2b6286f09f5c	DC16ds v3	16	128	1200	$1.920/hour	 $2.656/hour
006dd4b6-dc75-470c-bc32-5e1555d598cd	DC24ds v3	24	192	1800	$2.880/hour	 $3.984/hour
8c85a175-1c19-4a5a-bdb2-af8afecf3e00	DC32ds v3	32	256	2400	$3.840/hour	 $5.312/hour
7896a405-1b02-4a09-b69e-747e08f1a0dc	DC48ds v3	48	384	2400	$5.760/hour	 $7.968/hour
8fecce4b-ab72-401d-8230-3abcdd8c8ff2	DC1s v3	1	8	0	$0.101/hour	 $0.147/hour
9cb5e7a2-5a4d-4850-9587-d0ead8b2d307	DC2s v3	2	16	0	$0.202/hour	 $0.294/hour
d285ef2e-cdda-42c4-8801-836c2cf56206	DC4s v3	4	32	0	$0.404/hour	 $0.588/hour
efa52e03-d981-47e4-8d0d-d41f52959c7d	DC8s v3	8	64	0	$0.808/hour	 $1.176/hour
498cda33-0aa9-4ddd-94e2-92cde24da74a	DC16s v3	16	128	0	$1.616/hour	 $2.352/hour
3fd0fa73-c63f-4c77-ba43-d8d47ea21114	DC24s v3	24	192	0	$2.424/hour	 $3.528/hour
44ec1c99-dc93-494a-8547-c158ef1a0a82	DC32s v3	32	256	0	$3.232/hour	 $4.704/hour
9fa28272-26a3-4c99-9ff4-104a281a11b5	DC48s v3	48	384	0	$4.848/hour	 $7.056/hour
2d6193c6-71cc-485c-979b-0914e82d0ea4	D2d v4	2	8	75	$0.122/hour	 $0.214/hour
92e46a3c-cccd-47ba-b2f7-9bb826a3ce51	D4d v4	4	16	150	$0.244/hour	 $0.428/hour
9e1fcd1d-8978-4c35-80ad-96c9de73a0ae	D8d v4	8	32	300	$0.488/hour	 $0.856/hour
f194ecbf-3d39-4c18-9e43-ae8c36ea5134	D16d v4	16	64	600	$0.976/hour	 $1.712/hour
c2089ae9-458d-45fd-a16d-6951ca4f1416	D32d v4	32	128	1200	$1.952/hour	 $3.424/hour
b54b668c-2045-4c9f-808b-8e25f6483473	D48d v4	48	192	1800	$2.928/hour	 $5.136/hour
add40661-db25-46ce-8d66-152e42ddfe4a	D64d v4	64	256	2400	$3.904/hour	 $6.848/hour
e8dee9b4-bc21-4ad2-a2c5-3cde85d1ef6f	D2ds v4	2	8	75	$0.122/hour	 $0.214/hour
186e1223-8032-48ec-af75-5e3f5ba54861	D4ds v4	4	16	150	$0.244/hour	 $0.428/hour
88cf1668-0283-4dae-98fd-8398657a1906	D8ds v4	8	32	300	$0.488/hour	 $0.856/hour
1b637509-4992-4afc-8917-f9f55e588431	D16ds v4	16	64	600	$0.976/hour	 $1.712/hour
f4867281-4a5e-4236-9718-9f5400c8d96a	D32ds v4	32	128	1200	$1.952/hour	 $3.424/hour
f47db1c3-6883-4bc2-bacf-974ade812f98	D48ds v4	48	192	1800	$2.928/hour	 $5.136/hour
4622e95a-cc94-4a79-8e37-5251ce0ff384	D64ds v4	64	256	2400	$3.904/hour	 $6.848/hour
8af7faf6-beda-4d02-a850-1e8d498c0acd	D2ds v5	2	8	75	$0.122/hour	 $0.214/hour
aefa1ebe-977a-466c-9f7e-61f98169e316	D4ds v5	4	16	150	$0.244/hour	 $0.428/hour
c376fcff-0557-4233-83ed-6ff852f6cc2d	D8ds v5	8	32	300	$0.488/hour	 $0.856/hour
e270ff52-0000-4a53-b0db-f283ca46b923	D16ds v5	16	64	600	$0.976/hour	 $1.712/hour
4de3b971-7015-47a0-955d-d7529a7f116f	D32ds v5	32	128	1200	$1.952/hour	 $3.424/hour
3ac1f100-f53d-4337-a3bf-0fdc6049db24	D48ds v5	48	192	1800	$2.928/hour	 $5.136/hour
76270ee7-c9a4-4bf6-a830-78e8fb4cfdcc	D64ds v5	64	256	2400	$3.904/hour	 $6.848/hour
bf28dc1c-699d-4110-8037-8a9497c112b5	D96ds v5	96	384	3600	$5.856/hour	 $10.272/hour
35a7fd7f-f136-4e2d-80b2-f582f8ede37c	D2d v5	2	8	75	$0.122/hour	 $0.214/hour
b1cec8a9-09e6-4628-abfc-24e34674fe1e	D4d v5	4	16	150	$0.244/hour	 $0.428/hour
86aa87a5-6153-4ccf-8aba-ea5ae41e3a97	D8d v5	8	32	300	$0.488/hour	 $0.856/hour
54405f43-b594-4faa-8b21-ca1c0cfb488a	D16d v5	16	64	600	$0.976/hour	 $1.712/hour
9beab282-7178-4b7b-90d6-9ec1b0f92bc6	D32d v5	32	128	1200	$1.952/hour	 $3.424/hour
359866de-f257-40cc-8174-58b92f415da2	D48d v5	48	192	1800	$2.928/hour	 $5.136/hour
82fedba0-828a-410c-9467-7004bd00b8ab	D64d v5	64	256	2400	$3.904/hour	 $6.848/hour
bc3593fa-dbb1-401f-b077-32cfcea4c56b	D96d v5	96	384	3600	$5.856/hour	 $10.272/hour
b611af7f-d711-41f1-aaad-83d6978a788e	D2lds v5	2	4	75	$0.099/hour	 $0.191/hour
b9dfdfcb-a969-41e7-987b-3e1c2c1efc72	D4lds v5	4	8	150	$0.198/hour	 $0.382/hour
2b7eae03-b7f2-4536-a366-cb8c9b6cceb4	D8lds v5	8	16	300	$0.396/hour	 $0.764/hour
db216366-b8c1-4ada-b761-345a624ea36b	D16lds v5	16	32	600	$0.792/hour	 $1.528/hour
b5249dba-db87-44de-90cd-90dba99bedd7	D32lds v5	32	64	1200	$1.584/hour	 $3.056/hour
dfd8b167-f6cf-47e9-afc7-b1db051d7d63	D48lds v5	48	96	1800	$2.376/hour	 $4.584/hour
611320aa-bdfa-43bc-a11f-c7e79e4708e3	D64lds v5	64	128	2400	$3.168/hour	 $6.112/hour
8f80aeb8-3b74-4ee5-87e4-afdf44639aa0	D96lds v5	96	192	3600	$4.752/hour	 $9.168/hour
e2e2ba92-3a5d-40a7-adf1-ad964008b964	D2ls v5	2	4	0	$0.085/hour	 $0.177/hour
8cc5cdc3-4a5a-4708-ab28-c055f5e2f6b2	D4ls v5	4	8	0	$0.170/hour	 $0.354/hour
c7a2a527-04b7-42f7-8f0c-eb20bb46561b	D8ls v5	8	16	0	$0.340/hour	 $0.708/hour
ac6ae85b-fd03-4694-9a74-0d53b1569ca0	D16ls v5	16	32	0	$0.680/hour	 $1.416/hour
b1b7cca3-c0e2-41b3-a0ac-bafd53d31151	D32ls v5	32	64	0	$1.360/hour	 $2.832/hour
2cf0dc1b-ac31-4942-9253-f7791f5300ee	D48ls v5	48	96	0	$2.040/hour	 $4.248/hour
83bd08f9-8417-43b5-9d51-26f6f7596844	D64ls v5	64	128	0	$2.720/hour	 $5.664/hour
6347ccc5-5aa6-453f-a5dd-2b7dcd5fa55b	D96ls v5	96	192	0	$4.080/hour	 $8.496/hour
12a4b2de-4fdf-41c7-a133-93efee53d58d	D2pds v5	2	8	75	$0.060/hour	\N
7e542349-f142-4506-b04a-127c3c10ca81	D4pds v5	4	16	150	$0.121/hour	\N
ecb22265-255b-4a81-9e59-666788e0f98d	D8pds v5	8	32	300	$0.242/hour	\N
9658e778-2dce-4ccb-b3e7-f8e9555c4438	D16pds v5	16	64	600	$0.483/hour	\N
40078130-d7bb-49e3-973d-b1d6b41cb13b	D32pds v5	32	128	1200	$0.966/hour	\N
078c8a9c-6bc8-44ff-9a2c-893677803408	D48pds v5	48	192	1800	$1.450/hour	\N
d15d5e3e-317e-4eeb-98a4-3956ad2b4aea	D64pds v5	64	208	2400	$1.933/hour	\N
fc710aba-0013-4c15-9617-6d5f308ca488	D2pds v6	2	8	110	$0.060/hour	\N
23edd89f-d277-4b9f-a6ea-1b726cadc426	D4pds v6	4	16	220	$0.121/hour	\N
f727eec5-835a-4867-96d1-95f2054905b5	D8pds v6	8	32	440	$0.242/hour	\N
e3751934-618a-465f-a1cc-94a649c1da51	D16pds v6	16	64	880	$0.483/hour	\N
33f6c96a-3e1c-4755-a4b2-b49201efc093	D32pds v6	32	128	1760	$0.966/hour	\N
a93a3654-a4d6-4f3a-af42-6160a1015d73	D48pds v6	48	192	2640	$1.450/hour	\N
f2abdc28-0860-46c4-8b0c-7c07ff65183e	D64pds v6	64	256	3520	$1.933/hour	\N
70be6ea7-ff1a-4982-979a-e8139aa7bc8d	D96pds v6	96	384	5280	$2.899/hour	\N
127ad874-7e4b-46a5-a2ae-58a17902848e	D2plds v5	2	4	75	$0.049/hour	\N
978efc1d-b852-45f3-831f-1c1e262d827a	D4plds v5	4	8	150	$0.098/hour	\N
9600c392-882c-4beb-8486-cea77b2039fd	D8plds v5	8	16	300	$0.196/hour	\N
7eb43fd3-547a-485f-b50e-8c1a1627d276	D16plds v5	16	32	600	$0.392/hour	\N
fcb6eb36-d66e-4245-af0d-3e5281a39c62	D32plds v5	32	64	1200	$0.784/hour	\N
c6007ec8-5814-4b75-b5e8-e28f2e108e4b	D48plds v5	48	96	1800	$1.176/hour	\N
a452356a-9c40-489f-8827-ff334699837c	D64plds v5	64	128	2400	$1.568/hour	\N
9a473f5a-a39c-4405-b207-1b99eb615f0d	D2plds v6	2	4	110	$0.051/hour	\N
f09f95ea-b4e2-4956-9c89-6ea7b05dc66c	D4plds v6	4	8	220	$0.103/hour	\N
a8f07e72-db51-47a1-94e2-59e7225f881f	D8plds v6	8	16	440	$0.206/hour	\N
8ace8377-7a3a-4628-be56-dd9a7b9b7d8f	D16plds v6	16	32	880	$0.411/hour	\N
4a1d2589-e4b3-4903-98ec-f745b7ceaa66	D32plds v6	32	64	1760	$0.822/hour	\N
ad69f98b-a138-4991-8a6f-ec0af138298a	D48plds v6	48	96	2640	$1.234/hour	\N
e241afe5-23c1-49ba-b85c-527df407d9ae	D64plds v6	64	128	3520	$1.645/hour	\N
30f354c1-fa5f-4065-9128-770362277e83	D96plds v6	96	192	5280	$2.467/hour	\N
e8a2eb15-b6e6-4c8e-9afb-ae4c6c18884a	D2pls v5	2	4	0	$0.043/hour	\N
ebae1db2-4e1a-4284-8bd9-a7bfa82ec3fb	D4pls v5	4	8	0	$0.085/hour	\N
1c1c0c75-ed92-4e17-9d7a-47aeaebb2c09	D8pls v5	8	16	0	$0.170/hour	\N
5a7d208e-415a-4217-8bcc-90ed50058585	D16pls v5	16	32	0	$0.341/hour	\N
4511be30-a04e-4c1f-a42e-fbf3feffa630	D32pls v5	32	64	0	$0.682/hour	\N
42ce378d-a6e4-48c3-80b9-6061b7f53776	D48pls v5	48	96	0	$1.022/hour	\N
b961da35-86bd-4ec4-bd3b-d2bfb564282f	D64pls v5	64	128	0	$1.363/hour	\N
0c3c119e-b451-442d-8e06-f0c4031c1f0f	D2pls v6	2	4	0	$0.041/hour	\N
b7d91c54-10b5-46ca-8d99-7f12883528d8	D4pls v6	4	8	0	$0.082/hour	\N
865109e7-dd83-459b-a05b-2aa9c25686c4	D8pls v6	8	16	0	$0.163/hour	\N
2caaa9ad-11e4-44cb-a7bd-70917a3647f4	D16pls v6	16	32	0	$0.326/hour	\N
cf1bea23-555c-4e0a-9a6c-577053d0079a	D32pls v6	32	64	0	$0.653/hour	\N
513b8ba7-8c0f-495c-890f-d40fc5fa5bed	D48pls v6	48	96	0	$0.979/hour	\N
67530257-6976-4eed-bfc1-62852d574726	D64pls v6	64	128	0	$1.306/hour	\N
f52b89ae-b36f-4858-982f-5eec00078041	D96pls v6	96	192	0	$1.958/hour	\N
8457a9ac-1037-4c45-8204-e099ca647860	D2ps v5	2	8	0	$0.051/hour	\N
10c8f10e-3f03-4db4-97f4-44fd07e258bd	D4ps v5	4	16	0	$0.101/hour	\N
ee60fd8d-07a4-4aac-800c-3e0e6438b762	D8ps v5	8	32	0	$0.202/hour	\N
c36ef614-55e9-4bc8-9bb1-b16d3794cb67	D16ps v5	16	64	0	$0.405/hour	\N
9c48e996-1ca3-4235-a8cf-826c0dcd28d4	D32ps v5	32	128	0	$0.810/hour	\N
8f6cd825-e787-4d51-a421-1644f4cf26ce	D48ps v5	48	192	0	$1.214/hour	\N
51e9fc52-551e-49cc-94a8-df71554730df	D64ps v5	64	208	0	$1.619/hour	\N
fdc3ca55-dbab-41d8-9310-1ff841f8edce	D2ps v6	2	8	0	$0.046/hour	\N
33838ecd-ca70-4653-b235-a02c3d8d8562	D4ps v6	4	16	0	$0.092/hour	\N
4b3ecb68-7904-4fde-a5ac-0532028132cd	D8ps v6	8	32	0	$0.185/hour	\N
6154a9ac-03fd-48e9-9972-bf46ec69dfe3	D16ps v6	16	64	0	$0.370/hour	\N
3cd5d361-09a1-483b-864b-86e407324c58	D32ps v6	32	128	0	$0.739/hour	\N
7f639d53-fa64-41d8-916a-9ee5894b2f8b	D48ps v6	48	192	0	$1.109/hour	\N
30c088d2-9df1-463e-86c3-6ba3d9327a3e	D64ps v6	64	256	0	$1.478/hour	\N
ebe635a3-55e7-4721-b1cc-f4dc27f4fb2f	D96ps v6	96	384	0	$2.218/hour	\N
5bbd8cb3-e03f-4f2f-b1e7-fc85d86f4a8e	D1	1	3.5	50	$0.071/hour	 $0.116/hour
92e8fb6b-e18f-430f-979e-caf5da86ecc3	D2	2	7	100	$0.141/hour	 $0.233/hour
f0258b83-228c-40a5-a800-86228caaf708	D3	4	14	200	$0.282/hour	 $0.466/hour
4c72a982-e47f-4b2f-b78b-e66e990f2ca6	D4	8	28	400	$0.564/hour	 $0.932/hour
6b68db89-d19c-4463-be3c-2443b9572ac2	D11	2	14	100	$0.182/hour	 $0.274/hour
108ce1a7-4dc0-4c06-a22a-73b5b0a8e003	D12	4	28	200	$0.365/hour	 $0.549/hour
fb1acde3-a2c8-49aa-b763-cbe8f5756287	D13	8	56	400	$0.730/hour	 $1.098/hour
e73dd5f1-8b8b-44bf-a9e7-aa4a6e9e9a34	D14	16	128	800	$1.460/hour	 $2.196/hour
944acaf5-d14e-4fd3-9b3d-d1ba4ef50789	D1s	1	3.5	7	$0.071/hour	 $0.116/hour
409a0d98-8d73-4131-8a15-5e3abb296771	D2s	2	7	14	$0.141/hour	 $0.233/hour
071148fa-b749-4cf3-9c93-eb4a1ec8ad44	D3s	4	14	28	$0.282/hour	 $0.466/hour
1980fb57-df7e-42c2-8d96-f3bb7cb8381f	D4s	8	28	56	$0.564/hour	 $0.932/hour
6cee0661-222a-48bd-9566-4673dded2b1f	D11s	2	14	28	$0.182/hour	 $0.274/hour
78ff5a89-0bc5-4993-9883-6009470c335f	D12s	4	28	56	$0.365/hour	 $0.549/hour
e893c659-977f-4f9c-b0b7-fc36ecc919dd	D13s	8	56	112	$0.730/hour	 $1.098/hour
8a46e342-132a-4a9d-97c5-043a4ac9bdcb	D14s	16	128	224	$1.460/hour	 $2.196/hour
08a43ae9-8c7f-4e2f-8ad5-346847a41ed5	DS1 v2	1	3.5	7	$0.084/hour	 $0.130/hour
58bb259e-b300-4656-a595-4d6fca446e43	DS2 v2	2	7	14	$0.169/hour	 $0.261/hour
8ecb9589-91ac-43e2-b520-eb2705c8741e	DS3 v2	4	14	28	$0.337/hour	 $0.521/hour
dddce98f-f025-4c90-8e16-edf0a4db9dc2	DS4 v2	8	28	56	$0.675/hour	 $1.043/hour
55dbdfc4-183f-44bb-be04-85bce442b476	DS5 v2	16	56	112	$1.350/hour	 $2.086/hour
21d83516-c02e-4e5b-94d1-efa0f676b991	DS11-1 v2	1	14	28	$0.189/hour	 $0.282/hour
15b3e51d-68cc-4092-b780-1f7902ae7e98	DS11 v2	2	14	28	$0.189/hour	 $0.282/hour
c361a42e-2896-4ef0-8ab4-56c17f86d8dd	DS12-1 v2	1	28	56	$0.379/hour	 $0.563/hour
50093800-f825-4583-b9c9-0aa5ddcdd746	DS12-2 v2	2	28	56	$0.379/hour	 $0.563/hour
f6f3694c-c8b1-4138-912a-aa714b5e630a	DS12 v2	4	28	56	$0.379/hour	 $0.563/hour
5f3c859f-61af-4498-acc9-bc9f41515b26	DS13-2 v2	2	56	112	$0.758/hour	 $1.126/hour
0950f072-d3ab-4308-b592-fb573a028ad8	DS13-4 v2	4	56	112	$0.758/hour	 $1.126/hour
93e1bc22-5552-4044-b972-04a99758c86f	DS13 v2	8	56	112	$0.758/hour	 $1.126/hour
aebb3f6c-4ff1-44a3-b3cc-8c9d0cd132de	DS14-4 v2	4	112	224	$1.516/hour	 $2.252/hour
1ac70e2e-e66d-4a25-a65f-f15fe5024ca6	DS14-8 v2	8	112	224	$1.516/hour	 $2.252/hour
17e0e2be-0e65-441c-853a-04b168192c6e	DS14 v2	16	112	224	$1.516/hour	 $2.252/hour
68d6584b-04f2-4dd6-81b3-5cc485c57abd	DS15 v2	20	140	280	$1.895/hour	 $2.815/hour
405b111f-a302-4462-aa8c-a3ca9b7c8dbf	DS15i v2	20	140	280	$1.895/hour	 $2.815/hour
34dfadff-cd6d-456d-88c7-36902dacd49a	D2s v3	2	8	16	$0.105/hour	 $0.197/hour
8ce608b0-7ae5-4f29-80e7-f7d46f7733e4	D4s v3	4	16	32	$0.210/hour	 $0.394/hour
1389f8da-f006-40cb-9c52-e8365d9d6acb	D8s v3	8	32	64	$0.420/hour	 $0.788/hour
9a37a189-249b-4c7f-bba9-1106919af314	D16s v3	16	64	128	$0.840/hour	 $1.576/hour
fa5c7ed3-9245-463d-a1f1-5147f31193dc	D32s v3	32	128	256	$1.680/hour	 $3.152/hour
de1b7551-cecb-4207-a529-43340de5a5ba	D48s v3	48	192	384	$2.520/hour	 $4.728/hour
e21c4279-eefc-4cb4-8dac-b9ec8ac2cd24	D64s v3	64	256	512	$3.360/hour	 $6.304/hour
77e60af5-a74b-415c-b351-242c1a779151	D2s v4	2	8	0	$0.101/hour	 $0.193/hour
16e8b45c-4ddd-4109-8466-f2e5c89285f1	D4s v4	4	16	0	$0.202/hour	 $0.386/hour
f0ea615b-f4bc-40d4-a73c-ccc4a0b3aeea	D8s v4	8	32	0	$0.404/hour	 $0.772/hour
db3428c4-853b-4aea-99c5-d5f87946763d	D16s v4	16	64	0	$0.808/hour	 $1.544/hour
6c527b4c-beab-4edc-a187-14bad44ff7d7	D32s v4	32	128	0	$1.616/hour	 $3.088/hour
541a81d7-4014-4931-b720-0c0463350f3d	D48s v4	48	192	0	$2.424/hour	 $4.632/hour
4eb7e522-5513-45fe-bb7a-4b42783b2871	D64s v4	64	256	0	$3.232/hour	 $6.176/hour
5f441ac2-e4f5-4208-8e7a-6f7bbff0381d	D2s v5	2	8	0	$0.101/hour	 $0.193/hour
92a79cbb-cf7a-4012-9619-fc73f99bb4df	D4s v5	4	16	0	$0.202/hour	 $0.386/hour
d815d878-6b75-41d6-8859-724953d52feb	D8s v5	8	32	0	$0.404/hour	 $0.772/hour
bc2fa6aa-fe69-4fc3-9c3f-3c5b717a552b	D16s v5	16	64	0	$0.808/hour	 $1.544/hour
b473aa34-bb99-491b-a527-9a33863b9357	D32s v5	32	128	0	$1.616/hour	 $3.088/hour
45cbcbc8-9f28-43c2-81e6-6c181912c358	D48s v5	48	192	0	$2.424/hour	 $4.632/hour
cf04be53-3384-4c2e-a2d6-3a6efb2c4a1c	D64s v5	64	256	0	$3.232/hour	 $6.176/hour
07c019c0-ef47-4b80-b35d-c412212a6d5b	D96s v5	96	384	0	$4.848/hour	 $9.264/hour
fa886c92-4367-4615-af14-a736567b4393	D1 v2	1	3.5	50	$0.084/hour	 $0.130/hour
7d885177-0b48-42c8-ac52-e5c11b20c735	D2 v2	2	7	100	$0.169/hour	 $0.261/hour
8b64212f-3d96-426c-9fcd-1235930fb925	D3 v2	4	14	200	$0.337/hour	 $0.521/hour
2d0e5d5c-d60a-4a41-8d39-f7ef9f6f0ba5	D4 v2	8	28	400	$0.675/hour	 $1.043/hour
3837fd76-faab-4ef1-ae4e-20e284d0b9dc	D5 v2	16	56	800	$1.350/hour	 $2.086/hour
fa63e814-7da4-40d5-8aab-5ab5bfbcd63d	D11 v2	2	14	100	$0.189/hour	 $0.282/hour
5c8046b4-b684-4f28-ab7d-7e8a2fdfd807	D12 v2	4	28	200	$0.379/hour	 $0.563/hour
6c799241-e97f-4c12-b2f5-5b88d1869614	D13 v2	8	56	400	$0.758/hour	 $1.126/hour
a7427799-9c27-48bb-ab3f-4aa320b05010	D14 v2	16	112	800	$1.516/hour	 $2.252/hour
fe039bf1-1f91-4200-95d7-5f324f35a506	D15 v2	20	140	1000	$1.895/hour	 $2.815/hour
8ab1d3ef-1334-4d2e-81df-4f7893504a50	D15i v2	20	140	1000	$1.895/hour	 $2.815/hour
8a8f18bd-8a81-45e1-8a36-59cc87d1d4a2	D2 v3	2	8	50	$0.105/hour	 $0.197/hour
a8c24aeb-b080-407e-bc44-dc1029699dd0	D4 v3	4	16	100	$0.210/hour	 $0.394/hour
202c61ae-b55a-465f-8bcf-76f942319ec4	D8 v3	8	32	200	$0.420/hour	 $0.788/hour
c1cf31f8-f971-48c8-80ad-c0065dbb44ba	D16 v3	16	64	400	$0.840/hour	 $1.576/hour
151134c9-5ecb-4b5f-851e-faadbcfc9f96	D32 v3	32	128	800	$1.680/hour	 $3.152/hour
457e4d6a-6f0c-4b35-8e6e-b77c67389ff6	D48 v3	48	192	1200	$2.520/hour	 $4.728/hour
87fd8ce0-3be7-4560-bb6d-b3b1c1d6c40c	D64 v3	64	256	1600	$3.360/hour	 $6.304/hour
d18052fa-d34a-4263-880e-d7ebf4b7d97a	D2 v4	2	8	0	$0.101/hour	 $0.193/hour
9b38deeb-1b32-4059-8c9e-863134fc0897	D4 v4	4	16	0	$0.202/hour	 $0.386/hour
4f877f8e-4292-4ac0-aff3-4361ad7a18ea	D8 v4	8	32	0	$0.404/hour	 $0.772/hour
505e6b33-30b1-41d6-af2d-bfa44b3c2e89	D16 v4	16	64	0	$0.808/hour	 $1.544/hour
b3a02c7e-19ca-4309-bbba-aece5163e311	D32 v4	32	128	0	$1.616/hour	 $3.088/hour
6607bbb8-8b4e-4d44-80a2-404509f9a147	D48 v4	48	192	0	$2.424/hour	 $4.632/hour
71b74ec2-bf3e-4a13-bef8-83ba37d698ba	D64 v4	64	256	0	$3.232/hour	 $6.176/hour
68436371-1e3c-4fcb-be2f-2f047e548cbd	D2 v5	2	8	0	$0.101/hour	 $0.193/hour
660084be-c076-42f6-ad5f-ceeb7e4ba83a	D4 v5	4	16	0	$0.202/hour	 $0.386/hour
b52d9786-431d-449b-a111-f1f6b32e2c3d	D8 v5	8	32	0	$0.404/hour	 $0.772/hour
6e96ead7-c67c-4e67-85b6-55bfbec4eeec	D16 v5	16	64	0	$0.808/hour	 $1.544/hour
69eae78a-4d32-4f8c-bdb2-dedccfa9ea6f	D32 v5	32	128	0	$1.616/hour	 $3.088/hour
9e0ed719-ccce-4802-b410-d0712dfb0743	D48 v5	48	192	0	$2.424/hour	 $4.632/hour
fdd907be-66c0-4b9a-a73e-23250ba9b030	D64 v5	64	256	0	$3.232/hour	 $6.176/hour
0b17f08a-8c9e-467d-a964-b275927002e7	D96 v5	96	384	0	$4.848/hour	 $9.264/hour
5ed83036-67da-4565-a865-10716f540854	E2a v4	2	16	50	$0.080/hour	 $0.182/hour
d6157d67-c725-45b9-9ee0-e6d6e5c0b2e1	E4a v4	4	32	100	$0.158/hour	 $0.363/hour
31a57cf2-26f8-49d6-b280-363356397872	E8a v4	8	64	200	$0.317/hour	 $0.726/hour
9076bf21-7f6b-4d80-8395-a0488071ad9d	E16a v4	16	128	400	$0.635/hour	 $1.453/hour
334175f3-4925-4b49-9b0f-6411c48bcb2b	E20a v4	20	160	500	$0.794/hour	 $1.816/hour
322d5e9b-151e-4ba5-a3dd-ec1d329b1070	E32a v4	32	256	800	$1.271/hour	 $2.906/hour
e7966464-3aa5-4c21-8217-8262c6d570d3	E48a v4	48	384	1200	$1.906/hour	 $4.360/hour
11b40eab-ea4c-4d91-9436-bae12fec5906	E64a v4	64	512	1600	$2.542/hour	 $5.813/hour
ec76d0e1-7948-4fc7-b942-f5ce172758d4	E96a v4	96	672	2400	$3.813/hour	 $8.720/hour
f0349c2d-18f8-47ec-bf9e-d136cd35a770	E2ads v5	2	16	75	$0.083/hour	 $0.175/hour
13de5770-ba0e-4bcc-b3cb-7336ba0a1f3f	E4-2ads v5	2	32	150	$0.166/hour	 $0.350/hour
828a8943-ca65-4eb8-8252-205fd8efdb22	E4ads v5	4	32	150	$0.166/hour	 $0.350/hour
c8171bec-446c-4ffe-91b9-4adf6e393802	E8-2ads v5	2	64	300	$0.332/hour	 $0.700/hour
8d36e558-a4ba-4d29-8561-0b61ebd3f03c	E8-4ads v5	4	64	300	$0.332/hour	 $0.700/hour
8ec44c03-af14-486c-b44f-aa9dfa40aca7	E8ads v5	8	64	300	$0.332/hour	 $0.700/hour
39c30543-7e41-4898-b796-9b4216ed7e7b	E16-4ads v5	4	128	600	$0.664/hour	 $1.400/hour
f5b2cd13-dc86-46b6-b7b2-32b6838845a3	E16-8ads v5	8	128	600	$0.664/hour	 $1.400/hour
2d4de831-69f3-4871-a44b-5bfab9ee4a7d	E16ads v5	16	128	600	$0.664/hour	 $1.400/hour
15cbb388-e4d0-4d1e-8dfa-e6f4ef9f0af1	E20ads v5	20	160	750	$0.664/hour	 $1.750/hour
3b5b9003-3372-4730-acea-da6808a8a50d	E32-8ads v5	8	256	1200	$1.329/hour	 $2.801/hour
f9bc78bf-26ac-4767-bc57-1b420b06c1b4	E32-16ads v5	16	256	1200	$1.329/hour	 $2.801/hour
06086466-bae2-4d37-a46e-696daa1f6fc5	E32ads v5	32	256	1200	$1.329/hour	 $2.801/hour
3a88efcc-6443-4cb7-a3d6-9a41fee40857	E48ads v5	48	384	1800	$1.993/hour	 $4.201/hour
7f13c630-c2f9-47b8-9764-a307e7d4f87b	E64-16ads v5	16	512	2400	$2.658/hour	 $5.602/hour
3cd1072e-9ece-4458-9f3e-cd1706bced38	E64-32ads v5	32	512	2400	$2.658/hour	 $5.602/hour
70691bf6-2e23-414f-9bb0-81db5f41de70	E64ads v5	64	512	2400	$2.658/hour	 $5.602/hour
32776233-3514-4c09-a950-d7a3d07bbad1	E96-24ads v5	24	672	3600	$3.986/hour	 $8.402/hour
cf40b550-ff10-4999-96ea-240194de6f66	E96-48ads v5	48	672	3600	$3.986/hour	 $8.402/hour
84a5d9d8-ed1b-42d9-81b6-8fdafbb84c75	E96ads v5	96	672	3600	$3.986/hour	 $8.402/hour
7c8b39e3-9504-4a5e-98dc-1ffce0fc2c06	E2as v4	2	16	32	$0.080/hour	 $0.182/hour
c72ee626-7eb2-4544-a3ee-68652c76614c	E4-2as v4	2	32	64	$0.260/hour	 $0.444/hour
da9222b0-a9ab-47d8-a821-a0d602c69912	E4as v4	4	32	64	$0.158/hour	 $0.363/hour
1dcfc44d-4167-48f7-baba-32b79903e670	E8-2as v4	2	64	128	 $0.520/hour	 $0.888/hour
42436a40-048c-4d35-91ad-ae8efc6ff22e	E8-4as v4	4	64	128	 $0.520/hour	 $0.888/hour
25166c02-a9f1-46a8-a67c-fb92ae50b9ac	E8as v4	8	128	128	 $0.317/hour	 $0.726/hour
f987917c-c174-48d4-b897-b800610ba0c9	E16-4as v4	4	128	256	 $1.040/hour	 $1.776/hour
7cd589fa-aafa-4b95-95af-091bc3833702	E16-8as v4	8	128	256	 $1.040/hour	 $1.776/hour
e9074c61-b4ee-40c2-b85d-34173dd67df3	E16as v4	16	128	256	 $0.635/hour	 $1.453/hour
70fd0475-554c-413f-b80d-d267f2163d58	E20as v4	20	160	320	\N	 $1.816/hour
5d74fa23-155f-4f0e-933b-0b63265980b7	E32-8as v4	8	256	512	 $2.080/hour	 $3.552/hour
ffa76b2d-14af-45f5-a897-1027457d6ccc	E32-16as v4	16	256	512	 $2.080/hour	 $3.552/hour
281252aa-24ca-4f08-9d9e-338e29c1c667	E32as v4	32	256	512	 $1.271/hour	 $2.906/hour
c5b06b58-d65d-4143-954a-b01910e5b439	E48as v4	48	384	768	\N	$4.360/hour
2c8cf54b-8ae2-40e7-b586-5b76aac41415	E64-16as v4	16	512	1024	 $4.160/hour	 $7.104/hour
1708b9f9-d7a3-4f23-9faa-a3d3d24808b0	E64-32as v4	32	512	1024	 $4.160/hour	 $7.104/hour
d0db2c02-ec40-46a3-bbce-9269bb70ef8d	E64as v4	16	512	1024	 $2.542/hour	 $5.813/hour
ca3fbe62-af7b-425c-b6f6-a2ea711aef4d	E96-24as v4	32	672	1344	 $6.240/hour	 $10.656/hour
ecfcd2c6-e90d-473f-b711-1823308704c8	E96-48as v4	48	672	1344	 $6.240/hour	 $10.656/hour
8b771c4d-9d9a-4b79-b68a-a0a83404036f	E96as v4	96	672	1344	 $3.813/hour	 $8.720/hour
cd90329a-28ab-4077-a3c9-eed387cd6e48	E2as v5	2	16	0	 $0.072/hour	 $0.164/hour
4a200f70-42a6-45f3-84ab-9227af081a60	E4-2as v5	2	32	0	 $0.143/hour	 $0.327/hour
43eacd94-2bf7-4bea-9a7f-564619f5e4e7	E4as v5	4	32	0	 $0.143/hour	 $0.327/hour
8e541225-66c5-40fe-b806-29870fc3f994	E8-2as v5	2	64	0	 $0.286/hour	 $0.654/hour
e3423d5b-4986-48b1-a419-bd0244b1f431	E8-4as v5 	4	64	0	 $0.286/hour	 $0.654/hour
742c453e-ea99-4fb9-b2dc-2ed4b4abcd30	E8as v5	8	64	0	 $0.286/hour	 $0.654/hour
e715aef6-4b6a-4682-b7ba-92a17c6edc51	E16-4as v5	4	128	0	 $0.572/hour	 $1.308/hour
6f82f1c2-35f1-4b9b-829a-c730647bba8c	E16-8as v5	8	128	0	 $0.572/hour  	 $1.308/hour
467f965e-989d-48a2-97f2-1fc9a2074cdc	E16as v5	16	128	0	 $0.572/hour	 $1.308/hour
f506265a-984c-4b3e-b190-1bb807c87bf6	E20as v5	20	160	0	 $0.715/hour	 $1.635/hour
da81524b-54fb-49a7-8b39-30d0d16c6985	E32-8as v5	8	256	0	 $1.144/hour	 $2.616/hour
5a1a3e55-85e2-4339-a32c-e7e3b568a3fe	E32-16as v5	16	256	0	 $1.144/hour	 $2.616/hour
f20ce8bb-70df-4ab8-9716-11a02be3c64d	E32as v5	32	256	0	 $1.144/hour	 $2.616/hour
eb494b34-c8c2-4798-b079-9f440e30c018	E48as v5	48	384	0	 $1.716/hour	 $3.924/hour
3bacd450-04bb-4044-b939-fa9b16e1b0d0	E64-16as v5	16	512	0	 $2.288/hour	$5.232/hour
5d9934c4-f1a3-4973-a710-c9c75032cec6	E64-32as v5	32	512	0	 $2.288/hour	 $5.232/hour
55346b16-1a03-446f-9bc1-312aafe61444	E64as v5	64	512	0	 $2.288/hour	 $5.232/hour
e046eb0a-a2f9-4e12-bd78-1e31fcb411ef	E96-24as v5	24	672	0	 $3.432/hour	 $7.848/hour
5960917c-92e4-4ff4-a45b-f7c8f0b78d35	E96-48as v5	48	672	0	 $3.432/hour	 $7.848/hour
d98e6379-8234-42fe-a45e-6fe968ede436	E96as v5	96	672	0	 $3.432/hour	 $7.848/hour
edb86eba-d19c-4f88-b844-f4679e305055	E2bds v5	2	16	75	 $0.176/hour	 $0.268/hour
d9621293-190c-4a9c-b28b-86c11b70e638	E4bds v5	4	32	150	 $0.352/hour	 $0.536/hour
c89494c2-91ad-4818-ae8a-161eb0eb0101	E8bds v5	8	64	300	 $0.704/hour	 $1.072/hour
8851551a-d6cd-406d-897a-baf881ee7f03	E16bds v5	16	128	600	 $1.408/hour	 $2.144/hour
200ad076-bbb1-4d12-917d-791609306fa7	E32bds v5	32	256	1200	 $2.816/hour	 $4.288/hour
2ed59d03-0505-454f-89b3-d406444c529c	E48bds v5	48	384	1800	 $4.224/hour	 $6.432/hour
30ccb434-de9f-493f-a15b-4bea95e954b4	E64bds v5	64	512	2400	 $5.632/hour	 $8.576/hour
d4282225-8c2f-4e25-87bb-cc26c6dea16e	E96bds v5	96	672	3600	 $8.448/hour	 $12.864/hour
35081f97-11cb-4f7c-b96b-32e2150d8add	E112ibds v5	112	672	3800	 $10.842/hour	 $15.994/hour
014a8276-cd4a-49ec-8631-2c98e70601a3	E2bs v5	2	16	0	 $0.155/hour	 $0.247/hour
dddb94fa-8884-4450-be3c-cd8a53f84fb8	E4bs v5	4	32	0	 $0.310/hour	 $0.494/hour
a3456886-7cb9-4003-a92a-fdaed7ce0f48	E8bs v5	8	64	0	 $0.620/hour	 $0.988/hour
68cd9b67-db95-4bf6-bce2-90b71bc2c93b	E16bs v5	16	128	0	 $1.240/hour	 $1.976/hour
7c60dee3-9cff-45c3-90a9-01a7d1b152e6	E32bs v5	32	256	0	 $2.480/hour	 $3.952/hour
6e4c4543-9d0c-4c3b-8a45-1cc451aba5dc	E48bs v5	48	384	0	 $3.720/hour	 $5.928/hour
c59691c3-f016-43e8-a2e4-88486187f5b5	E64bs v5	64	512	0	 $4.960/hour	 $7.904/hour
2ef4585d-6266-442a-87d0-da164365aa73	E96bs v5	96	672	0	 $7.440/hour	 $11.856/hour
335984be-1ed9-4cde-a50a-14afbbe33ff3	E112ibs v5	112	672	0	 $9.548/hour	 $14.700/hour
7d68a2e6-fd20-4dc4-b5bf-e271acd96bcf	EC2ads v5	2	16	75	 $0.083/hour	 $0.175/hour
b77ec1fa-d69f-4cd9-bdef-698448eb8835	EC4ads v5	4	32	150	 $0.166/hour	 $0.350/hour
f8d4682e-a982-404e-bb6d-0e563425272d	EC8ads v5	8	64	300	 $0.332/hour	 $0.700/hour
ae9d223f-e087-4490-9069-b163c1001bac	EC16ads v5	16	128	600	 $0.664/hour	 $1.400/hour
870dfebd-b24d-441f-890e-e3f98e5bdc71	EC20ads v5	20	160	750	 $0.831/hour	 $1.751/hour
d0071048-e822-4358-95e4-e9c34326accc	EC32ads v5	32	192	1200	 $1.329/hour	 $2.801/hour
6842a9f4-e474-46fb-bd00-93d042478715	EC48ads v5	48	384	1800	 $1.993/hour	 $4.201/hour
dafce97a-c26d-4314-a097-4d24bbe03a9c	EC64ads v5	64	512	2400	 $2.658/hour	 $5.602/hour
8fe97987-0c5d-4854-8884-b0d4169265bf	EC96ads v5	96	672	2400	 $3.986/hour	 $8.402/hour
e9f83d90-4db9-4e5f-b868-294641079483	EC96iads v5	96	672	2400	 $4.385/hour	 $8.801/hour
a3658c5f-ba9c-4133-bb54-e9aea4dd9672	EC2as v5	2	16	0	 $0.072/hour	 $0.164/hour
6547b7ac-12d1-4987-a4f7-f7190b506b55	EC4as v5	4	32	0	 $0.143/hour	 $0.327/hour
cc286bc4-f584-4b06-b2b7-532d2f5629f5	EC8as v5	8	64	0	 $0.286/hour	 $0.654/hour
9c576bd2-0118-4ccf-9a84-a7234e473025	EC16as v5	16	128	0	 $0.572/hour	 $1.308/hour
7342b3bb-4504-4131-a016-d0ab3b504fde	EC20as v5	20	160	0	 $0.715/hour	 $1.635/hour
5db7eb2c-334a-4177-bc88-e5d454601774	EC32as v5	32	192	0	 $1.144/hour	 $2.616/hour
f59f04c4-6474-439a-9051-d3596f237319	EC48as v5	48	384	0	 $1.716/hour	 $3.924/hour
4bce6fec-88fa-40dd-aa5b-376f40e3b246	EC64as v5	64	512	0	 $2.288/hour	 $5.232/hour
720adbad-0a65-4b06-ba9a-0744168d06d8	EC96as v5	96	672	0	 $3.432/hour	 $7.848/hour
fdbfb691-539d-44f1-a85b-e243255582e4	EC96ias v5	96	672	0	 $3.775/hour	 $8.191/hour
2f62cf4e-9171-4173-892f-478f0cbd3990	E2d v4	2	16	75	 $0.151/hour	 $0.243/hour
bf91276f-e664-49e6-a794-589b04352ca2	E4d v4	4	32	150	 $0.302/hour	 $0.486/hour
9a20af8a-95e3-459a-bf5c-30f4fcb65aef	E8d v4	8	64	300	 $0.604/hour	 $0.972/hour
fb13058a-dc8e-4f22-9144-075d94b4c80f	E16d v4	16	128	600	 $1.208/hour	 $1.944/hour
ad84c1e0-f396-4375-a375-968f5a918f6b	E32d v4	32	256	1200	 $2.416/hour	 $2.430/hour
b813b722-d6f3-47a5-926c-e5a3e7d745b8	E48d v4	48	384	1800	 $3.624/hour	 $3.888/hour
a466c345-b645-4a81-8997-e5dd1d9008e5	E64d v4	64	504	2400	 $4.832/hour	 $5.832/hour
dff0f8bd-0d37-4ad1-b334-b391183b1d0c	E2ds v4	2	16	75	 $0.151/hour	 $7.776/hour
b42150a4-3bf2-4a7e-9687-dd65cb5e7bea	E4-2ds v4	2	32	150	 $0.302/hour	 $0.243/hour
039a9d9d-473b-47f2-b222-bafdb730ff9e	E4ds v4	4	32	150	 $0.302/hour	 $0.486/hour
e6271251-992c-48c6-b8de-e338bdce9ccb	E8-2ds v4	2	64	300	 $0.604/hour	 $0.486/hour
fe86092c-30ef-4f08-8ea9-0969beac10d4	E8-4ds v4	4	64	300	 $0.604/hour	 $0.972/hour
0904ba94-0c56-4707-94ad-9621029beff0	E8ds v4	8	64	300	 $0.604/hour	 $0.972/hour
192bbe4b-395c-4d7e-9f83-e8a839bfd3b0	E16-4ds v4	4	128	600	 $1.208/hour	 $0.972/hour
b757bb6d-3543-4487-9b90-6fcaa54a314a	E16-8ds v4	8	128	600	 $1.208/hour	 $1.944/hour
42fb121e-13b3-4b87-933c-78d56a9e9430	E16ds v4	16	128	600	 $1.208/hour	 $1.944/hour
19c01db3-3fb0-48cc-af18-813dfbacb4dc	E20ds v4	20	160	750	 $1.510/hour	 $1.944/hour
7ed2c939-8d10-4522-bab2-d4d97f98e669	E32-8ds v4	8	256	1200	 $2.416/hour	 $2.430/hour
af71b7ea-e318-446c-9bd2-efc40f250056	E32-16ds v4	16	256	1200	 $2.416/hour	 $3.888/hour
4075430e-126b-4603-9147-ca9cae211ed8	E32ds v4	32	256	1200	 $2.416/hour	 $3.888/hour
4e2dddc4-e824-4b95-a4b3-c0ff64730a7d	E48ds v4	48	384	1800	 $3.624/hour	 $3.888/hour
22125aff-77fa-409b-902f-41ac2cfb4dfc	E64-16ds v4	16	504	2400	 $4.832/hour	 $5.832/hour
8b7a296c-a8f4-4adf-a3c6-c85e06a98098	E64-32ds v4	32	504	2400	 $4.832/hour	 $7.776/hour
cd760d0d-beb0-4efc-a4f9-af28653fbbf9	E64ds v4	64	504	2400	 $4.832/hour	 $7.776/hour
5bec98de-f05c-49e1-b54d-505427e015b9	E80ids v4	80	504	2400	 $6.040/hour	 $7.776/hour
55b29bc7-66fd-48c9-af1d-a5f798c0d15f	E2ds v5	2	16	75	 $0.151/hour	 $9.720/hour
b8695d80-bd23-4831-a571-d045a54bf505	E4-2ds v5	2	32	150	 $0.302/hour	 $0.243/hour
fd040d0a-b264-4cd1-b510-3234dd848f84	E4ds v5	4	32	150	 $0.302/hour	 $0.486/hour
3179155c-652d-44a0-9520-9346fe4d2f91	E8-2ds v5	2	64	300	 $0.604/hour	 $0.486/hour
3b25b8ef-1897-41a9-9420-a9b6c122a6ac	E8-4ds v5	4	64	300	 $0.604/hour	 $0.972/hour
293f4697-b36e-427d-b8a8-81b1e2b1048f	E8ds v5	8	64	300	 $0.604/hour	 $0.972/hour
1deb1d24-e755-4ac6-905f-2e756ed39d0f	E16-4ds v5	4	128	600	 $1.208/hour	 $0.972/hour
612f86a7-4a60-4d5d-824a-0ca5e45bf16e	E16-8ds v5	8	128	600	 $1.208/hour	 $1.944/hour
9296d38d-3cb3-4086-aa6a-aedd978e200f	E16ds v5	16	128	600	 $1.208/hour	 $1.944/hour
29f85dfa-ef0c-4079-bc5e-60479110047d	E20ds v5	20	160	750	 $1.510/hour	 $1.944/hour
904c6e9a-587a-48b7-940f-d36b50731b5b	E32-8ds v5	8	256	1200	 $2.416/hour	 $2.430/hour
468ca30f-d2e9-4d6a-abf4-0b6bb29c95fa	E32-16ds v5	16	256	1200	 $2.416/hour	 $3.888/hour
bcfdef15-74b2-49cf-8908-a6a7f9d9ef2f	E32ds v5	32	256	1200	 $2.416/hour	 $3.888/hour
39b4e9ff-0b18-4b73-a552-e3ec081e3f88	E48ds v5	48	384	1800	 $3.624/hour	 $3.888/hour
4c4b20a9-b25b-4168-9ef1-dda77fb30cdd	E64-16ds v5	16	512	2400	 $4.832/hour	 $5.832/hour
b66b21c0-9cff-4d73-8b06-752579a336fe	E64-32ds v5	32	512	2400	 $4.832/hour	 $7.776/hour
1a93a104-9008-4798-9dcf-1b0f7a5744df	E64ds v5	64	512	2400	 $4.832/hour	 $7.776/hour
2f18160a-a375-4334-b9fc-c847c607fe24	E96-24ds v5	24	672	2400	 $7.248/hour	 $7.776/hour
676eea29-927e-4a88-8b00-ca7ae898d013	E96-48ds v5	48	672	2400	 $7.248/hour	 $11.664/hour
bc86a98d-5f70-48c9-9909-133a18d0d77f	E96ds v5	96	672	3600	 $7.248/hour	 $11.664/hour
5604457c-d4cb-4a5c-8f15-e98ace3c11a6	E104ids v5	104	672	3900	 $8.637/hour	 $11.664/hour
ad070e34-e005-4443-aa5b-98d0aabf82db	E2d v5	2	16	75	 $0.151/hour	 $13.421/hour
69a57359-e109-4c36-b98b-07eebf9f4dc4	E4d v5	4	32	150	 $0.302/hour	 $0.243/hour
6e125411-744b-4f54-955e-00bc6392f344	E8d v5	8	64	300	 $0.604/hour	 $0.486/hour
2d8a9aed-ec65-43e8-994e-062c1786524d	E16d v5	16	128	600	 $1.208/hour	 $0.972/hour
39c0f279-622d-486f-aabe-f0aeefcb0d7e	E20d v5	20	160	750	 $1.510/hour	 $1.944/hour
79ef64ea-8bd2-4b93-bec2-47284009d147	E32d v5	32	256	1200	 $2.416/hour	 $2.430/hour
3b320ec7-1bad-4aee-9a65-511e11f4920e	E48d v5	48	384	1800	 $3.624/hour	 $3.888/hour
6605d1c3-955e-42a1-b5bb-b4cfcb3a316a	E64d v5	64	512	2400	 $4.832/hour	 $5.832/hour
b730a762-41de-485f-ae59-6ddcd196f88c	E96d v5	96	672	3600	 $7.248/hour	 $7.776/hour
b5c5af89-36d1-4ef2-9f1e-bb3c78ae9afa	E104id v5	104	672	3900	 $8.637/hour	 $11.664/hour
6e8b768d-3901-4f96-a9ba-39d4b2e5d6ff	E2pds v5	2	16	75	 $0.082/hour	 $13.421/hour
e97eb7e6-797d-4750-9752-6f44c5572ef4	E4pds v5	4	32	150	 $0.164/hour	 $0.229/hour
de205632-2c1e-45cc-9e87-0ac9b9bda337	E8pds v5	8	64	300	 $0.328/hour	 $0.458/hour
29f660dc-b856-49ad-a071-76c5e89891bf	E16pds v5	16	128	600	 $0.656/hour	 $0.458/hour
9030740e-c9c6-44c0-86b3-b373c14f52e8	E20pds v5	20	160	750	 $0.820/hour	 $0.916/hour
06ba13b8-cc76-4267-9ac3-b700ba3bade9	E32pds v5	32	208	1200	 $1.312/hour	 $0.916/hour
59f7b1d4-ae20-4c6f-8d2e-96f80974c95d	E2pds v6	2	16	110	 $0.077/hour	 $0.916/hour
9b1360dd-3b1d-4c8f-82d7-0d477a0b007e	E4pds v6	4	32	220	 $0.154/hour	 $1.832/hour
df0443d9-5693-4220-82dd-2f98dc2b43f8	E8pds v6	8	64	440	 $0.307/hour	 $1.832/hour
c956f456-34ca-4803-9548-2f81bfe19de6	E16pds v6	16	128	880	 $0.614/hour	 $1.832/hour
68431c2f-afb6-44b5-9965-2cadbbe5c828	E32pds v6	32	256	1760	 $1.229/hour	 $2.290/hour
15e1a1fb-0769-438e-b6c2-168db454223b	E48pds v6	48	384	2640	 $1.843/hour	 $3.664/hour
3201e155-cf85-4770-9019-ca47869a657c	E64pds v6	64	512	3520	 $2.458/hour	 $3.664/hour
3dc00651-4fa5-4582-ae3a-6e0fb0f31199	E96pds v6	96	 672  RAM	5280	 $3.686/hour	 $3.664/hour
c9a7f2ef-6144-449c-8bca-31e0a94e0305	E2ps v5	2	16	0	 $0.065/hour	 $5.489/hour
8e712a0c-d28e-4f57-aef1-e93f386cac00	E4ps v5	4	32	0	 $0.130/hour	 $6.881/hour
0b3b1e2f-b705-449f-9c0d-12080ba37ad6	E8ps v5	8	64	0	 $0.260/hour	 $6.881/hour
1bcf3db8-84a7-4506-ba98-c67a04d2b4cb	E16ps v5	16	128	0	 $0.520/hour	 $6.881/hour
5c59256b-4eb8-4e55-85c2-7720280108a0	E20ps v5	20	160	0	 $0.650/hour	 $0.222/hour
06e89913-159d-4b60-a2f1-faaa337ab396	E32ps v5	32	208	0	 $1.040/hour	 $0.444/hour
863486a3-8d01-4250-8d39-847f8ff40f6c	E2ps v6	2	16	0	 $0.061/hour	 $0.444/hour
ea5b02b8-4c86-4bcb-8169-ad7303adfb5d	E4ps v6	4	32	0	 $0.121/hour	 $0.888/hour
d3b08761-fe5e-411d-9ee3-e586c649e4f9	E8ps v6	8	64	0	 $0.242/hour	 $0.888/hour
ee8fced0-540d-4281-83f4-da18061a50ac	E16ps v6	16	128	0	 $0.485/hour	 $0.888/hour
16568d28-69d3-45fc-8d50-1cd2dd39c3f8	E32ps v6	32	256	0	 $0.970/hour	 $1.776/hour
f4184245-3ac7-4896-a5e4-6af1d9a1a769	E48ps v6	48	384	0	 $1.454/hour	 $1.776/hour
914a07b6-9b95-4397-8214-03f9d6422127	E64ps v6	64	512	0	 $1.939/hour	 $1.776/hour
bcf99969-766f-48fd-bd9b-210928954e20	E96ps v6	96	672	0	 $2.909/hour	 $2.220/hour
33cc42e2-c10a-4078-9a25-69a20a61f7e5	E2s v3	2	16	32	 $0.137/hour	 $3.552/hour
3a9170ab-2d35-47c4-a9f6-c9f6f4504268	E4-2s v3	2	32	64	 $0.274/hour	 $3.552/hour
6c2f1d79-3fd7-4217-a825-6223d175b146	E4s v3	4	32	64	 $0.274/hour	 $3.552/hour
4446a118-c8d1-4758-b5d8-395c2e7b3253	E8-4s v3	4	64	128	 $0.548/hour	 $5.328/hour
38d0e1de-67c1-4633-a9df-b73b22a1916a	E8s v3	8	64	128	 $0.548/hour	 $7.104/hour
93e13bc7-2447-425b-a228-b902433f6beb	E16-4s v3	4	128	256	 $1.096/hour	 $7.104/hour
091c7ed5-16a1-43ea-9e0f-8b9701a1cb59	E16-8s v3	8	128	256	 $1.096/hour	 $7.104/hour
9da2b38b-cf51-424d-9667-552fcfc0440f	E16s v3	16	128	256	 $1.096/hour	 $8.880/hour
3a8b8daa-51f5-4ffb-a317-97e6cb1f2842	E20s v3	20	160	320	 $1.370/hour	 $0.222/hour
d5bd6008-7271-4b96-9c27-4e09eb20bf12	E32-8s v3	8	256	512	 $2.192/hour	 $0.444/hour
d0f991f2-e976-4256-829d-2233a1ca2c5c	E32-16s v3	16	256	512	 $2.192/hour	 $0.444/hour
e8747e75-f3b8-4c98-bdc7-43b7f3285169	E32s v3	32	256	512	 $2.192/hour	 $0.888/hour
1d260d4a-8fcd-4572-8e2c-4ed5b3ad9255	E48s v3 	48	384	768	 $3.281/hour	 $0.888/hour
6def6fd8-655a-4c45-9d4b-177a86e66d70	E64-16s v3	16	432	864	 $3.937/hour	 $0.888/hour
548ff5db-a660-4614-8068-046eeed6cfc3	E64-32s v3	32	432	864	 $3.937/hour	 $1.776/hour
1d3afce1-1618-4d23-a484-19ca8854b644	E64s v3	64	432	864	 $3.937/hour	 $1.776/hour
001b51bc-14a8-46b3-a6f8-b606c027761e	E2s v4	2	16	0	 $0.130/hour	 $1.776/hour
ac3f78f6-baaf-4a19-b539-cdb38a6d3db0	E4-2s v4	2	32	0	 $0.260/hour	 $2.220/hour
b751885d-e836-4c3b-a56f-acbc2694c2de	E4s v4	4	32	0	 $0.260/hour	 $3.552/hour
39e9c259-44cd-428b-b14d-4b56747ab94d	E8-2s v4	2	64	0	 $0.520/hour	 $3.552/hour
9c247d28-9742-4278-a7a0-0040e82167e6	E8-4s v4	4	64	0	 $0.520/hour	 $3.552/hour
0ebfc892-0045-4dd7-8c12-ea82c0b3ec5e	E8s v4	8	64	0	 $0.520/hour	 $5.328/hour
7a12d1d4-f940-4892-9e70-1268c0e4550c	E16-4s v4	4	128	0	 $1.040/hour	 $7.104/hour
9f963bcd-16e4-4405-a8f1-0343d4e8f8ca	E16-8s v4	8	128	0	 $1.040/hour	 $7.104/hour
993ba685-80b1-4c90-a843-623702ea5cd4	E16s v4	16	128	0	 $1.040/hour	 $7.104/hour
77d849fc-df18-4220-a55f-165bdb570855	E20s v4	20	160	0	 $1.300/hour	 $10.656/hour
6bbb56f7-21c6-4868-8f63-e4117c2e1501	E32-8s v4	8	256	0	 $2.080/hour	 $10.656/hour
817ab3ec-e938-4773-a692-53e4151af7c0	E32-16s v4	16	256	0	 $2.080/hour	 $10.656/hour
ce698ff7-b152-4a2a-9809-2445ecc6e1e4	E32s v4	32	256	0	 $2.080/hour	 $12.220/hour
7d853be8-dd24-439c-a33f-8ac18f128c7c	E48s v4	48	384	0	 $3.120/hour	 $0.229/hour
115241ec-5ea5-482e-8c2c-a92e8eec37a5	E64-16s v4	16	504	0	 $4.160/hour	 $0.458/hour
06cef821-71e7-4b0f-ba39-b1441d4b07a8	E64-32s v4	32	504	0	 $4.160/hour	 $0.916/hour
f6e426ba-d962-4847-98d5-f89ff14cfebb	E64s v4	64	504	0	 $4.160/hour	 $1.832/hour
b0c50ae7-538f-4fbf-aa97-450c58977384	E80is v4	80	504	2400	 $5.200/hour	 $2.290/hour
577ddd4f-11e4-4205-95d6-70964e1513ad	E2s v5	2	16	0	 $0.130/hour	 $3.664/hour
2be1d38f-6d87-4752-a154-1eedacd07454	E4-2s v5	2	32	0	 $0.260/hour	 $5.489/hour
3c0af559-1e7f-409e-b783-deaf3e1549e1	E4s v5 	4	32	0	 $0.260/hour	 $6.881/hour
c028ef6c-31f8-479e-ac6e-d298fe03290b	E8-2s v5	2	64	0	 $0.520/hour	 $0.222/hour
ab8fdfac-a332-4677-91e9-47cc6e97e121	E8-4s v5	4	64	0	 $0.520/hour	 $0.444/hour
64619431-1eff-47d2-aea5-f1046dfe4079	E8s v5	8	64	0	 $0.520/hour	 $0.888/hour
6a00f2de-2451-4fed-b1cb-1d3141180069	E16-4s v5	4	128	0	 $1.040/hour	 $1.776/hour
16942ee8-7d18-4e19-bfa7-678ae1bece5e	E16-8s v5	8	128	0	 $1.040/hour	 $2.220/hour
4ad6c773-09a8-4e77-ae81-d00cbbbc44d0	E16s v5	16	128	0	 $1.040/hour	 $3.552/hour
641e8bd8-649a-41b8-b269-2d64c9be5563	E20s v5	20	160	0	 $1.300/hour	 $5.328/hour
93ac5a98-4627-4ce1-b245-422f4ddaf553	E32-8s v5	8	256	0	 $2.080/hour	 $7.104/hour
cfce25de-2297-451b-81c6-6ee5d464310e	E32-16s v5	16	256	0	 $2.080/hour	 $0.222/hour
5c6283d4-a183-46bb-9ffb-0cb3f59788c7	E32s v5	32	256	0	 $2.080/hour	 $0.444/hour
b955043d-c09f-431f-85da-49cea6b644bf	E48s v5	48	384	0	 $3.120/hour	 $0.888/hour
95ae2aa2-2bd9-4491-bd49-ad0ebd4a07c2	E64-16s v5	16	512	0	 $4.160/hour	 $1.776/hour
9f8f0458-c50a-47a5-b54e-6d291a9a831d	E64-32s v5	32	512	0	 $4.160/hour	 $2.220/hour
5bed9634-99f6-410a-8ce6-727fd0023f7c	E64s v5	64	512	0	 $4.160/hour	 $3.552/hour
36bff5c2-92aa-4c10-8d1e-f645ede8fa30	E96-24s v5	24	672	3600	 $6.240/hour	 $5.328/hour
c1487d42-9152-475e-a88b-34d85ea47905	E96-48s v5	48	672	3600	 $6.240/hour	 $7.104/hour
a1631651-b318-4c28-a8d3-4602ae219ff5	E96s v5	96	672	0	 $6.240/hour	 $10.656/hour
7dc48408-2d99-439e-a84c-c5ab8c84e131	E104is v5	104	672	0	 $7.436/hour	 $12.220/hour
246299d6-4308-44e1-9ac2-396893da190c	E2 v3	2	16	50	 $0.137/hour	\N
dde5ad24-ac57-428e-b45d-c651483510d7	E4 v3	4	32	100	 $0.274/hour	\N
7f09c1a3-d548-4b20-8958-b817fd8fa7ab	E8 v3	8	64	200	 $0.548/hour	\N
d25ae5a9-3594-4685-8a01-cd2c8503172d	E16 v3	16	128	400	 $1.096/hour	\N
5440e9dd-dc24-4460-a7d1-f78e237c3ed8	E20 v3	20	160	500	 $1.370/hour	\N
5cc65519-beda-4689-84ef-ef54bcbe9d7c	E32 v3	32	256	800	 $2.192/hour	\N
0f6126dd-d8f9-4319-bc85-046441f50aef	E48 v3	48	384	1200	 $3.281/hour	\N
324c1fa9-1cd6-4301-b07e-8dc447899847	E64 v3	64	432	1600	 $3.937/hour	\N
a1896a73-fa72-4207-9a4a-26ec9029a559	E2 v4	2	16	0	 $0.130/hour	\N
eea78429-5bec-4b5b-b3b4-2b22d3aafd3b	E4 v4	4	32	0	 $0.260/hour	\N
f0dc0ad5-3fd0-46a4-a2a3-0874859c4efa	E8 v4	8	64	0	 $0.520/hour	\N
ce405291-3535-4130-8a02-000bed2c903f	E16 v4	16	128	0	 $1.040/hour	\N
5e2d481e-f2b8-4c59-9fbc-e77c7d3a850a	E20 v4	20	160	0	 $1.300/hour	\N
7789b24e-0a61-4995-8be6-474c333c0277	E32 v4	32	256	0	 $2.080/hour	\N
c6e3dd10-6f73-4b4e-aa91-9852a2955fbc	E48 v4	48	384	0	 $3.120/hour	\N
5ca1f102-681d-437d-8cfd-79e4c07a1878	E64 v4	64	504	0	 $4.160/hour	\N
1a2ef0df-a537-42fd-afbd-957210e5ab68	E2 v5	2	16	0	 $0.130/hour	\N
ccd2d320-6ce0-48fd-9584-cd1b9b1e7924	E4 v5	4	32	0	 $0.260/hour	\N
ec11ea86-d939-49da-98e3-1b672c855685	E8 v5	8	64	0	 $0.520/hour	\N
96aaaa01-aecd-4513-a7d4-bb0a8509f85b	E16 v5	16	128	0	 $1.040/hour	\N
fb44c8f5-efc5-428e-b557-d58ef606d102	E20 v5	20	160	0	 $1.300/hour	\N
f2175d69-f48c-4981-b779-856281d031f6	E32 v5	32	256	0	 $2.080/hour	\N
c355edb4-1940-495d-b0f3-77a23e0b4084	E48 v5	48	384	0	 $3.120/hour	\N
37c9dc27-205c-40db-9b47-a0cbfff3e030	E64 v5	64	512	0	 $4.160/hour	\N
3cf09171-8a8b-4b5b-9eec-092e5ebe8991	E96 v5	96	672	0	 $6.240/hour	\N
91560c1d-4af2-4cbc-992a-1fb95a2ee6cc	E104i v5	104	672	0	 $7.436/hour	\N
78266a6e-852c-4d77-8dc2-18e0476f21ca	F1	1	2	16	 $0.049/hour	 $0.096/hour
b3e5e5d8-0f27-4b11-b57a-862db7c8a799	F2	2	4	32	 $0.099/hour	 $0.192/hour
6d016056-780d-4db1-a939-1fe7f4d9b0be	F4	4	8	64	 $0.198/hour	 $0.383/hour
3f548fc2-13e1-401f-b3d0-81009c3d82ef	F8	8	16	128	 $0.395/hour	 $0.766/hour
52d62df5-33de-45e1-ad92-f3e4c34c81a9	F16	16	32	256	 $0.790/hour	 $1.532/hour
70dae539-3f52-4334-873e-6fde29f085a1	F1s	1	2	4	 $0.049/hour	 $0.096/hour
852f81f0-b51c-4228-8ba8-1f917f7b33ca	F2s	2	4	8	 $0.099/hour	 $0.192/hour
7e140917-158e-4c54-91a2-351edb3400d8	F4s	4	8	16	 $0.198/hour	 $0.383/hour
329c5737-e688-4618-8726-a93e529d61cd	F8s	8	16	32	 $0.395/hour	 $0.766/hour
71e33bf2-ef29-4817-8e23-98cffe6209e4	F16s	16	32	64	 $0.790/hour	 $1.532/hour
a39096b5-c78f-4430-9773-2127c12e673d	F2s v2	2	4	16	 $0.085/hour	 $0.177/hour
d5efd25f-82a5-46e7-9bae-11f75ac1cdb3	F4s v2	4	8	32	 $0.170/hour	 $0.354/hour
da5b69c1-2d04-42f9-a1c4-c97f208bcc1e	F8s v2	8	16	64	 $0.340/hour	 $0.708/hour
0bfb27c8-d83e-4f5a-a71f-e6cfa493ba05	F16s v2	16	32	128	 $0.680/hour	 $1.416/hour
a61bedc0-b0fd-4f2a-8919-b89abd609208	F32s v2	32	64	256	 $1.360/hour	 $2.832/hour
d0b32421-2e25-484a-a0ec-524b6367bbef	F48s v2	48	96	384	 $2.040/hour	 $4.248/hour
84117b42-62c5-4696-ae76-cd3f0ed26583	F64s v2	64	128	512	 $2.720/hour	 $5.664/hour
56a523bb-3bb0-47ed-872c-97df4b314216	F72s v2	72	144	576	 $3.060/hour	 $6.372/hour
9964f374-f049-4bee-a90e-0997a4e645d6	FX4mds	4	84	168	 $0.392/hour	 $0.576/hour
c7bffe91-8b3c-47a6-a8c7-61522edab08e	FX12mds	12	252	504	 $1.176/hour	 $1.728/hour
fd1a72d7-d876-4ee2-9bf2-5be88cc636eb	FX24mds	24	504	1008	 $2.352/hour	 $3.456/hour
38b31d35-d13b-4f73-a73c-f14c1dee1b85	FX36mds	36	756	1512	 $3.528/hour	 $5.184/hour
b71a6c4e-4f32-4aa5-8415-c35d87f34625	FX48mds	48	1008	2016	 $4.704/hour	 $6.912/hour
684b3da2-85da-46b7-945b-be2681a582c3	HB120-16rs v3	16	456	2100	 $5.040/hour	 $10.560/hour
b0983685-012c-44f6-9aa7-5736f00af84b	HB120-32rs v3	32	456	2100	 $5.040/hour	 $10.560/hour
5fa32004-b7aa-4aed-a283-3e46726d0190	HB120-64rs v3	64	456	2100	 $5.040/hour	 $10.560/hour
ea0bb128-06fc-47f4-a05e-b873177ce0b5	HB120-96rs v3	96	456	2100	 $5.040/hour	 $10.560/hour
3c8059a0-efd0-42d5-9fc6-b893a88be8eb	HB120rs v3	120	456	2100	 $5.040/hour	 $10.560/hour
54466253-5878-4adc-bb76-2fb090c28503	HC44-16rs	16	352	700	 $4.435/hour	 $6.459/hour
c1b25ca0-0874-4096-af70-0eadcbb2b9bd	HC44-32rs	32	352	700	 $4.435/hour	 $6.459/hour
ae5dbc19-0c86-4668-9715-2b36e366e179	HC44rs	44	352	700	 $4.435/hour	 $6.459/hour
0089cab0-3bc1-4d21-8514-2f32aeb8e0b3	H8	8	56	1000	 $0.998/hour	 $1.939/hour
a7edc290-d266-4ad2-8337-152f635b0da2	H16	16	112	2000	 $1.995/hour	 $3.877/hour
3955f4c2-980b-427a-94da-4e9a530274db	H8m	8	112	1000	 $1.337/hour	 $2.598/hour
8f39690f-def8-475a-bde6-4433e6860270	H16m	16	224	2000	 $2.674/hour	 $5.196/hour
7e532968-179a-4472-af78-2cabc9b73d40	H16mr	16	224	2000	 $2.941/hour	 $5.715/hour
5075a65f-2e56-4987-b9d7-e921f688f426	H16r	16	112	2000	 $2.195/hour	 $4.265/hour
411df64c-42fb-405c-a48b-9ad8eb9aec99	L8as v3	8	64	80	 $0.708/hour	 $1.076/hour
51063bb4-733d-4a08-add2-9bb93f3c60e3	L16as v3	16	128	160	 $1.416/hour	 $2.152/hour
5d655b6b-325f-4f6f-99b6-61991101eccc	L32as v3	32	256	320	 $2.832/hour	 $4.304/hour
9c9e41c1-73ac-4e3a-9d22-b0a227433a7b	L48as v3	48	384	480	 $4.248/hour	 $6.456/hour
5be0a124-297d-46b9-8cc8-4fba97505bde	L64as v3	64	512	640	 $5.664/hour	 $8.608/hour
4bcc844a-164f-442a-9309-19e0dec4295f	L80as v3	80	640	800	 $7.080/hour	 $10.760/hour
6c1ced17-2b51-4584-85ec-0e229ffb691d	L8s v2	8	64	80	 $0.708/hour	 $1.160/hour
31e03ff4-78ae-436c-a0e7-913dd8558180	L16s v2	16	128	160	 $1.416/hour	 $2.320/hour
f7ebf0c6-7761-4fda-b521-3a3a600620d0	L32s v2	32	256	320	 $2.832/hour	 $4.640/hour
4a29ab1e-4945-4983-828d-b72005709a72	L48s v2	48	384	480	 $4.248/hour	 $6.960/hour
0ae489ec-a0cc-411f-890b-fed9ad8c888b	L64s v2	64	512	640	 $5.664/hour	 $9.280/hour
1a0dea2c-7b38-40ec-8722-c15191f9a7a1	L80s v2	80	640	800	 $7.080/hour	 $11.600/hour
b60fb646-0e95-4a00-85c1-42e3cbed9be1	L8s v3	8	64	80	 $0.792/hour	\N
3b7161be-9c0a-4729-bbe0-96f7190d0b81	L16s v3	16	128	160	 $1.584/hour	\N
d1c40044-1f41-4fbf-80d6-6e581aea2aaa	L32s v3	32	256	320	 $3.168/hour	\N
bed109a4-4657-4479-b040-fd58d63d0980	L48s v3	48	384	480	 $4.752/hour	\N
2d940378-3c75-483d-89b4-09393b6d0b12	L64s v3	64	512	640	 $6.336/hour	\N
bdb753da-ed66-4825-9e8c-946f17916b64	L80s v3	80	640	800	 $7.920/hour	\N
c014f9e8-22fb-4bc0-8a2f-ac3f4991b35c	M32dms v2	32	875	1024	 $6.341/hour	 $7.813/hour
2650df9b-0005-4b20-ba14-7b76963e7c4f	M64dms v2	64	1792	2048	 $10.668/hour	 $13.612/hour
aef210ff-af35-499d-b226-337bb2660c56	M64ds v2	64	1024	2048	 $6.880/hour	 $9.824/hour
2b25cd1a-e39e-4961-b19c-4dbf50979cae	M128dms v2	128	3892	4096	 $27.536/hour	 $33.424/hour
3f2a3b61-e9c8-4880-bcaa-a9255326459f	M128ds v2	128	2048	4096	 $13.763/hour	 $19.651/hour
209d6b23-ba33-46c8-8b10-a41e107291f6	M192idms v2	192	4096	4096	 $33.080/hour	 $41.912/hour
fb276a18-2d92-4c6b-8fec-233102c227ba	M192ids v2	192	2048	4096	 $16.540/hour	 $25.372/hour
3f1dc976-900c-40d3-ad04-abc3aede9d1a	M12ds v3	12	240	400	 $1.680/hour	 $2.240/hour
d1dc77e1-10df-4edc-a2f5-a33725481767	M24ds v3	24	480	400	 $3.358/hour	 $4.501/hour
46482df7-a254-451a-a4d0-0039134e838d	M48ds1 v3	48	974	400	 $6.819/hour	 $9.095/hour
185d977a-a872-4a90-804e-42c21fc59906	M96ds1 v3	96	974	400	 $10.228/hour	 $14.770/hour
7fbb3626-89be-4b19-b3b6-598660fb4ab6	M96ds2 v3	96	1946	400	 $13.627/hour	 $18.180/hour
2e424a7b-82a8-442e-aa0f-c06ee4a7d1ab	M176ds3 v3	176	2794	400	 $19.570/hour	 $27.913/hour
8b4120d7-ba42-4f94-8323-c2e023f5dda2	M176ds4 v3	176	3892	400	 $27.264/hour	 $35.597/hour
e4dfdbed-7e61-4d51-b137-142a62748861	M64	64	1024	7168	 $6.881/hour	 $9.825/hour
169317f0-eff9-4e1e-af57-aac34ec85806	M128	128	2048	14336	 $13.762/hour	 $19.650/hour
80eab8fd-f201-47a8-b358-e97c541c290b	M32ls	32	256	1024	 $2.964/hour	 $4.436/hour
1d4b6b31-558d-4cf6-90fe-55e731e9fffa	M64ls	64	512	2048	 $5.587/hour	 $8.531/hour
42868da7-9618-4749-9e6c-a4afd15c9c80	M64m	64	1792	7168	 $10.666/hour	 $13.610/hour
2aad60e8-a00d-4371-86f3-3324d62b5d9b	M128m	128	3892	14336	 $27.524/hour	 $33.424/hour
4f6e7cac-51ab-4b66-94c1-82b25cceb0a1	M8-2ms	2	218.75	256	 $1.585/hour	 $1.953/hour
dad0a4d5-3973-4a6c-85da-a01212d5c46f	M8-4ms	4	218.75	256	 $1.585/hour	 $1.953/hour
0087b950-153d-4a5e-a87a-264a7d40a822	M8ms	8	218.75	256	 $1.585/hour	 $1.953/hour
92ae1227-6d26-41fb-a6f5-3f7e8c8e8cee	M16-4ms	4	437.5	256	 $3.170/hour	 $3.907/hour
3f7751ba-ed21-4b4b-8e79-2ec6bfd32eb1	M16-8ms	8	437.5	256	 $3.170/hour	 $3.907/hour
cb2d9b4c-3e46-4508-bfa0-6a2ccd9cce66	M16ms	16	437.5	512	 $3.170/hour	 $3.907/hour
5d0cdaae-0b8a-45e9-b832-49439c008d84	M32-8ms	8	875	1024	 $6.341/hour	 $7.813/hour
14d51e3d-93d0-4fe0-954e-247091cbf6f7	M32-16ms	16	875	1024	 $6.341/hour	 $7.813/hour
0568c847-fa0f-4940-b3e3-2f3b6c60145b	M32ms	32	875	1024	 $6.341/hour	 $7.813/hour
119d7b7c-7682-4575-8c92-b97a6b65a56d	M64-16ms	16	1792	2048	 $10.666/hour	 $13.610/hour
e2e3716f-2a6d-4e2e-843b-0a2447d10a63	M64-32ms	32	1792	2048	 $10.666/hour	 $13.610/hour
f89d3f8c-5e0f-468e-bcf3-8ba6c7393630	M64ms	64	1792	2048	 $10.666/hour	 $13.610/hour
3044d6dd-61b5-4e85-9101-ae29223b22a3	M128-32ms	32	3892	4096	 $27.524/hour	 $33.424/hour
9b81e94e-1f7d-4d37-9350-04158914e971	M128-64ms	64	3892	4096	 $27.524/hour	 $33.424/hour
d2d15aa4-d6ef-4148-97be-40716041e8f3	M128ms	128	3892	4096	 $27.524/hour	 $33.424/hour
b0f351e0-f865-4a10-b932-ebf5b446bb36	M64s	64	1024	2048	 $6.881/hour	 $9.825/hour
e60d0c0a-973e-40e3-a6d2-73e380c9c25a	M128s	128	2048	4096	 $13.762/hour	 $19.650/hour
a8f79792-86ef-4f9a-9a08-0157c46b5a4b	M32ts	32	192	1024	 $2.793/hour	 $4.265/hour
5a376812-fcdb-4669-802c-8366237309b0	M32ms v2	32	875	0	 $6.232/hour	 $7.704/hour
c551a60c-8446-476e-aadb-7e799b3bacbc	M64ms v2	64	1792	0	 $10.451/hour	 $13.395/hour
de3eff90-c90f-4500-94f7-0ea653741285	M64s v2	64	1024	0	 $6.663/hour	 $9.607/hour
109773d5-b82d-4ad5-a617-3959ea129a1f	M128ms v2	128	3892	0	 $27.102/hour	 $32.990/hour
bb72bb60-acc5-4720-b7f7-51b18017c7b3	M128s v2	128	2048	0	 $13.329/hour	 $19.217/hour
a255e84f-4903-41c9-8d76-2f0777dac7f0	M192ims v2	192	4096	0	 $32.646/hour	 $41.478/hour
b1caddb2-8f25-4f69-9572-43b63c56b5ab	M192is v2	192	2048	0	 $16.106/hour	 $24.938/hour
08e8da90-50b0-488b-a66b-e58bdb85af2b	M12s v3	12	240	0	 $1.580/hour	 $2.140/hour
19037f32-39f8-4063-82d7-43d106fc5494	M24s v3	24	480	0	 $3.162/hour	 $4.305/hour
843a5984-6103-40d7-85d7-919b008512a3	M48s1 v3	48	974	0	 $6.417/hour	 $8.693/hour
c56858ef-16c2-4256-acd9-a58ddf2e1520	M96s1 v3	96	974	0	 $9.620/hour	 $14.173/hour
14746f86-bbcd-4dcb-8359-a64bda21d259	M96s2 v3	96	1946	0	 $12.824/hour	 $17.376/hour
899ab0ad-3e64-4bd6-86a0-ebd3070d4f61	M176s3 v3	176	2794	0	 $18.416/hour	 $26.759/hour
eb0cdda6-e7e0-488d-b45c-870496e85f7a	M176s4 v3	176	3892	0	 $25.657/hour	 $33.990/hour
4df7db3f-86c3-48bc-88d8-a63d0eec51ab	M208ms v2	208	5700	4096	 $45.959/hour	 $55.551/hour
65fd3be0-e33f-4fb1-ada0-b2e9c08fbe95	M416ms v2	416	11400	8192	 $102.120/hour	 $121.260/hour
67403967-4d7b-4ed5-b573-acbebdeb261f	M208s v2	208	2850	4096	 $22.979/hour	 $32.568/hour
d6cc1666-a6f6-49f8-876b-3562d33a1d38	M416s_8_v2	416	7600	4096	 $92.550/hour	 $111.690/hour
86c56bd8-2827-4936-813d-a4fce9c303bf	M416s v2	416	5700	8192	 $51.067/hour	 $70.204/hour
40f15107-4299-46c7-89f2-528d8a009b96	NC24ads A100 v4	24	220	958	 $5.142/hour	 $6.246/hour
d74d50f2-5b41-44ef-96f7-7f27bd36f4ca	NC48ads A100 v4	48	440	1916	 $10.284/hour	 $12.492/hour
de689c69-a62e-4c44-83d3-ddecadd0d3c4	NC96ads A100 v4	96	880	3832	 $20.569/hour	 $24.985/hour
53c0cc8f-c923-4e1c-8fa2-6e281fb3e7f4	NC4as T4 v3	4	28	180	 $0.579/hour	 $0.763/hour
e1f35504-9266-4f79-a210-8620d126b542	NC8as T4 v3	8	56	360	 $0.827/hour	 $1.195/hour
83bae3a2-1801-4042-9d5c-f5338b70a996	NC16as T4 v3	16	110	360	 $1.324/hour	 $2.060/hour
6f47d1c1-6272-4869-bcb2-695beb90b536	NC64as T4 v3	64	440	2880	 $4.787/hour	 $7.731/hour
c4183bfb-6ce2-4cc0-a6a9-a659ac25e59f	NC40ads H100 v5	40	320	3576	 $9.772/hour	 $11.612/hour
63b65d22-8e16-4256-97d9-fa3398758bb6	NC80adis H100 v5	80	640	7152	 $19.544/hour	 $23.224/hour
3303b54e-3782-45a0-8873-74801a06899d	NC6s v3	6	112	736	 $4.234/hour	 $4.510/hour
6dd5c852-532b-4f44-b1e4-7c1301efb3d6	NC12s v3	12	224	1474	 $8.468/hour	 $9.020/hour
8c613366-3561-4fe3-bdff-474ced067d48	NC24s v3	24	448	2948	 $16.936/hour	 $18.040/hour
19f2ae91-4b87-419f-8766-3f57b6757db2	NC24rs v3	24	448	2948	 $18.630/hour	 $19.734/hour
9faf90bd-9bca-41ba-bafd-3aca50c75981	NV6ads A10 v5	6	55	180	 $0.636/hour	 $0.912/hour
02c26e8b-0ff6-478b-8653-e131501e0dbc	NV12ads A10 v5	12	110	320	 $1.271/hour	 $1.823/hour
bd002dfe-7d9c-4ad5-9173-699f5300bf42	NV18ads A10 v5	18	220	720	 $2.240/hour	 $3.068/hour
9a11e655-817e-4d32-b40c-304c04090c8c	NV36adms A10 v5	36	880	720	 $6.328/hour	 $7.984/hour
d5f0c67a-5527-4db3-aa90-97aebb91c933	NV36ads A10 v5	36	440	720	 $4.480/hour	 $6.136/hour
13240d7b-546a-4110-b0dc-87bd2c491851	NV72ads A10 v5	72	880	1400	 $9.128/hour	\N
0b5bbeef-2636-403e-bdab-1d7e8813a29d	NV6	6	56	340	 $1.718/hour	 $1.902/hour
eb5587c3-a48b-45a3-ac20-7fdf7541f571	NV12	12	112	680	 $3.436/hour	 $3.804/hour
173c0647-ab31-4836-a587-bcae59a1e1ba	NV24	24	224	1440	 $6.872/hour	 $7.608/hour
15021b21-733d-450b-9793-c4dd6144a4cb	NV12s v3	12	112	736	 $1.596/hour	 $2.148/hour
5fbeddc7-0559-4529-a553-9fb7ff7e0739	NV24s v3	24	224	1474	 $3.192/hour	 $4.296/hour
69499e03-8a94-4d99-b5d6-9351e5e10d51	NV48s v3	48	448	2948	 $6.384/hour	 $8.592/hour
9093e7c1-283b-45eb-b1b2-f9a09723031c	NV4as v4	4	 14  RAM	88	\N	 $0.510/hour
70ad98a2-455d-4010-8bff-e9d043df8dc5	NV8as v4	8	 28  RAM	176	\N	 $1.020/hour
f46183b3-0547-4493-a8d5-d0bd79fbc35b	NV16as v4	16	 56  RAM	352	\N	 $2.041/hour
6dec7f65-18aa-4b80-8945-ded317acf0d8	NV32as v4	32	 112  RAM	700	\N	 $4.082/hour
\.


--
-- Data for Name: certifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.certifications (certificationid, userid, certificationname) FROM stdin;
\.


--
-- Data for Name: cloudassignedinstance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cloudassignedinstance (id, username, user_id, instance_id, public_ip, instance_name, instance_type, start_date, end_date, created_at, password, lab_id, isrunning, isstarted) FROM stdin;
49	A1	34c17183-06ed-46d0-b1f8-49caef71ed1e	i-052d7195a25cf3371	54.162.9.77	A1_34c17183-06ed-46d0-b1f8-49caef71ed1e	t3.small	2025-04-08 06:46:28	2025-04-09 00:00:00	2025-04-08 06:48:12.140106	\N	2a746d79-5539-475f-9eec-349069ea30ce	f	t
\.


--
-- Data for Name: cloudslicelab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cloudslicelab (labid, createdat, createdby, services, region, startdate, enddate, cleanuppolicy, platform, provider, title, description, status, rating, modules, difficultylevel, credits) FROM stdin;
95547f54-2782-4f9d-9af6-c1bf13c62b1b	2025-04-17 12:34:21.422684	c66e7ac0-7b36-4dc1-8f0e-094eb0a34c4d	["Amazon API Gateway"]	us-east-1	2025-04-17 12:34:00	2025-04-26 12:34:00	1	cloud	aws	aa	aa	pending	\N	without-modules	\N	100
fb9ecbe9-cd3f-4454-85fd-01c715cff4cd	2025-04-17 12:50:46.210683	c66e7ac0-7b36-4dc1-8f0e-094eb0a34c4d	[]	us-east-1	2025-04-17 12:35:00	2025-04-18 12:35:00	\N	cloud	aws	Ibm Cosmos	Learn the ibm cloud	pending	\N	with-modules	\N	\N
\.


--
-- Data for Name: cloudslicelabwithmodules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cloudslicelabwithmodules (labid, createdat, createdby, region, startdate, enddate, cleanuppolicy, platform, provider, title, description, difficultylevel, status, rating, modules) FROM stdin;
\.


--
-- Data for Name: createlab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.createlab (lab_id, user_id, title, description, duration, type, platform, provider, cpu, ram, storage, instance, snapshot_type, os, os_version, difficulty, status, rating, total_enrollments, created_at) FROM stdin;
\.


--
-- Data for Name: ec2_instance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ec2_instance (id_serial, instancename, memory, vcpu, storage, networkperformance, ondemand_windows_base_pricing, ondemand_ubuntu_pro_base_pricing, ondemand_suse_base_pricing, ondemand_rhel_base_pricing, ondemand_linux_base_pricing) FROM stdin;
7a26cc15-599d-40d8-b318-5f26ce3e08cd	t2.micro-Free tier eligible	1	1	ESB Only	Up to 5 Gigabit	0.0162 USD per Hour	0.0134 USD per Hour	0.0116 USD per Hour	0.026 USD per Hour	0.0116 USD per Hour
e4009db0-f3da-4487-a6f0-15b70f97d5a2	t2.nano	0.5	1	ESB Only	Up to 5 Gigabit	0.0081 USD per Hour	0.0076 USD per	 0.0058 USD per Hour	-	0.0058 USD per Hour
ad227fcd-83b5-4b17-8910-d84e4108b805	t2.small	2	1	ESB Only	Up to 5 Gigabit	0.032 USD per Hour	0.025 USD per Hour	0.053 USD per Hour	0.0376 USD per Hour	0.023 USD per Hour
9d3cca05-2303-4fdb-924a-8381712d8b7a	t2.large	8	2	ESB Only	Up to 5 Gigabit	 0.1208 USD per Hour	0.0963 USD per Hour	0.1928 USD per Hour	0.1216 USD per Hour	0.0928 USD per Hour
87cfbc16-905c-48e8-8a42-eeb36eb5512e	t2.xlarge	16	4	ESB Only	Up to 5 Gigabit	0.2266 USD per Hour	 0.1926 USD per Hour	0.2856 USD per Hour	0.2432 USD per Hour	0.1856 USD per Hour
89c75772-be4a-40c9-9043-07666b9a4309	t2.2xlarge	32	8	ESB Only	Up to 5 Gigabit	 0.4332 USD per Hour	0.3852 USD per Hour	 0.4712 USD per Hour	0.4864 USD per Hour	0.3712 USD per Hour
2bfcc545-efb0-4621-a07c-e92598cf7b0f	t3.nano	0.5	2	ESB Only	Up to 5 Gigabit	 0.0098 USD per Hour	0.0087 USD per Hour	 0.0052 USD per Hour	\N	0.0052 USD per Hour
31f2d279-a856-4f41-a63f-71fcf3271ece	t3.micro	1	2	ESB Only	Up to 5 Gigabit	0.0196 USD per Hour	0.0139 USD per Hour	0.0104 USD per Hour	0.0392 USD per Hour	0.0104 USD per Hour
de837288-a306-4138-9525-0797d82dc5f6	t3.small	2	2	ESB Only	Up to 5 Gigabit	0.0392 USD per Hour	0.0243 USD per Hour	0.0518 USD per Hour	0.0496 USD per Hour	0.0208 USD per Hour
4c82084c-5814-4555-85a3-ef7ed0cc0b25	t3.large	8	2	ESB Only	Up to 5 Gigabit	0.1108 USD per Hour	0.0867 USD per Hour	0.1395 USD per Hour	0.112 USD per Hour	0.0832 USD per Hour
d4339315-3a0a-4813-86c6-443ace10a58f	t3.xlarge	16	4	ESB Only	Up to 5 Gigabit	0.24 USD per Hour	0.1734 USD per Hour	0.2227 USD per Hour	0.224 USD per Hour	 0.1664 USD per Hour
456542dc-7dde-4fa5-a619-d5c6038bcf03	t3.2xlarge	32	8	ESB Only	Up to 5 Gigabit	0.48 USD per Hour	0.3468 USD per Hour	 0.4578 USD per Hour	0.448 USD per Hour	 0.3328 USD per Hour
c3b7774a-e513-4106-adc7-5032b61ce800	x2iden.8xlarge	1024	128	ESB Only	\N	9.07775 USD per Hour	-	7.73075 USD Per hour	-	-
5d11bad1-a8f5-4532-9aee-4487932ff03c	c5.xlarge	8	4	ESB Only	Up to 10 Gigabit	0.354 USD per Hour	0.177 USD per Hour	0.226 USD per Hour	0.228 USD per Hour	0.17 USD per Hour
eaf8b8cb-723e-482d-a9e1-2fd46d18f301	c5.large	4	2	ESB Only	Up to 10 Gigabit	0.177 USD per Hour	0.089 USD per Hour	0.141 USD per Hour	 0.114 USD per Hour	0.085 USD per Hour
7cd8fab8-60de-43a8-822b-bb1a401344f3	c5.4xlarge	32	16	1 x 400 NVMe SSD	Up to 10 Gigabit	 1.416 USD per Hour	 0.708 USD per Hour	 0.78 USD per Hour	0.853 USD per Hour	0.68 USD per Hour
1fffb49b-3f3b-4c1f-b868-7949af9871a0	c5.xlarge	8	4	ESB Only	Up to 10 Gigabit	 0.354 USD per Hour	0.177 USD per Hour	0.226 USD per Hour	0.228 USD per Hour	 0.17 USD per Hour
b5b545fe-5d3c-40e1-8627-295dbd6e9356	c5.12xlarge	96	48	ESB Only	Up to 12 Gigabit	4.248 USD per Hour	2.124 USD per Hour	2.14 USD per Hour	2.558 USD per Hour	2.04 USD per Hour
a963f0ed-7afe-4948-b1b5-b1b71d8340de	c5.24xlarge	192	96	ESB Only	Up to 25 Gigabit	8.496 USD per Hour	4.248 USD per Hour	4.18 USD per Hour	5.117 USD per Hour	4.08 USD per Hour
5c758488-ca83-4269-8abd-c3a3a81c3025	c5.metal	192	96	ESB Only	Up to 25 Gigabit	8.496 USD per Hour	 4.248 USD per Hour	4.18 USD per Hour	5.117 USD per Hour	4.08 USD per Hour
95b5b2c5-4b93-4b41-afda-4e0152666585	c5a.12xlarge	96	48	ESB Only	Up to 12 Gigabit	4.056 USD per Hour	1.932 USD per Hour	1.973 USD per Hour	2.366 USD per Hour	1.848 USD per Hour
c059fffb-4729-4011-ae3a-b40f4d737037	c5ad.16xlarge	128	64	2400 GB (2 * 1200 GB NVMe SSD) 	Up to 20 Gigabit	5.696 USD per Hour	2.864 USD per Hour	2.877 USD per Hour	3.443 USD per Hour	 2.752 USD per Hour
2ad76305-b96a-4fb3-aa65-2cb554affe18	c6a.16xlarge	128	64	ESB Only	25000 Megabit	5.392 USD per Hour	2.56 USD per Hour	2.573 USD per Hour	 3.1392 USD per Hour	2.448 USD per Hour
534acf1c-2f7e-4934-977c-5c5d2025d887	c6i.4xlarge	32	16	ESB Only	Up to 12500 Megabit	1.416 USD per Hour	0.708 USD per Hour	0.805 USD per Hour	0.8528 USD per Hour	0.68 USD per Hour
b7630552-9e5d-43be-8c1d-988036473e34	c7a.medium	2	1	ESB Only	Up to 12.5 Gigabit	0.09732 USD per Hour	0.05307 USD per Hour	0.10762 USD per Hour	 0.06572 USD per Hour	0.05132 USD per Hour
6ca709b0-7e6d-43ce-a3cf-ecf101cfe352	vt1.24xlarge	192	6	ESB Only	Up to 25 Gigabit	-	5.368 USD per Hour	-	6.2368 USD per Hour	5.2 USD per Hour
8b72c4d9-9dd3-4e1c-9440-64aff9d54be6	z1d.large	16	2	75 GB NVMe SSD	Up to 10 Gigabit	0.278 USD per Hour	0.19 USD per Hour	0.242 USD per Hour	 0.215 USD per Hour	0.186 USD per Hour
dfcefe1d-0407-4e72-8830-f56de8e466f3	m5d.xlarge	16	4	150 GB NVMe SSD	Up to 10 Gigabit	 0.41 USD per Hour	0.233 USD per Hour	0.282 USD per Hour	0.284 USD per Hour	 0.226 USD per Hour
15ef3819-f049-45c3-86b2-5cf82a3e554e	d3.xlarge	32	4	5940 GB (3 * 1980 GB NVMe HDD)	Up to 15 Gigabit	0.683 USD per Hour	0.506 USD per Hour	0.556 USD per Hour	0.557 USD per Hour	0.499 USD per Hour
164e9445-09df-4448-ac91-feda4d0da283	i3.large	15.3	2	475 GB NVMe SSD	Up to 10 Gigabit	0.248 USD per Hour	0.16 USD per Hour	0.256 USD per Hour	0.185 USD per Hour	 0.156 USD per Hour
b90eff58-bc6d-4ddb-bdb8-99bb7596d306	i3.metal	512	72	ESB Only	\N	7.936 USD per Hour	5.118 USD per Hour	5.092 USD per Hour	5.77 USD per Hour	4.992 USD per Hour
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (id, module_id, type, created_at) FROM stdin;
ee6c58fb-2f86-4e04-a0ca-70d7bf183342	f9c19681-d743-4c5e-bf0c-6808bc350c62	lab	2025-04-17 12:50:46.238255
000ba49c-d997-436a-a1c0-2f66ef3c5150	f9c19681-d743-4c5e-bf0c-6808bc350c62	questions	2025-04-17 12:50:46.261681
\.


--
-- Data for Name: golden_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.golden_images (id, ami_id, image_name) FROM stdin;
\.


--
-- Data for Name: instance_pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instance_pricing (instance_name, memory, vcpu, storage, network_performance, on_demand_windows_base_pricing, on_demand_ubuntu_pro_base_pricing, on_demand_suse_base_pricing, on_demand_rhel_base_pricing, on_demand_linux_base_pricing, service) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instances (id, lab_id, instance_id, created_at, instance_name, public_ip, password, isrunning, isstarted) FROM stdin;
185	12ad72b1-e52a-4a4d-a37e-4988d09c5c84	i-01e0c069b175ebd30	2025-04-03 17:04:31.516775	\N	54.175.91.106	RLSFf*TRBN!zA(ptA9u(X%4JCh=pDmh=	\N	f
\.


--
-- Data for Name: lab_batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_batch (batch_id, lab_id, admin_id, org_id, config_details, configured_by, software) FROM stdin;
\.


--
-- Data for Name: lab_configurations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_configurations (config_id, lab_id, admin_id, config_details, configured_at) FROM stdin;
\.


--
-- Data for Name: lab_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_exercises (id, exercise_id, estimated_duration, instructions, services, files, title, cleanuppolicy) FROM stdin;
35e5cdb1-a530-4b3a-94ac-b2b17e15f944	ee6c58fb-2f86-4e04-a0ca-70d7bf183342	30	Do the task one after the other	{"Active Directory Connector (AD Connector)"}	{"C:\\\\Users\\\\Administrator\\\\Desktop\\\\microservice\\\\cloud-slice-service\\\\src\\\\public\\\\uploads\\\\1744894246176-.viminfo"}	Ibm	{"type": "auto", "enabled": true, "duration": 60, "durationUnit": "minutes"}
\.


--
-- Data for Name: labassignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.labassignments (assignment_id, lab_id, user_id, status, start_date, completion_date, progress_percentage, remarks, assigned_admin_id, duration, launched) FROM stdin;
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modules (id, name, description, created_at, lab_id) FROM stdin;
f9c19681-d743-4c5e-bf0c-6808bc350c62	Lab Exercise	Learn the Ibm cloud by doing the exercises	2025-04-17 12:50:46.233263	fb9ecbe9-cd3f-4454-85fd-01c715cff4cd
\.


--
-- Data for Name: operating_systems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.operating_systems (category, name) FROM stdin;
Ubuntu	Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
Ubuntu	Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
Ubuntu	Ubuntu Server 22.04 LTS (HVM) with SQL Server 2022 Standard
Ubuntu	Ubuntu Pro - Ubuntu Server Pro 24.04 LTS (HVM), SSD Volume Type
Ubuntu	Deep Learning Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04)
Ubuntu	Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.5 (Ubuntu 22.04)
Ubuntu	Deep Learning AMI Neuron (Ubuntu 22.04)
Ubuntu	Deep Learning OSS Nvidia Driver AMI GPU TensorFlow 2.18 (Ubuntu 22.04)
Windows	Microsoft Windows Server 2025 Base
Windows	Microsoft Windows Server 2025 Core Base
Windows	Microsoft Windows Server 2022 Base
Windows	Microsoft Windows Server 2022 Core Base
Windows	Microsoft Windows Server 2019 Base
Windows	Microsoft Windows Server 2019 Core Base
Windows	Microsoft Windows Server 2016 Base
Windows	Microsoft Windows Server 2016 Core Base
Windows	Microsoft Windows Server 2022 with SQL Server 2022 Standard
Windows	Microsoft Windows Server 2022 with SQL Server 2022 Enterprise
Windows	Microsoft Windows Server 2022 with SQL Server 2022 Web
Windows	Microsoft Windows Server 2019 with SQL Server 2022 Standard
Windows	Microsoft Windows Server 2019 with SQL Server 2022 Enterprise
Windows	Microsoft Windows Server 2022 with SQL Server 2019 Standard
Windows	Microsoft Windows Server 2022 with SQL Server 2019 Enterprise
Windows	Microsoft Windows Server 2019 with SQL Server 2019 Standard
Windows	Microsoft Windows Server 2019 with SQL Server 2019 Enterprise
Windows	Microsoft Windows Server 2019 with SQL Server 2019 Web
Windows	Microsoft Windows Server 2019 with SQL Server 2017 Standard
Rhel	Red Hat Enterprise Linux 9 (HVM), SSD Volume Type
Rhel	Red Hat Enterprise Linux 9 with High Availability
Rhel	RHEL 8 with SQL Server 2022 Standard Edition AMI
Linux	Amazon Linux 2023 AMI
Linux	Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
Linux	Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.5 (Amazon Linux 2023)
Linux	Deep Learning OSS Nvidia Driver AMI GPU TensorFlow 2.16 (Amazon Linux 2)
Linux	Deep Learning Base OSS Nvidia Driver GPU AMI (Amazon Linux 2023)
Linux	Deep Learning AMI Neuron (Amazon Linux 2023)
Linux	Amazon Linux 2 LTS with SOL Server 2019 Standard
Linux	Amazon Linux 2 LTS with SQL Server 2017 Standard
Linux	Amazon Linux 2 with .NET 6, PowerShell, Mono, and MATE Desktop Environment
\.


--
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.options (id, question_id, option_text, option_id) FROM stdin;
ee8003cc-8103-4d4c-9df5-a595e7d776de	e9e9c20a-f1be-4812-a83e-77499585f9d9	its a cloud	option-1744893381106-f5ap0relw
a8b85e66-9cb6-4db6-a218-27b56591a376	e9e9c20a-f1be-4812-a83e-77499585f9d9	instance	option-1744893381106-1w1rmmjd8
d5ed9319-eea8-4fdf-b441-8a585a3f3296	e9e9c20a-f1be-4812-a83e-77499585f9d9	service	option-1744893423871-amctc3da1
fb0aad40-be61-4d3a-a88f-b706aa31d50a	e9e9c20a-f1be-4812-a83e-77499585f9d9	none of the above	option-1744893429702-j5q7k1ea7
\.


--
-- Data for Name: organization_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_users (id, name, email, password, role, admin_id, created_at, organization, organization_type, status, lastactive, org_id) FROM stdin;
1da5810e-6dfd-4629-a6db-a93f01871289	Khan	khan@gmail.com	$2b$10$z0Db1homheIwp3IJ/9hBKe8YwKQTJzvV/fjy0CYnnyVez1jjwJu1.	user	0ee99e02-557a-4600-8b71-ce0bb6414da1	2025-03-21 15:58:35.213917	Techcorp Solutions	enterprise	inactive	22 March 2025	a37627fd-53aa-4666-998f-e4fb2e07af4e
b22caad4-bcb0-44be-8432-927653c9eca7	Joh 	john@golabing.com	$2b$10$3aTQUf6dNvTTRRgQaEj1pOOAoOIriJ7P3E0FERyJUmiHCfHJkX.96	user	0ee99e02-557a-4600-8b71-ce0bb6414da1	2025-03-25 15:27:17.255413	TechCorp Solutions	enterprise	inactive	25 March 2025 15:28:48	a37627fd-53aa-4666-998f-e4fb2e07af4e
34c17183-06ed-46d0-b1f8-49caef71ed1e	A1	a1@gmail.com	$2b$10$m4ju8w8EyzdiqOgKoarR8e9Q6NUB/ovsKBEFik404RCK7R7PsYrve	user	0ee99e02-557a-4600-8b71-ce0bb6414da1	2025-02-05 16:09:56.970762	Techcorp Solutions	enterprise	inactive	17 April 2025 7:2:42	a37627fd-53aa-4666-998f-e4fb2e07af4e
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organizations (id, organization_name, org_email, org_admin, org_type, admin_name, phone_number, address, website_url, status, org_id, logo, total_users, total_admins, active_workspaces, monthly_usage) FROM stdin;
8c2e802b-ff40-462e-ae56-2c5090ca02b6	Cloud Skills	cloudskills@tech.com	c66e7ac0-7b36-4dc1-8f0e-094eb0a34c4d	training	john	93534545354	Bangalore	https://www.cloudskills.com	active	1111	C:\\Users\\Shilpa\\Desktop\\microservices\\organization-service\\src\\public\\uploads\\1742477476331-cloud.png	0	0	0	0.00
a37627fd-53aa-4666-998f-e4fb2e07af4e	Techcorp Solutions	techcorp@tech.com	0ee99e02-557a-4600-8b71-ce0bb6414da1	enterprise	Parveezkhan	93534545354	Bangalore	https://www.techcorpsolutions.com	active	1111	C:\\Users\\Shilpa\\Desktop\\microservices\\organization-service\\src\\public\\uploads\\1742536652869-Logo.png	0	0	0	0.00
\.


--
-- Data for Name: processed_labs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.processed_labs (lab_id) FROM stdin;
ac9b0ddc-cbb8-457e-b86d-1f8a327de014
c1d44d02-5649-40bd-b8d3-eb4de04ca34c
15a46c33-ff78-44ab-89e7-de2844a115dd
9b23893c-2beb-4bf5-b827-7638dd382ca5
799dd568-3fb2-4c7c-8ee1-c0eb5b35a719
d6d96d6b-7db1-42a8-941f-ca6b0896ecf4
b7121009-1638-461f-b348-4c18d15587ee
62f76226-836c-459f-ab4f-b6da2b4899e8
55d69e6a-333e-4ec0-a692-378ca657762e
c65f01d2-3d8e-416a-833d-93464d23162e
381a6baa-2361-402a-a53b-4ff07b17fec3
a57973ad-028b-44cb-a954-e8103e6a74e6
9f117445-1b9f-46df-a02f-a309629eb9b3
e5f33c1c-56ce-46ec-8225-42f6265b8e6d
dc747f26-c0e5-44da-bfd5-38ceb83efc5b
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, exercise_id, question_text, description, correct_answer, title, estimated_duration) FROM stdin;
e9e9c20a-f1be-4812-a83e-77499585f9d9	000ba49c-d997-436a-a1c0-2f66ef3c5150	What is IBM cloud ?	To know about the ibm cloud	option-1744893381106-f5ap0relw	Practice Questions	15
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, organization, organization_type, role, status, created_by, created_at, lastactive, org_id) FROM stdin;
9cfc74ac-28c9-49c4-8238-08f1a926bcc9	corpacademia	corpacademia@gmail.com	$2b$10$n9EO9hU9Uw3tmaZ.Ws0y8.uU/e.DUWVDgrLihMdyWVCkT0BUAJzDS	Cloud Skills	training	orgadmin	inactive	c66e7ac0-7b36-4dc1-8f0e-094eb0a34c4d	2025-03-25 15:00:41.418742	25 March 2025 15:16:48	8c2e802b-ff40-462e-ae56-2c5090ca02b6
1ba7c8ee-5e06-4496-a6d0-a3bd993401b7	trainer	trainer@golabing.ai	$2b$10$fEyOFXVDU9ygdIMGIHituuf2dAdMJNxVc1VCNIfZG8CFAlBqd0/wq	TechCorp Solutions	enterprise	trainer	inactive	\N	2024-12-25 18:18:38.47722	31 January 2025	\N
0ee99e02-557a-4600-8b71-ce0bb6414da1	ParveezKhan	xyz@gmail.com	$2b$10$S2k2KZHHox.l3MJq8GTcsO6.mRNGfy6lbBs06RitcLMSVBJOzdswq	TechCorp Solutions	enterprise	orgadmin	inactive	\N	2024-12-25 17:58:40.281494	8 April 2025 6:45:9	a37627fd-53aa-4666-998f-e4fb2e07af4e
c66e7ac0-7b36-4dc1-8f0e-094eb0a34c4d	admin	superadmin@golabing.ai	$2b$10$l7VVp5DwVdO4kWBiFhrniemBLf8nQt1W1xlyzr0hVLChqJ4K6Czjq	\N	\N	superadmin	active	\N	2024-12-25 17:56:02.511865	17 April 2025 7:6:41	\N
\.


--
-- Data for Name: userstats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userstats (userid, completedlabs, activeassessments, averagescore, totalpurchases, learninghours) FROM stdin;
\.


--
-- Data for Name: workspace; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workspace (id, lab_name, description, lab_type, documents, url, date, status, created_by, last_updated, org_id) FROM stdin;
c91e829b-4694-423f-b753-bfe505a097e4	aa	aa	single-vm	{"C:\\\\Users\\\\Shilpa\\\\Desktop\\\\microservices\\\\workspace-service\\\\src\\\\public\\\\uploads\\\\1742981380515-Yaseen shariff.pdf"}	\N	2025-03-26 00:00:00	pending	0ee99e02-557a-4600-8b71-ce0bb6414da1	2025-03-26 14:59:40.615482	a37627fd-53aa-4666-998f-e4fb2e07af4e
6f2876df-9bc0-4d48-ab90-668a19feeabf	ec2	ec2 instance	single-vm	{"C:\\\\Users\\\\Shilpa\\\\Desktop\\\\microservices\\\\workspace-service\\\\src\\\\public\\\\uploads\\\\1742982285640-users-template (1).csv"}	\N	2025-03-26 00:00:00	pending	0ee99e02-557a-4600-8b71-ce0bb6414da1	2025-03-26 15:14:45.784629	a37627fd-53aa-4666-998f-e4fb2e07af4e
\.


--
-- Name: cloudassignedinstance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cloudassignedinstance_id_seq', 49, true);


--
-- Name: golden_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.golden_images_id_seq', 6, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instances_id_seq', 186, true);


--
-- Name: aws_ec2 aws_ec2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aws_ec2
    ADD CONSTRAINT aws_ec2_pkey PRIMARY KEY (id);


--
-- Name: certifications certifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_pkey PRIMARY KEY (certificationid);


--
-- Name: cloudassignedinstance cloudassignedinstance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudassignedinstance
    ADD CONSTRAINT cloudassignedinstance_pkey PRIMARY KEY (id);


--
-- Name: cloudslicelab cloudslicelab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudslicelab
    ADD CONSTRAINT cloudslicelab_pkey PRIMARY KEY (labid);


--
-- Name: cloudslicelabwithmodules cloudslicelabwithmodules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudslicelabwithmodules
    ADD CONSTRAINT cloudslicelabwithmodules_pkey PRIMARY KEY (labid);


--
-- Name: createlab createlab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.createlab
    ADD CONSTRAINT createlab_pkey PRIMARY KEY (lab_id);


--
-- Name: ec2_instance ec2_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ec2_instance
    ADD CONSTRAINT ec2_instance_pkey PRIMARY KEY (id_serial);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: golden_images golden_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.golden_images
    ADD CONSTRAINT golden_images_pkey PRIMARY KEY (id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: lab_configurations lab_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_configurations
    ADD CONSTRAINT lab_configurations_pkey PRIMARY KEY (config_id);


--
-- Name: lab_exercises lab_exercises_exercise_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_exercises
    ADD CONSTRAINT lab_exercises_exercise_id_key UNIQUE (exercise_id);


--
-- Name: lab_exercises lab_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_exercises
    ADD CONSTRAINT lab_exercises_pkey PRIMARY KEY (id);


--
-- Name: labassignments labassignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labassignments
    ADD CONSTRAINT labassignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: organization_users organization_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_email_key UNIQUE (email);


--
-- Name: organization_users organization_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: processed_labs processed_labs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processed_labs
    ADD CONSTRAINT processed_labs_pkey PRIMARY KEY (lab_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: userstats userstats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userstats
    ADD CONSTRAINT userstats_pkey PRIMARY KEY (userid);


--
-- Name: workspace workspace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspace
    ADD CONSTRAINT workspace_pkey PRIMARY KEY (id);


--
-- Name: certifications certifications_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: cloudslicelab cloudslicelab_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudslicelab
    ADD CONSTRAINT cloudslicelab_createdby_fkey FOREIGN KEY (createdby) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: cloudslicelabwithmodules cloudslicelabwithmodules_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cloudslicelabwithmodules
    ADD CONSTRAINT cloudslicelabwithmodules_createdby_fkey FOREIGN KEY (createdby) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: createlab createlab_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.createlab
    ADD CONSTRAINT createlab_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: exercises exercises_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- Name: users fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lab_batch lab_batch_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_batch
    ADD CONSTRAINT lab_batch_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- Name: lab_batch lab_batch_configured_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_batch
    ADD CONSTRAINT lab_batch_configured_by_fkey FOREIGN KEY (configured_by) REFERENCES public.users(id);


--
-- Name: lab_batch lab_batch_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_batch
    ADD CONSTRAINT lab_batch_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: lab_configurations lab_configurations_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_configurations
    ADD CONSTRAINT lab_configurations_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lab_configurations lab_configurations_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_configurations
    ADD CONSTRAINT lab_configurations_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.createlab(lab_id) ON DELETE CASCADE;


--
-- Name: lab_exercises lab_exercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_exercises
    ADD CONSTRAINT lab_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: labassignments labassignments_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labassignments
    ADD CONSTRAINT labassignments_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.createlab(lab_id);


--
-- Name: labassignments labassignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.labassignments
    ADD CONSTRAINT labassignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.organization_users(id);


--
-- Name: modules modules_lab_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_lab_id_fkey FOREIGN KEY (lab_id) REFERENCES public.cloudslicelab(labid) ON DELETE CASCADE;


--
-- Name: options options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: organization_users organization_users_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: organization_users organization_users_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_users
    ADD CONSTRAINT organization_users_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: organizations organizations_org_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_org_admin_fkey FOREIGN KEY (org_admin) REFERENCES public.users(id);


--
-- Name: questions questions_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: users users_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users users_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organizations(id);


--
-- Name: userstats userstats_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userstats
    ADD CONSTRAINT userstats_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

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

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

