CREATE DATABASE Flight_Management_System
USE Flight_Management_System
USE master



CREATE TABLE Airline
(
	Airline_code int NOT NULL,
	Airline_name varchar(50) NOT NULL,
	Owned_company varchar(100) NOT NULL,
	Address varchar(200) NOT NULL,
	Email varchar(50) NOT NULL,
	Website varchar(50) NULL,
	Fleet_size int NULL,
	Commenced_year int NULL CONSTRAINT Df_commenced_year DEFAULT 1950,
	CONSTRAINT PK_Airline PRIMARY KEY(Airline_code)
)


CREATE TABLE Airport
(
   Airport_code char(3) NOT NULL,
   Airport_name varchar(50) NOT NULL,
   City varchar (30) NOT NULL,
   Country varchar(30) NOT NULL,
   Established_year int NULL CONSTRAINT Df_established_year DEFAULT 2000,
   CONSTRAINT PK_Airport PRIMARY KEY(Airport_code),
)

CREATE TABLE Airline_Destinations
(
    Airline_code int NOT NULL,
    Destination varchar(50) NOT NULL,
    CONSTRAINT PK_Airline_Destinations PRIMARY KEY(Airline_code, Destination),
    CONSTRAINT FK_Airline_Destinations FOREIGN KEY(Airline_code) REFERENCES Airline(Airline_code)
)

CREATE TABLE Flight
(
    Flight_no int NOT NULL,
	Type varchar(15) NOT NULL,
	Estimated_arrival_time Time(0) NOT NULL,
	Estimated_departure_time Time(0) NOT NULL,
	Duration Time(0) NULL CONSTRAINT Df_duration DEFAULT '01:00:00',
	Landing_information varchar(200) NULL,
	Take_off_information varchar(200) NULL,
	Airline_code int NOT NULL,
	CONSTRAINT PK_Flight PRIMARY KEY(Flight_no),
	CONSTRAINT FK_Flight FOREIGN KEY(Airline_code) 
	REFERENCES Airline(Airline_code)
)


CREATE TABLE Aircrew
(
    Staff_ID int NOT NULL,
	Designation varchar(30) NOT NULL,
	Joined_date date NOT NULL,
	Work_experience float(3) NULL CONSTRAINT Df_Work_experience DEFAULT 2,
	CONSTRAINT Chk_work_experinece CHECK(Work_experience >= 2), 
	Passport_no varchar(20) NOT NULL,
	Airline_code int NOT NULL,
	CONSTRAINT PK_Aircrew PRIMARY KEY(Staff_ID),
	CONSTRAINT FK_Aircrew FOREIGN KEY(Airline_code) 
	REFERENCES Airline(Airline_code)
)



CREATE TABLE Aircraft
(
    Aircraft_code char(4) NOT NULL,
	Aircraft_name varchar(30) NOT NULL,
	Model int NOT NULL,
	MFD_company char(100) NULL CONSTRAINT Df_MFD_company DEFAULT 'Boeing',
	Maximum_seats int NOT NULL CONSTRAINT Chk_maximum_seats CHECK(Maximum_seats >= 100),
	Airline_code int NOT NULL,
	CONSTRAINT PK_Aircraft PRIMARY KEY(Aircraft_code),
	CONSTRAINT FK_Aircraft FOREIGN KEY(Airline_code) REFERENCES Airline(Airline_code)
)



CREATE TABLE Flight_leg
(
    Leg_no int NOT NULL,
	Status varchar(15) NOT NULL,
	Date_of_flight Date NOT NULL,
	Actual_arrival_time time(0) NOT NULL,
	Actual_departure_time time(0) NOT NULL,
	Arrival_terminal_no int NOT NULL,
	Departure_terminal_no int NOT NULL,
	Remark varchar(150) NULL CONSTRAINT Default_remark DEFAULT 'Technical Failure',
	Aircrew_check_in_time Time(0) NOT NULL,
	Staff_ID int NOT NULL,
	Flight_no int NOT NULL,
	CONSTRAINT PK_Flight_leg_T1 PRIMARY KEY(Leg_no),
	CONSTRAINT FK1_Flight_leg_T1 FOREIGN KEY(Staff_ID) REFERENCES Aircrew(Staff_ID),
	CONSTRAINT FK2_Flight_leg_T1 FOREIGN KEY(Flight_no) REFERENCES Flight(Flight_no)
)



CREATE TABLE Passenger_T1
(
   Passenger_passport_no varchar(20) NOT NULL,
   Passenger_name varchar(100) NOT NULL,
   Nationality varchar(30) NOT NULL,
   Date_of_Birth date NOT NULL,
   Gender varchar(10) NOT NULL,
   Passport_issued_date date NOT NULL,
   Passport_expiry_date date NOT NULL,
   Class varchar(30) NOT NULL CONSTRAINT Df_class DEFAULT 'Economy',
   Baggage_weight_KG float(6) NOT NULL 
   CONSTRAINT Chk_baggage_weight CHECK(Baggage_weight_KG <= 40),
   Ticket_no varchar(20) NOT NULL CONSTRAINT unq_ticket_no UNIQUE,
   Leg_no int NOT NULL,
   Guardian_passport_no varchar(20) NULL,
   CONSTRAINT PK_Passenger_T1 PRIMARY KEY(Passenger_passport_no),
   CONSTRAINT FK1_Passenger_T1 FOREIGN KEY(Leg_no) 
   REFERENCES Flight_leg(Leg_no),
   CONSTRAINT FK2_Passenger_T1 FOREIGN KEY(Guardian_passport_no) 
   REFERENCES Passenger_T1(Passenger_passport_no)

)

