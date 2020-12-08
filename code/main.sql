SET client_encoding = 'UTF8';
SET client_min_messages = warning;

DROP DATABASE nikirova_205;
CREATE DATABASE nikirova_205 WITH ENCODING = 'UTF8';

\connect nikirova_205

SET client_encoding = 'UTF8';
SET client_min_messages = warning;

CREATE TABLE public.classes (
    courseid integer NOT NULL,
    officeid integer NOT NULL,
    numlis integer NOT NULL,
    nextdate date,
    id integer NOT NULL,
    CONSTRAINT available_nextdate CHECK ((nextdate >= CURRENT_DATE)),
    CONSTRAINT numlis_check CHECK (((numlis > 0) AND (numlis <= 10))),
    CONSTRAINT positive_courseid CHECK ((courseid > 0)),
    CONSTRAINT positive_officeid CHECK ((officeid > 0))
);

CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;

CREATE TABLE public.coach_office (
    coachid integer NOT NULL,
    officeid integer NOT NULL,
    CONSTRAINT positive_coachid_coach_office CHECK ((coachid > 0)),
    CONSTRAINT positive_officeid_coach_office CHECK ((officeid > 0))
);

CREATE TABLE public.coach_tool (
    coachid integer NOT NULL,
    toolid integer NOT NULL,
    CONSTRAINT positive_coachid_coach_tool CHECK ((coachid > 0)),
    CONSTRAINT positive_toolid_coach_tool CHECK ((toolid > 0))
);

CREATE TABLE public.coaches (
    id integer NOT NULL,
    name character varying NOT NULL,
    experience integer,
    CONSTRAINT coaches_coachname_check CHECK ((length((name)::text) > 1)),
    CONSTRAINT coaches_experience_check CHECK (((experience >= 0) AND (experience < 50))),
    CONSTRAINT positive_experience CHECK ((experience >= 0))
);

CREATE SEQUENCE public.coaches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.coaches_id_seq OWNED BY public.coaches.id;

CREATE TABLE public.course_tool (
    courseid integer NOT NULL,
    toolid integer NOT NULL
);

CREATE TABLE public.courses (
    id integer NOT NULL,
    name character varying NOT NULL,
    duration interval NOT NULL,
    online boolean,
    skilltraining smallint,
    coachid integer NOT NULL,
    pathid integer NOT NULL,
    price numeric(8,2),
    CONSTRAINT courses_coachid_check CHECK ((coachid > 0)),
    CONSTRAINT courses_coursename_check CHECK ((length((name)::text) > 1)),
    CONSTRAINT courses_courseprice_check CHECK ((price > 0.00)),
    CONSTRAINT courses_duration_check CHECK ((duration >= '1 day'::interval)),
    CONSTRAINT courses_duration_check1 CHECK (((duration >= '1 day'::interval) AND (duration < '6 days'::interval))),
    CONSTRAINT courses_pathid_check CHECK ((pathid > 0)),
    CONSTRAINT courses_skilltraining_check CHECK (((skilltraining >= 0) AND (skilltraining < 6))),
    CONSTRAINT positive_skilltraining CHECK ((skilltraining >= 0))
);

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;

CREATE TABLE public.offices (
    id integer NOT NULL,
    name character varying NOT NULL,
    location character varying NOT NULL,
    shop boolean,
    phone character varying(20) NOT NULL,
    CONSTRAINT offices_location_check CHECK ((length((location)::text) > 1)),
    CONSTRAINT offices_officename_check CHECK ((length((name)::text) > 1)),
    CONSTRAINT offices_phone_check CHECK (((length((phone)::text) > 5) AND (length((phone)::text) < 21)))
);

CREATE SEQUENCE public.offices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.offices_id_seq OWNED BY public.offices.id;

CREATE TABLE public.paths (
    id integer NOT NULL,
    name character varying NOT NULL,
    CONSTRAINT paths_pathname_check CHECK ((length((name)::text) > 1))
);

CREATE SEQUENCE public.paths_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.paths_id_seq OWNED BY public.paths.id;

CREATE TABLE public.producers (
    id integer NOT NULL,
    name character varying NOT NULL,
    country character varying NOT NULL,
    CONSTRAINT producers_country_check CHECK ((length((country)::text) > 1)),
    CONSTRAINT producers_producername_check CHECK ((length((name)::text) > 1))
);

CREATE SEQUENCE public.producers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.producers_id_seq OWNED BY public.producers.id;

CREATE TABLE public.tools (
    id integer NOT NULL,
    name character varying NOT NULL,
    producerid integer NOT NULL,
    type character varying NOT NULL,
    price numeric(8,2),
    CONSTRAINT tools_producerid_check CHECK ((producerid > 0)),
    CONSTRAINT tools_toolname_check CHECK ((length((name)::text) > 1)),
    CONSTRAINT tools_toolprice_check CHECK ((price > 0.00)),
    CONSTRAINT tools_tooltype_check CHECK ((length((type)::text) > 1))
);

CREATE SEQUENCE public.tools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.tools_id_seq OWNED BY public.tools.id;

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);

ALTER TABLE ONLY public.coaches ALTER COLUMN id SET DEFAULT nextval('public.coaches_id_seq'::regclass);

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);

