create database test;
use test;
create table log( id int(4) auto_increment primary key, date varchar(50), terminal_id varchar(50), client_type varchar(50), request_id int(5), retry_id int(5), year int(4), month int(4), day int(4), hour int(4), minutes int(4), seconds int(4));