CREATE TABLE Passenger_T2
(
    Leg_no int NOT NULL,
	Passenger_check_in_time Time(0) NOT NULL,
	Seat_no int NOT NULL,
	CONSTRAINT PK_Passenger_T2 PRIMARY KEY(Leg_no),
    CONSTRAINT FK_Passenger_T2 FOREIGN KEY(Leg_no) 
	REFERENCES Flight_leg(Leg_no)
)

CREATE TABLE Arrival
(
    Leg_no int NOT NULL,
	Baggage_belt_no int NOT NULL CONSTRAINT Unq_baggage_belt_no_of_arrival UNIQUE,
	CONSTRAINT PK_Arrival PRIMARY KEY(Leg_no),
	CONSTRAINT FK_Arrival FOREIGN KEY(Leg_no) REFERENCES Flight_leg(Leg_no)
)


CREATE TABLE Departure
(
   Leg_no int NOT NULL,
   Gate_no int NOT NULL CONSTRAINT Df_gate_no DEFAULT 01,
   Boarding_time Time(0) NOT NULL,
   CONSTRAINT PK_Departure PRIMARY KEY(Leg_no),
   CONSTRAINT FK_Departure FOREIGN KEY(Leg_no) REFERENCES Flight_leg(Leg_no)
)

CREATE TABLE Flight_Schedule
(
    Flight_no int NOT NULL,
	Scheduled_days varchar(10) NOT NULL,
	CONSTRAINT PK_Flight_Schedule PRIMARY KEY(Flight_no, Scheduled_days),
	CONSTRAINT FK_Flight_Schedule FOREIGN KEY(Flight_no) REFERENCES Flight(Flight_no)
)


CREATE TABLE Special_requirement
(
    Passenger_passport_no varchar(20) NOT NULL,
	requirement varchar(200) NOT NULL,
	CONSTRAINT PK_Special_requirement PRIMARY KEY(Passenger_passport_no,requirement),
	CONSTRAINT FK_Special_requirement FOREIGN KEY(Passenger_passport_no) 
	REFERENCES Passenger_T1(Passenger_passport_no)
)


CREATE TABLE Airline_Airport
(
    Airline_code int NOT NULL,
	Airport_code char(3) NOT NULL,
	CONSTRAINT PK_Airline_Airport PRIMARY KEY(Airline_code, Airport_code),
	CONSTRAINT FK1_Airline_Airport FOREIGN KEY(Airline_code) 
	REFERENCES Airline(Airline_code),
	CONSTRAINT FK2_Airline_Airport FOREIGN KEY(Airport_code) 
	REFERENCES Airport(Airport_code)
)



CREATE TABLE Airline_Contact_Number
(
    Airline_code int NOT NULL,
	Contact_no int NOT NULL,
	CONSTRAINT PK_Airline_Contact_Number PRIMARY KEY(Airline_code,Contact_no),
	CONSTRAINT FK_Airline_Contact_Number FOREIGN KEY(Airline_code) 
	REFERENCES Airline(Airline_code)
)


CREATE TABLE Flight_Airport
(
    Flight_no int NOT NULL,
	Airport_code char(3) NOT NULL,
	CONSTRAINT PK_Flight_Airport PRIMARY KEY(Flight_no, Airport_code),
	CONSTRAINT FK1_Flight_Airport FOREIGN KEY(Flight_no) REFERENCES Flight(Flight_no),
	CONSTRAINT FK2_Flight_Airport FOREIGN KEY(Airport_code) REFERENCES Airport(Airport_code)
)

CREATE TABLE Aircraft_Flight_leg
(
    Aircraft_code char(4) NOT NULL,
	Leg_no int NOT NULL,
	CONSTRAINT PK_Aircraft_Flight_leg PRIMARY KEY(Aircraft_code, Leg_no),
	CONSTRAINT FK1_Aircraft_Flight_leg FOREIGN KEY(Aircraft_code) REFERENCES Aircraft(Aircraft_code),
	CONSTRAINT FK2_Aircraft_Flight_leg FOREIGN KEY(Leg_no) REFERENCES Flight_leg(Leg_no)
)

CREATE TABLE Aircrew_qualification
(
   Staff_ID int NOT NULL,
   Qualification varchar(200) NOT NULL,
   CONSTRAINT PK_Aircrew_qualification PRIMARY KEY(Staff_ID, Qualification),
   CONSTRAINT FK_Aircrew_qualification FOREIGN KEY(Staff_ID ) REFERENCES Aircrew(Staff_ID )
)



select * from Airline
select * from Airport
select * from Airline_Destinations
select * from Aircrew
select * from Aircraft
select * from Aircraft_Flight_leg
select * from Departure
select * from Arrival
select * from Passenger_T1
select * from Passenger_T2
select * from Special_requirement
select * from Flight_Airport
select * from Airline_Airport
select * from Airline_Contact_Number
select * from Flight_Schedule
select * from Aircrew_qualification
select * from Flight
select * from Flight_leg