ALTER TABLE ONLY public.offices ALTER COLUMN id SET DEFAULT nextval('public.offices_id_seq'::regclass);

ALTER TABLE ONLY public.paths ALTER COLUMN id SET DEFAULT nextval('public.paths_id_seq'::regclass);

ALTER TABLE ONLY public.producers ALTER COLUMN id SET DEFAULT nextval('public.producers_id_seq'::regclass);

ALTER TABLE ONLY public.tools ALTER COLUMN id SET DEFAULT nextval('public.tools_id_seq'::regclass);

COPY public.classes (courseid, officeid, numlis, nextdate, id) FROM stdin;
1	2	8	2019-10-25	1
2	5	4	2019-12-01	2
3	4	8	2019-12-12	3
4	3	6	2019-11-30	4
10	6	4	2019-10-05	5
11	6	6	2019-10-05	6
13	3	4	2019-10-05	7
9	3	8	2019-10-05	8
7	2	8	2019-11-09	9
8	2	10	2019-12-19	10
4	10	10	2019-02-19	11
6	1	2	2019-02-01	13
7	8	4	2019-04-01	14
6	7	7	2019-05-11	15
6	8	9	2019-09-11	16
1	3	1	2019-09-13	17
\.

COPY public.coach_office (coachid, officeid) FROM stdin;
1	1
1	3
1	4
2	5
3	4
3	5
4	7
5	3
5	5
5	7
6	1
6	2
6	6
1	6
8	6
9	6
9	5
9	88
7	88
7	8
7	18
7	28
3	28
3	58
3	98
2	98
2	8
3	8
3	7
\.

COPY public.coach_tool (coachid, toolid) FROM stdin;
4	7
4	8
4	5
3	1
2	2
8	19
1	19
1	1
1	2
1	8
2	8
2	99
2	59
2	39
2	29
2	22
3	22
6	22
6	12
6	13
6	14
5	14
5	34
5	32
5	12
5	16
5	17
8	1
8	4
8	99
8	29
\.

COPY public.coaches (id, name, experience) FROM stdin;
1	Cvetkova Anzhelika	10
2	Bakulmanova Kseniya	5
3	Kuznecova Yuliya	3
4	Svoboda Tatyana	8
5	Zajceva Velmitina	3
6	Semenova Daria	1
7	Sacha Thompson	11
8	Rowan Davis	9
9	Tatiana Hobbs	9
10	Claire Benton	12
11	Victoria Soto	13
12	Hiroko Tyler	4
13	Wendy Hines	7
14	Caryn Sexton	2
15	Delilah Powell	13
16	Jaime Nicholson	3
17	Cleo White	1
18	Hanna Cooke	12
19	Rhiannon Jackson	4
20	Anastasia Dyer	13
21	Jena Mccray	10
22	Gisela Duffy	15
23	Mikayla Bullock	11
24	Kalia Barry	5
25	Cathleen Roach	8
26	Inga Vega	5
27	Mona Harrington	6
28	Nichole Dale	15
29	Leila Koch	6
30	Zephr Powell	13
31	Teegan Rosario	3
32	Maggie Mcfarland	13
33	Shay Marshall	7
34	Wynter Mcintosh	7
35	Carla Juarez	9
36	Victoria Harrington	3
37	Amethyst Vang	6
38	Gisela Barnett	15
39	Adria Rivers	7
40	Karina Rocha	5
41	Amy Mueller	8
42	Desirae Noble	13
43	Rhoda Vinson	11
44	Justine Mcknight	2
45	Indigo Mcgowan	5
46	Rhiannon Yates	4
47	Amy George	2
48	Alexandra Ochoa	7
49	Rinah Kelley	4
50	Shellie Bates	13
51	Yvette Knowles	7
52	Karly Roy	8
53	Eve Moody	5
54	Vielka Calhoun	2
55	Evangeline Jensen	13
56	Hayley Fields	14
57	Illana Porter	7
58	Inez Walter	15
59	Lee Fowler	13
60	Miriam Salas	14
61	Nevada Munoz	5
62	Melissa Wong	4
63	Hillary Bailey	13
64	Phyllis Blevins	8
65	Marny Richardson	10
66	Brynne Sullivan	12
67	Wendy Walton	5
68	Charity Golden	10
69	Zia Boyd	14
70	Odessa Greene	4
71	Evelyn Dominguez	6
72	Demetria Allen	2
73	Shannon Cox	8
74	Kaye Wynn	14
75	Adena Lane	2
76	Katell Brooks	2
77	Kyra Good	2
78	Abigail Guthrie	12
79	Brynne Salinas	4
80	Quail Sawyer	11
81	Haley Dejesus	12
82	Larissa Cummings	4
83	Whilemina Hanson	15
84	Cheryl Lloyd	5
85	Emma Bradshaw	9
86	Anjolie Baker	10
87	Summer Shannon	9
88	Keely Wade	7
89	Dana Holt	5
90	Darrel Pennington	5
91	Wendy Craig	8
92	Clementine Brown	3
93	Kaye Williamson	3
94	Ori Battle	3
95	Ayanna Casey	2
96	Charde Carr	8
97	Aubrey Murray	4
98	Hayfa Bush	7
99	Rose Simmons	6
100	Lois Kirby	11
101	Maia Lawson	4
102	Lillian Camacho	1
103	Mechelle Carroll	11
104	Martina Haney	9
105	Emma Hoffman	7
106	Clio Dickerson	1
\.

