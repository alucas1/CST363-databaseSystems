-- AUTHORS: Alberto Lucas, Gabriel De Leon
-- DATE: 02/02/2021
-- CLASS: CST363
-- DESCRIPTION: creates the database for project 2 - Drug store DB design
-- Also Contains sample data

-- Create the database
DROP DATABASE IF EXISTS drugchain;
CREATE DATABASE drugchain;

-- Select the database
USE drugchain;

-- Create tables and data

-- ------------ --
-- DOCTOR TABLE --
-- ------------ --
CREATE TABLE doctor
  (
     docid              CHAR(5) NOT NULL,
     docdatehired		DATE NOT NULL,
     docspecialty       VARCHAR(45) NOT NULL,
     docssn             INT(9) NOT NULL,
     docphonenumber     CHAR(12) NOT NULL,
     docyearsexperience INT NOT NULL,
     docfirstname       VARCHAR(45) NOT NULL,
     doclastname        VARCHAR(45) NOT NULL,
     PRIMARY KEY (docid)
  );

-- -------------- --
-- PHARMACY TABLE --
-- -------------- --
CREATE TABLE pharmacy
  (
     pharmid           CHAR(5) NOT NULL,
     pharmname         VARCHAR(45) NOT NULL,
     pharmphonenumber  CHAR(12) NOT NULL,
     pharmzip          CHAR(5) NOT NULL,
     pharmstreetnumber VARCHAR(10) NOT NULL,
     pharmstreetname   VARCHAR(45) NOT NULL,
     pharmcity         VARCHAR(45) NOT NULL,
     pharmstate        CHAR(2) NOT NULL,
     PRIMARY KEY (pharmid)
  );

-- ------------------- --
-- PHARMACOMPANY TABLE --
-- ------------------- --
CREATE TABLE pharmacompany
  (
     pcname        VARCHAR(45) NOT NULL,
     pcphonenumber CHAR(12) NOT NULL,
     PRIMARY KEY (pcname)
  );

-- ------------- --
-- PATIENT TABLE --
-- ------------- --
CREATE TABLE patient
  (
     patientid           CHAR(10) NOT NULL,
     patientdob          DATE NOT NULL,
     patientssn          INT(9) NOT NULL,
     patientfirstname    VARCHAR(45) NOT NULL,
     patientlastname     VARCHAR(45) NOT NULL,
     patientzip          CHAR(5) NOT NULL,
     patientstreetnumber VARCHAR(10) NOT NULL,
     patientstreetname   VARCHAR(45) NOT NULL,
     patientcity         VARCHAR(45) NOT NULL,
     patientstate        CHAR(2) NOT NULL,
     primarycareid       CHAR(5) NOT NULL,
     PRIMARY KEY (patientid),
     FOREIGN KEY (primarycareid) REFERENCES doctor(docid)
  );

-- --------------- --
--  CONTRACT TABLE --
-- --------------- --
CREATE TABLE contract
  (
     contractid                  CHAR(10) NOT NULL,
     contractstartdate           DATE NOT NULL,
     contractenddate             DATE NOT NULL,
     contracttext                VARCHAR(5000) NOT NULL,
     contractsupervisorfirstname VARCHAR(45) NOT NULL,
     contractsupervisorlastname  VARCHAR(45) NOT NULL,
     pcname                      VARCHAR(45) NOT NULL,
     pharmid                     CHAR(5) NOT NULL,
     PRIMARY KEY (contractid),
     FOREIGN KEY (pcname) REFERENCES pharmacompany(pcname),
     FOREIGN KEY (pharmid) REFERENCES pharmacy(pharmid),
     CHECK (contractstartdate <= contractenddate)
  );

-- ---------- --
-- DRUG TABLE --
-- ---------- --
CREATE TABLE drug
  (
     drugname    VARCHAR(45) NOT NULL,
     drugformula VARCHAR(45) NOT NULL,
     pcname      VARCHAR(45) NOT NULL,
     PRIMARY KEY (drugname),
     FOREIGN KEY (pcname) REFERENCES pharmacompany(pcname)
  );

