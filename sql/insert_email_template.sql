--backup
INSERT INTO `emailstemplate` VALUES (1, 1, 0, 'Hello, {customer}!\r\nThank you for registering at https://isalon2you-soft.com/manhattanonline/\r\n-------------------\r\nUsername: {login}\r\nPassword: {password}\r\n-------------------\r\n\r\nSincerely, Administration https://isalon2you-soft.com/manhattanonline/', '');
INSERT INTO `emailstemplate` VALUES (2, 1, 1, 'Hello, {customer}!\r\n\r\nYou have an appointment at https://isalon2you-soft.com/manhattanonline/\r\n-------------------\r\nOperator: {operator}\r\nService: {service}\r\nDate: {date}\r\nTime: {time}\r\nShopping: {product}\r\n-------------------\r\n\r\nSincerely, Administration https://isalon2you-soft.com/manhattanonline/', '');
INSERT INTO `emailstemplate` VALUES (3, 1, 2, 'Hello, {customer}!\r\nYou booking has been accepted.\r\n-------------------\r\nOperator: {operator}\r\nService: {service}\r\nDate: {date}\r\nTime: {time}\r\nShopping: {product}\r\n-------------------\r\n\r\nSincerely, Administration https://isalon2you-soft.com/manhattanonline/', '');
INSERT INTO `emailstemplate` VALUES (4, 1, 3, 'Hello, {customer}!\r\nWe can not accept your booking.\r\nPlease make your booking again.\r\nYou old booking:\r\n-------------------\r\nOperator: {operator}\r\nService: {service}\r\nDate: {date}\r\nTime: {time}\r\nShopping: {product}\r\n-------------------\r\n\r\nSincerely, Administration https://isalon2you-soft.com/manhattanonline/', '');
INSERT INTO `emailstemplate` VALUES (5, 1, 4, 'Hello, {customer}!\r\nForgot Username and Password.\r\n-------------------\r\nUsername: {login}\r\nPassword: {password}\r\n-------------------\r\n\r\nSincerely, Administration https://isalon2you-soft.com/manhattanonline/', '');

INSERT INTO `emailstemplate` VALUES (6, 1, 100, 'Dear {customerName},\r\n This is a reminder of the appointment at {appointmentTime}, Please enjoy time!', '');

INSERT INTO `emailstemplate` VALUES (7, 1, 101, 'Dear {customerName},\r\n The Appointment at: {dataTime} has been canceled!', '');
INSERT INTO `emailstemplate` VALUES (8, 1, 102, 'Dear {customerName},\nThanks for using iSalon. Hope you enjoy the time with us.\n\n{dateTime}\nIsalon\n', '');

--update emailstemplate set text='<h3>{customerName}</h3>\n<h4>CLIENT TICKCT</h4>\n<table border="1">\n<tr>\n<th>employee</th>\n<th>service/product</th>\n<th>quantity</th>\n<th>discount</th>\n<th>price</th>\n</tr>\n${employee}{service}{quantity}{discount}{price}$\n</table>\n<p>sub-total: {subtotal}</p>\n<p>tax: {taxe}</p>\n<p>total: {total}</p>\n<p>at {dateTime}</p>\n' where type=102;
--update emailstemplate set text='Dear {customerName},\nThanks for using iSalon. Hope you enjoy the time with us.\n\n{dateTime}\nIsalon\n' where type=102;
alter table `appointment` add column `is_send_appointment_mail` boolean default false; 
alter table `appointment` add column `is_send_reminder_mail` boolean default false; 
update appointment set is_send_reminder_mail=true;