COPY public.course_tool (courseid, toolid) FROM stdin;
1	7
1	8
3	7
3	4
3	5
4	6
4	8
2	2
10	1
10	2
10	10
10	11
10	99
10	89
1	89
12	89
2	89
2	9
2	69
6	69
7	69
7	9
7	19
8	19
\.

COPY public.courses (id, name, duration, online, skilltraining, coachid, pathid, price) FROM stdin;
1	Apparatnyj manikyur	3 days	t	2	4	1	12000.00
2	Francuzskij manikyur	1 day	t	0	3	3	2500.00
3	Kombinirovannyj pedikyur	2 days	f	1	5	2	8000.00
4	Modelirovanie gelem	3 days	f	3	2	4	15000.00
6	Floristika	1 day	t	0	3	3	3500.00
7	Akvarel gelevymi kraskami	1 day	t	0	6	3	2975.00
8	Venzelya	1 day	t	0	6	3	2975.00
9	Lepka gelem	1 day	t	0	7	3	2500.00
10	"KOMBI STAR" Povyshenie kvalifikacii po manikyuru	1 day	f	1	8	1	5000.00
11	Kombinirovannyj i apparatnyj manikyur + slozhnyj remont	2 days	f	2	4	1	12000.00
12	Bazovyj kurs 4 tekhniki: klassika bez zamachivaniya i apparata, kombi, apparatno-preparatnyj pedikyur	4 days	f	4	6	2	23000.00
13	Apparatnyj pedikyur + ehstetika v pedikyure	3 days	f	4	8	2	15000.00
\.


