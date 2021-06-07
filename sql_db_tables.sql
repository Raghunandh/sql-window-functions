create table person(
	id int primary key,
	first_name varchar(max),
	last_name varchar(max),
	age int
);

INSERT INTO person (id,first_name,last_name,age) VALUES ('1','Dallas','Mills','47');
INSERT INTO person (id,first_name,last_name,age) VALUES ('2','Derek','Black','35');
INSERT INTO person (id,first_name,last_name,age) VALUES ('3','Eduardo','Clarke','24');
INSERT INTO person (id,first_name,last_name,age) VALUES ('4','Clayton','Stone','47');
INSERT INTO person (id,first_name,last_name,age) VALUES ('5','Kelly','Owen','44');

create table dog(
	id int primary key,
	owner_id int,
	name varchar(max),
	breed varchar(max),
	age int,
	foreign key(owner_id) references person(id) on delete cascade
)

INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('1','4','Lola','Husky','6');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('2','3','Molly','Husky','4');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('3','3','Lucy','Husky','9');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('4','1','Bella','Beagle','3');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('5','1','Sophie','Beagle','2');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('6','2','Sadie','Labrador','3');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('7','2','Chloe','Labrador','7');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('8','2','Bailey','Labrador','1');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('9','4','Dasy','Bulldog','1');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('10','2','Max','Bulldog','2');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('11','5','Charlie','Bulldog','2');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('12','4','Buddy','Husky','10');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('13','1','Rocky','Husky','9');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('14','2','Jake','Husky','8');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('15','4','Jack','Beagle','6');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('16','3','Toby','Labrador','5');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('17','4','Cody','Beagle','8');
INSERT INTO dog (id,owner_id,name,breed,age) VALUES ('18','4','Buster','Labrador','7');


create table department(
	id int primary key,
	name varchar(max)
);

INSERT INTO department (id,name) VALUES ('1','IT');
INSERT INTO department (id,name) VALUES ('2','Management');
INSERT INTO department (id,name) VALUES ('3','Human Resources');
INSERT INTO department (id,name) VALUES ('4','Accounting');
INSERT INTO department (id,name) VALUES ('5','Help Desk');

create table employees(
id int primary key,
first_name varchar(max),
last_name varchar(max),
department_id int foreign key references department(id) on delete cascade,
salary int,
years_worked int
);

INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('1','Diane','Turner','1','5330','4');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('2','Clarence','Robinson','1','3617','2');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('3','Eugene','Phillips','1','4877','2');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('4','Philip','Mitchell','1','5259','3');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('5','Ann','Wright','2','2094','5');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('6','Charles','Wilson','2','5167','5');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('7','Russell','Johnson','2','3762','4');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('8','Jacqueline','Cook','2','6923','3');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('9','Larry','Lee','3','2796','4');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('10','Willie','Patterson','3','4771','5');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('11','Janet','Ramirez','3','3782','2');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('12','Doris','Bryant','3','6419','1');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('13','Amy','Williams','3','6261','1');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('14','Keith','Scott','3','4928','8');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('15','Karen','Morris','4','6347','6');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('16','Kathy','Sanders','4','6286','1');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('17','Joe','Thompson','5','5639','3');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('18','Barbara','Clark','5','3232','1');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('19','Todd','Bell','5','4653','1');
INSERT INTO employees (id,first_name,last_name,department_id,salary,years_worked) VALUES ('20','Ronald','Butler','5','2076','5');

create table purchase(
id int primary key,
department_id int foreign key references department(id) on delete cascade,
item varchar(max),
price int
);