-- ------------------ --
-- PRESCRIPTION TABLE --
-- ------------------ --
CREATE TABLE prescription
  (
	 rxid 			 CHAR(10) NOT NULL,
     patientid       CHAR(10) NOT NULL,
     drugname        VARCHAR(45) NOT NULL,
     prescdate       DATE NOT NULL,
     prescquantity   INT NOT NULL,
     docid           CHAR(5) NOT NULL,
     prescdatefilled DATE,
     pharmacyfilled  CHAR(5),
     PRIMARY KEY (rxid),
     FOREIGN KEY (patientid) REFERENCES patient(patientid),
     FOREIGN KEY (drugname) REFERENCES drug(drugname),
     FOREIGN KEY (docid) REFERENCES doctor(docid),
     FOREIGN KEY (pharmacyfilled) REFERENCES pharmacy(pharmid)
  );

-- ----------- --
-- SELLS TABLE --
-- ----------- --
CREATE TABLE sells
  (
     drugname VARCHAR(45) NOT NULL,
     pharmid  CHAR(5) NOT NULL,
     price    NUMERIC(7, 2) NOT NULL,
     PRIMARY KEY (drugname, pharmid),
     FOREIGN KEY (drugname) REFERENCES drug(drugname),
     FOREIGN KEY (pharmid) REFERENCES pharmacy(pharmid)
  );


-- INSERT statements for sample data --

INSERT INTO doctor VALUES ('AL001', '2020-01-01', 'Healer', 343456789, '902-959-2989', '5', 'Alberto', 'Lucas');
INSERT INTO doctor VALUES ('TD001', '2019-01-01', 'Surgeon', 124556758, '409-749-4329', '15', 'The', 'Doktor');
INSERT INTO doctor VALUES ('GW001', '2018-01-01', 'Psychiatry', 423456433, '949-949-7958', '35', 'George', 'Washington');
INSERT INTO doctor VALUES ('EM001', '2017-01-01', 'General', 153356788, '957-892-4979', '54', 'Elon', 'Musk');
INSERT INTO doctor VALUES ('GL001', '2016-01-01', 'Revival', 523456749, '905-989-7949', '23', 'Gabriel', 'DeLeon');


INSERT INTO pharmacy VALUES ('CVS01','CVS','908-483-6567', '85645', '12463', 'Hello st.', 'Portland', 'OR');
INSERT INTO pharmacy VALUES ('RTA01','Rite Aid','859-128-4567', '16348', '62356', 'What st.', 'Ontario', 'CA');
INSERT INTO pharmacy VALUES ('WAG01','Walgreens','909-863-4567', '46345', '62455', 'Hello st.', 'Pasadena', 'CA');


INSERT INTO pharmacompany VALUES ('BioMedica','716-121-5846');
INSERT INTO pharmacompany VALUES ('Pfizer','769-134-5142');
INSERT INTO pharmacompany VALUES ('Blackmart','629-181-5249');
INSERT INTO pharmacompany VALUES ('Innovate','219-834-5646');
INSERT INTO pharmacompany VALUES ('Zombietech','621-134-5649');


INSERT INTO patient VALUES ('TP00000001','2000-01-01', 250385914, 'Test', 'Person', '85645', '12463', 'Hello st.', 'Claremont', 'CA', 'AL001');
INSERT INTO patient VALUES ('LS00000002','1999-01-01', 514303095, 'Luke', 'Skywalker', '46345', '62455', 'Hello st.', 'NewYork', 'NY', 'GL001');
INSERT INTO patient VALUES ('JT00000003','1998-01-01', 446244390, 'John', 'Talk', '85645', '63455', 'GoodBye st.', 'Claremont', 'CA', 'AL001');
INSERT INTO patient VALUES ('MY00000004','1997-01-01', 764871750, 'Master', 'Yoda', '12345', '12456', 'Hello st.', 'Ontario', 'CA', 'GW001');
INSERT INTO patient VALUES ('TL00000005','1996-01-01', 134403490, 'Tyrion', 'Lannister', '52658', '32456', 'Yes st.', 'Dallas', 'TX', 'TD001');