COPY public.offices (id, name, location, shop, phone) FROM stdin;
1	Nevskij prospekt	Nevskij prospekt 32-34	f	555-00-36
2	Parnas	4-j Verhnij pereulok 19	f	555-00-32
3	Komendantskij prospekt	ulica Utochkina 3 korpus 3	t	555-00-52
4	Ligovskij prospekt	Transportnyj pereulok 1 litera A	t	555-00-47
5	Grazhdanskij prospekt	ulica Ushinskogo 14	f	555-00-34
6	Ozerki	prospect Ehngelsa 107 korpus 3	t	555-00-87
7	Moskovskaya	Leninskij prospect 159	f	555-00-39
8	Ullamcorper Viverra Maecenas Corporation	P.O. Box 492, 6212 Tortor. Avenue	t	97377712599
9	Molestie Pharetra Foundation	Ap #983-9832 Mauris Av.	t	42499366399
10	Ac Inc.	408-3505 Id, Av.	t	09306208699
11	Eu Odio Phasellus LLP	Ap #510-9339 Nullam Road	t	22415134899
12	Cras Vehicula Aliquet LLP	Ap #399-6482 Malesuada Rd.	t	04246634899
13	Libero Proin Mi Company	P.O. Box 998, 5103 Diam Rd.	t	39436882699
14	Tincidunt Incorporated	402-3980 Elit. Street	t	88968646599
15	Euismod Urna Nullam PC	P.O. Box 666, 119 Sed Avenue	t	46763623999
16	Ante Institute	197-1200 Ipsum Rd.	t	45706487699
17	Nunc Company	Ap #354-3793 Augue, Street	t	22931558399
18	Fermentum Incorporated	845 Facilisis. Avenue	t	10289562299
19	At Augue Id PC	P.O. Box 407, 1730 Interdum Rd.	t	79296674699
20	Ante Dictum LLC	125-2057 Tincidunt St.	t	00410869099
21	Nonummy Ac Feugiat Industries	7935 Purus Rd.	t	20578597799
22	Adipiscing Lacus Ut Institute	Ap #162-5574 Netus Rd.	t	32981933699
23	Fringilla Purus Mauris LLP	132-2511 Aliquam Street	t	42849883899
24	Magna Duis Dignissim Corporation	Ap #473-431 Fermentum Rd.	t	41336471899
25	Dui Institute	575-4653 Felis. Av.	t	02667902799
26	Non Vestibulum Inc.	140-8345 Dui, St.	t	97872248799
27	Dictum Inc.	5318 A Ave	t	85416359999
28	Consectetuer Consulting	9087 Ac Av.	t	65456878799
29	Iaculis Aliquet Company	Ap #975-9108 Proin St.	t	18414841699
30	Lacus Associates	5557 Porttitor St.	t	99494761699
31	Lectus Sit Amet PC	319-8853 Dapibus Street	t	91391158399
32	Neque Ltd	P.O. Box 168, 7272 Orci Road	t	17525585199
33	Accumsan Convallis Ante LLP	270-2351 Lorem Ave	t	09871226599
34	Ullamcorper Nisl Arcu LLC	P.O. Box 511, 2948 Vitae, Street	t	29843803399
35	Metus In Nec Consulting	Ap #914-9538 Nulla. Street	t	76253347399
36	Sit Amet Consulting	Ap #447-2046 Blandit Rd.	t	18975930099
37	Pede Cras Inc.	Ap #433-9454 Sem. Av.	t	14274846299
38	Fringilla Limited	586-6462 Lacinia Street	t	79881126199
39	Nibh Lacinia Associates	P.O. Box 453, 5393 Augue. Av.	t	40760489999
40	Imperdiet Dictum Magna PC	Ap #704-7353 Non, St.	t	96951121399
41	Lacinia Sed Congue Incorporated	6952 Non Rd.	t	48687315899
42	Nisi Sem Semper LLP	1436 Dolor, St.	t	61692306799
43	Nec Ligula Consectetuer LLP	115-3703 Diam Street	t	13897328699
44	Adipiscing Elit Aliquam Company	208-360 Aliquet, Rd.	t	51346456999
45	Enim Etiam LLP	Ap #503-3544 Dolor, Road	t	34399272199
46	Neque Industries	296-9026 Semper Road	t	20596190199
47	Iaculis Lacus Foundation	479-1136 Praesent Avenue	t	68687269399
48	Enim Industries	Ap #160-223 Purus Road	t	51664472899
49	Fermentum Associates	1258 Odio Av.	t	98882589699
50	Ante Ltd	P.O. Box 856, 1976 Nulla St.	t	11949104099
51	Ut Sem Nulla LLC	P.O. Box 889, 553 Velit. Street	t	13712326199
52	Cras Inc.	312-1765 Ligula Rd.	t	33432586599
53	Eget Dictum Placerat LLC	Ap #277-7822 Dignissim Road	t	81498590399
54	Id PC	887-5843 Sem. Rd.	t	00314902299
55	Mi LLC	P.O. Box 365, 2329 Sit Avenue	t	01767853999
56	At Industries	Ap #681-5266 Urna. Road	t	22658025199
57	Nec Eleifend Ltd	P.O. Box 218, 183 Aliquam Rd.	t	60825699799
58	Vitae Diam LLC	Ap #159-2259 Erat, Av.	t	37865896499
59	Scelerisque Foundation	Ap #305-2206 At St.	t	06468762799
60	Nunc Institute	Ap #288-5208 Tellus St.	t	42653771899
61	Accumsan Laoreet Ipsum Company	718-312 Dolor Av.	t	86896496399
62	Orci Lacus PC	Ap #164-9437 Nibh Road	t	41437344999
63	Velit Quisque Varius Ltd	5365 Semper St.	t	39969070699
64	Adipiscing Institute	Ap #161-5536 Sem Av.	t	53761381799
65	Nullam Limited	650-2378 Semper Ave	t	06405876299
66	Ipsum Non Arcu Foundation	P.O. Box 768, 2866 Sed Avenue	t	33279622999
67	Diam Pellentesque Habitant Associates	P.O. Box 348, 1368 Etiam Avenue	t	69764702999
68	Commodo LLP	983-8065 Dictum Rd.	t	66234505499
69	Eu Odio Industries	304-9469 Ac Av.	t	63469670999
70	Fusce Mollis LLP	647-1837 Aliquam Street	t	96281271899
71	Vehicula Pellentesque Tincidunt Ltd	9950 Felis St.	t	13955601199
72	Ultrices LLC	P.O. Box 951, 1834 Pharetra. Rd.	t	93330580099
73	Mi Pede Nonummy LLP	Ap #663-1974 Elit Av.	t	86895777899
74	Magna Ut PC	638-7216 Nullam St.	t	49827918899
75	Fusce Mollis Industries	588-824 Tristique Rd.	t	07604370699
76	Mi Ac Corporation	9782 Felis. Rd.	t	23590668699
77	Non Company	1965 Curabitur Avenue	t	61998226999
78	Ridiculus Mus Limited	487-5078 At St.	t	53489867899
79	Elit Pharetra Ut Company	P.O. Box 912, 5112 Ac Road	t	81522390899
80	Tempor Arcu Vestibulum Industries	Ap #516-9195 Amet, Road	t	37893211499
81	Sed Neque LLP	205-8664 Neque. Rd.	t	76309309599
82	Ridiculus Mus Company	786 Mauris, Av.	t	76749332999
83	Amet Faucibus Foundation	Ap #223-5823 Tempor, Road	t	73517128099
84	Curae; LLP	P.O. Box 473, 4930 Aenean Road	t	78236268299
85	Pharetra Felis Foundation	957-1055 Lorem Road	t	92260474099
86	Lobortis Incorporated	Ap #280-2563 Quisque St.	t	36765401599
87	Nibh Aliquam Ornare Inc.	901-4338 Lectus St.	t	35833734599
88	Quis Urna Company	P.O. Box 258, 6464 Ut St.	t	25244968799
89	Sed Eget Incorporated	918-6308 Nunc Ave	t	56767165699
90	Nascetur Inc.	6713 Sociosqu St.	t	10710541399
91	Etiam Gravida Ltd	4304 Urna. Rd.	t	57230891799
92	Et Tristique Incorporated	P.O. Box 212, 7215 Ultrices. Road	t	48569826299
93	Neque Tellus Consulting	892-5326 Orci Av.	t	50972126399
94	Sed Foundation	Ap #543-7589 Et, Road	t	62262747399
95	Dis Parturient LLP	Ap #942-3834 Ipsum Road	t	49656818299
96	Nullam LLC	2031 Pellentesque St.	t	70252403599
97	Lorem Vehicula Inc.	P.O. Box 164, 5191 Scelerisque St.	t	59443071199
98	Eu Nulla At PC	414-6491 Elit, Street	t	91767004799
99	Ultrices Associates	Ap #875-4278 Id, Rd.	t	60990192899
100	Ultricies Dignissim Lacus Corp.	Ap #594-4049 Consectetuer Ave	t	49834574699
101	Augue Inc.	150-1370 Sagittis Rd.	t	00330167699
102	Semper Cursus LLC	P.O. Box 957, 9416 Aliquet, Avenue	t	04541861299
103	Sed Inc.	5623 Nonummy Rd.	t	25276724799
104	Enim Etiam LLC	P.O. Box 657, 9189 Elit. St.	t	94614101899
105	Massa Vestibulum Accumsan Inc.	6930 Nisl Avenue	t	44415745199
106	Rutrum Non Hendrerit Corporation	P.O. Box 393, 197 Urna. Street	t	31493443599
107	A Magna Lorem Incorporated	P.O. Box 502, 3472 In Rd.	t	57570605699
108	Amet Consectetuer Corp.	P.O. Box 345, 6615 Eu Ave	f	54284580599
109	Parturient Montes Nascetur Consulting	Ap #654-7544 Nullam St.	f	95579322999
110	Eleifend Industries	423-792 Faucibus Ave	f	84996982799
111	Sem Inc.	3220 Tristique Ave	f	08994301099
112	Amet Faucibus Consulting	P.O. Box 841, 7730 Malesuada St.	f	61801267099
113	Fermentum Fermentum Arcu Ltd	Ap #685-4647 Maecenas St.	f	57563654499
114	Cras Vehicula Aliquet Industries	8839 Faucibus Rd.	f	34723742899
115	Amet Luctus Institute	Ap #281-5830 Tincidunt St.	f	52568036899
116	Pulvinar Arcu Limited	P.O. Box 388, 9708 Consequat St.	f	28915344299
117	Mauris A Company	1558 Cubilia Rd.	f	21796698599
118	Tellus Faucibus Leo Corp.	7545 Iaculis Ave	f	84523867599
119	Pretium Aliquet Company	P.O. Box 537, 7736 Diam Road	f	61615064399
120	Vestibulum Neque Sed Foundation	P.O. Box 136, 7967 Cras Ave	f	64707059599
121	Lorem Eu Inc.	P.O. Box 504, 5094 Ligula. Avenue	f	60646243899
122	Mauris Sagittis Placerat Incorporated	P.O. Box 412, 9899 Donec Avenue	f	44779881499
123	Vulputate Mauris Sagittis Inc.	4345 Massa. Ave	f	96207530799
124	Semper Industries	7018 Lacus Av.	f	18271863299
125	Suspendisse Commodo Incorporated	360-8676 Egestas. Rd.	f	81982610099
126	Sed Orci Lobortis Foundation	Ap #750-6696 Et Avenue	f	84821515499
127	Semper Cursus Integer Associates	908-8486 Varius Street	f	50741534099
128	Curabitur Sed Limited	P.O. Box 843, 4681 Donec Street	f	97886454599
129	Erat In Corporation	Ap #231-9554 Sed Road	f	93254554699
130	Est PC	P.O. Box 150, 2213 Lectus Rd.	f	02971697799
131	In Industries	2196 Molestie Av.	f	28422843499
132	Nunc Laoreet Inc.	4496 Ligula. St.	f	98675051199
133	Risus Nunc Company	Ap #697-8809 In Rd.	f	57914185499
134	Purus In LLP	9154 Euismod Rd.	f	65675684799
135	Semper Tellus Id Consulting	P.O. Box 607, 4479 Fringilla Ave	f	19540493299
136	Aenean Massa LLP	P.O. Box 942, 2700 Mus. Av.	f	47209892099
137	Ut Erat Inc.	P.O. Box 670, 2825 In St.	f	72932086099
138	Et Magnis LLP	P.O. Box 896, 9448 Donec St.	f	68622473399
139	Pharetra Foundation	P.O. Box 870, 5167 Justo. Ave	f	40980916299
140	Egestas Fusce LLC	5056 Et, Road	f	24300718499
141	Dolor Tempus Institute	P.O. Box 122, 3866 At Ave	f	33851048499
142	At Auctor Foundation	Ap #627-4423 Velit. Avenue	f	17421719299
143	Sit LLC	P.O. Box 700, 7641 Quam Ave	f	73491198799
144	Arcu Aliquam Ultrices LLP	P.O. Box 566, 2579 Eget, Rd.	f	23452853099
145	Nonummy Ultricies Foundation	4566 Fermentum Avenue	f	23453989899
146	Amet Orci Ut Incorporated	883-852 Eleifend Rd.	f	42506189199
147	Pellentesque Massa Industries	4555 Eu Avenue	f	82525140899
148	Sem LLP	775-8416 Est. Av.	f	70869548599
149	Nisl Nulla LLC	3414 Quam, Av.	f	90234293299
150	Suscipit Associates	P.O. Box 151, 801 At, Road	f	99721643999
151	Nibh Limited	Ap #902-4313 Ac, St.	f	30618462499
152	Mauris Ipsum PC	Ap #445-9608 Cum Rd.	f	02913042699
153	Ut Institute	Ap #764-8806 Egestas. Rd.	f	01844680099
154	Sit Amet Foundation	189-791 Curabitur Av.	f	46550295099
155	Felis Ullamcorper LLP	Ap #472-8541 In Av.	f	17933736899
156	A Malesuada Id Industries	P.O. Box 254, 1789 Nam Av.	f	99477170499
157	Rutrum Non Hendrerit PC	193-585 Vel Av.	f	28201840099
158	Rhoncus PC	367-5640 Ut, Avenue	f	62455772999
159	Orci Luctus Et Limited	6757 Orci. Road	f	71419340599
160	Ipsum Consulting	371-8746 Suspendisse Ave	f	42740107899
161	In Incorporated	9589 Lorem. Rd.	f	13689097799
162	In Dolor Ltd	665-1929 Non Rd.	f	83345414099
163	Est Nunc Laoreet Incorporated	8040 Integer Avenue	f	06318677899
164	Tempus LLC	7497 Et Avenue	f	59527982299
165	Egestas Nunc Sed LLC	Ap #466-2533 A Av.	f	09992331699
166	Duis Mi Ltd	5357 Lacus. Road	f	33362741999
167	Nullam Nisl Consulting	P.O. Box 570, 1315 Curabitur Rd.	f	05629136799
176	Mauris Magna LLP	P.O. Box 870, 6080 Risus St.	f	66716256099
177	Est Ac Facilisis Ltd	4559 Leo. Av.	f	60807513799
178	Tempor Associates	895-6205 Egestas Ave	f	95815912899
179	Ut Nisi A Incorporated	454-9245 Erat, Av.	f	41803206299
180	Arcu Aliquam Industries	358-864 Laoreet, Rd.	f	60217957199
181	Tempor Foundation	Ap #728-8059 Enim Rd.	f	58443056599
182	Felis Industries	120-7787 Aptent Rd.	f	36372752199
183	Mattis Integer Ltd	Ap #896-3575 Volutpat St.	f	72413538399
184	Lacinia Incorporated	6068 Augue St.	f	65665534499
185	Feugiat Metus Limited	Ap #808-2985 Nec Street	f	86230984799
186	Sed Est Corp.	Ap #577-9884 Habitant St.	f	17283622899
187	Diam Vel LLC	P.O. Box 202, 2983 Non, Ave	f	28838693599
188	Varius Et Euismod Incorporated	541-8980 Interdum Rd.	f	16406984099
189	Eget Lacus Mauris Ltd	6503 Amet, St.	f	05890195899
190	Aenean Massa Integer Industries	128-6360 Aliquet Rd.	f	75825879199
191	Ac Corp.	P.O. Box 456, 6181 Duis Av.	f	48965173499
192	Augue Company	658-5380 Sed Av.	f	58588309499
193	Nec Imperdiet Nec Institute	272-3313 Elit Road	f	36221175799
194	Odio Auctor Vitae Ltd	215-2330 Arcu Road	f	33931486199
195	Dis Parturient Institute	6672 Enim. Av.	f	68363064399
196	Erat Inc.	837-3971 Sem. Rd.	f	73788838599
197	Nibh Quisque Nonummy Consulting	P.O. Box 334, 4035 Accumsan St.	f	32534344299
198	Phasellus Limited	757-4333 Mauris St.	f	74640434899
199	Ipsum Associates	P.O. Box 315, 2578 Quis Rd.	f	33247094199
200	Sed Dictum Associates	875-3682 Consequat Av.	f	88817660999
201	Etiam Institute	P.O. Box 109, 2592 Etiam Av.	f	50728621899
202	Scelerisque Dui Suspendisse LLP	P.O. Box 567, 3741 Ullamcorper. Rd.	f	20766210399
203	Augue Eu Tellus Limited	P.O. Box 524, 3255 Nec Av.	f	64944475399
204	Natoque Penatibus Limited	Ap #809-3096 Sit Road	f	21547783499
205	Dolor Elit Pellentesque Company	Ap #478-8731 Leo. Av.	f	47531304499
\.

