alter table `appointment` add column `batchId` varchar(80);
alter table `appointment` add column `batchType` varchar(10);

alter table `login` add column `employees` varchar(3000);
alter table `login` add column `ips` varchar(500);

