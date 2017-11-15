use juicd;

/* Some queries for the juicd database. */

select * from customer where jCardNum = 1000;
select distinct count(*) from customerorder;
select name, address from employee join manages on employee.jEmpID = manages.jEmpID;
select name, address from employee join worksat on employee.jEmpID = worksat.jEmpID where (employee.jEmpID = worksat.jEmpID and worksAt.percentage = 100);
select employee.name, employee.address, sum(worksat.percentage) from employee join worksat on employee.jEmpID = worksat.jEmpID join outlet on worksat.jStoreID = outlet.jStoreID group by name;
select min(jPoints), max(jPoints), avg(jPoints) from customer;
select employee.name, count(linemgr.supervisee) as employees_supervised from employee join linemgr on employee.jempid = linemgr.supervisor group by linemgr.supervisor;
select outlet.address, count(customerorder.orderid) as orders_served from outlet join customerorder on outlet.jstoreid=customerorder.outletid group by customerorder.outletid;
select juice.jname, comprises.percentage from comprises join juice on juice.jid = comprises.juiceid where comprises.cupid = 1000;
select sum(juice.perml * comprises.percentage * juicecup.size/100) as price from juice join comprises join juicecup on juice.jid = comprises.juiceid and comprises.cupid = juicecup.cupid where comprises.cupid = '1000';
select outlet.address, dayname(date) as day, count(*) as orders from customerorder join outlet on customerorder.outletID = outlet.jStoreId group by day, outletID order by outlet.address, dayname(date);
select cupID from (select cupID, count(*) AS number from comprises group by cupID) AS default_table where number > 3;
select name, address from employee left outer join worksat on employee.jempid = worksat.jempid where worksat.percentage is null;
select distinct customerorder.orderid from customerorder left outer join hasnonjuice on customerorder.orderid = hasnonjuice.orderid join hasjuice on customerorder.orderid = hasjuice.orderid where hasnonjuice.orderid is null group by orderid;

/* Some functions for the juicd database*/

drop function if exists juiceCupCost;
delimiter %%
create function juiceCupCost(id INT) returns double
begin
declare price double;

select sum(juice.perMl*(size*(percentage/100))) into price
from juicecup join comprises on juicecup.cupId = comprises.cupId join juice on comprises.juiceid = juice.jid
where comprises.cupid = id
and juicecup.cupId = id;

return price;

end %%
delimiter ;

drop function if exists juiceOrderCost;
delimiter ^^
create function juiceOrderCost(id INT) returns double
begin
declare price double;

select sum(quantity*(select(juiceCupCost(cupid)))) into price
from hasJuice
where orderid = id
group by orderid;

return price;

end ^^
delimiter ;

drop function if exists totalOrderCost;
delimiter __
create function totalOrderCost(id INT) returns double
begin
declare price double;

select coalesce(sum(peritem*quantity*100),0) + (select juiceOrderCost(CustomerOrder.orderid)) into price
from nonjuice join hasnonjuice on nonjuice.prodid = hasnonjuice.prodid right outer join customerorder on hasnonjuice.orderid = customerorder.orderid
where customerorder.orderid = id
group by customerorder.orderid;

return price;

end __
delimiter ;

drop view if exists CustomerPricedOrder;
create view CustomerPricedOrder as
select date, customerID, orderID, (select(totalOrderCost(orderid))) as orderCost
from CustomerOrder;
select * from CustomerPricedOrder;