COPY public.paths (id, name) FROM stdin;
1	Manikyur
2	Pedikyur
3	Narashchivanie nogtej
4	Dizajn
\.

COPY public.producers (id, name, country) FROM stdin;
1	Zinger	Germaniya
2	Yoko	Kitaj
3	Staleks	Rossiya
4	Metzger	Rossiya
5	RosBel	Rossiya
13	Citroen	American Samoa
14	RAM Trucks	El Salvador
15	Seat	Zambia
16	Ferrari	Christmas Island
17	Lexus	Kiribati
18	Renault	Wallis and Futuna
19	Mitsubishi Motors	Saudi Arabia
20	MINI	Croatia
21	Ford	Macedonia
22	FAW	Eritrea
6	Cakewalk	Martinique
7	Macromedia	Portugal
8	Sibelius	Laos
9	Borland	Trinidad and Tobago
10	Altavista	Guatemala
11	Apple Systems	Liberia
12	Microsoft	Palau
\.

COPY public.tools (id, name, producerid, type, price) FROM stdin;
15	feugiat placerat velit.	6	freza	335.00
16	vel faucibus	19	freza	489.00
26	nec, cursus a, enim.	7	freza	956.00
36	feugiat. Sed nec	19	freza	249.00
38	vitae nibh. Donec	10	freza	879.00
35	nec, malesuada ut,	4	freza	91.00
7	Bor almaznyj 173.524.023 sinij srednyaya 	5	freza	150.00
1	Pusher 2-h storonnij MC-0023 Pusher 13 sm	1	pusher	207.00
2	Shaber 130 mm glyancevyj SI 001	2	pusher	312.00
5	Nozhnicy dlya kutikuly (lezviya - 21 mm)(s chekhlom)	3	nozhnicy	1295.00
6	Nozhnicy dlya kutikuly Z	5	nozhnicy	1200.00
3	Kusachki dlya kozhi (rezhushaya chast 7 mm)NS-11-7	4	kusachki	980.00
4	Kusachki kutikulnye PN-836-AV-(9 mm)-BJ	3	kusachki	990.00
40	eget, ipsum.	22	Donec	379.00
60	sodales	14	ridiculus	320.00
101	mauris blandit mattis. Cras	15	ornare	554.00
9	eu, eleifend nec, malesuada	2	upchar	760.00
8	Bor almaznyj 198.012 Krasnyj 	5	freza	170.00
41	dolor dolor, tempus non,	14	kusachki	698.00
42	consequat dolor vitae dolor.	10	kusachki	600.00
43	rutrum non, hendrerit	14	kusachki	440.00
44	vitae	1	kusachki	838.00
10	inner	3	justo	354.00
100	non nisi.	4	orci	468.00
61	Vestibulum	13	nozhnicy	156.00
62	orci. Ut sagittis lobortis	21	nozhnicy	147.00
65	hendrerit.	16	nozhnicy	78.00
66	Curae; Phasellus ornare. Fusce	22	nozhnicy	80.00
68	Suspendisse aliquet	2	nozhnicy	277.00
69	pede. Cras vulputate velit	17	nozhnicy	139.00
84	scelerisque, lorem ipsum	6	pusher	125.00
85	vestibulum,	6	pusher	605.00
86	porttitor	7	pusher	181.00
45	sed	10	kusachki	437.00
46	id,	12	kusachki	606.00
47	nibh. Donec est mauris,	21	kusachki	488.00
48	purus, accumsan interdum	1	kusachki	242.00
13	sociis	8	freza	360.00
17	Aliquam rutrum lorem	10	freza	651.00
18	placerat	15	freza	613.00
19	fermentum	20	freza	586.00
20	erat volutpat.	7	freza	663.00
21	vel sapien imperdiet ornare.	7	freza	664.00
22	magna.	8	freza	442.00
23	quis, tristique	7	freza	469.00
24	sapien.	9	freza	496.00
25	ipsum porta elit,	2	freza	340.00
27	gravida. Praesent	15	freza	710.00
28	et, lacinia vitae, sodales	8	freza	935.00
29	ac orci. Ut semper	10	freza	819.00
30	non	16	freza	264.00
31	eros nec tellus.	18	freza	28.00
32	Maecenas	13	freza	147.00
33	sagittis lobortis	9	freza	392.00
34	ultricies adipiscing,	18	freza	686.00
37	Vestibulum accumsan neque et	15	freza	187.00
39	quam dignissim pharetra.	22	freza	741.00
11	dis parturient montes nascetur	21	freza	568.00
12	egestas rhoncus	7	freza	954.00
14	fames ac turpis egestas	17	freza	151.00
49	lacus	1	kusachki	35.00
50	vitae aliquam eros	5	kusachki	867.00
51	In ornare	1	kusachki	999.00
52	magna nec quam.	10	kusachki	282.00
53	consectetuer mauris id	21	kusachki	731.00
55	ridiculus mus.	14	kusachki	553.00
56	non, vestibulum nec,	3	kusachki	67.00
57	erat semper	4	kusachki	177.00
58	ac urna. Ut tincidunt	13	kusachki	299.00
59	gravida non, sollicitudin	5	kusachki	70.00
54	est,	15	kusachki	998.00
87	Sed diam lorem, auctor	10	pusher	714.00
89	orci sem	6	pusher	674.00
90	Quisque imperdiet,	18	pusher	597.00
91	dolor elit, pellentesque a,	13	pusher	507.00
93	tristique	7	pusher	202.00
94	parturient	15	pusher	74.00
95	pede	1	pusher	146.00
99	vel, venenatis vel, faucibus	18	pusher	925.00
98	nec tellus. Nunc	13	pusher	21.00
97	fermentum risus,	10	pusher	257.00
96	massa. Integer vitae	7	pusher	337.00
92	massa. Suspendisse	6	pusher	934.00
88	Vivamus	2	pusher	137.00
83	ligula eu enim.	20	pusher	60.00
82	non, sollicitudin a,	7	pusher	567.00
70	Vivamus nibh dolor, nonummy	16	nozhnicy	742.00
71	Nulla eu neque pellentesque	7	nozhnicy	995.00
72	Nunc ac sem	5	nozhnicy	785.00
73	laoreet lectus quis massa.	14	nozhnicy	626.00
74	varius orci, in	20	nozhnicy	577.00
75	nec metus facilisis lorem	8	nozhnicy	717.00
76	iaculis	21	nozhnicy	214.00
77	parturient montes, nascetur ridiculus	15	nozhnicy	117.00
78	ut, sem.	19	nozhnicy	32.00
67	ut, pellentesque	21	nozhnicy	830.00
64	justo.	5	nozhnicy	957.00
63	interdum ligula	19	nozhnicy	892.00
\.