insert into Airline values(603,'Sri Lanka Airlines','Sri Lankan Government','SriLankan Airlines Ltd., Airline Centre,Bandaranaike International Airport,Katunayake,
Sri Lanka.','feedback@srilankan.com','www.srilankan.com',27,1998)
insert into Airline values(016,'United Airlines','United Continental Holdings','233 S Wacker Dr, Chicago, IL 60606','feedback@unitedairlines.com','www.united.com',758,1931)
insert into Airline values(250,'Uzbekistan Airways','Uzbekistan Government','51 Amir Temur Ave., Tashkent','uzairplus@uzairways.com','www.uzairways.com',31,1992)
insert into Airline values(738,'Vietnam Airlines','Vietnam Governmnet','200 Nguyen Son Str., Long Bien Dist., Hanoi, Vietnam','lotusmiles@vietnamairlines.com ',
'www.vietnamairlines.com',87,1956)
insert into Airline values(235,'Turkish Airlines','Turkey Wealth Fund','THY A.O. Genel Yonetim Binasi Ataturk Airport, Yesilkoy','turkeyairlines@customerfeedback.com',
'www.turkishairlines.com',329,1933)
insert into Airline values(618,'Singapore Airlines','Temasek Holdings (Pvt) Ltd','Singapore Airlines Ltd. Airline House 25 Airline Road Singapore 819829',
'saa_feedback@singaporeair.com.sg','www.singaporeair.com',117,1947)
insert into Airline values(180,'Korean Air Airlines','Korea Airport Service Co., Ltd.','9th floor of Korean Air Building, 117 Seosomun-Ro (3-41, Seosomun-dong),
Chung-gu, Seoul, South Korea','customersvc@koreanair.com','www.koreanair.com',174,1962)
insert into Airline values(131,'Japan Airlines','Japan Airport Terminal Co., Ltd.','Nomura Real Estate Bldg., 2-4-11 Higashi-Shinagawa, Shinagawa-ku, Tokyo',
'japanairlines@feedback.com','www.jal.co.jp',164,1951)
insert into Airline values(297,'China Airlines','China Aviation Development Foundation','No. 1, Hangzhan S. Rd, Dayuan Dist, Taoyuan City, 33758 ',
'chinaairlines@feedback.com','www.china-airlines.com',88,1959)
insert into Airline values(001,'American Airlines','American Airlines Group','4333 Amon Carter Blvd, Fort Worth, TX 76155','americanairlines@customercare.us',
'www.americanairlines.com',949,1926)
insert into Airline values(014,'Air Canada','Letko, Brosseau & Associates Inc.','7373 Boulevard de la Côte-Vertu,  Saint Laurent, QC H4S 1Z3','aircanada@canada.ca',
'www.aircanada.com',186,1937)
insert into Airline values(098,'Air India','Indian Government','3 SAFDARJUNG AIRPORT ,Aurobindo Marg.New Delhi','call.del@airindia.in','www.airindia.in',118,1932)
insert into Airline values(057,'Air France','France Government','45 Rue de Paris, 95747 Roissy CDG Cedex, France','mail.internet.afc@airfrance.fr',
'www.airfrance.fr',212,1933)
insert into Airline values(006,'Delta Airlines','Berkshire Hathaway Inc.','1030 Delta Blvd, Atlanta, GA 30354','delta@airlines.us','www.delta.com',878,1924)
insert into Airline values(081,'Qantas Airlines','Qantas','Qantas, 10 Bourke road Mascot NSW 2020','qantasairlines@qantas.com','www.qantas.com',131,1920)

insert into Flight values(1235,'Arrival','11:25:00','02:00:00','02:25:00','Landing successfull','Take off succesfull',603)
insert into Flight values(7561,'Arrival','13:56:00','17:25:00','04:21:00','Landing successfull','Take off succesfull',016)
insert into Flight values(4375,'Departure','10:00:00','23:15:00','13:15:00','Ridirected to Mattala International Airport','Take off succesfull',250)
insert into Flight values(7566,'Arrival','21:50:00','02:05:00','19:05:00','Landing successfull','Take off succesfull',738)
insert into Flight values(1375,'Arrival','04:40:00','13:10:00','08:10:00','Landing delayed due to extreme weather','Take off succesfull',235)
insert into Flight values(7543,'Departure','02:00:00','00:20:00','10:20:00','Landing successfull','Take off succesfull',618)
insert into Flight values(4367,'Departure','00:40:00','05:10:00','04:30:00','Landing successfull','Take off delayed',098)
insert into Flight values(7334,'Arrival','17:50:00','03:45:00','09:40:00','Successfully landed to runway 02','Take off succesfull',180)
insert into Flight values(2354,'Departure','17:30:00','10:00:00','17:30:00','Landing successfull','Take off succesfull',297)
insert into Flight values(9877,'Departure','16:10:00','01:30:00','10:20:00','Landing successfull','Take off canceled',001)
insert into Flight values(8006,'Departure','09:50:00','16:20:00','06:50:00','Landing delayed due to extreme weather','Take off succesfull',006)
insert into Flight values(3314,'Arrival','03:30:00','17:00:00','15:30:00','Landing successfull','Take off delayed',081)
insert into Flight values(1434,'Departure','10:00:00','12:12:00','2:12:00','Landing successfull','Take off succesfull',014)
insert into Flight values(9880,'Arrival','18:05:00','00:00:00','05:55:00','Landing delayed due to technical failure','Take off canceled',131)
insert into Flight values(1256,'Departure','06:25:00','10:55:00','03:20:00','Landing successfull','Take off succesfull',057)

insert into Flight_Schedule values(1235,'Monday')
insert into Flight_Schedule values(1235,'Wednesday')
insert into Flight_Schedule values(7561,'Monday')
insert into Flight_Schedule values(4375,'Saturday')
insert into Flight_Schedule values(4375,'Sunday')
insert into Flight_Schedule values(1375,'Thursday')
insert into Flight_Schedule values(7543,'Monday')
insert into Flight_Schedule values(4367,'Friday')
insert into Flight_Schedule values(7334,'Saturday')
insert into Flight_Schedule values(2354,'Saturday')
insert into Flight_Schedule values(9877,'Tuesday')
insert into Flight_Schedule values(9880,'Monday')
insert into Flight_Schedule values(9880,'Tuesday')
insert into Flight_Schedule values(1256,'Friday')
insert into Flight_Schedule values(1434,'Sunday')

insert into Flight_leg values(315,'On-air','2018/12/02','12:00:00','10:20:00',1,3,null,'12:10:00',1010515,1235)
insert into Flight_leg values(458,'Canceled','2018/12/02','23:40:00','00:00:00',2,5,'Technical error','00:00:00',1010474,7561)
insert into Flight_leg values(346,'Delayed','2018/12/03','10:35:00','15:20:00',5,10,'Heavy traffic volume','10:50:00',1010647,4375)
insert into Flight_leg values(876,'Arrived','2018/12/02','11:25:00','13:45:00',10,2,null,'12:00:00',1010522,1375)
insert into Flight_leg values(463,'Arrived','2018/12/02','15:05:00','01:00:00',2,8,null,'15:20:00',1010474,7543)
insert into Flight_leg values(875,'Boarding','2018/12/02','11:50:00','02:05:00',6,11,null,'12:00:00',1010793,4367)
insert into Flight_leg values(467,'On-air','2018/12/01','10:55:00','14:15:00',5,12,null,'11:25:00',1010878,7334)
insert into Flight_leg values(786,'Arrived','2018/12/02','01:45:00','17:35:00',9,14,null,'02:05:00',1010255,8006)
insert into Flight_leg values(988,'Boarding','2018/12/02','02:30:00','00:20:00',7,7,null,'02:35:00',1010995,1256)
insert into Flight_leg values(668,'On-air','2018/12/02','05:25:00','19:05:00',2,9,null,'07:30:00',1010522,9880)
insert into Flight_leg values(234,'Boarding','2018/12/02','14:10:00','11:35:00',15,10,null,'02:35:00',1010267,1434)
insert into Flight_leg values(432,'Arrived','2018/12/02','17:20:00','20:55:00',11,1,null,'19:30:00',1010735,3314)
insert into Flight_leg values(123,'On-air','2018/12/02','00:00:00','19:50:00',10,12,null,'04:25:00',1010326,2354)
insert into Flight_leg values(235,'Check-in','2018/12/02','00:10:00','08:25:00',6,7,null,'06:32:00',1010995,1375)
insert into Flight_leg values(654,'Canceled','2018/12/05','00:45:00','04:05:00',5,9,'Due to extreme weather','05:05:00',1010678,1256)

insert into Passenger_T2 values(315,'12:25:00',12)
insert into Passenger_T2 values(458,'18:30:00',34)
insert into Passenger_T2 values(346,'00:24:00',56)
insert into Passenger_T2 values(876,'01:01:00',78)
insert into Passenger_T2 values(463,'16:56:00',01)
insert into Passenger_T2 values(875,'14:14:00',456)
insert into Passenger_T2 values(467,'20:00:00',321)
insert into Passenger_T2 values(786,'06:00:00',786)
insert into Passenger_T2 values(988,'03:16:00',45)
insert into Passenger_T2 values(668,'13:14:00',201)
insert into Passenger_T2 values(234,'02:10:00',625)
insert into Passenger_T2 values(432,'05:30:00',365)
insert into Passenger_T2 values(123,'05:32:00',420)
insert into Passenger_T2 values(235,'05:40:00',38)
insert into Passenger_T2 values(654,'09:55:00',364)

insert into Departure values(315,01,'01:32:00')
insert into Departure values(458,12,'13:20:00')
insert into Departure values(346,13,'20:10:00')
insert into Departure values(876,07,'02:00:00')
insert into Departure values(463,09,'14:00:00')
insert into Departure values(875,11,'21:15:00')
insert into Departure values(467,01,'23:05:00')
insert into Departure values(786,01,'19:20:00')
insert into Departure values(988,20,'17:30:00')
insert into Departure values(668,31,'04:10:00')
insert into Departure values(234,10,'07:45:00')
insert into Departure values(432,12,'11:55:00')
insert into Departure values(123,52,'12:50:00')
insert into Departure values(235,45,'00:00:00')
insert into Departure values(654,33,'23:35:00')

insert into Aircraft_Flight_leg values('A310',315)
insert into Aircraft_Flight_leg values('G159',458)
insert into Aircraft_Flight_leg values('A311',346)
insert into Aircraft_Flight_leg values('E170',876)
insert into Aircraft_Flight_leg values('DC87',463)
insert into Aircraft_Flight_leg values('A321',875)
insert into Aircraft_Flight_leg values('DC10',467)
insert into Aircraft_Flight_leg values('CL60',786)
insert into Aircraft_Flight_leg values('A320',988)
insert into Aircraft_Flight_leg values('AN26',668)
insert into Aircraft_Flight_leg values('BA11',234)
insert into Aircraft_Flight_leg values('A400',432)
insert into Aircraft_Flight_leg values('B732',123)
insert into Aircraft_Flight_leg values('B703',235)
insert into Aircraft_Flight_leg values('A300',654)

insert into Arrival values(315,328621354)
insert into Arrival values(458,549845315)
insert into Arrival values(346,146511213)
insert into Arrival values(876,153156312)
insert into Arrival values(463,456878765)
insert into Arrival values(875,098230978)
insert into Arrival values(467,267765456)
insert into Arrival values(786,089774679)
insert into Arrival values(988,235352370)
insert into Arrival values(668,278709956)
insert into Arrival values(234,098877347)
insert into Arrival values(432,785409856)
insert into Arrival values(123,955765690)
insert into Arrival values(235,098987555)
insert into Arrival values(654,098646333)

insert into Passenger_T1 values('388616886','Randell Staub','British','1950/02/12','Male','2015/02/05','2020/02/05','First',23.5,'3193476512487',315,null)
insert into Passenger_T1 values('PA4521442','Takish Gambrel','Japanese','2008/03/14','Male','2016/03/18','2026/03/18','Business',5.5,'2349875612485',458,'866834331')
insert into Passenger_T1 values('145DS4566','Anna Roberts','American','1987/10/10','Other','2017/10/01','2022/10/01','Business',10.0,'765413689765',458,null)
insert into Passenger_T1 values('FD1562112','Evia Grande','American','1947/12/01','Female','2012/11/30','2022/11/30','Economy',31.2,'5679815236498',876,null)
insert into Passenger_T1 values('184915653','John Smith','Swedish','1963/07/31','Male','2018/01/05','2028/01/05','Business',3.5,'4563218975264',463,null)
insert into Passenger_T1 values('CV1563118','Antonie Weasley','Hungarian','2007/05/21','Male','2018/05/21','2023/05/21','First',13.6,'0214793541258',876,'388616886')
insert into Passenger_T1 values('789654364','Dave Prince','Australian','1955/11/16','Male','2010/09/27','2020/09/27','Economy',20.0,'0215879632541',988,null)
insert into Passenger_T1 values('GF4683144','Shawn Bourke','Mexican','1997/04/02','Male','2018/11/11','2023/11/11','Economy',38.4,'3652178952364',123,null)
insert into Passenger_T1 values('866834331','Melinda Silvis','Portuguese','1973/01/31','Female','2012/12/04','2022/12/04','Economy',11.1,'9786248531248',234,null)
insert into Passenger_T1 values('GF5752126','Noelle Evan','Dutch','1977/05/20','Female','2016/03/31','2016/03/31','Economy',9.9,'7613498625475',654,null)
insert into Passenger_T1 values('789116515','Fredricka Evan','British','2009/07/24','Female','2014/04/14','2014/04/14','First',4.7,'8963314684216',432,'DD4538896')
insert into Passenger_T1 values('DD4538896','George Hemond','Nowergian','1991/08/07','Male','2015/08/29','2025/08/29','Economy',23.4,'3649752149865',988,null)
insert into Passenger_T1 values('282796292','Tao Yang','Chinese','1990/03/30','Male','2013/10/30','2023/10/30','Economy',34.6,'39761348962158',786,null)
insert into Passenger_T1 values('CA4268228','Raj Kumar','Indian','1979/12/05','Male','2010/06/03','2020/06/03','Economy',40,'3197516487264',668,null)
insert into Passenger_T1 values('888561122','Hasitha Athukorala','Sri Lankan','1993/11/08','Male','2018/11/30','2023/11/30','Economy',32.5,'1349756214895',234,null)

insert into Special_requirement values('888561122','Need mobility equipment')
insert into Special_requirement values('CA4268228','Carry baby strollers')
insert into Special_requirement values('282796292','Need personal assistant in hearing')
insert into Special_requirement values('DD4538896','Need personal assistant in hearing')
insert into Special_requirement values('DD4538896','Visually impaired')
insert into Special_requirement values('866834331','Need mobility equipment')
insert into Special_requirement values('866834331','Carry pets')
insert into Special_requirement values('GF4683144','Carry pets')
insert into Special_requirement values('789116515','Carry baby strollers')
insert into Special_requirement values('145DS4566','Need wheel chair')
insert into Special_requirement values('145DS4566','Need personal assistant')
insert into Special_requirement values('FD1562112','Need mobility equipment')
insert into Special_requirement values('CV1563118','Carry baby strollers')
insert into Special_requirement values('FD1562112','Need medical assistance')
insert into Special_requirement values('789116515','Need medical assistance')

insert into Airline_Airport values(603,'AAC')
insert into Airline_Airport values(016,'ABE')
insert into Airline_Airport values(250,'ACJ')
insert into Airline_Airport values(738,'WAW')
insert into Airline_Airport values(235,'GCM')
insert into Airline_Airport values(618,'AER')
insert into Airline_Airport values(180,'CAA')
insert into Airline_Airport values(131,'CBR')
insert into Airline_Airport values(297,'CCJ')
insert into Airline_Airport values(001,'LBA')
insert into Airline_Airport values(014,'VAR')
insert into Airline_Airport values(098,'QUO')
insert into Airline_Airport values(057,'LAX')
insert into Airline_Airport values(006,'OAK')
insert into Airline_Airport values(081,'VKO')

insert into Airline_Contact_Number values(603,0941125685)
insert into Airline_Contact_Number values(016,0331541556)
insert into Airline_Contact_Number values(250,0568561123)
insert into Airline_Contact_Number values(738,0123564231)
insert into Airline_Contact_Number values(738,0314863321)
insert into Airline_Contact_Number values(618,0186312312)
insert into Airline_Contact_Number values(180,0132821365)
insert into Airline_Contact_Number values(014,0954681231)
insert into Airline_Contact_Number values(297,0321481312)
insert into Airline_Contact_Number values(001,0355654481)
insert into Airline_Contact_Number values(014,0486111658)
insert into Airline_Contact_Number values(098,0466123315)
insert into Airline_Contact_Number values(057,0651321232)
insert into Airline_Contact_Number values(006,0546556511)
insert into Airline_Contact_Number values(006,0552151654)

insert into Aircraft values('A310','Airbus A310',737,'Airbus',838,603)
insert into Aircraft values('G159','Gulfstream Aerospace G-159',777,'Grumman',525,016)
insert into Aircraft values('A311','Airbus A310',777,'Airbus',763,250)
insert into Aircraft values('E170','Embraer 170',787,'Embraer',300,738)
insert into Aircraft values('DC87','Douglas DC-8-72 pax',737,'McDonelle Douglas',450,235)
insert into Aircraft values('A321','Airbus A310',747,'Airbus',838,618)
insert into Aircraft values('DC10','Douglas DC-10 pax',787,'McDonelle Douglas',450,180)
insert into Aircraft values('CL60','Canadair Challenger',737,'Bombadier Inc.',225,131)
insert into Aircraft values('A320','Airbus A310',747,'Airbus',763,297)
insert into Aircraft values('AN26','Antonov AN-26',787,'Antonov',520,001)
insert into Aircraft values('BA11','Boeing 011-100 pax',737,'Boeing',723,014)
insert into Aircraft values('A400','Airbus A310',747,'Airbus',600,098)
insert into Aircraft values('B732','Boeing 732-200 pax',747,'Boeing',450,057)
insert into Aircraft values('B703','Boeing 707 Freighter',737,'Boeing',490,006)
insert into Aircraft values('A300','Airbus A310',777,'Airbus',853,081)

insert into Aircrew values(1010515,'Captain','2000/01/15',18,'01234689',603)
insert into Aircrew values(1010474,'First Officer','2003/05/23',15,'DJ486313',016)
insert into Aircrew values(1010647,'Pilot','1999/12/12',19,'78913458',250)
insert into Aircrew values(1010522,'Air Host','2010/10/30',8,'FG789653',738)
insert into Aircrew values(1010357,'Chief Flight Attendant','2012/05/11',6,'48943211G',235)
insert into Aircrew values(1010857,'Captain','2015/03/16',3,'14889256FE',618)
insert into Aircrew values(1010267,'Air Host','2007/11/01',9,'189461364',180)
insert into Aircrew values(1010545,'Chief Flight Attendant','2016/7/21',2,'289713131',131)
insert into Aircrew values(1010678,'Cruise Captain','1997/11/12',14,'254821586',297)
insert into Aircrew values(1010793,'Loadmaster','2017/05/31',11,'GF597543',001)
insert into Aircrew values(1010326,'First Officer','2014/08/09',10,'48949SD',014)
insert into Aircrew values(1010255,'Air Hostess','2006/05/20',8,'LH287912',098)
insert into Aircrew values(1010735,'Flight Engineer','2018/01/15',3,'49811133',057)
insert into Aircrew values(1010995,'Air Host','2018/06/30',5,'98787521',006)
insert into Aircrew values(1010878,'Air Hostess','2017/10/05',2,'008752243',081)

insert into Aircrew_qualification values(1010515,'Fluent in English')
insert into Aircrew_qualification values(1010678,'BSc Aviation')
insert into Aircrew_qualification values(1010515,'BSc Air Transport with Commercial Pilot Training')
insert into Aircrew_qualification values(1010995,'BSc Aeronautical Engineering')
insert into Aircrew_qualification values(1010878,'BSc Aircraft Engineering')
insert into Aircrew_qualification values(1010545,'BSc Aviation')
insert into Aircrew_qualification values(1010647,'India Professional Pilot Programme')
insert into Aircrew_qualification values(1010878,'Fluent in English')
insert into Aircrew_qualification values(1010647,'Certificate in Private Pilot')
insert into Aircrew_qualification values(1010255,'Dip in Aircraft Maintainance')
insert into Aircrew_qualification values(1010522,'ATP Airline Transport Pilot')
insert into Aircrew_qualification values(1010267,'First Officer Program')
insert into Aircrew_qualification values(1010357,'Fluent in English')
insert into Aircrew_qualification values(1010857,'EASA Integrated Pilot Training')
insert into Aircrew_qualification values(1010735,'BSc Aeronautical Engineering')

insert into Airline_Destinations values(603,'New York')
insert into Airline_Destinations values(016,'London')
insert into Airline_Destinations values(250,'Moscow')
insert into Airline_Destinations values(001,'Shanghai')
insert into Airline_Destinations values(235,'Thaipe')
insert into Airline_Destinations values(618,'Sydney')
insert into Airline_Destinations values(603,'New Jersy')
insert into Airline_Destinations values(131,'Ottawa')
insert into Airline_Destinations values(297,'Rio De Jenairo')
insert into Airline_Destinations values(001,'Cape Town')
insert into Airline_Destinations values(014,'Delhi')
insert into Airline_Destinations values(057,'Tokyo')
insert into Airline_Destinations values(057,'Auckland')
insert into Airline_Destinations values(006,'Mexico city')
insert into Airline_Destinations values(081,'Mumbai')

insert into Airport values('AAC','EI Arish International','EI Arish','Egypt',2011)
insert into Airport values('ABE','Lehigh Valley International','Allentown','USA',1956)
insert into Airport values('ACJ','Anuradhapura Airport Base','Anuradhapura','Sri Lanka',1999)
insert into Airport values('WAW','Warsaw Chopin','Warsaw','Porland',1925)
insert into Airport values('GCM','Owen Roberts International','Georgetown','Cayman Islands',1968)
insert into Airport values('AER','Sochi International','Sochi','Russia',1962)
insert into Airport values('CAA','Catacamas','Catacamas','Honduras',2000)
insert into Airport values('CBR','Canberra International','Canberra','Australia',1984)
insert into Airport values('CCJ','Calicut International','Calicut','India',1972)
insert into Airport values('LBA','Leeds Bradford','Leeds','UK',1956)
insert into Airport values('VAR','Varna','Varna','Bulgaria',2001)
insert into Airport values('QUO','Akwa Ibom International','Uyo','Nigeria',1991)
insert into Airport values('LAX','Los Angeles International','Los Angeles','USA',1976)
insert into Airport values('OAK','Metropolitan Oakland International','Oakland','USA',1955)
insert into Airport values('VKO','Vnukovo International','Moscow','Russia',1974)

insert into Flight_Airport values(1235,'AAC')
insert into Flight_Airport values(7561,'ABE')
insert into Flight_Airport values(4375,'ACJ')
insert into Flight_Airport values(7566,'WAW')
insert into Flight_Airport values(1375,'GCM')
insert into Flight_Airport values(7543,'AER')
insert into Flight_Airport values(4367,'CAA')
insert into Flight_Airport values(7334,'CBR')
insert into Flight_Airport values(2354,'CCJ')
insert into Flight_Airport values(9877,'LBA')
insert into Flight_Airport values(8006,'VAR')
insert into Flight_Airport values(3314,'QUO')
insert into Flight_Airport values(1434,'LAX')
insert into Flight_Airport values(9880,'OAK')
insert into Flight_Airport values(1256,'VKO')


/*procedures*/

	CREATE PROCEDURE CheckPassExp
	@ACode char (5), @PPNum char (10)
AS
DECLARE @maxSeats int
	DECLARE @availableSeats int
	DECLARE @expDate date 
	DECLARE @today date
	
	SELECT @today = CAST(GETDATE() as date)
	SELECT @maxSeats = Maximum_seats from Aircraft where @ACode = Aircraft_code
	SELECT @availableSeats = count(Seat_no) from Passenger_T2
	Select @expDate = Passport_expiry_date from Passenger_T1 where Passenger_passport_no = @PPNum

	if (@availableSeats=null)
		set @availableSeats=0

	if(@availableSeats<=@maxSeats)
		Begin
			if(@today>=@expDate)
				BEGIN
					PRINT 'Passport has been expired.'
					Delete from Special_requirement where Passenger_passport_no = @PPNum
					Delete from Passenger_T1 where Passenger_passport_no=@PPNum
				END
			ELSE 
			PRINT 'Passport is valid.'
		END




		
	CREATE PROCEDURE Passengercheck
	@passportNumber char (10)
AS
	DECLARE @legno char(15)
	DECLARE @dob date
	DECLARE @today date
	DECLARE @parent varchar (20)
	
	SELECT @parent=Guardian_passport_no from Passenger_T1  where Passenger_passport_no=@passportNumber
	SELECT @today = CAST(GETDATE() as date)
	SELECT @legno= Leg_no from Passenger_T1  where Passenger_passport_no=@passportNumber
	SELECT @dob=Date_of_Birth from Passenger_T1  where Passenger_passport_no=@passportNumber

	SELECT Flight_leg.Status, Flight_leg.Remark, Flight_leg.Arrival_terminal_no,Flight_leg.Staff_ID,
	Flight_leg.Leg_no, Flight_leg.Flight_no,Passenger_T1.Passenger_passport_no,Passenger_T1.Passenger_name,
	Special_requirement.requirement,Flight_Schedule.Scheduled_days
		from Flight_leg
		JOIN Aircrew on (Aircrew.Staff_ID = Flight_leg.Staff_ID)
		JOIN Passenger_T1 on (Flight_leg.Leg_no=Passenger_T1.Leg_no)
		JOIN Special_requirement on (Passenger_T1.Passenger_passport_no=Special_requirement.Passenger_passport_no)
		JOIN Flight_Schedule on (Flight_leg.Flight_no=Flight_Schedule.Flight_no)

		Where  Passenger_T1.Leg_no=@legno

	DECLARE @rowcount int

	select  @@ROWCOUNT as [Number of Passengers]
	Print 'There are '+ cast (@@ROWCOUNT as varchar(30))+' other passenger(s) with this person'

	if(DATEDIFF(hour,@dob,GETDATE())/8766 <12)
		BEGIN
			Print 'This Passenger is a minor and their guardian is ' + @parent
		END


/*functions*/



CREATE FUNCTION FlightStatusInfo (@status varchar(50),@date date)

RETURNS @flight_info TABLE 
(
	Status varchar (15),
	Remark varchar (150),
	Arrival_teminal_number int,
	Leg_no int,
	Flight_number int,
	Passport_no varchar(20),
	Passenger_name varchar(100),
	Special_Requirement varchar (200),
	Flight_date date	
)
AS
	BEGIN
		INSERT INTO @flight_info (Status,Remark,Arrival_teminal_number,Leg_no,
		Flight_number,Passport_no,Passenger_name,Special_Requirement,Flight_date)
		
		SELECT Flight_leg.Status,Flight_leg.Remark,Flight_leg.Arrival_terminal_no,
		Flight_leg.Leg_no,Flight_leg.Flight_no,Passenger_T1.Passenger_passport_no,
		Passenger_T1.Passenger_name, Special_requirement.Requirement,Flight_leg.Date_of_flight
		from Flight_leg 
			JOIN Passenger_T1 on (Flight_leg.Leg_no=Passenger_T1.Leg_no)
			JOIN Special_requirement on (Passenger_T1.Passenger_passport_no=Special_requirement.Passenger_passport_no)
		Where Status=@status and Date_of_flight=@date
		RETURN
	END


		/*select * from FlightStatusInfo('On-air' ,'2018-12-02')*/





CREATE FUNCTION find_passenger (@startDate date, @endDate date)
RETURNS @PassengerInfo TABLE 
(	
	Passenger_Name varchar(100),
	Passport_number varchar(20),
	Ticket_number varchar(20),
	Flight_no int,
	Leg_no int
				
)

AS 
	BEGIN
		INSERT INTO  @PassengerInfo (Passenger_Name,Passport_number,Ticket_number,Flight_no, Leg_no)
			
		Select Passenger_name,Passenger_passport_no,Ticket_no,Flight_leg.Flight_no,Flight_leg.Leg_no
		From Passenger_T1
			JOIN Flight_leg on (Flight_leg.Leg_no=Passenger_T1.Leg_no)
		WHERE	 
			Passenger_T1.Leg_no=Flight_leg.Leg_no and
			Flight_leg.Date_of_flight <= @endDate and
			Flight_leg.Date_of_flight >= @startDate
			ORDER BY Passenger_T1.Passenger_name
			Return
	END



		/*select * from find_passenger ('2018-12-01','2018-12-03')*/






/*view*/


create view Passengers_With_Guardians as
 select * 
 from Passenger_T1
 Where Guardian_passport_no is not null
 go
select * from Passengers_With_Guardians


create view Delayed_Take_Off as
 select * 
 from Flight
 Where Take_off_information LIKE 'delayed%' or
 Take_off_information LIKE '%delayed' or
 Take_off_information LIKE '%delayed%' or
 Take_off_information = 'delayed'
 go
select * from Delayed_Take_Off


create view Delayed_Landing as
 select * 
 from Flight
 Where Landing_information LIKE 'delayed%' or
 Landing_information LIKE '%delayed' or
 Landing_information LIKE '%delayed%' or
 Landing_information = 'delayed'
 go
select * from Delayed_Landing


create view Flights_on_Monday as
 select Flight_no 
 from Flight_Schedule
 Where Scheduled_days = 'Monday' 
 go
select * from Flights_on_Monday


create view Female_Passengers as
 select * 
 from Passenger_T1
 Where Gender = 'Female' 
 go
select * from Female_Passengers



/*triggers*/


create trigger AirLine_Trigger_2 on Airline
   for update 
     as
			declare @intRowCount int
			select @intRowCount = @@rowcount
      if @intRowCount > 1
        begin
            if update (Airline_Code)
            rollback transaction
        end
      else
        if @intRowCount = 1
             begin
               if update (Airline_Code)
                    begin
                        update  Airline_Destinations
                        set Airline_Destinations.Airline_Code = (SELECT Airline_Code FROM inserted)
                        from Airline_Destinations INNER JOIN deleted
                        on Airline_Destinations.Airline_Code = deleted.Airline_Code
              end
       end




	   
create trigger Aircraft_Trigger
on Aircraft
after insert,delete,update
as
begin
select * from inserted
select * from deleted
end


create trigger Aircrew_qualification_Trigger
on Aircrew_qualification
after insert,delete,update
as
begin
select * from inserted
select * from deleted
end


create trigger Departure_Trigger
on Departure
after insert,delete,update
as
begin
select * from inserted
select * from deleted
end


create trigger Flight_Trigger
on Flight
after insert,delete,update
as
begin
select * from inserted
select * from deleted
end


















