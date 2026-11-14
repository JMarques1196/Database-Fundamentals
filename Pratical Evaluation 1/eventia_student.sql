DROP DATABASE IF EXISTS eventia;
CREATE DATABASE eventia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eventia;

CREATE TABLE venue (
  venue_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  city VARCHAR(80) NOT NULL,
  capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE event (
  event_id INT PRIMARY KEY,
  title VARCHAR(160) NOT NULL,
  event_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL,
  venue_id INT NOT NULL,
  CONSTRAINT chk_event_status CHECK (status IN ('scheduled','completed','cancelled')),
  CONSTRAINT fk_event_venue FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

CREATE TABLE artist (
  artist_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  country VARCHAR(80)
);

CREATE TABLE event_artist (
  event_id INT NOT NULL,
  artist_id INT NOT NULL,
  role VARCHAR(60) NOT NULL,
  fee DECIMAL(10,2) NOT NULL CHECK (fee >= 0),
  PRIMARY KEY (event_id, artist_id),
  FOREIGN KEY (event_id) REFERENCES event(event_id),
  FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  birth_date DATE
);

CREATE TABLE ticket (
  ticket_id INT PRIMARY KEY,
  event_id INT NOT NULL,
  customer_id INT NOT NULL,
  category VARCHAR(20) NOT NULL,
  price DECIMAL(8,2) NOT NULL CHECK (price > 0),
  purchase_date DATE NOT NULL,
  checkin_at DATETIME NULL,
  CONSTRAINT chk_ticket_category CHECK (category IN ('standard','premium','vip')),
  FOREIGN KEY (event_id) REFERENCES event(event_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE review (
  review_id INT PRIMARY KEY,
  event_id INT NOT NULL,
  customer_id INT NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment VARCHAR(500),
  created_at DATE NOT NULL,
  UNIQUE (event_id, customer_id),
  FOREIGN KEY (event_id) REFERENCES event(event_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- venue: 6 registos
INSERT INTO venue (venue_id, name, city, capacity) VALUES
(1,'Arena Atlântica','Lisboa',18000),
(2,'Casa do Rio','Porto',1600),
(3,'Teatro Central','Coimbra',900),
(4,'Pavilhão Sul','Faro',4200),
(5,'Auditório do Minho','Braga',1100),
(6,'Espaço Livre','Lisboa',650);

-- event: 9 registos
INSERT INTO event (event_id, title, event_date, status, venue_id) VALUES
(101,'Luzes do Tejo','2026-11-15','scheduled',1),
(102,'Noite do Norte','2026-09-20','completed',2),
(103,'Jazz ao Centro','2026-10-12','completed',3),
(104,'Maré Alta','2026-12-05','scheduled',2),
(105,'Ritmos do Sul','2026-11-28','scheduled',4),
(106,'Cordas do Minho','2027-01-10','scheduled',5),
(109,'Vozes de Coimbra','2026-07-16','completed',3),
(110,'Noite Aberta','2026-11-03','scheduled',6),
(111,'Encontro Acústico','2026-10-30','completed',5);

-- artist: 8 registos
INSERT INTO artist (artist_id, name, country) VALUES
(201,'Aurora Azul','Portugal'),
(202,'North Line','Portugal'),
(203,'Trio Mondego','Portugal'),
(204,'Delta Waves','Espanha'),
(205,'Maré Viva','Portugal'),
(206,'Faro Beat','Portugal'),
(207,'Electric Room','Reino Unido'),
(208,'Minho Strings','Portugal');

-- event_artist: 9 registos
INSERT INTO event_artist (event_id, artist_id, role, fee) VALUES
(101,201,'headliner',3500),
(102,202,'headliner',1200),
(103,203,'headliner',900),
(104,205,'headliner',1600),
(105,206,'headliner',1800),
(106,208,'headliner',1100),
(109,203,'guest',700),
(110,201,'guest',1000),
(111,208,'guest',650);

-- customer: 12 registos
INSERT INTO customer (customer_id, name, email, birth_date) VALUES
(501,'Ana Silva','ana.silva@example.pt','1993-04-12'),
(502,'Bruno Costa','bruno.costa@example.pt','1988-11-03'),
(503,'Carla Neves','carla.neves@example.pt','1996-01-20'),
(504,'Diogo Alves','diogo.alves@example.pt','1984-06-07'),
(505,'Eva Dias','eva.dias@example.pt','1999-09-14'),
(506,'Filipe Rocha','filipe.rocha@example.pt','1991-02-28'),
(507,'Gabriela Reis','gabriela.reis@example.pt','1995-12-09'),
(508,'Hugo Melo','hugo.melo@example.pt','1987-03-22'),
(509,'Inês Ramos','ines.ramos@example.pt','2000-07-18'),
(510,'João Matos','joao.matos@example.pt','1992-10-05'),
(511,'Leonor Vaz','leonor.vaz@example.pt','1998-08-11'),
(512,'Miguel Pires','miguel.pires@example.pt','1989-05-30');

-- ticket: 32 registos
INSERT INTO ticket (ticket_id, event_id, customer_id, category, price, purchase_date, checkin_at) VALUES
(9001,102,501,'premium',50,'2026-09-02','2026-09-20 20:10:00'),
(9002,102,502,'standard',40,'2026-09-03',NULL),
(9003,102,503,'standard',40,'2026-09-05','2026-09-20 20:05:00'),
(9004,102,504,'vip',75,'2026-09-06','2026-09-20 19:58:00'),
(9005,102,505,'standard',40,'2026-09-07','2026-09-20 20:15:00'),
(9006,103,501,'standard',30,'2026-09-20','2026-10-12 18:45:00'),
(9007,103,506,'standard',30,'2026-09-21','2026-10-12 18:50:00'),
(9008,103,507,'premium',45,'2026-09-22','2026-10-12 18:47:00'),
(9009,103,508,'standard',30,'2026-09-23',NULL),
(9010,109,503,'standard',25,'2026-07-01','2026-07-16 19:00:00'),
(9011,109,506,'standard',25,'2026-07-02','2026-07-16 18:55:00'),
(9012,109,509,'premium',40,'2026-07-03','2026-07-16 18:52:00'),
(9013,111,501,'premium',35,'2026-10-01','2026-10-30 20:00:00'),
(9014,111,502,'standard',25,'2026-10-02','2026-10-30 20:03:00'),
(9015,101,501,'vip',90,'2026-10-10',NULL),
(9016,101,510,'standard',55,'2026-10-11',NULL),
(9017,101,511,'premium',70,'2026-10-12',NULL),
(9018,101,512,'standard',55,'2026-10-13',NULL),
(9019,104,502,'standard',35,'2026-10-14',NULL),
(9020,104,503,'premium',50,'2026-10-15',NULL),
(9021,104,504,'standard',35,'2026-10-16',NULL),
(9022,104,505,'standard',35,'2026-10-17',NULL),
(9023,105,506,'standard',42,'2026-10-18',NULL),
(9024,105,507,'premium',60,'2026-10-19',NULL),
(9025,105,508,'standard',42,'2026-10-20',NULL),
(9026,105,509,'vip',85,'2026-10-21',NULL),
(9027,105,510,'standard',42,'2026-10-22',NULL),
(9028,106,511,'standard',28,'2026-10-23',NULL),
(9029,106,512,'standard',28,'2026-10-24',NULL),
(9033,110,504,'standard',32,'2026-10-27',NULL),
(9034,110,505,'premium',48,'2026-10-28',NULL),
(9035,110,506,'standard',32,'2026-10-29',NULL);

-- review: 8 registos
INSERT INTO review (review_id, event_id, customer_id, rating, comment, created_at) VALUES
(7001,102,501,5,'Excelente organização.','2026-09-21'),
(7002,102,503,4,'Boa noite.','2026-09-21'),
(7003,102,505,4,'Gostei.','2026-09-22'),
(7004,103,501,5,'Muito bom.','2026-10-13'),
(7005,103,507,4,'Bom concerto.','2026-10-13'),
(7006,109,503,3,'Interessante.','2026-07-17'),
(7007,109,509,5,'Excelente.','2026-07-17'),
(7008,111,502,4,'Boa sessão.','2026-10-31');