SELECT pg_catalog.setval('public.classes_id_seq', 17, true);
SELECT pg_catalog.setval('public.coaches_id_seq', 106, true);
SELECT pg_catalog.setval('public.courses_id_seq', 13, true);
SELECT pg_catalog.setval('public.offices_id_seq', 205, true);
SELECT pg_catalog.setval('public.paths_id_seq', 4, true);
SELECT pg_catalog.setval('public.producers_id_seq', 22, true);
SELECT pg_catalog.setval('public.tools_id_seq', 101, true);

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.coach_office
    ADD CONSTRAINT coach_office_pkey PRIMARY KEY (coachid, officeid);
ALTER TABLE ONLY public.coach_tool
    ADD CONSTRAINT coach_tool_pkey PRIMARY KEY (toolid, coachid);
ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.course_tool
    ADD CONSTRAINT course_tool_pkey PRIMARY KEY (courseid, toolid);
ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.paths
    ADD CONSTRAINT paths_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT uniq_coachname UNIQUE (name);
ALTER TABLE ONLY public.courses
    ADD CONSTRAINT uniq_coursename UNIQUE (name);
ALTER TABLE ONLY public.offices
    ADD CONSTRAINT uniq_location UNIQUE (location);
ALTER TABLE ONLY public.offices
    ADD CONSTRAINT uniq_officename UNIQUE (name);