INSERT INTO purchase (id,department_id,item,price) VALUES ('1','4','monitor','531');
INSERT INTO purchase (id,department_id,item,price) VALUES ('2','1','printer','315');
INSERT INTO purchase (id,department_id,item,price) VALUES ('3','3','whiteboard','170');
INSERT INTO purchase (id,department_id,item,price) VALUES ('4','5','training','117');
INSERT INTO purchase (id,department_id,item,price) VALUES ('5','3','computer','2190');
INSERT INTO purchase (id,department_id,item,price) VALUES ('6','1','monitor','418');
INSERT INTO purchase (id,department_id,item,price) VALUES ('7','3','whiteboard','120');
INSERT INTO purchase (id,department_id,item,price) VALUES ('8','3','monitor','388');
INSERT INTO purchase (id,department_id,item,price) VALUES ('9','5','paper','37');
INSERT INTO purchase (id,department_id,item,price) VALUES ('10','1','paper','695');
INSERT INTO purchase (id,department_id,item,price) VALUES ('11','3','projector','407');
INSERT INTO purchase (id,department_id,item,price) VALUES ('12','4','garden party','986');
INSERT INTO purchase (id,department_id,item,price) VALUES ('13','5','projector','481');
INSERT INTO purchase (id,department_id,item,price) VALUES ('14','2','chair','180');
INSERT INTO purchase (id,department_id,item,price) VALUES ('15','2','desk','854');
INSERT INTO purchase (id,department_id,item,price) VALUES ('16','2','post-it','15');
INSERT INTO purchase (id,department_id,item,price) VALUES ('17','3','paper','60');
INSERT INTO purchase (id,department_id,item,price) VALUES ('18','2','tv','943');
INSERT INTO purchase (id,department_id,item,price) VALUES ('19','2','desk','478');
INSERT INTO purchase (id,department_id,item,price) VALUES ('20','5','keyboard','214');


create table train(
	id int primary key,
	model varchar(100),
	max_speed int,
	production_year int,
	first_class_places int,
	second_class_places int
);

INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('1','InterCity 100','160','2000','30','230');
INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('2','InterCity 100','160','2000','40','210');
INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('3','InterCity 125','200','2001','40','180');
INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('4','Pendolino 390','240','2012','45','150');
INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('5','Pendolino ETR310','240','2010','50','250');
INSERT INTO train (id,model,max_speed,production_year,first_class_places,second_class_places) VALUES ('6','Pendolino 390','240','2010','60','250');


create table route(
	id int primary key,
	name varchar(max),
	from_city varchar(max),
	to_city varchar(max),
	distance int
);

INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('1','Manchester Express','Sheffield','Manchester','60');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('2','GoToLeads','Manchester','Leeds','70');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('3','StudentRoute','London','Oxford','90');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('4','MiddleEnglandWay','London','Leicester','160');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('5','BeatlesRoute','Liverpool','York','160');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('6','NewcastleDaily','York','Newcastle','135');
INSERT INTO route (id,name,from_city,to_city,distance) VALUES ('7','ScotlandSpeed','Newcastle','Edinburgh','200');

create table journey(
	id int primary key,
	train_id int foreign key references train(id) on delete cascade,
	route_id int foreign key references route(id) on delete cascade,
	route_date date
);

INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('1','1','1',CONVERT(DATE,'03-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('2','1','2',CONVERT(DATE,'04-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('3','1','3',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('4','1','4',CONVERT(DATE,'06-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('5','2','2',CONVERT(DATE,'03-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('6','2','3',CONVERT(DATE,'04-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('7','2','4',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('8','2','5',CONVERT(DATE,'06-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('9','3','3',CONVERT(DATE,'03-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('10','3','5',CONVERT(DATE,'04-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('11','3','5',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('12','3','6',CONVERT(DATE,'06-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('13','4','4',CONVERT(DATE,'04-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('14','4','5',CONVERT(DATE,'04-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('15','4','6',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('16','4','7',CONVERT(DATE,'06-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('17','5','2',CONVERT(DATE,'03-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('18','5','1',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('19','5','3',CONVERT(DATE,'05-01-2016',103));
INSERT INTO journey (id,train_id,route_id,route_date) VALUES ('20','5','1',CONVERT(DATE,'06-03-2016',103));

create table ticket(
	id int primary key,
	price int,
	class int,
	journey_id int foreign key references journey(id) on delete cascade
);

INSERT INTO ticket (id,price,class,journey_id) VALUES ('1','200','2','24');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('2','76','1','12');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('3','102','2','6');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('4','126','2','11');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('5','80','1','17');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('6','74','1','5');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('7','200','2','5');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('8','66','1','17');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('9','59','1','22');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('10','134','2','11');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('11','60','1','6');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('12','89','1','14');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('13','71','1','3');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('14','99','1','7');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('15','166','2','3');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('16','154','2','6');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('17','76','1','23');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('18','106','2','23');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('19','97','1','7');
INSERT INTO ticket (id,price,class,journey_id) VALUES ('20','124','2','19');


create table game(
	id int primary key,
	name varchar(max),
	platform varchar(max),
	genre varchar(max),
	editor_rating int,
	size int,
	released date,
	updated date
);

INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('1','Go Bunny','iOS','action','5','101',CONVERT(DATE,'01-05-2015',103),CONVERT(DATE,'13-07-2015',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('2','Fire Rescue','iOS','action','9','36',CONVERT(DATE,'30-07-2015',103),CONVERT(DATE,'27-09-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('3','Eternal Stone','iOS','adventure','10','125',CONVERT(DATE,'20-03-2015',103),CONVERT(DATE,'25-10-2015',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('4','Froggy Adventure','iOS','adventure','7','127',CONVERT(DATE,'01-05-2015',103),CONVERT(DATE,'02-07-2015',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('5','Speed Race','iOS','racing','7','127',CONVERT(DATE,'20-03-2015',103),CONVERT(DATE,'25-07-2015',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('6','Monsters in Dungeon','Android','adventure','9','10',CONVERT(DATE,'01-12-2015',103),CONVERT(DATE,'15-12-2015',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('7','Shoot in Time','Android','shooting','9','123',CONVERT(DATE,'01-12-2015',103),CONVERT(DATE,'20-03-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('8','Hit Brick','Android','action','4','54',CONVERT(DATE,'01-05-2015',103),CONVERT(DATE,'05-01-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('9','The Square','Android','action','4','86',CONVERT(DATE,'01-12-2015',103),CONVERT(DATE,'16-03-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('10','Duck Dash','Android','shooting','4','36',CONVERT(DATE,'30-07-2015',103),CONVERT(DATE,'23-05-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('11','Perfect Time','Windows Phone','action','6','55',CONVERT(DATE,'01-12-2015',103),CONVERT(DATE,'07-01-2016',103));
INSERT INTO game (id,name,platform,genre,editor_rating,size,released,updated) VALUES ('12','First Finish','Windows Phone','racing','7','44',CONVERT(DATE,'01-10-2015',103),CONVERT(DATE,'20-02-2016',103));



create table product(
	id int primary key,
	name varchar(max),
	introduced date
);

INSERT INTO product (id,name,introduced) VALUES ('1','Frozen Yoghurt',CONVERT(DATE,'26-01-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('2','Ice cubes',CONVERT(DATE,'10-04-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('3','Ice cream',CONVERT(DATE,'05-01-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('4','Skis',CONVERT(DATE,'09-04-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('5','Snowboard',CONVERT(DATE,'01-02-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('6','Sledge',CONVERT(DATE,'20-02-2016',103));
INSERT INTO product (id,name,introduced) VALUES ('7','Freezer',CONVERT(DATE,'16-01-2016',103));


create table single_order(
	id int primary key,
	placed date,
	total_price decimal
);

INSERT INTO single_order (id,placed,total_price) VALUES ('1',CONVERT(DATE,'10-07-2016',103),'3876.76');
INSERT INTO single_order (id,placed,total_price) VALUES ('2',CONVERT(DATE,'10-07-2016',103),'3949.21');
INSERT INTO single_order (id,placed,total_price) VALUES ('3',CONVERT(DATE,'18-07-2016',103),'2199.46');
INSERT INTO single_order (id,placed,total_price) VALUES ('4',CONVERT(DATE,'13-06-2016',103),'2659.63');
INSERT INTO single_order (id,placed,total_price) VALUES ('5',CONVERT(DATE,'13-06-2016',103),'602.03');
INSERT INTO single_order (id,placed,total_price) VALUES ('6',CONVERT(DATE,'13-06-2016',103),'3599.83');
INSERT INTO single_order (id,placed,total_price) VALUES ('7',CONVERT(DATE,'29-06-2016',103),'4402.04');
INSERT INTO single_order (id,placed,total_price) VALUES ('8',CONVERT(DATE,'21-08-2016',103),'4553.89');
INSERT INTO single_order (id,placed,total_price) VALUES ('9',CONVERT(DATE,'30-08-2016',103),'3575.55');
INSERT INTO single_order (id,placed,total_price) VALUES ('10',CONVERT(DATE,'01-08-2016',103),'4973.43');
INSERT INTO single_order (id,placed,total_price) VALUES ('11',CONVERT(DATE,'05-08-2016',103),'3252.83');
INSERT INTO single_order (id,placed,total_price) VALUES ('12',CONVERT(DATE,'05-08-2016',103),'3796.42');


create table order_position(
	id int primary key,
	product_id int foreign key references product(id) on delete cascade,
	order_id int foreign key references single_order(id) on delete cascade,
	quantity int
);

INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('1','1','9','7');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('2','1','6','15');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('3','7','2','1');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('4','1','4','24');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('5','1','5','16');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('6','3','8','7');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('7','5','12','5');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('8','2','12','1');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('9','5','10','20');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('10','2','8','14');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('11','4','6','28');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('12','6','3','15');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('13','6','6','16');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('14','4','1','8');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('15','2','8','13');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('16','5','4','27');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('17','2','8','30');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('18','7','6','29');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('19','1','10','6');
INSERT INTO order_position (id,product_id,order_id,quantity) VALUES ('20','6','5','21');

create table stock_change(
	id int primary key,
	product_id int foreign key references product(id) on delete cascade,
	quantity int,
	changed date
);

INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('1','5','-90',CONVERT(DATE,'11-09-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('2','2','-91',CONVERT(DATE,'16-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('3','5','-15',CONVERT(DATE,'08-06-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('4','2','51',CONVERT(DATE,'10-06-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('5','1','-58',CONVERT(DATE,'09-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('6','1','-84',CONVERT(DATE,'28-09-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('7','4','56',CONVERT(DATE,'09-06-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('8','5','73',CONVERT(DATE,'22-09-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('9','1','-43',CONVERT(DATE,'07-06-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('10','2','-79',CONVERT(DATE,'27-07-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('11','4','93',CONVERT(DATE,'22-09-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('12','4','74',CONVERT(DATE,'13-06-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('13','2','-37',CONVERT(DATE,'02-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('14','7','19',CONVERT(DATE,'14-07-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('15','7','-72',CONVERT(DATE,'13-09-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('16','7','-13',CONVERT(DATE,'28-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('17','3','23',CONVERT(DATE,'24-07-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('18','1','24',CONVERT(DATE,'17-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('19','3','77',CONVERT(DATE,'11-08-2016',103));
INSERT INTO stock_change (id,product_id,quantity,changed) VALUES ('20','1','24',CONVERT(DATE,'28-08-2016',103));

create table store(
	id int primary key,
	country varchar(max),
	city varchar(max),
	opening_day date,
	rating int
);

INSERT INTO store (id,country,city,opening_day,rating) VALUES ('1','Spain','Madrid',CONVERT(DATE,'30-05-2014',103),'5');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('2','Spain','Barcelona',CONVERT(DATE,'28-07-2015',103),'3');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('3','Spain','Valencia',CONVERT(DATE,'13-12-2014',103),'2');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('4','France','Paris',CONVERT(DATE,'05-12-2014',103),'5');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('5','France','Lyon',CONVERT(DATE,'24-09-2014',103),'3');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('6','France','Nice',CONVERT(DATE,'15-03-2014',103),'2');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('7','France','Bordeaux',CONVERT(DATE,'29-07-2015',103),'1');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('8','Germany','Berlin',CONVERT(DATE,'15-12-2014',103),'3');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('9','Germany','Hamburg',CONVERT(DATE,'12-06-2015',103),'3');
INSERT INTO store (id,country,city,opening_day,rating) VALUES ('10','Germany','Frankfurt',CONVERT(DATE,'14-03-2015',103),'4');



create table sales(
	store_id foreign key references store(id),
	on_day date,
	revenue decimal,
	transactions int,
	customers bigint
);

INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'01-08-2016',103),'6708.16','77','1465');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'02-08-2016',103),'3556','36','762');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'03-08-2016',103),'2806.82','30','650');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'04-08-2016',103),'6604.8','103','1032');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'05-08-2016',103),'6409.46','66','859');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'06-08-2016',103),'6909.54','123','1604');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'07-08-2016',103),'5596.67','61','730');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'08-08-2016',103),'4254.43','63','1439');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'09-08-2016',103),'2872.62','30','635');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'10-08-2016',103),'2715.27','48','524');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'11-08-2016',103),'3475.64','64','1416');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'12-08-2016',103),'4049.45','47','1024');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'13-08-2016',103),'3211.2','33','669');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('1',CONVERT(DATE,'14-08-2016',103),'1502.08','30','721');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'01-08-2016',103),'4828','71','1704');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'02-08-2016',103),'17056','213','2132');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'03-08-2016',103),'7209.78','108','2475');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'04-08-2016',103),'12473.08','166','2162');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'05-08-2016',103),'8070','147','1614');
INSERT INTO sales (store_id,day,revenue,transactions,customers) VALUES ('2',CONVERT(DATE,'06-08-2016',103),'8220','137','1781');