INSERT INTO contract VALUES ('CVS0100001','2020-01-01', '2024-01-02', 'Sample text', 'steve', 'buscetti', 'BioMedica', 'CVS01');
INSERT INTO contract VALUES ('CVS0100002','2019-01-01', '2023-01-02', 'Sample text', 'mark', 'hamill', 'Blackmart', 'CVS01');
INSERT INTO contract VALUES ('RTA0100001','2017-01-01', '2021-01-02', 'Sample text', 'clark', 'kent', 'Pfizer', 'RTA01');
INSERT INTO contract VALUES ('WAG0100001','2016-01-01', '2020-01-02', 'Sample text', 'iron', 'man', 'Zombietech', 'WAG01');


INSERT INTO drug VALUES ('manaplus','3-xeto-lio pharmahol','BioMedica');
INSERT INTO drug VALUES ('aspirin','2-Acetoxybenzoic acid','Zombietech');
INSERT INTO drug VALUES ('supermana','3-xeto-lio pharmahol','Blackmart');
INSERT INTO drug VALUES ('claratin','Loratadine','Pfizer');
INSERT INTO drug VALUES ('vicodin','hydrocodone','Blackmart');


INSERT INTO prescription VALUES ('0456FFDS5H', 'LS00000002','manaplus', '2019-01-01', 50, 'AL001', '2020-01-02', 'CVS01');
INSERT INTO prescription VALUES ('6D56GDF4G5', 'LS00000002','aspirin', '2020-01-01', 45, 'AL001', NULL, NULL);
INSERT INTO prescription VALUES ('LJK450KJL5', 'JT00000003','supermana', '2020-01-01', 80, 'AL001', NULL, NULL);
INSERT INTO prescription VALUES ('RET0456ETR', 'MY00000004','supermana', '2020-01-01', 75, 'EM001', NULL, NULL);
INSERT INTO prescription VALUES ('KJ0JKG6506', 'TL00000005','vicodin', '2020-01-01', 15, 'GL001', NOW(), 'RTA01');
INSERT INTO prescription VALUES ('0456GGDS5H', 'LS00000002','manaplus', '2019-01-01', 50, 'TD001', '2020-01-02', 'CVS01');
INSERT INTO prescription VALUES ('6F5FFDFGG5', 'LS00000002','aspirin', '2020-01-01', 45, 'GW001', '2020-01-02', 'WAG01');
INSERT INTO prescription VALUES ('HHHHHHHHHH', 'JT00000003','supermana', '2020-01-01', 80, 'GW001', '2020-01-02', 'WAG01');
INSERT INTO prescription VALUES ('FDLJKLDFGJ', 'MY00000004','supermana', '2020-01-01', 75, 'EM001','2020-01-02', 'CVS01');
INSERT INTO prescription VALUES ('EIWORUOTOI', 'TL00000005','vicodin', '2020-01-01', 15, 'GL001', NOW(), 'RTA01');
INSERT INTO prescription VALUES ('045SDKFS5H', 'LS00000002','manaplus', '2019-01-01', 50, 'TD001', '2020-01-02', 'CVS01');
INSERT INTO prescription VALUES ('KLJSDEIIII', 'LS00000002','aspirin', '2020-01-01', 45, 'GW001', '2020-01-02', 'RTA01');
INSERT INTO prescription VALUES ('564FDSDSFF', 'JT00000003','supermana', '2020-01-01', 80, 'AL001', '2020-01-02', 'WAG01');
INSERT INTO prescription VALUES ('897FSDDSF7', 'MY00000004','claratin', '2020-01-01', 75, 'EM001','2020-01-02', 'RTA01');


INSERT INTO sells VALUES ('manaplus','RTA01', 20.00);
INSERT INTO sells VALUES ('supermana','RTA01', 30.00);
INSERT INTO sells VALUES ('claratin','RTA01', 20.00);
INSERT INTO sells VALUES ('vicodin','RTA01', 50.00);
INSERT INTO sells VALUES ('manaplus','WAG01', 25.00);
INSERT INTO sells VALUES ('supermana','WAG01', 35.00);
INSERT INTO sells VALUES ('claratin','WAG01', 10.00);
INSERT INTO sells VALUES ('vicodin','WAG01', 20.00);
INSERT INTO sells VALUES ('manaplus','CVS01', 15.00);
INSERT INTO sells VALUES ('supermana','CVS01', 15.00);