ALTER TABLE ONLY public.paths
    ADD CONSTRAINT uniq_pathname UNIQUE (name);
ALTER TABLE ONLY public.offices
    ADD CONSTRAINT uniq_phone UNIQUE (phone);
ALTER TABLE ONLY public.producers
    ADD CONSTRAINT uniq_producername UNIQUE (name);
ALTER TABLE ONLY public.tools
    ADD CONSTRAINT uniq_toolname UNIQUE (name);

CREATE INDEX classes_courseid_idx ON public.classes USING btree (courseid);
CREATE INDEX classes_nextdate_idx ON public.classes USING btree (nextdate);
CREATE INDEX coaches_experience_idx ON public.coaches USING btree (experience);
CREATE INDEX coaches_id_idx ON public.coaches USING btree (id);
CREATE INDEX course_tool_courseid_idx ON public.course_tool USING btree (courseid);
CREATE INDEX course_tool_toolid_idx ON public.course_tool USING btree (toolid);
CREATE INDEX courses_coachid_idx ON public.courses USING btree (coachid);
CREATE INDEX courses_id_idx ON public.courses USING btree (id);
CREATE INDEX courses_lower_idx ON public.courses USING btree (lower((name)::text));
CREATE INDEX offices_lower_idx ON public.offices USING btree (lower((name)::text));
CREATE INDEX producers_id_idx ON public.producers USING btree (id);
CREATE INDEX tools_id_idx ON public.tools USING btree (id);
CREATE INDEX tools_lower_idx ON public.tools USING btree (lower((type)::text));
CREATE INDEX tools_producerid_idx ON public.tools USING btree (producerid);

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_courseid_fkey FOREIGN KEY (courseid) REFERENCES public.courses(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_officeid_fkey FOREIGN KEY (officeid) REFERENCES public.offices(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.coach_office
    ADD CONSTRAINT coach_office_coachid_fkey FOREIGN KEY (coachid) REFERENCES public.coaches(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.coach_office
    ADD CONSTRAINT coach_office_officeid_fkey FOREIGN KEY (officeid) REFERENCES public.offices(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.coach_tool
    ADD CONSTRAINT coach_tool_coachid_fkey FOREIGN KEY (coachid) REFERENCES public.coaches(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.coach_tool
    ADD CONSTRAINT coach_tool_toolid_fkey FOREIGN KEY (toolid) REFERENCES public.tools(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.course_tool
    ADD CONSTRAINT course_tool_courseid_fkey FOREIGN KEY (courseid) REFERENCES public.courses(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.course_tool
    ADD CONSTRAINT course_tool_toolid_fkey FOREIGN KEY (toolid) REFERENCES public.tools(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_coachid_fkey FOREIGN KEY (coachid) REFERENCES public.coaches(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pathid_fkey FOREIGN KEY (pathid) REFERENCES public.paths(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_producerid_fkey FOREIGN KEY (producerid) REFERENCES public.producers(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
