DROP TABLE IF EXISTS `car_rental_bookings`;
CREATE TABLE IF NOT EXISTS `car_rental_bookings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` int(10) unsigned DEFAULT NULL,
  `booking_id` varchar(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `car_id` int(10) unsigned DEFAULT NULL,
  `pickup_id` int(10) unsigned DEFAULT NULL COMMENT 'Location ID',
  `return_id` int(10) unsigned DEFAULT NULL COMMENT 'Location ID',
  `from` datetime DEFAULT NULL,
  `to` datetime DEFAULT NULL,
  `start` int(10) unsigned DEFAULT NULL,
  `end` int(10) unsigned DEFAULT NULL,
  `rental_days` int(10) unsigned DEFAULT NULL,
  `rental_hours` int(10) unsigned DEFAULT NULL,
  `price_per_day` decimal(16,2) unsigned DEFAULT NULL,
  `price_per_day_detail` varchar(255) DEFAULT NULL,
  `price_per_hour` decimal(16,2) unsigned DEFAULT NULL,
  `price_per_hour_detail` varchar(255) DEFAULT NULL,
  `car_rental_fee` decimal(16,2) unsigned DEFAULT NULL,
  `extra_price` decimal(16,2) unsigned DEFAULT NULL,
  `insurance` decimal(16,2) unsigned DEFAULT NULL,
  `sub_total` decimal(16,2) unsigned DEFAULT NULL,
  `tax` decimal(16,2) unsigned DEFAULT NULL,
  `total_price` decimal(16,2) unsigned DEFAULT NULL,
  `required_deposit` decimal(16,2) unsigned DEFAULT NULL,
  `extra_mileage_charge` decimal(16,2) unsigned DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `status` enum('confirmed','cancelled','pending','collected','completed') DEFAULT 'pending',
  `pickup_date` datetime DEFAULT NULL,
  `pickup_mileage` int(10) unsigned DEFAULT NULL,
  `actual_dropoff_datetime` datetime DEFAULT NULL,
  `dropoff_mileage` int(10) unsigned DEFAULT NULL,
  `security_deposit` decimal(16,2) unsigned DEFAULT NULL,
  `txn_id` varchar(255) DEFAULT NULL,
  `processed_on` datetime DEFAULT NULL,  
  `created` datetime DEFAULT NULL,
  `c_title` varchar(255) DEFAULT NULL,
  `c_name` varchar(255) DEFAULT NULL,
  `c_phone` varchar(255) DEFAULT NULL,
  `c_email` varchar(255) DEFAULT NULL,
  `c_company` varchar(255) DEFAULT NULL,
  `c_notes` text DEFAULT NULL,
  `c_address` varchar(255) DEFAULT NULL,
  `c_city` varchar(255) DEFAULT NULL,
  `c_state` varchar(255) DEFAULT NULL,
  `c_zip` varchar(255) DEFAULT NULL,
  `c_country` int(10) unsigned DEFAULT NULL,
  `cc_type` varchar(255) DEFAULT NULL,
  `cc_num` blob,
  `cc_exp` blob,
  `cc_code` blob,
  `locale_id` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `car_id` (`car_id`),
  KEY `type_id` (`type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_bookings_extras`;
CREATE TABLE IF NOT EXISTS `car_rental_bookings_extras` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` int(10) unsigned DEFAULT NULL,
  `extra_id` int(10) unsigned DEFAULT NULL,
  `quantity` int(10) unsigned DEFAULT NULL,
  `price` decimal(16,2) unsigned DEFAULT NULL,
  `extended_price` decimal(16,2) unsigned DEFAULT '0',
  `extended_notes` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`,`extra_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_bookings_payments`;
CREATE TABLE IF NOT EXISTS `car_rental_bookings_payments` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `booking_id` int(10) unsigned default NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `payment_type` varchar(255) DEFAULT NULL,
  `amount` decimal(16,2) unsigned DEFAULT NULL,
  `status` enum('paid','notpaid') DEFAULT 'paid',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_prices`;
CREATE TABLE IF NOT EXISTS `car_rental_prices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned DEFAULT NULL,
  `from` smallint(5) unsigned DEFAULT NULL,
  `to` smallint(5) unsigned DEFAULT NULL,
  `date_from` DATE DEFAULT NULL,                        
  `date_to` DATE DEFAULT NULL,     
  `price` decimal(7,2) unsigned DEFAULT NULL,
  `price_per` enum('day','hour') DEFAULT 'day',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_cars`;
CREATE TABLE IF NOT EXISTS `car_rental_cars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned DEFAULT NULL,
  `registration_number` varchar(255) DEFAULT NULL,
  `mileage` int(10) unsigned DEFAULT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`),
  UNIQUE KEY `registration_number` (`registration_number`),
  KEY `location_id` (`location_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_cars_types`;
CREATE TABLE IF NOT EXISTS `car_rental_cars_types` (
  `car_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`car_id`,`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_extras`;
CREATE TABLE IF NOT EXISTS `car_rental_extras` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `price` decimal(16,2) unsigned DEFAULT NULL,
  `per` enum('booking','day') DEFAULT NULL,
  `count` smallint(5) unsigned DEFAULT NULL,
  `type` enum('single','multi') DEFAULT 'multi',
  `status` enum('T','F') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_locations`;
CREATE TABLE IF NOT EXISTS `car_rental_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` int(10) unsigned DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `address_1` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `lat` varchar(255) DEFAULT NULL,
  `lng` varchar(255) DEFAULT NULL,
  `thumb` VARCHAR(255) NULL,
  `notify_email` enum('T','F') DEFAULT 'T',
  `status` enum('T','F') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_id` (`country_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_types`;
CREATE TABLE IF NOT EXISTS `car_rental_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `passengers` smallint(5) unsigned DEFAULT NULL,
  `luggages` tinyint(3) unsigned DEFAULT NULL,
  `doors` tinyint(3) unsigned DEFAULT NULL,
  `transmission` enum('manual','automatic','semi-automatic') DEFAULT NULL,
  `thumb_path` varchar(255) DEFAULT NULL,
  `default_distance` float unsigned DEFAULT 0,
  `extra_price` decimal(16,2) unsigned DEFAULT 0,
  `price_per_day` decimal(16,2) unsigned DEFAULT 0,
  `price_per_hour` decimal(16,2) unsigned DEFAULT 0,
  `rent_type` enum('day','hour','both') DEFAULT 'day' NULL,
  `status` enum('T','F') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_types_extras`;
CREATE TABLE IF NOT EXISTS `car_rental_types_extras` (
  `type_id` int(10) unsigned NOT NULL,
  `extra_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`type_id`,`extra_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `car_rental_fields`;
CREATE TABLE IF NOT EXISTS `car_rental_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `type` enum('backend','frontend','arrays') DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `source` enum('script','plugin') DEFAULT 'script',
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_multi_lang`;
CREATE TABLE IF NOT EXISTS `car_rental_multi_lang` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) unsigned DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `locale` tinyint(3) unsigned DEFAULT NULL,
  `field` varchar(50) DEFAULT NULL,
  `content` text,
  `source` enum('script','plugin','data') DEFAULT 'script',
  PRIMARY KEY (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`model`,`locale`,`field`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_options`;
CREATE TABLE IF NOT EXISTS `car_rental_options` (
  `foreign_id` int(10) unsigned NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL DEFAULT '',
  `tab_id` tinyint(3) unsigned DEFAULT NULL,
  `value` text,
  `label` text,
  `type` enum('string','text','int','float','enum','bool') NOT NULL DEFAULT 'string',
  `order` int(10) unsigned DEFAULT NULL,
  `is_visible` tinyint(1) unsigned DEFAULT '1',
  `style` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`foreign_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_roles`;
CREATE TABLE IF NOT EXISTS `car_rental_roles` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `role` varchar(255) DEFAULT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_users`;
CREATE TABLE IF NOT EXISTS `car_rental_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` blob,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  `is_active` enum('T','F') NOT NULL DEFAULT 'F',
  `ip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_working_times`;
CREATE TABLE IF NOT EXISTS `car_rental_working_times` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `monday_from` time DEFAULT '00:00:00',
  `monday_to` time DEFAULT NULL,
  `monday_dayoff` enum('T','F') DEFAULT 'F',
  `tuesday_from` time DEFAULT '00:00:00',
  `tuesday_to` time DEFAULT '23:59:00',
  `tuesday_dayoff` enum('T','F') DEFAULT 'F',
  `wednesday_from` time DEFAULT '00:00:00',
  `wednesday_to` time DEFAULT '23:59:00',
  `wednesday_dayoff` enum('T','F') DEFAULT 'F',
  `thursday_from` time DEFAULT '00:00:00',
  `thursday_to` time DEFAULT '23:59:00',
  `thursday_dayoff` enum('T','F') DEFAULT 'F',
  `friday_from` time DEFAULT '00:00:00',
  `friday_to` time DEFAULT '23:59:00',
  `friday_dayoff` enum('T','F') DEFAULT 'F',
  `saturday_from` time DEFAULT '00:00:00',
  `saturday_to` time DEFAULT '23:59:00',
  `saturday_dayoff` enum('T','F') DEFAULT 'F',
  `sunday_from` time DEFAULT '00:00:00',
  `sunday_to` time DEFAULT '23:59:00',
  `sunday_dayoff` enum('T','F') DEFAULT 'F',
  `monday_lunch_from` time DEFAULT NULL,
  `monday_lunch_to` time DEFAULT NULL,
  `tuesday_lunch_from` time DEFAULT NULL,
  `tuesday_lunch_to` time DEFAULT NULL,
  `wednesday_lunch_from` time DEFAULT NULL,
  `wednesday_lunch_to` time DEFAULT NULL,
  `thursday_lunch_from` time DEFAULT NULL,
  `thursday_lunch_to` time DEFAULT NULL,
  `friday_lunch_from` time DEFAULT NULL,
  `friday_lunch_to` time DEFAULT NULL,
  `saturday_lunch_from` time DEFAULT NULL,
  `saturday_lunch_to` time DEFAULT NULL,
  `sunday_lunch_from` time DEFAULT NULL,
  `sunday_lunch_to` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_id` (`location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_dates`;
CREATE TABLE IF NOT EXISTS `car_rental_dates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_dayoff` enum('T','F') DEFAULT 'F',
  `start_lunch` time DEFAULT NULL,
  `end_lunch` time DEFAULT NULL,
  `all_day` enum('T','F') DEFAULT 'F',
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_id` (`location_id`,`from_date`),
  KEY `is_dayoff` (`is_dayoff`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `car_rental_notifications`;
CREATE TABLE IF NOT EXISTS `car_rental_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` enum('client','admin') DEFAULT NULL,
  `transport` enum('email','sms') DEFAULT NULL,
  `variant` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipient` (`recipient`,`transport`,`variant`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `car_rental_notifications` (`id`, `recipient`, `transport`, `variant`, `is_active`) VALUES
(1, 'client', 'email', 'confirmation', 1),
(2, 'client', 'email', 'payment', 1),
(3, 'client', 'email', 'cancel', 1),
(4, 'admin', 'email', 'confirmation', 1),
(5, 'admin', 'email', 'payment', 1),
(6, 'admin', 'email', 'cancel', 1),
(7, 'admin', 'sms', 'confirmation', 1),
(8, 'admin', 'sms', 'payment', 1),
(9, 'client', 'sms', 'reminder', 1);

INSERT INTO `car_rental_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, 1, 'pjOption', 1, 'confirm_sms_admin', 'New booking has been made. ID: {BookingID}', 'script'),
(NULL, 1, 'pjOption', 1, 'payment_sms_admin', 'Reservation deposit has been paid. ID: {BookingID}', 'script'),
(NULL, 1, 'pjOption', 1, 'confirm_subject_admin', 'New reservation received', 'script'),
(NULL, 1, 'pjOption', 1, 'confirm_tokens_admin', 'New booking has been made.<br/><br/>ID: {BookingID}', 'script'),
(NULL, 1, 'pjOption', 1, 'payment_subject_admin', 'New payment received', 'script'),
(NULL, 1, 'pjOption', 1, 'payment_tokens_admin', 'Reservation deposit has been paid.<br/><br/>ID: {BookingID}', 'script'),
(NULL, 1, 'pjOption', 1, 'cancel_subject_admin', 'Reservation cancelled', 'script'),
(NULL, 1, 'pjOption', 1, 'cancel_tokens_admin', 'Reservation has been cancelled.<br/><br/>ID: {BookingID}', 'script'),
(NULL, 1, 'pjOption', 1, 'confirm_subject_client', 'Reservation confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'confirm_tokens_client', 'Dear {Name},<br/><br/>we''ve received your reservation.<br/><br/>From: {DtFrom}<br/>To: {DtTo}<br/><br/>Pickup Location: {PickupLocation}<br/>Return Location: {ReturnLocation}<br/><br/>ID: {BookingID}<br/><br/>If you want to cancel your booking use this link {CancelURL}<br/><br/>You can contact us at +123 456 789<br/><br/>Regards,<br/>Car Rental Company', 'script'),
(NULL, 1, 'pjOption', 1, 'payment_subject_client', 'Payment confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'payment_tokens_client', 'Dear {Name},<br/><br/>we''ve received payment for your reservation.<br/><br/>From: {DtFrom}<br/>To: {DtTo}<br/><br/>Pickup Location: {PickupLocation}<br/>Return Location: {ReturnLocation}<br/><br/>ID: {BookingID}<br/><br/>You can contact us at +123 456 789<br/><br/>Regards,<br/>Car Rental Company', 'script'),
(NULL, 1, 'pjOption', 1, 'cancel_subject_client', 'Cancellation confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'cancel_tokens_client', 'Dear {Name},<br/><br/>you''ve cancelled a reservation.<br/><br/>From: {DtFrom}<br/>To: {DtTo}<br/><br/>Pickup Location: {PickupLocation}<br/>Return Location: {ReturnLocation}<br/><br/>ID: {BookingID}<br/><br/>If you want to cancel your booking use this link {CancelURL}<br/><br/>You can contact us at +123 456 789<br/><br/>Regards,<br/>Car Rental Company', 'script'),
(NULL, 1, 'pjOption', 1, 'reminder_sms_client', '{CustomerName}, your reservation is confirmed on {DtFrom}', 'script');


INSERT INTO `car_rental_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_unit', 1, 'km|mile::km', NULL, 'enum', 1, 1, NULL),
(1, 'o_booking_periods', 1, 'perday|perhour|both::perday', 'Per day only|Per hour only|Per day and per hour', 'enum', 2, 1, NULL),
(1, 'o_new_day_per_day', 1, '2', NULL, 'int', 3, 1, NULL),
(1, 'o_min_hour', 1, '1', NULL, 'int', 4, 1, NULL),
(1, 'o_theme', 1, 'theme1|theme2|theme3|theme4|theme5|theme6|theme7|theme8|theme9|theme10::theme1', 'Theme 1|Theme 2|Theme 3|Theme 4|Theme 5|Theme 6|Theme 7|Theme 8|Theme 9|Theme 10', 'enum', 5, 0, NULL),
(1, 'o_booking_pending', 1, '1', NULL, 'int', 5, 1, NULL),
(1, 'o_time_period', 1, '12hours|24hours::12hours', '12 hours|24 hours', 'enum', 6, 1, NULL),
(1, 'o_deposit_payment', 1, '10', NULL, 'int', 7, 1, NULL),
(1, 'o_deposit_type', 1, 'amount|percent::percent', 'Amount|Percent', 'enum', 8, 0, NULL),
(1, 'o_tax_payment', 1, '9', NULL, 'int', 9, 1, NULL),
(1, 'o_tax_type', 1, 'amount|percent::amount', 'Amount|Percent', 'enum', 10, 0, NULL),
(1, 'o_security_payment', 1, NULL, NULL, 'float', 11, 1, NULL),
(1, 'o_insurance_payment', 1, '10', NULL, 'int', 12, 1, NULL),
(1, 'o_insurance_payment_type', 1, 'percent|perday|perbooking::perday', 'Percent|Per day|Per Reservation', 'enum', 13, 0, NULL),
(1, 'o_booking_status', 1, 'confirmed|pending|cancelled::pending', 'Confirmed|Pending|Cancel', 'enum', 14, 1, NULL),
(1, 'o_payment_status', 1, 'confirmed|pending|cancelled::confirmed', 'Confirmed|Pending|Cancel', 'enum', 15, 1, NULL),
(1, 'o_payment_disable', 1, '1|0::0', NULL, 'bool', 16, 1, NULL),
(1, 'o_thankyou_page', 1, 'http://www.phpjabbers.com', NULL, 'string', 17, 1, NULL),
(1, 'o_website_seo', 1, 'Yes|No::No', NULL, 'enum', 18, 0, NULL),
(1, 'o_cancel_booking_page', 1, 'http://www.phpjabbers.com', NULL, 'string', 18, 1, NULL),
(1, 'o_bf_include_title', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 1, 1, NULL),
(1, 'o_bf_include_name', 2, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 2, 1, NULL),
(1, 'o_bf_include_email', 2, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 4, 1, NULL),
(1, 'o_bf_include_phone', 2, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 5, 1, NULL),
(1, 'o_bf_include_company', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 6, 1, NULL),
(1, 'o_bf_include_address', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 7, 1, NULL),
(1, 'o_bf_include_country', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 10, 1, NULL),
(1, 'o_bf_include_state', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 11, 1, NULL),
(1, 'o_bf_include_city', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 12, 1, NULL),
(1, 'o_bf_include_zip', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 13, 1, NULL),
(1, 'o_bf_include_notes', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 14, 1, NULL),
(1, 'o_bf_include_captcha', 2, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 15, 1, NULL),
(1, 'o_terms', 3, '', NULL, 'text', 5, 1, NULL),
(1, 'o_allow_paypal', 3, 'Yes|No::Yes', NULL, 'enum', 20, 1, NULL),
(1, 'o_paypal_address', 3, 'paypal_seller@example.com', NULL, 'string', 21, 1, NULL),
(1, 'o_allow_authorize', 3, 'Yes|No::No', NULL, 'enum', 22, 1, NULL),
(1, 'o_authorize_merchant_id', 3, NULL, NULL, 'string', 23, 1, NULL),
(1, 'o_authorize_transkey', 3, NULL, NULL, 'string', 24, 1, NULL),
(1, 'o_authorize_timezone', 3, '-43200|-39600|-36000|-32400|-28800|-25200|-21600|-18000|-14400|-10800|-7200|-3600|0|3600|7200|10800|14400|18000|21600|25200|28800|32400|36000|39600|43200|46800::0', 'GMT-12:00|GMT-11:00|GMT-10:00|GMT-09:00|GMT-08:00|GMT-07:00|GMT-06:00|GMT-05:00|GMT-04:00|GMT-03:00|GMT-02:00|GMT-01:00|GMT|GMT+01:00|GMT+02:00|GMT+03:00|GMT+04:00|GMT+05:00|GMT+06:00|GMT+07:00|GMT+08:00|GMT+09:00|GMT+10:00|GMT+11:00|GMT+12:00|GMT+13:00', 'enum', 25, 1, NULL),
(1, 'o_authorize_md5_hash', 3, NULL, NULL, 'string', 26, 1, NULL),
(1, 'o_allow_creditcard', 3, 'Yes|No::No', NULL, 'enum', 27, 1, NULL),
(1, 'o_allow_bank', 3, 'Yes|No::No', NULL, 'enum', 28, 1, NULL),
(1, 'o_bank_account', 3, NULL, NULL, 'text', 29, 1, NULL),
(1, 'o_allow_cash', 3, '1|0::1', NULL, 'enum', 30, 1, NULL),
(1, 'o_email_confirmation', 5, '0|1::1', 'No|Yes', 'enum', 1, 1, NULL),
(1, 'o_admin_email_confirmation', 5, '0|1::1', 'No|Yes', 'enum', 1, 1, NULL),
(1, 'o_sms_confirmation_message', 5, '', NULL, 'text', 2, 1, NULL),
(1, 'o_email_confirmation_subject', 5, '', NULL, 'string', 2, 1, NULL),
(1, 'o_admin_sms_confirmation_message', 5, '', NULL, 'text', 2, 1, NULL),
(1, 'o_admin_email_confirmation_subject', 5, '', NULL, 'string', 2, 1, NULL),
(1, 'o_email_confirmation_message', 5, '', NULL, 'text', 3, 1, NULL),
(1, 'o_admin_email_confirmation_message', 5, '', NULL, 'text', 3, 1, NULL),
(1, 'o_email_payment', 5, '0|1::1', 'No|Yes', 'enum', 4, 1, NULL),
(1, 'o_admin_email_payment', 5, '0|1::1', 'No|Yes', 'enum', 4, 1, NULL),
(1, 'o_admin_sms_payment_message', 5, '', NULL, 'text', 4, 1, NULL),
(1, 'o_email_payment_subject', 5, '', NULL, 'string', 5, 1, NULL),
(1, 'o_admin_email_payment_subject', 5, '', NULL, 'string', 5, 1, NULL),
(1, 'o_email_payment_message', 5, '', NULL, 'text', 6, 1, NULL),
(1, 'o_admin_email_payment_message', 5, '', NULL, 'text', 6, 1, NULL),
(1, 'o_email_cancel', 5, '0|1::1', 'No|Yes', 'enum', 7, 1, NULL),
(1, 'o_admin_email_cancel', 5, '0|1::1', 'No|Yes', 'enum', 7, 1, NULL),
(1, 'o_email_cancel_subject', 5, '', NULL, 'string', 8, 1, NULL),
(1, 'o_admin_email_cancel_subject', 5, '', NULL, 'string', 8, 1, NULL),
(1, 'o_email_cancel_message', 5, '', NULL, 'text', 9, 1, NULL),
(1, 'o_admin_email_cancel_message', 5, '', NULL, 'text', 9, 1, NULL),
(1, 'o_multi_lang', 99, '1|0::1', NULL, 'enum', NULL, 0, NULL),
(1, 'o_fields_index', 99, 'd874fcc5fe73b90d770a544664a3775d', NULL, 'string', NULL, 0, NULL);


INSERT INTO `car_rental_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, 1, 'pjOption', 1, 'o_sms_confirmation_message', '{CustomerName}, your reservation is confirmed on {DtFrom}', 'script'),
(NULL, 1, 'pjOption', 1, 'o_sms_payment_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_sms_cancel_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_sms_confirmation_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_sms_payment_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_sms_cancel_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_confirmation_subject', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_confirmation_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_payment_subject', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_payment_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_cancel_subject', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_admin_email_cancel_message', '', 'script'),
(NULL, 1, 'pjOption', 1, 'o_terms', 'Add your Booking Terms here. \r\n\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. \r\n\r\nLorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \r\n\r\nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_confirmation_subject', 'Reservation confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_confirmation_message', 'Dear {Name},\r\n\r\nwe''ve received your reservation.\r\n\r\nFrom: {DtFrom}\r\nTo: {DtTo}\r\n\r\nPickup Location: {PickupLocation}\r\nReturn Location: {ReturnLocation}\r\n\r\nID: {BookingID}\r\n\r\nIf you want to cancel your booking use this link {CancelURL}\r\n\r\nYou can contact us at +123 456 789\r\n\r\nRegards,\r\nCar Rental Company', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_payment_subject', 'Payment confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_payment_message', 'Dear {Name},\r\n\r\nwe''ve received payment for your reservation.\r\n\r\nFrom: {DtFrom}\r\nTo: {DtTo}\r\n\r\nPickup Location: {PickupLocation}\r\nReturn Location: {ReturnLocation}\r\n\r\nID: {BookingID}\r\n\r\nYou can contact us at +123 456 789\r\n\r\nRegards,\r\nCar Rental Company', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_cancel_subject', 'Cancellation confirmation', 'script'),
(NULL, 1, 'pjOption', 1, 'o_email_cancel_message', 'Dear {Name},\r\n\r\nyou''ve cancelled a reservation.\r\n\r\nFrom: {DtFrom}\r\nTo: {DtTo}\r\n\r\nPickup Location: {PickupLocation}\r\nReturn Location: {ReturnLocation}\r\n\r\nID: {BookingID}\r\n\r\nIf you want to cancel your booking use this link {CancelURL}\r\n\r\nYou can contact us at +123 456 789\r\n\r\nRegards,\r\nCar Rental Company', 'script');

UPDATE `car_rental_plugin_base_options` SET `value`='Yes|No::Yes' WHERE `key`='o_auto_backup';

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'user', 'backend', 'Username', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Username', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pass', 'backend', 'Password', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'email', 'backend', 'E-Mail', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'url', 'backend', 'URL', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'URL', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'created', 'backend', 'Created', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'DateTime', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnSave', 'backend', 'Save', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Save', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnReset', 'backend', 'Reset', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reset', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'addLocale', 'backend', 'Add language', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add language', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuLang', 'backend', 'Menu Multi lang', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Multi Lang', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuPlugins', 'backend', 'Menu Plugins', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Plugins', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuUsers', 'backend', 'Menu Users', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Users', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuOptions', 'backend', 'Menu Options', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Options', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuLogout', 'backend', 'Menu Logout', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Logout', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnUpdate', 'backend', 'Update', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblChoose', 'backend', 'Choose', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnSearch', 'backend', 'Search', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Search', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'backend', 'backend', 'Backend titles', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back-end titles', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'frontend', 'backend', 'Front-end titles', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Front-end titles', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'locales', 'backend', 'Languages', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'adminLogin', 'backend', 'Admin Login', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin Login', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnLogin', 'backend', 'Login', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Login', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuDashboard', 'backend', 'Menu Dashboard', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dashboard', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOptionList', 'backend', 'Option list', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Option list', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAdd', 'backend', 'Button Add', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add +', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDelete', 'backend', 'Delete', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblType', 'backend', 'Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblName', 'backend', 'Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblRole', 'backend', 'Role', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Role', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblStatus', 'backend', 'Status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblIsActive', 'backend', 'Is Active', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is confirmed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateUser', 'backend', 'Update user', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update user', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddUser', 'backend', 'Add user', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add New User', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblValue', 'backend', 'Value', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Value', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOption', 'backend', 'Option', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Option', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDays', 'backend', 'Days', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'day(s)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuLocales', 'backend', 'Menu Languages', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblYes', 'backend', 'Yes', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblNo', 'backend', 'No', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblError', 'backend', 'Error', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Error', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnBack', 'backend', 'Button Back', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '&laquo; Back', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnCancel', 'backend', 'Button Cancel', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblForgot', 'backend', 'Forgot password', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Forgot password', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'adminForgot', 'backend', 'Forgot password', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password reminder', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnSend', 'backend', 'Button Send', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'emailForgotSubject', 'backend', 'Email / Forgot Subject', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password reminder', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'emailForgotBody', 'backend', 'Email / Forgot Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dear {Name},Your password: {Password}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuProfile', 'backend', 'Menu Profile', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Profile', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesTitle', 'backend', 'Infobox / Locales Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesBody', 'backend', 'Infobox / Locales Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendTitle', 'backend', 'Infobox / Locales Backend Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Backend Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendBody', 'backend', 'Infobox / Locales Backend Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Backend Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendTitle', 'backend', 'Infobox / Locales Frontend Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Frontend Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendBody', 'backend', 'Infobox / Locales Frontend Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Frontend Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingPricesTitle', 'backend', 'Infobox / Listing Prices Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Prices Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingPricesBody', 'backend', 'Infobox / Listing Prices Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Prices Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingBookingsTitle', 'backend', 'Infobox / Listing Bookings Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Bookings Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingBookingsBody', 'backend', 'Infobox / Listing Bookings Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Bookings Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingContactTitle', 'backend', 'Infobox / Listing Contact Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Contact Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingContactBody', 'backend', 'Infobox / Listing Contact Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Contact Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingAddressTitle', 'backend', 'Infobox / Listing Address Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Address Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingAddressBody', 'backend', 'Infobox / Listing Address Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Address Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingExtendTitle', 'backend', 'Infobox / Extend exp.date Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extend exp.date Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoListingExtendBody', 'backend', 'Infobox / Extend exp.date Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extend exp.date Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuBackup', 'backend', 'Menu Backup', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnBackup', 'backend', 'Button Backup', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBackupDatabase', 'backend', 'Backup / Database', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup database', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBackupFiles', 'backend', 'Backup / Files', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup files', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridChooseAction', 'backend', 'Grid / Choose Action', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose Action', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridGotoPage', 'backend', 'Grid / Go to page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Go to page:', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridTotalItems', 'backend', 'Grid / Total items', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total items:', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridItemsPerPage', 'backend', 'Grid / Items per page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Items per page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridPrevPage', 'backend', 'Grid / Prev page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Prev page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridPrev', 'backend', 'Grid / Prev', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '&laquo; Prev', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridNextPage', 'backend', 'Grid / Next page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridNext', 'backend', 'Grid / Next', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next &raquo;', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridDeleteConfirmation', 'backend', 'Grid / Delete confirmation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridConfirmationTitle', 'backend', 'Grid / Confirmation Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected entry?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridActionTitle', 'backend', 'Grid / Action Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Action confirmation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridBtnOk', 'backend', 'Grid / Button OK', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'OK', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridBtnCancel', 'backend', 'Grid / Button Cancel', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridBtnDelete', 'backend', 'Grid / Button Delete', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'gridEmptyResult', 'backend', 'Grid / Empty resultset', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No records found', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'multilangTooltip', 'backend', 'MultiLang / Tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To fill in description and titles into any language just click on its language flag icon.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblIp', 'backend', 'IP address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'IP address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUserCreated', 'backend', 'User / Registration Date & Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Registration date/time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_currency', 'backend', 'Options / Currency', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Currency', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_date_format', 'backend', 'Options / Date format', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date format', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_timezone', 'backend', 'Options / Timezone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Timezone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_week_start', 'backend', 'Options / First day of the week', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'First day of the week', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_T', 'arrays', 'u_statarr_ARRAY_T', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Active', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_F', 'arrays', 'u_statarr_ARRAY_F', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Inactive', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_active', 'arrays', 'filter_ARRAY_active', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Active', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_inactive', 'arrays', 'filter_ARRAY_inactive', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Inactive', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_T', 'arrays', '_yesno_ARRAY_T', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_F', 'arrays', '_yesno_ARRAY_F', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mr', 'arrays', 'personal_titles_ARRAY_mr', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mr.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mrs', 'arrays', 'personal_titles_ARRAY_mrs', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mrs.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_miss', 'arrays', 'personal_titles_ARRAY_miss', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Miss', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_ms', 'arrays', 'personal_titles_ARRAY_ms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Ms.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_dr', 'arrays', 'personal_titles_ARRAY_dr', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dr.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_prof', 'arrays', 'personal_titles_ARRAY_prof', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Prof.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_rev', 'arrays', 'personal_titles_ARRAY_rev', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rev.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_other', 'arrays', 'personal_titles_ARRAY_other', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Other', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-43200', 'arrays', 'timezones_ARRAY_-43200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-12:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-39600', 'arrays', 'timezones_ARRAY_-39600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-11:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-36000', 'arrays', 'timezones_ARRAY_-36000', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-10:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-32400', 'arrays', 'timezones_ARRAY_-32400', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-09:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-28800', 'arrays', 'timezones_ARRAY_-28800', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-08:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-25200', 'arrays', 'timezones_ARRAY_-25200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-07:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-21600', 'arrays', 'timezones_ARRAY_-21600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-06:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-18000', 'arrays', 'timezones_ARRAY_-18000', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-05:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-14400', 'arrays', 'timezones_ARRAY_-14400', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-04:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-10800', 'arrays', 'timezones_ARRAY_-10800', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-03:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-7200', 'arrays', 'timezones_ARRAY_-7200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-02:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-3600', 'arrays', 'timezones_ARRAY_-3600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-01:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_0', 'arrays', 'timezones_ARRAY_0', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_3600', 'arrays', 'timezones_ARRAY_3600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+01:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_7200', 'arrays', 'timezones_ARRAY_7200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+02:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_10800', 'arrays', 'timezones_ARRAY_10800', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+03:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_14400', 'arrays', 'timezones_ARRAY_14400', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+04:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_18000', 'arrays', 'timezones_ARRAY_18000', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+05:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_21600', 'arrays', 'timezones_ARRAY_21600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+06:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_25200', 'arrays', 'timezones_ARRAY_25200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+07:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_28800', 'arrays', 'timezones_ARRAY_28800', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+08:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_32400', 'arrays', 'timezones_ARRAY_32400', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+09:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_36000', 'arrays', 'timezones_ARRAY_36000', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+10:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_39600', 'arrays', 'timezones_ARRAY_39600', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+11:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_43200', 'arrays', 'timezones_ARRAY_43200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+12:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_46800', 'arrays', 'timezones_ARRAY_46800', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+13:00', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU01', 'arrays', 'error_titles_ARRAY_AU01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU03', 'arrays', 'error_titles_ARRAY_AU03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User added!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU04', 'arrays', 'error_titles_ARRAY_AU04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User failed to add.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU08', 'arrays', 'error_titles_ARRAY_AU08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO01', 'arrays', 'error_titles_ARRAY_AO01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB01', 'arrays', 'error_titles_ARRAY_AB01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB02', 'arrays', 'error_titles_ARRAY_AB02', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup completed!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB03', 'arrays', 'error_titles_ARRAY_AB03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup failed!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB04', 'arrays', 'error_titles_ARRAY_AB04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup failed!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA10', 'arrays', 'error_titles_ARRAY_AA10', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Account not found!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA11', 'arrays', 'error_titles_ARRAY_AA11', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password send!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA12', 'arrays', 'error_titles_ARRAY_AA12', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password not send!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA13', 'arrays', 'error_titles_ARRAY_AA13', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU01', 'arrays', 'error_bodies_ARRAY_AU01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU03', 'arrays', 'error_bodies_ARRAY_AU03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU04', 'arrays', 'error_bodies_ARRAY_AU04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We are sorry, but the user has not been added.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU08', 'arrays', 'error_bodies_ARRAY_AU08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User your looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO01', 'arrays', 'error_bodies_ARRAY_AO01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Options have been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ALC01', 'arrays', 'error_bodies_ARRAY_ALC01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB01', 'arrays', 'error_bodies_ARRAY_AB01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We recommend you to regularly back up your database and files to prevent any loss of information.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB02', 'arrays', 'error_bodies_ARRAY_AB02', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All backup files have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB03', 'arrays', 'error_bodies_ARRAY_AB03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No option was selected.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB04', 'arrays', 'error_bodies_ARRAY_AB04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup not performed.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA10', 'arrays', 'error_bodies_ARRAY_AA10', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Given email address is not associated with any account.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA11', 'arrays', 'error_bodies_ARRAY_AA11', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'For further instructions please check your mailbox.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA12', 'arrays', 'error_bodies_ARRAY_AA12', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We\'re sorry, please try again later.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA13', 'arrays', 'error_bodies_ARRAY_AA13', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to your profile have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_1', 'arrays', 'months_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'January', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_2', 'arrays', 'months_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'February', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_3', 'arrays', 'months_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'March', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_4', 'arrays', 'months_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'April', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_5', 'arrays', 'months_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'May', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_6', 'arrays', 'months_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'June', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_7', 'arrays', 'months_ARRAY_7', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'July', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_8', 'arrays', 'months_ARRAY_8', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'August', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_9', 'arrays', 'months_ARRAY_9', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'September', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_10', 'arrays', 'months_ARRAY_10', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'October', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_11', 'arrays', 'months_ARRAY_11', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'November', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'months_ARRAY_12', 'arrays', 'months_ARRAY_12', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'December', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_0', 'arrays', 'days_ARRAY_0', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sunday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_1', 'arrays', 'days_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Monday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_2', 'arrays', 'days_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tuesday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_3', 'arrays', 'days_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wednesday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_4', 'arrays', 'days_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Thursday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_5', 'arrays', 'days_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Friday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'days_ARRAY_6', 'arrays', 'days_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Saturday', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_0', 'arrays', 'day_names_ARRAY_0', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'S', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_1', 'arrays', 'day_names_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'M', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_2', 'arrays', 'day_names_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'T', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_3', 'arrays', 'day_names_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'W', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_4', 'arrays', 'day_names_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'T', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_5', 'arrays', 'day_names_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'F', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_6', 'arrays', 'day_names_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'S', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_1', 'arrays', 'short_months_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jan', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_2', 'arrays', 'short_months_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Feb', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_3', 'arrays', 'short_months_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mar', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_4', 'arrays', 'short_months_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Apr', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_5', 'arrays', 'short_months_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'May', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_6', 'arrays', 'short_months_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jun', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_7', 'arrays', 'short_months_ARRAY_7', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jul', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_8', 'arrays', 'short_months_ARRAY_8', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Aug', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_9', 'arrays', 'short_months_ARRAY_9', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sep', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_10', 'arrays', 'short_months_ARRAY_10', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oct', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_11', 'arrays', 'short_months_ARRAY_11', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Nov', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_12', 'arrays', 'short_months_ARRAY_12', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dec', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_1', 'arrays', 'status_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You are not loged in.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_2', 'arrays', 'status_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Access denied. You have not requisite rights to.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_3', 'arrays', 'status_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Empty resultset.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_7', 'arrays', 'status_ARRAY_7', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The operation is not allowed in demo mode.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_123', 'arrays', 'status_ARRAY_123', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your hosting account does not allow uploading such a large image.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_999', 'arrays', 'status_ARRAY_999', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No permisions to edit the property', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_998', 'arrays', 'status_ARRAY_998', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No permisions to edit the reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_997', 'arrays', 'status_ARRAY_997', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No reservation found', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_996', 'arrays', 'status_ARRAY_996', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No property for the reservation found', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9999', 'arrays', 'status_ARRAY_9999', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your registration was successfull.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9998', 'arrays', 'status_ARRAY_9998', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your registration was successfull. Your account needs to be approved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9997', 'arrays', 'status_ARRAY_9997', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail address already exist', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_1', 'arrays', 'login_err_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong username or password', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_2', 'arrays', 'login_err_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Access denied', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_3', 'arrays', 'login_err_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Account is disabled', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'localeArrays', 'backend', 'Locale / Arrays titles', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Arrays titles', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysTitle', 'backend', 'Locale / Languages Array Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Arrays Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysBody', 'backend', 'Locale / Languages Array Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Array Body', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lnkBack', 'backend', 'Link Back', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'locale_order', 'backend', 'Locale / Order', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Order', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'locale_is_default', 'backend', 'Locale / Is default', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is default', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'locale_flag', 'backend', 'Locale / Flag', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Flag', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'locale_title', 'backend', 'Locale / Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnDelete', 'backend', 'Button Delete', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnContinue', 'backend', 'Button Continue', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Continue', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'vr_email_taken', 'backend', 'Users / Email already taken', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User with this email address already exists.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'revert_status', 'backend', 'Revert status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Revert status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblExport', 'backend', 'Export', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_send_email', 'backend', 'opt_o_send_email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_host', 'backend', 'opt_o_smtp_host', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMTP Host', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_port', 'backend', 'opt_o_smtp_port', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMTP Port', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_user', 'backend', 'opt_o_smtp_user', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMTP Username', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_pass', 'backend', 'opt_o_smtp_pass', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMTP Password', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_datetime_format', 'backend', 'Options / Date Time format', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date Time  format', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_deposit_payment', 'backend', 'Options / Deposit payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deposit payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_deposit_payment_text', 'backend', 'Options / Deposit payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set flat amount or % of total price.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_tax_payment_text', 'backend', 'Options / Tax payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'If there is no tax for payments, just enter 0. You can also add a fixed tax value or % of the total price.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_tax_payment', 'backend', 'Options / Tax payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_security_payment', 'backend', 'Options / Security payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_security_payment_text', 'backend', 'Options / Security payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The system does not calculate the Security payment in the Deposit payment amount or the Total rental price. It will be used for defining reservation payments for each reservation that you can manage on Payments tab while editing a reservation.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_insurance_payment_text', 'backend', 'Options / Insurance payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add an insurance fee for each booking or just leave it 0. You can choose if the fee is per day, per reservation or percentage of the rental amount.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_insurance_payment', 'backend', 'Options / Insurance payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Insurance payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_status', 'backend', 'Options / Booking status if not paid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking status if not paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_payment_status', 'backend', 'Options / Booking status if paid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking status if paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_status_text', 'backend', 'Options / Booking status if not paid text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set what the default reservation status should be, if payment hasn\'t been made. ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_payment_disable', 'backend', 'Options / Disable payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Disable payments', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_payment_disable_text', 'backend', 'Options / Disable payments text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can disable online payments and only accept bookings.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_allow_paypal', 'backend', 'Options / Allow PayPal payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Allow payments with PayPal', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_paypal_address', 'backend', 'Options / Paypal address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paypal address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_allow_authorize', 'backend', 'Options / Allow Authorize.net payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Allow payments with Authorize.net', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_merchant_id', 'backend', 'Options / Authorize Merchant ID', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize Merchant ID', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_transkey', 'backend', 'Options / Authorize Transaction Key', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize Transaction Key', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_allow_creditcard', 'backend', 'Options / Allow payments with credit card', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Collect Credit Card details for offline processing', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_allow_bank', 'backend', 'Options / Allow Bank payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Provide Bank account details for wire transfers', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bank_account', 'backend', 'Options / Bank Account', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank Account', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page', 'backend', 'Options / Thank you page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Thank you page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_booking_page', 'backend', 'Options / Cancel booking page', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel booking page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_title', 'backend', 'Options / Booking form Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_name', 'backend', 'Options / Booking form Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_email', 'backend', 'Options / Booking form Email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_phone', 'backend', 'Options / Booking form Phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_company', 'backend', 'Options / Booking form Company', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_address', 'backend', 'Options / Booking form Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address 1', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_country', 'backend', 'Options / Booking form Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_state', 'backend', 'Options / Booking form State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'State', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_city', 'backend', 'Options / Booking form City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_zip', 'backend', 'Options / Booking form Zip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_notes', 'backend', 'Options / Booking form Notes', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_captcha', 'backend', 'Options / Booking form Capcha', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Capcha', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation', 'backend', 'Options / New Reservation email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Reservation Received email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_text', 'backend', 'Options / Send confirmation email text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to send an email to clients after they make new reservation. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_subject', 'backend', 'Options / New Reservation email subject', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Reservation email subject', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_message', 'backend', 'Options / Confirmation email message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Reservation email message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment', 'backend', 'Options / Send payment email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_text', 'backend', 'Options / Send payment email text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to send confirmation email to clients after they make a payment for their reservations.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_subject', 'backend', 'Options / Payment email subject', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment confirmation email subject', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_message', 'backend', 'Options / Payment email message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment confirmation email message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel', 'backend', 'Options / Send cancel email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send cancellation email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_text', 'backend', 'Options / Send cancel email text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to send confirmation email to clients after they cancel for their reservation.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_subject', 'backend', 'Options / Cancel email subject', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancellation email subject', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_message', 'backend', 'Options / Cancel email message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancellation email message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuBookings', 'backend', 'Menus / Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuCheckoutForm', 'backend', 'Menus / Checkout Form', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout Form', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuConfirmation', 'backend', 'Menus / Notifications', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO02', 'arrays', 'error_titles_ARRAY_AO02', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO03', 'arrays', 'error_titles_ARRAY_AO03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO04', 'arrays', 'error_titles_ARRAY_AO04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO02', 'arrays', 'error_bodies_ARRAY_AO02', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO03', 'arrays', 'error_bodies_ARRAY_AO03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The booking form has been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO04', 'arrays', 'error_bodies_ARRAY_AO04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email settings have been successfully updated', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoBookingsTitle', 'backend', 'Infobox / Booking title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Options', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoBookingsBody', 'backend', 'Infobox / Booking Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can choose your payment methods and set payment gateway accounts and payment preferences. Note that for cash payments the system will not be able to collect deposit amount online.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoBookingFormTitle', 'backend', 'Infobox / Booking Form title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking form', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoBookingFormBody', 'backend', 'Infobox / Booking Form body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select the available and required fields on the front-end. Select \'Yes\' if you want to include the field in the booking form, otherwise select No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'o_bf_include_text', 'backend', 'Options / Booking form text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \"Yes\" if you want to include the field in the booking form, otherwise select \"No\"', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuTerms', 'backend', 'Menus / Terms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuInstall', 'backend', 'Menu Install', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuCars', 'backend', 'Menu Cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Inventory', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuReservations', 'backend', 'Menu Reservations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuLocations', 'backend', 'Office Locations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Office Locations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuPreview', 'backend', 'Menu Preview', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Preview', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuTypes', 'backend', 'Menu Types', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Types', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuExtras', 'backend', 'Menu Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddType', 'backend', 'Lable Add Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddCar', 'backend', 'Lable Add Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add New Car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddExtra', 'backend', 'Lable Add Extra', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add Extra', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddLocation', 'backend', 'Lable Add Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add New Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddBooking', 'backend', 'Lable Add Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add New Reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAllBookings', 'backend', 'Lable All Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All Bookings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAvailability', 'backend', 'Lable Availability', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Availability', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAllCars', 'backend', 'Lable All Cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAllTypes', 'backend', 'Lable All Types', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Types', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAllLocations', 'backend', 'Lable All Locations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Locations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstall', 'backend', 'Lable Install', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallText', 'backend', 'Lable Install Text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Follow the instructions below to embed the script on your website. If you have multi language front-end you can choose how to integrate it into your website: all languages on 1 page or have each language on separate web page.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstall_step_1', 'backend', 'Lable Install Step 1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 1. (Required) Copy the code below and put it in the HEAD tag of your web page.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstall_step_2', 'backend', 'Lable Install Step 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2. (Required) Copy the code below and put it in your web page where you want the script to appear.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoConfirmationsTitle', 'backend', 'Infobox / Notifications Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications to customers', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoConfirmationsBody', 'backend', 'Infobox / Confirmations Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set and customize email and SMS notifications to your customers to prompt new actions or send them important information. You can enable or disable sending the notifications below. You can personalize emails with subscribers\' names and other information using the available tokens.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_message_text', 'backend', 'Option / Email Confirmations Tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br >{Name}<br >{Email}<br >{Phone}<br >{Country}<br >{City}<br >{State}<br >{Zip}<br >{Address}<br >{Company}<br >{Notes}<br >{DtFrom}{DtTo}<br >{PickupLocation}<br >{ReturnLocation}<br >{Type}<br >{Extras}<br >{BookingID}<br >{UniqueID}<br >{Deposit}<br >{Total}<br >{Tax}<br >{Security}<br >{Insurance}<br >{PaymentMethod}<br >{CCType}<br >{CCNum}<br >{CCExp}<br >{CCSec}<br >{CancelURL}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_message_text', 'backend', 'Option / Email Payment Confirmation Tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br >{Name}<br >{Email}<br >{Phone}<br >{Country}<br >{City}<br >{State}<br >{Zip}<br >{Address}<br >{Company}<br >{Notes}<br >{DtFrom}{DtTo}<br >{PickupLocation}<br >{ReturnLocation}<br >{Type}<br >{Extras}<br >{BookingID}<br >{UniqueID}<br >{Deposit}<br >{Total}<br >{Tax}<br >{Security}<br >{Insurance}<br >{PaymentMethod}<br >{CCType}<br >{CCNum}<br >{CCExp}<br >{CCSec}<br >{CancelURL}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_message_text', 'backend', 'Option / Email Cancel Tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br >{Name}<br >{Email}<br >{Phone}<br >{Country}<br >{City}<br >{State}<br >{Zip}<br >{Address}<br >{Company}<br >{Notes}<br >{DtFrom}{DtTo}<br >{PickupLocation}<br >{ReturnLocation}<br >{Type}<br >{Extras}<br >{BookingID}<br >{UniqueID}<br >{Deposit}<br >{Total}<br >{Tax}<br >{Security}<br >{Insurance}<br >{PaymentMethod}<br >{CCType}<br >{CCNum}<br >{CCExp}<br >{CCSec}<br >{CancelURL}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_address', 'backend', 'Option / Notification email address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notification email address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_name', 'backend', 'Label / Location Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_country', 'backend', 'Label / Location Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_state', 'backend', 'Label / Location State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'State', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_city', 'backend', 'Label / Location City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_address_1', 'backend', 'Label / Location Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_address_2', 'backend', 'Label / Location Address 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address 2', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_zip', 'backend', 'Label / Location Zip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_email', 'backend', 'Label / Location Email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_phone', 'backend', 'Label / Location Phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_opening_time', 'backend', 'Label / Location Opening Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Opening Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_availability', 'backend', 'Label / Location Available cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_city_addr_zip', 'backend', 'Label / Location City, Address, Zip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City, Address, Zip', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL01', 'arrays', 'error_titles_ARRAY_AL01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL01', 'arrays', 'error_bodies_ARRAY_AL01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Location have been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL03', 'arrays', 'error_titles_ARRAY_AL03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Changes Saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL03', 'arrays', 'error_bodies_ARRAY_AL03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New location has been added to the list.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL04', 'arrays', 'error_titles_ARRAY_AL04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Location failed to add.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL08', 'arrays', 'error_titles_ARRAY_AL08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Location not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL08', 'arrays', 'error_bodies_ARRAY_AL08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oops! The location you are looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cr_delete_selected', 'backend', 'Listings / Delete selected', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete selected', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cr_delete_confirmation', 'backend', 'Listings / Delete confirmation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected entry(s)?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateLocation', 'backend', 'Lable Update Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAllExtras', 'backend', 'Lable All Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateExtra', 'backend', 'Lable Update Extra', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Extra', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AX01', 'arrays', 'error_titles_ARRAY_AX01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AX01', 'arrays', 'error_bodies_ARRAY_AX01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this extra have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AX03', 'arrays', 'error_titles_ARRAY_AX03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra Added', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AX03', 'arrays', 'error_bodies_ARRAY_AX03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Extra has been added to the list.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AX04', 'arrays', 'error_titles_ARRAY_AX04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra failed to add.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AX08', 'arrays', 'error_titles_ARRAY_AX08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL04', 'arrays', 'error_bodies_ARRAY_AL04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'An error occurred! Data has not been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AX04', 'arrays', 'error_bodies_ARRAY_AX04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'An error occurred! Data has not been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AX08', 'arrays', 'error_bodies_ARRAY_AX08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oops! The extra you are looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_title', 'backend', 'Extra / Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_price', 'backend', 'Extra / Price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_count', 'backend', 'Extra / Count', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Count', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_per_ARRAY_booking', 'arrays', 'extra_per_ARRAY_booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_per_ARRAY_day', 'arrays', 'extra_per_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_all', 'arrays', 'filter_ARRAY_all', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT01', 'arrays', 'error_titles_ARRAY_AT01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT01', 'arrays', 'error_bodies_ARRAY_AT01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this type have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT03', 'arrays', 'error_titles_ARRAY_AT03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type Added', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT03', 'arrays', 'error_bodies_ARRAY_AT03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Type has been added to the list.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT08', 'arrays', 'error_titles_ARRAY_AT08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT04', 'arrays', 'error_bodies_ARRAY_AT04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'An error occurred! Data has not been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT04', 'arrays', 'error_titles_ARRAY_AT04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type failed to add.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT08', 'arrays', 'error_bodies_ARRAY_AT08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oops! The type you are looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateType', 'backend', 'Lable Update Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_size', 'backend', 'Type Size', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_description', 'backend', 'Type Description', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Description', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_image', 'backend', 'Type Image', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Image', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_passengers', 'backend', 'Type Num. of passengers', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Num. of passengers', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_doors', 'backend', 'Type / Number of doors', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of doors', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_luggages', 'backend', 'Type / Pieces of luggage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pieces of bags', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_extras', 'backend', 'Type / Available extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_transmission', 'backend', 'Type / Transmission', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Transmission', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_name', 'backend', 'Type / Type Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_car_models', 'backend', 'Type / Car models', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car models', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_num_cars', 'backend', 'Type / Number of cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_size_type', 'backend', 'Type / Size / Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size / Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_transmissions_ARRAY_manual', 'arrays', 'type_transmissions_ARRAY_manual', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Manual', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_transmissions_ARRAY_automatic', 'arrays', 'type_transmissions_ARRAY_automatic', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Automatic', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_transmissions_ARRAY_semi-automatic', 'arrays', 'type_transmissions_ARRAY_semi-automatic', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Semi-automatic', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_sizes_ARRAY_small', 'arrays', 'type_sizes_ARRAY_small', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Small', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_sizes_ARRAY_medium', 'arrays', 'type_sizes_ARRAY_medium', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Medium', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_sizes_ARRAY_large', 'arrays', 'type_sizes_ARRAY_large', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Large', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cr_choose', 'backend', 'Label/ Choose', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '-- Choose --', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateCar', 'backend', 'Lable Update Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_location', 'backend', 'Car / Current Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_make', 'backend', 'Car / Make', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Make', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_model', 'backend', 'Car / Model', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Model', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_make_model', 'backend', 'Car / Make & Model', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Make & Model', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_type', 'backend', 'Car / Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_reg', 'backend', 'Car / Registration number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Registration number', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC01', 'arrays', 'error_titles_ARRAY_AC01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC01', 'arrays', 'error_bodies_ARRAY_AC01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this car have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC03', 'arrays', 'error_titles_ARRAY_AC03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Added', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC03', 'arrays', 'error_bodies_ARRAY_AC03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Car has been added to the list.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC04', 'arrays', 'error_bodies_ARRAY_AC04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'An error occurred! Data has not been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC04', 'arrays', 'error_titles_ARRAY_AC04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car failed to add.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC08', 'arrays', 'error_titles_ARRAY_AC08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC08', 'arrays', 'error_bodies_ARRAY_AC08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oops! The car you are looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblUpdateBooking', 'backend', 'Lable Update Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_from', 'backend', 'Booking / From', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_to', 'backend', 'Booking / To', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingStatus', 'backend', 'Booking / Status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_confirmed', 'arrays', 'booking_statuses_ARRAY_confirmed', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_pending', 'arrays', 'booking_statuses_ARRAY_pending', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_cancelled', 'arrays', 'booking_statuses_ARRAY_cancelled', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancelled', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_uuid', 'backend', 'Booking / Unique ID', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Unique ID', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_car', 'backend', 'Booking / Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_type', 'backend', 'Booking / Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_method', 'backend', 'Booking / Payment Method', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Method', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_total', 'backend', 'Booking / Total', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_tax', 'backend', 'Booking / Tax', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_required_deposit', 'backend', 'Booking / Required deposit', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Required deposit', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extras', 'backend', 'Booking / Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extras_note', 'backend', 'Booking / Extras Note', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Note: Please select a Type first', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_pickup', 'backend', 'Booking / Pickup Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_return', 'backend', 'Booking / Return Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_company', 'backend', 'Booking / Company Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_email', 'backend', 'Booking / E-Mail Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_phone', 'backend', 'Booking / Telephone Number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Telephone Number', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_title', 'backend', 'Booking / Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_name', 'backend', 'Booking / Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_lname', 'backend', 'Booking / Last Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_country', 'backend', 'Booking / Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_state', 'backend', 'Booking / County/Region/State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'County/Region/State', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_city', 'backend', 'Booking / City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_address', 'backend', 'Booking / Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_address_2', 'backend', 'Booking / Address Line 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_address_3', 'backend', 'Booking / Address Line 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 3', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_zip', 'backend', 'Booking / Zip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_locations', 'backend', 'Booking / Locations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Locations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_available', 'backend', 'Booking / Available Cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_reservations', 'backend', 'Booking / Reservations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_select_date', 'backend', 'Booking / Select date', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select date', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_select_pdate', 'backend', 'Booking / Select pick up/return date', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select pick up/return date', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_unit', 'backend', 'Options / Unit', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mileage units', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_default_distance', 'backend', 'Type Default Distance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Limit mileage ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_extra_price', 'backend', 'Type Extra Price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price for extra mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_type', 'backend', 'Price / Car Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_from', 'backend', 'Price / From', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_to', 'backend', 'Price / To', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_per_day', 'backend', 'Price / Price Per Day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price Per Day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_status_start', 'backend', 'Price / Status Start', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please wait while saving...', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_status_end', 'backend', 'Price / Status End', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rates have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_date_from', 'backend', 'Price / Date From', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date From', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_date_to', 'backend', 'Price / Date To', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date To', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_per_hour', 'backend', 'Price / Per Hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price Per Hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_rent_type', 'backend', 'Type / Type of Rent', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type of Rent', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'rent_types_ARRAY_day', 'arrays', 'rent_types_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'rent_types_ARRAY_hour', 'arrays', 'rent_types_ARRAY_hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_allow_cash', 'backend', 'Options / Allow Cash payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enable cash payments', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_distance_start', 'backend', 'Booking / Distance Start', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_distance_end', 'backend', 'Booking / Distance End ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuPrices', 'backend', 'Menu Prices', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking rates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_empty', 'backend', 'Price / Empty Message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The price is empty.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoPricesTitle', 'backend', 'Infobox / Price title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom rates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoPricesBody', 'backend', 'Infobox / Price Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can define different prices based on reservation length and/or the time period of the reservation. Please make sure that periods for the same car type do not overlap. Depending on your Rental Settings you will be able to set prices per hour, per day or per hour and per day.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblSure', 'backend', 'Confirm', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected entry(s)?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashCars', 'backend', 'Label / Dashboard Cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashCar', 'backend', 'Label / Dashboard Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashBookings', 'backend', 'Label / Dashboard Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashBooking', 'backend', 'Label / Dashboard Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashUser', 'backend', 'Label / Dashboard User', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashUsers', 'backend', 'Label / Dashboard Users', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Users', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashLastLogin', 'backend', 'Label / Dashboard Last Login', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last Login', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashLatestCar', 'backend', 'Label / Dashboard Latest Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Latest Cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashLatestBooking', 'backend', 'Label / Dashboard Latest Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Latest Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_terms', 'backend', 'Options / Terms and Conditions', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental terms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO05', 'arrays', 'error_titles_ARRAY_AO05', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO05', 'arrays', 'error_bodies_ARRAY_AO05', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental terms have been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoTermsBody', 'backend', 'Infobox / Terms and Conditions Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add your own rental terms.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoTermsTitle', 'backend', 'Infobox / Terms and Conditions Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental terms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingDetails', 'backend', 'Reservation / Rental Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblClientDetails', 'backend', 'Booking / Client Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_security', 'backend', 'Booking / Security', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_insurance', 'backend', 'Booking / Insurance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Insurance', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Mr', 'arrays', '_titles_ARRAY_Mr', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mr', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Mrs', 'arrays', '_titles_ARRAY_Mrs', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mrs', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Ms', 'arrays', '_titles_ARRAY_Ms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Ms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Dr', 'arrays', '_titles_ARRAY_Dr', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dr', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Prof', 'arrays', '_titles_ARRAY_Prof', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Prof', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Rev', 'arrays', '_titles_ARRAY_Rev', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rev', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_titles_ARRAY_Other', 'arrays', '_titles_ARRAY_Other', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Other', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_cc_types_ARRAY_Visa', 'arrays', '_titles_ARRAY_Visa', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Visa', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_cc_types_ARRAY_MasterCard', 'arrays', '_titles_ARRAY_MasterCard', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'MasterCard', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_cc_types_ARRAY_Maestro', 'arrays', '_titles_ARRAY_Maestro', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Maestro', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_cc_types_ARRAY_AmericanExpress', 'arrays', '_titles_ARRAY_AmericanExpress', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'AmericanExpress', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_cc_type', 'backend', 'Booking /  Credit card type ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', ' Credit card type ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_cc_number', 'backend', 'Booking /  Credit card number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit card number', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_cc_code', 'backend', 'Booking /  Credit card code ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit card code ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_cc_exp', 'backend', 'Booking /  Credit card expiration', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit card expiration', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_start', 'backend', 'Booking / Start', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_end', 'backend', 'Booking / End', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnCalculate', 'backend', 'Calculate', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Calculate', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_paypal', 'arrays', 'payment_methods_ARRAY_paypal', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paypal', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_creditcard', 'arrays', 'payment_methods_ARRAY_creditcard', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_bank', 'arrays', 'payment_methods_ARRAY_bank', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_cash', 'arrays', 'payment_methods_ARRAY_cash', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cash', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extra_price', 'backend', 'Booking / Extras\' Price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras\' Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_status_ARRAY_confirmed', 'arrays', 'booking_statuses_ARRAY_confirmed', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_status_ARRAY_pending', 'arrays', 'booking_statuses_ARRAY_pending', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_status_ARRAY_cancelled', 'arrays', 'booking_statuses_ARRAY_cancelled', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancelled', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingNumDaysValidation', 'backend', 'Booking / Number of days validation ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of days is out of range.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingDateRangeValidation', 'backend', 'Booking / Date range validation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date range is not available', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR01', 'arrays', 'error_titles_ARRAY_AR01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR03', 'arrays', 'error_titles_ARRAY_AR03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Added', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR04', 'arrays', 'error_titles_ARRAY_AR04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Error: Failed to add booking.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR08', 'arrays', 'error_titles_ARRAY_AR08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking not found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR01', 'arrays', 'error_bodies_ARRAY_AR01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your changes have been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR03', 'arrays', 'error_bodies_ARRAY_AR03', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been added.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR04', 'arrays', 'error_bodies_ARRAY_AR04', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'An error occurred! Booking has not been added.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR08', 'arrays', 'error_bodies_ARRAY_AR08', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oops! The booking you are looking for is missing.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_min_hour', 'backend', 'Options / Min Hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Minimum booking length', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'tax_type_arr_ARRAY_0', 'arrays', 'tax_type_arr_ARRAY_0', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'tax_type_arr_ARRAY_1', 'arrays', 'tax_type_arr_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Percent', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_bookings', 'backend', 'Car / Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_same_reg', 'backend', 'Car / Same Registration number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Registration number was existed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_1', 'frontend', 'Front Label / When and Where', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'When and where', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_2', 'frontend', 'Front Label / Your Car Choice', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose a car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_3', 'frontend', 'Front Label / Price and Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price and extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_4', 'frontend', 'Front Label / Checkout', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_back', 'frontend', 'Front Button Label / Back', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_add', 'frontend', 'Front Button Label / Add', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_checkout', 'frontend', 'Front Button Label / Checkout', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_confirm', 'frontend', 'Front Button Label / Confirm Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirm Booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_continue', 'frontend', 'Front Button Label / Continue', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Continue', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_quote', 'frontend', 'Front Button Label / Get A Quote Now', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Get A Quote Now', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_btn_remove', 'frontend', 'Front Button Label / Remove', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Remove', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_close', 'frontend', 'Front Label / Close', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Close', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_start', 'frontend', 'Front Label / Rental Start Date/Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Date/Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_end', 'frontend', 'Front Label / Rental End Date/Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Date/Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_pickup', 'frontend', 'Front Label / Pickup location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_return', 'frontend', 'Front Label / Returning to', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_same', 'frontend', 'Front Label / Same as pickup location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Same as the pick-up location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_map_title', 'frontend', 'Front Label / Google Maps', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Google Maps', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_cant_find', 'frontend', 'Front Label / Can\'t find', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Can\'t find the location?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_view_map', 'frontend', 'Front Label / View Map', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View Map', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_num_days', 'frontend', 'Front Label / Number of days', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of days', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_v_err_dates', 'frontend', 'Front Label / Date range is incorect', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can only rent a car at least {HOURS} hour(s).', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_all', 'frontend', 'Front Label / View All', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View All', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_price', 'frontend', 'Front Label / Price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_size', 'frontend', 'Front Label / Size', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_luggage', 'frontend', 'Front Label / Number of Luggage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of bags allowed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_transmission', 'frontend', 'Front Label / Transmission', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Transmission', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_passengers', 'frontend', 'Front Label / Number of Passengers', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of passengers', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_doors', 'frontend', 'Front Label / Number of Doors', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of doors', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_any', 'frontend', 'Front Label / Any', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Any', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_example', 'frontend', 'Front Label / Example of this range', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Example of this range', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_best', 'frontend', 'Front Label / Total price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_available', 'frontend', 'Front Label / Available to book now', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available to book now', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_not', 'frontend', 'Front Label / Not available for selected dates', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Not available for selected dates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_per_day', 'frontend', 'Front Label / per day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_empty', 'frontend', 'Front Label / No cars found.', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No cars found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_booking', 'frontend', 'Front Label / Your Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_when', 'frontend', 'Front Label / When and Where', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Time and Place', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_pickup', 'frontend', 'Front Label / Pickup', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_return', 'frontend', 'Front Label / Return', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_rental', 'frontend', 'Front Label / Rental Period', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Period', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_change', 'frontend', 'Front Label / Change', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_choise', 'frontend', 'Front Label / Your Car Choice', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_example', 'frontend', 'Front Label / Example of this range', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Example of this range', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_extras', 'frontend', 'Front Label / Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_price', 'frontend', 'Front Label / Car rental fee', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car rental fee', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_total_price', 'frontend', 'Front Label / Total price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_tax', 'frontend', 'Front Label / Tax', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_security', 'frontend', 'Front Label / Security', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security Deposit', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_insurance', 'frontend', 'Front Label / Insurance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Insurance', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_required_deposit', 'frontend', 'Front Label / Required deposit', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Required deposit', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_conditions', 'frontend', 'Front Label / Booking Conditions', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental terms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_per', 'frontend', 'Front Label / per', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'per', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_title', 'frontend', 'Front Label / Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_select_title', 'frontend', 'Front Label / Select Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '-- Select Title --', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_name', 'frontend', 'Front Label /  Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_lname', 'frontend', 'Front Label / Last Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_phone', 'frontend', 'Front Label / Telephone Number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Telephone Number', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_email', 'frontend', 'Front Label / E-Mail Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_company', 'frontend', 'Front Label / Company Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_address', 'frontend', 'Front Label / Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_address_2', 'frontend', 'Front Label / Address Line 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_address_3', 'frontend', 'Front Label / Address Line 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 3', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_city', 'frontend', 'Front Label / City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_state', 'frontend', 'Front Label / County/Region/State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'County/Region/State', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_zip', 'frontend', 'Front Label / Postcode/ZIP Code', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Postcode/ZIP Code', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_country', 'frontend', 'Front Label / Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_select_country', 'frontend', 'Front Label / Select Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '-- Select Country --', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_billing', 'frontend', 'Front Label / Billing Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Billing Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_payment', 'frontend', 'Front Label / Payment Method', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Method', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_select_payment', 'frontend', 'Front Label / Select Payment Method', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '-- Select Payment Method --', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_terms', 'frontend', 'Front Label / Terms and Conditions', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental terms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_personal', 'frontend', 'Front Label / Personal Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Personal Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_agree', 'frontend', 'Front Label / I have read and agree to the Booking Conditions for my Pay Now booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'I have read and agree to the rental terms.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_click', 'frontend', 'Front Label / Click here to view', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Click here to view the rental terms.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_terms_title', 'frontend', 'Front Label / Pay Now terms and conditions', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pay Now terms and conditions', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_type', 'frontend', 'Front Label / CC type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_num', 'frontend', 'Front Label / CC number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC number', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_exp', 'frontend', 'Front Label / CC expiration date', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC expiration date', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_code', 'frontend', 'Front Label / CC security code', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC security code', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_types_ARRAY_Visa', 'arrays', 'Front Label / CC Type Visa', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Visa', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_types_ARRAY_MasterCard', 'arrays', 'Front Label / CC Type MasterCard', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'MasterCard', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_types_ARRAY_Maestro', 'arrays', 'Front Label / CC Type Maestro', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Maestro', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_cc_types_ARRAY_AmericanExpress', 'arrays', 'Front Label / CC Type AmericanExpress', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'AmericanExpress', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_type', 'frontend', 'Front Label / Validate Credit Card Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card type is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_num', 'frontend', 'Front Label / Validate Credit Card Number', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card number is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_exp', 'frontend', 'Front Label / Validate Credit Card Expiration ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card expiration date is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_exp_month', 'frontend', 'Front Label / Validate Credit Card Month', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card expiration month is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_exp_year', 'frontend', 'Front Label / Validate Credit Card Year', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card expiration year is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_cc_code', 'frontend', 'Front Label / Validate Credit Card Code', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card security code is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_title', 'frontend', 'Front Label / Validate title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_name', 'frontend', 'Front Label / Validate Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_lname', 'frontend', 'Front Label / Validate Last Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last Name is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_phone', 'frontend', 'Front Label / Validate Phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_email', 'frontend', 'Front Label / Validate Email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_address', 'frontend', 'Front Label / Validate Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_address_2', 'frontend', 'Front Label / Validate Address Line 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2 is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_address_3', 'frontend', 'Front Label / Validate Address Line 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 3 is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_city', 'frontend', 'Front Label / Validate City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_state', 'frontend', 'Front Label / Validate State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'County/Region/State is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_zip', 'frontend', 'Front Label / Validate Postcode/ZIP Code', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Postcode/ZIP Code is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_country', 'frontend', 'Front Label / Validate Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_payment', 'frontend', 'Front Label / Validate Payment Method', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Method is required', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_agree', 'frontend', 'Front Label / Validate You have to agree to the Booking Conditions', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You have to agree to the Booking Conditions', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_err_title', 'frontend', 'Front Label / You failed to correctly fill in the form:', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You failed to correctly fill in the form:', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_err_email', 'frontend', 'Front Label / Validate Email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail is invalid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_msg_1', 'frontend', 'Front Label / Msg 1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been added. Redirecting to PayPal...', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_msg_2', 'frontend', 'Front Label / Msg 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been added. Redirection to Authorize...', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_msg_3', 'frontend', 'Front Label / Msg 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been successfully added.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_msg_4', 'frontend', 'Front Label / Msg 4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservation failed to save', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_note', 'frontend', 'Front Label / Cancel Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel Booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_confirm', 'frontend', 'Front Label / Cancel Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel Booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_heading', 'frontend', 'Front Label / Your reservation details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your reservation details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_personal', 'frontend', 'Front Label / Personal Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Personal Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_from', 'frontend', 'Front Label / Date/Time From', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time From', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_to', 'frontend', 'Front Label / Date/Time To', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time To', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_pickup', 'frontend', 'Front Label / Pickup Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_return', 'frontend', 'Front Label / Return Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_type', 'frontend', 'Front Label / Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_title', 'frontend', 'Front Label / Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_description', 'frontend', 'Front Label / Description', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Description', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_datetime', 'frontend', 'Front Label / Date/Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_name', 'frontend', 'Front Label / Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_lname', 'frontend', 'Front Label / Last Name', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last Name', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_email', 'frontend', 'Front Label / E-Mail', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_phone', 'frontend', 'Front Label / Phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_company', 'frontend', 'Front Label / Company', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_country', 'frontend', 'Front Label / Country', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_city', 'frontend', 'Front Label / City', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_state', 'frontend', 'Front Label / County/Region/State', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'County/Region/State', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_zip', 'frontend', 'Front Label / Postcode/ZIP Code', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Postcode/ZIP Code', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_address', 'frontend', 'Front Label / Address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_address_2', 'frontend', 'Front Label / Address Line 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_address_3', 'frontend', 'Front Label / Address Line 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 3', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_1', 'arrays', 'cancel_err_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Missing parameters', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_2', 'arrays', 'cancel_err_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking with such ID did not exists', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_3', 'arrays', 'cancel_err_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security hash did not match', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_4', 'arrays', 'cancel_err_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking is already cancelled', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_200', 'arrays', 'cancel_err_ARRAY_200', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been cancelled successful', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_1', 'arrays', 'month_name_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'January', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_2', 'arrays', 'month_name_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'February', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_3', 'arrays', 'month_name_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'March', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_4', 'arrays', 'month_name_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'April', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_5', 'arrays', 'month_name_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'May', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_6', 'arrays', 'month_name_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'June', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_7', 'arrays', 'month_name_ARRAY_7', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'July', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_8', 'arrays', 'month_name_ARRAY_8', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'August', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_9', 'arrays', 'month_name_ARRAY_9', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'September', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_10', 'arrays', 'month_name_ARRAY_10', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'October', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_11', 'arrays', 'month_name_ARRAY_11', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'November', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'month_name_ARRAY_12', 'arrays', 'month_name_ARRAY_12', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'December', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_0', 'arrays', 'day_name_ARRAY_0', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Su', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_1', 'arrays', 'day_name_ARRAY_1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mo', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_2', 'arrays', 'day_name_ARRAY_2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tu', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_3', 'arrays', 'day_name_ARRAY_3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_4', 'arrays', 'day_name_ARRAY_4', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Th', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_5', 'arrays', 'day_name_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fr', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_name_ARRAY_6', 'arrays', 'day_name_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sa', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_type_transmissions_ARRAY_manual', 'arrays', 'front_type_transmissions_ARRAY_manual', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Manual', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_type_transmissions_ARRAY_automatic', 'arrays', 'front_type_transmissions_ARRAY_automatic', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Automatic', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_type_transmissions_ARRAY_semi-automatic', 'arrays', 'front_type_transmissions_ARRAY_semi-automatic', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Semi-automatic', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_payments_ARRAY_paypal', 'arrays', '_payments_ARRAY_paypal', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paypal', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_payments_ARRAY_authorize', 'arrays', '_payments_ARRAY_authorize', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_payments_ARRAY_creditcard', 'arrays', '_payments_ARRAY_creditcard', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit Card', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_payments_ARRAY_bank', 'arrays', '_payments_ARRAY_bank', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_payments_ARRAY_cash', 'arrays', '_payments_ARRAY_cash', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cash', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddCarTitle', 'backend', 'Infobox / Add Car Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add new car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddCarBody', 'backend', 'Infobox / Add Car Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new car. Please note that your clients are able to book a car type not a specific car/vehicle, so each car you add must be assigned to at least one car type. To add your cars/vehicles you need to have car types and locations added first.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCarTitle', 'backend', 'Infobox / Update Car Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCarBody', 'backend', 'Infobox / Update Car Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update your vehicle data. If you have multi language front-end do not forget to update vehicle make and model in all languages.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoTypesTitle', 'backend', 'Infobox / Types Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car types', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoTypesBody', 'backend', 'Infobox / Types Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your clients view and reserve car types, not specific vehicles, and the system assigns automatically a vehicle/car from the chosen car type to each reservation made. You can manage vehicles/cars under  Car Inventory menu and assign them to different car types. To add a new type, click on the \'Add +\' button below. You need at least 1 car assigned to each car type so clients can book it.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoExtrasBody', 'backend', 'Infobox / Extras Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can view and manage a list of extras which your clients can rent for additional fee  (for example: child seat, GPS navigation, etc.). You need to assign extras to car types. You can do this while adding or editing a car type. You can have different extras available for different car types.  To add new extra, click on the Add + button below.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoExtrasTitle', 'backend', 'Infobox / Extras Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddExtraTitle', 'backend', 'Infobox / Add Extra Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add an extra', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddExtraBody', 'backend', 'Infobox / Add Extra Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add an extra, then click Save. Tip: Enter 0 if you want to add a free extra.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateExtraTitle', 'backend', 'Infobox / Update Extra Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update extra', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateExtraBody', 'backend', 'Infobox / Update Extra Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change extra name, set its price and click on Save button.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddTypeTitle', 'backend', 'Infobox / Add Type Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add new car type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddTypeBody', 'backend', 'Infobox / Add Type Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new car type. Please, note that your clients view and book car types not a specific vehicle/car, so it\'s very important to fill in the specification details carefully. Using the \'Available extras\' drop down field you can choose which extras are available with the car type and can be selected by clients when making a reservation. If you have multiple language versions of your car rental system do not forget to fill in the car type title and description in all languages that you use.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateTypeTitle', 'backend', 'Infobox / Update Type Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update car type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateTypeBody', 'backend', 'Infobox / Update Type Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new car type. Please, note that your clients view and book car types not a specific vehicle/car, so it\'s very important to fill in the specification details carefully.  Under the \'Custom rates\' tab you can specify custom seasonal prices based on period and length of reservation.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_empty_extra', 'backend', 'Type / Empty Extra', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No extras added. Manage extras {STAG}here{ETAG}.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_empty_location', 'backend', 'Car / Empty Location', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You need to add at least one location. Add it', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_mileage', 'backend', 'Car / Mileage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_current_mileage', 'backend', 'Car / Current Mileage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Current Mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddLocationTitle', 'backend', 'Infobox / Add Location Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add new location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddLocationBody', 'backend', 'Infobox / Add Location Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below and click on \'Save\' button to add new location to your system.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateLocationTitle', 'backend', 'Infobox / Update Location Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update Location', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateLocationBody', 'backend', 'Infobox / Update Location Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update the office location data. If you change its address do not forget to replace it on the map. If you have multi language front-end, do not forget to translate the titles in all languages.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_empty_type', 'backend', 'Car / Empty Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No types added. Manage types', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblFrom', 'backend', 'Label From', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblTo', 'backend', 'Label To', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPickupDate', 'backend', 'Label Pickup Date', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Date', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblReturnDate', 'backend', 'Label Return Date', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Date', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddBookingTitle', 'backend', 'Infobox / Rental Details Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddBookingBody', 'backend', 'Infobox / Add Booking Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In the Rental Details box below you can add details about the reservation - start and end date/time, car type, pick-up and return locations. As soon as you select car type the price for the selected rental period will be automatically calculated in the Price box. Use the Extras box at the bottom to add additional extras to the reservation. Their price will also be included in the total rental price.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingDetailsTitle', 'backend', 'Infobox / Update Booking details Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change rental details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingDetailsDesc', 'backend', 'Infobox / Reservation details description', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In the Rental Details box below you can change the details about the reservation. Changes made to rental period or car type will reflect on the rental price and it will be automatically re-calculated. Use the Extras box at the bottom to add/edit additional extras to the reservation. Their price will also be included in the total rental price.

Use \'Send email notification\' and \'Send SMS notification\' to send an email/SMS to the customer.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_by', 'frontend', 'Front Label / Sort By', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sort by', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_price_asc', 'frontend', 'Front Label / Sort By Price ASC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price (Low to High)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_price_desc', 'frontend', 'Front Label / Sort By Price DESC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price (High to Low)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_size_asc', 'frontend', 'Front Label / Sort By Size ASC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size (Small to Large)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_size_desc', 'frontend', 'Front Label / Sort By Size DESC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size (Large to Small)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_luggage_asc', 'frontend', 'Front Label / Sort By Luggage ASC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bags (Low to High)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_sort_luggage_desc', 'frontend', 'Front Label / Sort By Luggage DESC', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bags (High to Low)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_bank_account', 'frontend', 'Front Label / Bank Account', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank Account', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_payment_status_text', 'backend', 'Options /  Booking status if not paid text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set what the default reservation status should be, if payment has been made. ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page_text', 'backend', 'Options /  Thankyou page text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter the URL your customers will be redirected to after online payment.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_booking_page_text', 'backend', 'Options /  Cancel page text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter the URL your customers will be redirected to if cancel  their reservation.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_rental_hours', 'frontend', 'Front Label / Rental Hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Hours', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocationsBody', 'backend', 'Infobox / Locations Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see a list with car rental office locations. Your clients will see office locations as Pick-up and Return Location options. To add new location, click on the \'Add New Location\' tab above.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoLocationsTitle', 'backend', 'Infobox / Locations Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Office locations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblGMapNote', 'backend', 'Location / Map Note', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Click on the \'Find on Map\' button to find location coordinates and place it on the map. You can also enter the Latitude and Longitude coordinates on your own. After the location is placed on the map you can drag & drop the location pin on the map for precise tuning.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLatitude', 'backend', 'Location / Latitude', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Latitude', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLongitude', 'backend', 'Location / Longitude', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Longitude', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAddressNotFound', 'backend', 'Location / AddressNotFound', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We sorry that we could not find out the Latitude and Longitude of the given address.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnGoogleMapsApi', 'backend', 'Location / btnGoogleMapsApi', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'FIND ON MAP', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoOptionTitle', 'backend', 'Infobox /Options Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'General options', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoOptionBody', 'backend', 'Infobox /Options  Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can set the Car Rental System general settings.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoCarsTitle', 'backend', 'Infobox / Cars Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars / Vehicles Inventory', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoCarsBody', 'backend', 'Infobox / Cars Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can view and manage all the vehicles/cars that you operate. You need to have at least one car added and assigned to a car type, so clients can make reservations. Your clients book car types but the system assigns specific car to each reservation. If no cars of the selected car type are available for the chosen period, then a reservation cannot be made. You can always edit the car assigned to each reservation manually. To add new vehicle/car, click on the \'Add New Car\' tab above.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUsersTitle', 'backend', 'Infobox / Users Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Users', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUsersBody', 'backend', 'Infobox / Users Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add and manage system users. You can have unlimited number of users. You can set users as \'Inactive\' if you wish to restrict their access to the system without deleting the user.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddUserTitle', 'backend', 'Infobox / Add User Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add user', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddUserBody', 'backend', 'Infobox / Add User body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill out the fields and click on \'Save\' button to add new user to the system. \'Editors\' have a limited access to the system back-end. They can only view Reservations menu.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateUserTitle', 'backend', 'Infobox / Update  User Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update User', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateUserBody', 'backend', 'Infobox / Update  User body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Review and update user\'s data. \'Editors\' have a limited access to the system back-end. They can only view Reservations menu.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoReservationsTitle', 'backend', 'Infobox / Reservations Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoReservationsBody', 'backend', 'Infobox / Reservations Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you see all the reservations made through the Car Rental system. To edit or delete reservations use the icons at the right end of each row. You can use the search form to find a reservation. You can also use the quick filter buttons to show only Today / Tomorrow pick-ups or returns.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoReservationsAvailabilityTitle', 'backend', 'Infobox / Reservations Availability Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below is a table with all the available cars for the current date. Use the date-picker to change the date.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingAmount', 'backend', 'Booking / Price Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_period', 'backend', 'Price / Period', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Period', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_rent_by_opts_ARRAY_day', 'arrays', 'items_rent_by_opts_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'by day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_rent_by_opts_ARRAY_hour', 'arrays', 'items_rent_by_opts_ARRAY_hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'by hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_price_per_ARRAY_day', 'arrays', 'items_price_per_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_price_per_ARRAY_hour', 'arrays', 'items_price_per_ARRAY_hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_hour_plural', 'backend', 'Price / Hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hours', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_day_plural', 'backend', 'Price / Days', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'days', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_price', 'backend', 'Price / Label Price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'items_length', 'backend', 'Price / Length Label', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Length', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_default_distance_tip', 'backend', 'Type / Default Distance Tip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set allowed daily mileage. Customers that extend this will be charged additional fee as per the amount you enter in the next box.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_extra_price_tip', 'backend', 'Type / Extra Price Tip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set price for each km/mile over the allowed daily mileage limit.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_rent_type_tip', 'backend', 'Type / Rent Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Specify whether the car type can be booked per hour, per day or both.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'rent_types_ARRAY_both', 'arrays', 'rent_types_ARRAY_both', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Both per day and per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_no_extras', 'frontend', 'Front Label / No Extras Available', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No extras available', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_set_current_mileage', 'backend', 'Booking Label / Current mileage will be set to', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'current mileage will be set to', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'car_update_current_mileage', 'backend', 'Booking Label / Update Car', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'update car', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_total_distance', 'backend', 'Booking Label / Total Distance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total Distance', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_min_hour_text', 'backend', 'Options / Minimum booking length text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Users will not be able to rent a car for less time than set here.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_days', 'frontend', 'Front Label / Rental Period - days', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'days', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_hours', 'frontend', 'Front Label / Rental Period - hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hours', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCurrentMileageTip', 'backend', 'Label / Mileage tip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can manage vehicle mileage data. Set the current mileage here and use the options on pick-up and return to keep this data up to date.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_change_dates', 'frontend', 'Label / Change dates', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change dates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_label_day', 'frontend', 'Label / day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuRates', 'backend', 'Menu / Rates', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Types and Rates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_periods', 'backend', 'Options / Booking Periods', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Calculate rental fee', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_charge_extra_per_day', 'backend', 'Options / Charge extra hours time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Charge extra hours time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_free_up_per_day', 'backend', 'Options / free of charge up to', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'free of charge up to', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_new_day_per_day', 'backend', 'Options / New day booking after', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Free of charge tolerance', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_charge_extra_per_both', 'backend', 'Options / Charge extra hours time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Charge extra hours time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_free_up_per_both_hourly', 'backend', 'Options / free of charge up to', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'free of charge up to', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_new_day_per_both_hourly', 'backend', 'Options / new day booking after', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'new day booking after', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_free_up_per_both_special', 'backend', 'Options / free of charge up to', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'free of charge up to s', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_new_day_per_both_special', 'backend', 'Options / new day booking after', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'new day booking after s', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'insurance_type_arr_ARRAY_percent', 'arrays', 'insurance_type_arr_ARRAY_percent', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Percent', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'insurance_type_arr_ARRAY_perday', 'arrays', 'insurance_type_arr_ARRAY_perday', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'insurance_type_arr_ARRAY_perbooking', 'arrays', 'insurance_type_arr_ARRAY_perbooking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per Reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDetails', 'backend', 'Label / Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblSetPriceForExtra', 'backend', 'Label / Set price for extra hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set price for extra hours', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ATR01', 'arrays', 'error_titles_ARRAY_ATR01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking rates updated', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ATR01', 'arrays', 'error_bodies_ARRAY_ATR01', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to the booking rates of the car type has been saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_extra_cost', 'frontend', 'Label / Extras', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_payment', 'frontend', 'Label / Payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_pending', 'backend', 'Options / Pending Status Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car \'On hold\' while pending', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_pending_text', 'backend', 'Options / Pending Status Bookings text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'A specific car is assigned to each new reservation. If reservation is not confirmed within X hours then this car will be available for booking again for the same date and time.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingCollect', 'backend', 'Label / Collect', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblQuote', 'backend', 'Label / Quote', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_deposit_status', 'backend', 'Label / Deposit Status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deposit Status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'deposit_statuses_ARRAY_paid', 'arrays', 'deposit_statuses_ARRAY_paid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'deposit_statuses_ARRAY_notpaid', 'arrays', 'deposit_statuses_ARRAY_notpaid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'not paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'plural_day', 'backend', 'Label / days', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'days', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'singular_day', 'backend', 'Label / day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'plural_hour', 'backend', 'Label / hours', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hours', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'singular_hour', 'backend', 'Label / hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_types_ARRAY_both', 'arrays', 'price_types_ARRAY_both', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per day and per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_types_ARRAY_day', 'arrays', 'price_types_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'price_types_ARRAY_hour', 'arrays', 'price_types_ARRAY_hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_quote_total', 'backend', 'Label / Quote total', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Quote total', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_due', 'backend', 'Label / Payment Due', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Due', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBasicInfo', 'backend', 'Label / Information', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Information', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_total_quote', 'backend', 'Label / Total Quote', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total Quote', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPickup', 'backend', 'Label / Pick-up', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_pickup_date', 'backend', 'Label / Pick-up Date and Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Date and Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_pickup_mileage', 'backend', 'Label / Pick-up Mileage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up Mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_set_as_current', 'backend', 'label / set same as current mileage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'set same as current mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_pickup', 'backend', 'Label / Payment on Pick-up', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment on Pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnDeliver', 'backend', 'Button / Deliver', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deliver', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCancelBooking', 'backend', 'Label / Cancel Booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel Booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCancelBookingConfirm', 'backend', 'Label / Cancel Booking confirm', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure that you want to cancel this booking?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblReturn', 'backend', 'Label / Return', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_return_deadline', 'backend', 'Label / Return Deadline', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Deadline', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_return_datetime', 'backend', 'Label / Return Date & Time', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Date & Time', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extra_hours_charge', 'backend', 'Label / Extra hours charge', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra hours charge', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_dropoff_mileage', 'backend', 'Label / Drop-off mileage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extra_mileage_charge', 'backend', 'Label / Extra mileage charge', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra mileage charge', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extended_extra_usage', 'backend', 'Label / Extended extra usage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extended extra usage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extra_item', 'backend', 'Label / Extra item', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra item', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_price', 'backend', 'Label / Extend price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extend price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_notes', 'backend', 'Label / Notes', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_security_deposit', 'backend', 'Label / Security deposit', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security deposit', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_balance', 'backend', 'Label / Balance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Balance', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_amount_due_pickup', 'backend', 'Label / Amount due on pick-up', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount due on pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_paid_status', 'backend', 'Label / Status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_at', 'backend', 'Label / at', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'at', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_pickup_dropoff', 'backend', 'Label / Pick-up / Drop-off', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up / Return', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_client', 'backend', 'Label / Client', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_subtotal', 'backend', 'Label / Sub-total', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sub-total', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_today', 'backend', 'Label / Today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuSettings', 'backend', 'Menu / Settings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Settings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblHours', 'backend', 'Label / hour(s)', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hour(s)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuPayments', 'backend', 'Menu / Payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuRentalSettings', 'backend', 'Menu / Rental Settings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Settings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDeleteImageConfirm', 'backend', 'Label / Delete confirmation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure that you want to delete this image?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPickupAt', 'backend', 'Label / pick-up at', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pick-up at', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDropoffAt', 'backend', 'Label / drop-off at', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'return at', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblFilterByType', 'backend', 'Lable / Filter by Type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Filter by Type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCars', 'backend', 'Label / Cars', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDate', 'backend', 'Label / Date ', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date ', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblViewAll', 'backend', 'Label/ View all', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View all', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblReturnAt', 'backend', 'Label / return at', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'return at', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAt', 'backend', 'Label / at', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'at', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLoading', 'backend', 'Lable / Loading', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Loading ...', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_booking_periods_text', 'backend', 'Optins / Booking Periods text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set how the system should calculate the price for each reservation.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_id', 'backend', 'Label / ID', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'ID', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_created_on', 'backend', 'label / Created on', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Created on', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_ip', 'backend', 'Label / IP address', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'IP address', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblNoExtra', 'backend', 'Label / No extras added', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No extras added', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'per_extras_ARRAY_booking', 'arrays', 'per_extras_ARRAY_booking', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'per_extras_ARRAY_day', 'arrays', 'per_extras_ARRAY_day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPricePerDay', 'backend', 'Label / Price per day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPricePerHour', 'backend', 'Label / Price per hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCarRentalFee', 'backend', 'Label / Car rental fee', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car rental fee', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_filter_by', 'frontend', 'Label / Filter by', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Filter by', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_price_per_day', 'frontend', 'Label / Price per day', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per day', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_price_per_hour', 'frontend', 'Label / Price per hour', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price per hour', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_extra_price', 'frontend', 'Label / Extras\' price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras\' price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_sub_total', 'frontend', 'Label / Sub-total', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sub-total', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_sub_total', 'backend', 'Label / Sub-total', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sub-total', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_total_price', 'backend', 'Label / Total price', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total Price', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingReturn', 'backend', 'Label / Return', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblBookingPayments', 'backend', 'Label / Payments', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_extra_hours_usage', 'backend', 'Lable / Extra hours usage', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra hours usage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_no', 'backend', 'label / no', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_collected', 'arrays', 'booking_statuses_ARRAY_collected', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Collected', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_completed', 'arrays', 'booking_statuses_ARRAY_completed', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Completed', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payments_made', 'backend', 'Label / Payments Made', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments Made', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_online', 'arrays', 'payment_types_ARRAY_online', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Online booking', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_balance', 'arrays', 'payment_types_ARRAY_balance', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_securitypaid', 'arrays', 'payment_types_ARRAY_securitypaid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security deposit paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_securityreturned', 'arrays', 'payment_types_ARRAY_securityreturned', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security deposit returned', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_delay', 'arrays', 'payment_types_ARRAY_delay', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delay fee', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_extra', 'arrays', 'payment_types_ARRAY_extra', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra mileage', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_types_ARRAY_additional', 'arrays', 'payment_types_ARRAY_additional', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Additional charges', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_statuses_ARRAY_paid', 'arrays', 'payment_statuses_ARRAY_paid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'payment_statuses_ARRAY_notpaid', 'arrays', 'payment_statuses_ARRAY_notpaid', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Not paid', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPaymentDetails', 'backend', 'Label / Payment Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDelPaymentConfirm', 'backend', 'Label / Delete payment confirm', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure that you want to delete this record?', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblNoRecordsFound', 'backend', 'Label / No record found.', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No record found.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_type', 'backend', 'Label / Payment type', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment type', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_amount', 'backend', 'Label / Amount', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_status', 'backend', 'Label / Status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblRentalDuration', 'backend', 'Label / Rental Duration', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Duration', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOf', 'backend', 'Label / of', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'of', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_label_of', 'frontend', 'Label / of', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'of', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_rental_duration', 'frontend', 'Label / Rental Duration', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Duration', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblHere', 'backend', 'Label / here', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'here', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_confirmation_text', 'backend', 'Options / Confirmation email admin text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to receive email notifications when new reservation has been made. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_payment_text', 'backend', 'Options / Payment email for admin text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to receive email notifications when a payment has just been received. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_cancel_text', 'backend', 'Options / Cancel email for admin text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to receive email notifications when clients cancel their reservations. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOptionClient', 'backend', 'Label / Client', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOptionAdministrator', 'backend', 'Label / Administrator', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Administrator', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoConfirmations2Title', 'backend', 'Infobox / Confirmation Admin Title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications to system admin', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoConfirmations2Body', 'backend', 'Infobox / Confirmation Admin Body', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Create customized email and SMS messages that will be sent to administrators (you). You can enable or disable sending of the notifications below. You can also personalize emails with subscribers\' names and other information using the available tokens.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_tomorrow', 'backend', 'Label / Tomorrow', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tomorrow', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLegendConfirmed', 'backend', 'Label / confirmed reservations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'confirmed reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLegendPending', 'backend', 'Label / pending reservation on hold', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pending reservations (on hold)', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLegendPendingOver', 'backend', 'Lable / pending reservations', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pending reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_email_reminder', 'backend', 'Label / Re-send confirmation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send email notification', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_subject', 'backend', 'Label / Subject', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Subject', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_message', 'backend', 'Label / Message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_send', 'arrays', 'buttons_ARRAY_send', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_cancel', 'arrays', 'buttons_ARRAY_cancel', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_new_day_per_day_text', 'backend', 'Options / new day booking after text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set number of hours over 24 hours (full day) that will not be charged additionally. If client makes a reservation that exceeds this number, a new whole day price will be added to the reservation total price. For example: if the tolerance is 5 hours and a reservation is 1 day and 4 hours long, then price will be calculated based on 1 day. However, if the reservation is 1 day and 6 hours long, then price will be calculated based on 2 days.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLegendEmails', 'backend', 'Lable / Emails', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Emails', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLegendSMS', 'backend', 'Labe / SMS', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation', 'backend', 'Options / SMS confirmation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS confirmation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation_text', 'backend', 'Options / SMS confirmation text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select \'Yes\' if you want to send confirmation via SMS to clients after they make a booking. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation_message', 'backend', 'Options / Booking reminder sms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservation reminder SMS', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation_message_text', 'backend', 'Options / SMS confirmation tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can send SMS message under the Edit Reservation page. Available Token(s):<br/><br/>
{CustomerName}<br/>
{DtFrom}<br/>
{DtTo}<br/>
{PickupLocation}<br/>
{ReturnLocation}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_payment', 'backend', 'Options / SMS payment', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_payment_text', 'backend', 'Options / SMS payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'select \'Yes\' if you want to send confirmation via SMS to clients after they make a payment for their booking. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_payment_message', 'backend', 'Options / SMS payment message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS payment message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_payment_message_text', 'backend', 'Options / SMS payment tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Token(s):<br/><br/>{Name}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_cancel', 'backend', 'Options / SMS cancel', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS for cancelling payment', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_cancel_text', 'backend', 'Options / SMS cancel text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'select \'Yes\' if you want to send confirmation via SMS to clients after they cancel for their booking. Otherwise select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_cancel_message', 'backend', 'Options / SMS cancel message', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS cancel message', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_sms_cancel_message_text', 'backend', 'Options / SMS cancel tokens', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Token(s):<br/><br/>
{Name}', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_confirmation_text', 'backend', 'Options / SMS confirmation text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'select \'Yes\' if you want to send confirmation via SMS to the administrator after booking has just been made. Otherwise, select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_payment_text', 'backend', 'Options / SMS payment text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'select \'Yes\' if you want to send payment confirmation via SMS to administrator after payment has been made. Otherwise, select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_cancel_text', 'backend', 'Options / Cancel SMS text', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'select \'Yes\' if you want to send cancel confirmation via SMS to administrator after booking has been cancelled. Otherwise, select \'No\'.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateClientDetailsTitle', 'backend', 'Infobox / Customer details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change customer details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateClientDetailsDesc', 'backend', 'Infobox / Customer details description', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Review and edit customer details in the form below.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCollectTitle', 'backend', 'Infobox / Collect information', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up information', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCollectDesc', 'backend', 'Infobox / Collect description information', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below when client collects the car. You can enter exact date and time when car is picked up and also the current mileage for the car being rented. It will be used when car is returned to calculate exact rental period and if there is extra mileage.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateReturnTitle', 'backend', 'Infobox / Return information', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return information', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateReturnDesc', 'backend', 'Infobox / Return explanation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below when client returns the car. Based on the return time entered the system will calculate if return is delayed. Enter car mileage on return and extra mileage fee will be automatically calculated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdatePaymentTitle', 'backend', 'Infobox / Payment details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments Log', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdatePaymentDesc', 'backend', 'Infobox / Payment details description', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the list below to add all payments made by your client for their reservation. You can add different types of payments and payment methods. All amounts in the Information box are automatically calculated based on the payments you add. When you return a security deposit, collected for the reservation, to your client add a \'Security deposit returned\' payment and it will deducted from the \'Payments Made\' amount.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_sms_reminder', 'backend', 'Label / Send SMS', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS notification', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_confirmation_message', 'backend', 'Options / New Reservation sms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New Reservation sms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_payment_message', 'backend', 'Options / Payment confirmation sms', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment confirmation sms', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_5', 'frontend', 'Label / Final', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Done!', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_final_message_1', 'frontend', 'Label / Final message 1', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your reservation has been successfully sent to the administrator.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_final_message_2', 'frontend', 'Label / Final message 2', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your reservation ID is', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_final_message_3', 'frontend', 'Label / Final message 3', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'If you have any questions, please contact us.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_button_start_new', 'frontend', 'Button / Start New Reservation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start New Reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNewTodayPlural', 'backend', 'Label / New reservations today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'new reservations today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNewTodaySingular', 'backend', 'Label / new reservation today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'new reservation today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashPickupToday', 'backend', 'Label / pick-up today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pick-up today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashPickupsToday', 'backend', 'Label / pick-ups today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pick-ups today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashReturnToday', 'backend', 'Label / return today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'return today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashReturnsToday', 'backend', 'Label / returns today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'returns today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashAvailCarsToday', 'backend', 'Lable / available cars today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'available cars now', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashAvailCarToday', 'backend', 'Lable / available car today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'available car now', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashQuickLinks', 'backend', 'Label / Quick links', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Quick links', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashLatestBookings', 'backend', 'Lable / Latest Bookings', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Latest Reservations', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTodayPickups', 'backend', 'Label / Today Pick-ups', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today Pick-ups', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTodayReturns', 'backend', 'Label / Today Returns', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today Returns', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashCarAssigned', 'backend', 'Label / Car assigned', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car assigned', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashCarAvailability', 'backend', 'Lable / Car Availability', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Availability', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTomorrowPickups', 'backend', 'Label / Tomorrow Pick-ups', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tomorrow Pick-ups', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTomorrowReturns', 'backend', 'Label / Tomorrow Returns', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tomorrow Returns', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashFrontEndPreview', 'backend', 'Label / Front-end Preview', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Front-end Preview', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashViewAll', 'backend', 'Label / view all', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'view all', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNoBooking', 'backend', 'Label / No booking found', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No booking found', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNoPickupToday', 'backend', 'Label / No pick-up today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No pick-up today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNoReturnToday', 'backend', 'Label / No return today', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No return today', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashCustomer', 'backend', 'Label / Customer', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashReturn', 'backend', 'Label / Return', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashPickup', 'backend', 'Label / Pick-up', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'phone', 'backend', 'Label / Phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblIntegrationMethod', 'backend', 'Label / Integration Method', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Integration Method', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'integration_methods_ARRAY_all', 'arrays', 'integration_methods_ARRAY_all', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All languages on 1 page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'integration_methods_ARRAY_each', 'arrays', 'integration_methods_ARRAY_each', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Each language on separate page', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCustomerEmail', 'backend', 'Label / Customer email', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer email', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCustomerPhone', 'backend', 'Label / Customer phone', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer phone', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblTotalPriceTip', 'backend', 'Total price tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The total reservation price as calculated on Rental Details tab.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPaymentMadeTip', 'backend', 'Payment made tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'A summary of all payments entered below (with status \'paid\').', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPaymentDueTip', 'backend', 'Payment due tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Calculates the margin between \'Total Price\' and all \'Payments Made\' amount.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblExtrasTip', 'backend', 'Extras tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Assign extras that are available with this car type. To have extras listed here you need to create them through the Extras tab first.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLocationTip', 'backend', 'Locations tooltip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'When the system assigns a vehicle to a reservation it does not matter what is the location of the vehicle. But you can set default vehicle location to make car inventory management easier.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAvailabilityTitle', 'backend', 'Infobox / Availability title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Availability', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAvailabilityDesc', 'backend', 'Infobox / Availability desc', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In the table below you can see car availability for the upcoming 7 days. You can change the period and also filter by car type or by specific cars. If a car is marked as \'Pending reservations on hold\' that means that the reservation for the car is pending, and it cannot be booked again for that period at the moment. 

If a car is marked as \'Pending reservations\' then the reservation is still pending, but the car can be assigned to another reservation for the same period. The system keeps cars \'on hold\' to prevent duplicate reservations. 

You can set the time length when a car is kept \'on hold\' through Settings menu / Rental Settings tab.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoRentalSettingsTitle', 'backend', 'Infobox / Rental Settings title', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental Settings', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoRentalSettingsDesc', 'backend', 'Infobox / Rental Settings desc', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'On this page you can set car rental settings related to how price is being calculated for each reservation. 

You can choose between 3 types of rental prices: daily, hourly or both daily and hourly. 

Here is an example if clients rents a car for 1 day and 6 hours. If \'Calculate rental fee\' option is set to \'Per day only\', then depending on \'Free of charge tolerance\' setting the system will calculate the price based on 1 day or 2 days daily prices. 

If \'Per hour only\' is chosen then the system will calculate the price based on 30 hours car usage. 

If \'Per day and per hour\' is chosen then the price will be calculated for 1 day and 6 hours. 

You can set rates for each car type under Edit Car type page.

Please, pay attention when you fill in daily and hourly rates for car types, especially if you have set the system  to \'Per day and per hour\'. In any of the 3 cases, the system will let clients select their pick-up and return time. So if the system is set to \'Per day only\' rental fee then you can manage how the system will calculate the \'extra hours\' for each reservation through \'Free of charge tolerance\' option.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddClientDetailsTitle', 'backend', 'Infobox / Add Customer Details', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer details', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoAddClientDetailsDesc', 'backend', 'Infobox / Add Client Details Desc', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter customer details in the form below.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCustomRates', 'backend', 'Label / Custom rates', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom rates', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPricePerDayTip', 'backend', 'Label / Price per day tip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This is the default daily price for renting this car type. Later when you add the car type you can specify custom seasonal prices.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPricePerHourTip', 'backend', 'Label / Price per hour tip', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This is the default hourly price for renting this car type. Later when you add the car type you can specify custom seasonal prices.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_cancel_reservation', 'frontend', 'Label / Cancel reservation', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel reservation', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_5', 'arrays', 'cancel_err_ARRAY_5', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You cannot cancel the booking that car was already picked up.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_6', 'arrays', 'cancel_err_ARRAY_6', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking was already completed.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO06', 'arrays', 'error_titles_ARRAY_AO06', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes saved.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO06', 'arrays', 'error_bodies_ARRAY_AO06', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rental settings have been successfully updated.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_min_days', 'frontend', 'Front Label / Minimum booking length', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Minimum booking length of {X} days is required.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_2_min_hours', 'frontend', 'Front Label / Minimum booking length', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Minimum booking length of {X} hours is required.', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'plugin_backup_size', 'backend', 'Plugin / Size', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Size', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'plugin_backup_sizeXXXXXX', 'backend', 'Plugin / Size', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SizeXXXX', 'script');
				
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'plugin_country_revert_status', 'backend', 'Plugin / Revert status', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPhoneNotAvailable', 'backend', 'Label / Phone number not available', 'script', '2014-08-04 12:37:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'There is no phone number available for this reservation.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_3_security_deposit', 'frontend', 'Label / Security deposit', 'script', '2014-08-14 10:19:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security deposit', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_1_v_err_length', 'frontend', 'Label / error bookingl length', 'script', '2014-08-14 11:25:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can only rent a car at least {DAYS} day(s).', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_timezone', 'backend', 'Options / Authorize.net time zone', 'script', '2015-02-10 08:22:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net time zone', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_md5_hash', 'backend', 'Options / Authorize.net MD5 hash', 'script', '2015-02-10 08:23:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net MD5 hash', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_confirmation_message_text', 'backend', 'Option / Email Tokens', 'script', '2015-02-13 15:54:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{BookingID}', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_payment_message_text', 'backend', 'Option / Email Tokens', 'script', '2015-02-13 15:54:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{BookingID}', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_notes', 'frontend', 'Label / Notes', 'script', '2015-07-09 03:56:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAddReservation', 'backend', 'Button / + Add reservation', 'script', '2015-11-19 06:45:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '+ Add reservation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAddLocation', 'backend', 'Button / + Add location', 'script', '2015-11-19 07:12:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '+ Add location', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAddCar', 'backend', 'Button / + Add car', 'script', '2015-11-19 07:35:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '+ Add car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAddUser', 'backend', 'Button / + Add user', 'script', '2015-11-19 07:44:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '+ Add user', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoThemeTitle', 'backend', 'Infobox / Preview front end', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Preview front end', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoThemeDesc', 'backend', 'Infobox / Preview front end', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'There are multiple color schemes available for the front end. Click on each of the thumbnails below to preview it. Click on "Use this theme" button for the theme you want to use.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallTheme', 'backend', 'Label / Choose theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose theme', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_1', 'arrays', 'option_themes_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 1', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_2', 'arrays', 'option_themes_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 2', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_3', 'arrays', 'option_themes_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 3', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_4', 'arrays', 'option_themes_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 4', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_5', 'arrays', 'option_themes_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 5', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_6', 'arrays', 'option_themes_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 6', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_7', 'arrays', 'option_themes_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 7', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_8', 'arrays', 'option_themes_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 8', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_9', 'arrays', 'option_themes_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 9', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_10', 'arrays', 'option_themes_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 10', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblCurrentlyInUse', 'backend', 'Label / Currently in use', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Currently in use', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnUseThisTheme', 'backend', 'Label / Use this theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use this theme', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_1_of_5', 'frontend', 'Lable / Step 1 of 5 - When and Where', 'script', '2015-11-20 04:14:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 1 of 5 - When and Where', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_2_of_5', 'frontend', 'Lable / Step 2 of 5 - Choose A Car', 'script', '2015-11-20 04:15:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2 of 5 - Choose A Car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_3_of_5', 'frontend', 'Lable / Step 3 of 5 - Price And Extras', 'script', '2015-11-20 04:15:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 3 of 5 - Price And Extras', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_4_of_5', 'frontend', 'Lable / Step 4 of 5 - Checkout', 'script', '2015-11-20 04:17:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 4 of 5 - Checkout', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_5_of_5', 'frontend', 'Lable / Step 4 of 5 - Finish', 'script', '2015-11-20 04:17:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 4 of 5 - Finish', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_step1', 'frontend', 'Label / Step 1 - When And Where', 'script', '2015-11-20 04:18:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 1 - When And Where', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_step2', 'frontend', 'Label / Step 2 - Choose A Car', 'script', '2015-11-20 04:19:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2 - Choose A Car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_step3', 'frontend', 'Label / Step 3 - Price And Extras', 'script', '2015-11-20 04:19:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 3 - Price And Extras', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_step4', 'frontend', 'Label / Step 4 - Checkout', 'script', '2015-11-20 04:19:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 4 - Checkout', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_menu_step5', 'frontend', 'Label / Step 4 - Finish', 'script', '2015-11-20 04:20:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 5 - Finish', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_email_invalid', 'frontend', 'Front Label / Validate Email', 'script', '2015-11-20 09:09:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email is invalid', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_notes', 'frontend', 'Front Label / Validate Notes', 'script', '2015-11-20 09:17:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes is required', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_company', 'frontend', 'Front Label / Validate Company name', 'script', '2015-11-20 09:17:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company name is required', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLocationThumb', 'backend', 'Locations / Thumbnail', 'script', '2015-12-10 10:01:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Thumb', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLocationDeleteThumbTitle', 'backend', 'Locations / Delete thumbnail (title)', 'script', '2015-12-10 10:01:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete thumbnail', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblLocationDeleteThumbContent', 'backend', 'Locations / Delete thumbnail (content)', 'script', '2015-12-10 10:01:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete the thumbnail?', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_type', 'backend', 'Extras / Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_single', 'backend', 'Extras / Single', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Single', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'extra_multi', 'backend', 'Extras / Multi', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Multi', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_email_notify', 'backend', 'Locations / Email notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email notifications', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_email_notify_tip', 'backend', 'Locations / Email notifications tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send New reservation, Payment confirmation, and Reservation Cancellation email notifications to this email address.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuAddress', 'backend', 'Menu / Address', 'script', '2016-01-15 06:28:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuDefaultWorkingTime', 'backend', 'Menu / Default working time', 'script', '2016-01-15 06:29:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default working time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuCustomWorkingTime', 'backend', 'Menu / Custom working time', 'script', '2016-01-15 06:29:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom working time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_day', 'backend', 'Day of week', 'script', '2016-01-15 06:37:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day of week', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_is', 'backend', 'Is Day off', 'script', '2016-01-15 06:37:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is Day off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_from', 'backend', 'Start time', 'script', '2016-01-15 06:37:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_to', 'backend', 'End time', 'script', '2016-01-15 06:38:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoDefaultWTimeTitle', 'backend', 'Infobox / Default Working Time ', 'script', '2016-01-15 06:42:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoDefaultWTimeDesc', 'backend', 'Infobox / Default Working Time ', 'script', '2016-01-15 06:42:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can set working time for this location only. Different working time can be set for each day of the week. You can also set days off. ', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoCustomWTimeTitle', 'backend', 'Infobox / Custom Working Time ', 'script', '2016-01-15 06:43:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom working time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoCustomWTimeDesc', 'backend', 'Infobox / Custom Working Time ', 'script', '2016-01-15 06:44:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Using the form below you can set a custom working time for any date for this location only. Just select a date and set working time for it. Or you can just mark the date as a day off.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AWT01', 'arrays', 'error_titles_ARRAY_AWT01', 'script', '2016-01-15 06:46:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working time updated!', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AWT01', 'arrays', 'error_bodies_ARRAY_AWT01', 'script', '2016-01-15 06:47:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to the default working time have been saved.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_custom', 'backend', 'Label / Custom', 'script', '2016-01-15 06:56:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_date', 'backend', 'Label / Date', 'script', '2016-01-15 06:57:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAll', 'backend', 'Label / All', 'script', '2016-01-15 06:58:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AWT02', 'arrays', 'error_titles_ARRAY_AWT02', 'script', '2016-01-15 07:06:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom working time added!', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AWT02', 'arrays', 'error_bodies_ARRAY_AWT02', 'script', '2016-01-15 07:07:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom working time has been added.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCustomWTimeTitle', 'backend', 'Infobox / Update working time', 'script', '2016-01-15 07:15:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update working time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateCustomWTimeDesc', 'backend', 'Infobox / Update working time', 'script', '2016-01-15 07:16:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Make any changes no the form below and click "Save" button.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AWT03', 'arrays', 'error_titles_ARRAY_AWT03', 'script', '2016-01-15 07:18:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom working time updated!', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AWT03', 'arrays', 'error_bodies_ARRAY_AWT03', 'script', '2016-01-15 07:19:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to custom working time have been updated.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_1', 'arrays', 'wtime_arr_ARRAY_1', 'script', '2016-01-19 02:51:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up location is not open at the selected time yet.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_2', 'arrays', 'wtime_arr_ARRAY_2', 'script', '2016-01-19 02:54:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up location is closed at the selected time.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_3', 'arrays', 'wtime_arr_ARRAY_3', 'script', '2016-01-19 02:52:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up location is not working on the selected date.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_4', 'arrays', 'wtime_arr_ARRAY_4', 'script', '2016-01-19 02:53:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return location is not open at the selected time yet.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_5', 'arrays', 'wtime_arr_ARRAY_5', 'script', '2016-01-19 02:53:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return location is closed at the selected time.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_6', 'arrays', 'wtime_arr_ARRAY_6', 'script', '2016-01-19 02:54:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return location is not working on the selected date.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_7', 'arrays', 'wtime_arr_ARRAY_7', 'script', '2016-03-11 09:56:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Office is closed on the selected date/time.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPickupWorkingTime', 'backend', 'Label / Pick-up location is not working at this time.', 'script', '2016-01-19 07:08:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pick-up location is not working at this time.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblReturnWorkingTime', 'backend', 'Label / Return location is not working at this time.', 'script', '2016-01-19 07:17:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return location is not working at this time.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_0', 'arrays', 'short_days_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Su', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_1', 'arrays', 'short_days_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mo', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_2', 'arrays', 'short_days_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_3', 'arrays', 'short_days_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_4', 'arrays', 'short_days_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Th', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_5', 'arrays', 'short_days_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fr', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_6', 'arrays', 'short_days_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sa', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_invalid_period', 'frontend', 'Label / Return Date/Time must be greater than Pick-up Date/Time', 'script', '2016-06-10 05:43:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return Date/Time to NOT be earlier than Pick-up Date/Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_time_period', 'backend', 'Options / Time format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Time format', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_bf_captcha', 'backend', 'Options / Captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_captcha', 'frontend', 'Label / Captcha', 'script', '2017-03-28 06:13:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_captcha', 'frontend', 'Label / Captcha is required.', 'script', '2017-03-28 06:17:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha is required.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_4_v_captcha_incorrect', 'frontend', 'Label / Captcha is incorrect.', 'script', '2017-03-28 06:17:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha is incorrect.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_google_map_api', 'backend', 'Options / Google Map API key', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Google Map API key', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_name', 'backend', 'Label / Script name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Car Rental', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuReminder', 'backend', 'Label / Reminder', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reminder', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'menuTime', 'backend', 'Label / Working Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_install_your_website', 'backend', 'Label / Install your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install your website', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_preview_your_website', 'backend', 'Label / Preview your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Open in new window', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionPreview', 'backend', 'Label / Preview Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionInstall', 'backend', 'Label / Integration Code Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Integration Code Menu', 'script');

INSERT INTO `car_rental_plugin_base_multi_lang` VALUES(NULL, '1', 'pjPayment', '1', 'cash', 'Cash', 'data');

INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdmin_pjActionIndex');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Dashboard', 'data');

INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, NULL, 'pjAdmin_pjActionProfile', 'F');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Profile', 'data');


INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Options Menu', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBooking');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reservation Options', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjPayments_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Payment Options', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBookingForm');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reservation Form', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionNotifications');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Notifications', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionTerm');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Terms & Conditions', 'data');
  

INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionPreview');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Preview Menu', 'data');

INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionInstall');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Integration Code Menu', 'data');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionIndex', 'backend', 'Label / Dashboard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionProfile', 'backend', 'Label / Profile', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile', 'script');  

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions', 'backend', 'Label / Options Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBooking', 'backend', 'Label / Reservation Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation Options', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjPayments_pjActionIndex', 'backend', 'Label / Payment Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBookingForm', 'backend', 'Label / Reservation Form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation Form', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionNotifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionTerm', 'backend', 'Label / Terms & Conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms & Conditions', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_periods_arr_ARRAY_perday', 'arrays', 'enum_o_booking_periods_arr_ARRAY_perday', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day only', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_periods_arr_ARRAY_perhour', 'arrays', 'enum_o_booking_periods_arr_ARRAY_perhour', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per hour only', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_periods_arr_ARRAY_both', 'arrays', 'enum_o_booking_periods_arr_ARRAY_both', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day and per hour', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_time_period_arr_ARRAY_12hours', 'arrays', 'enum_o_time_period_arr_ARRAY_12hours', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '12 hours', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_time_period_arr_ARRAY_24hours', 'arrays', 'enum_o_time_period_arr_ARRAY_24hours', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '24 hours', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_deposit_type_arr_ARRAY_amount', 'arrays', 'enum_o_deposit_type_arr_ARRAY_amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_deposit_type_arr_ARRAY_percent', 'arrays', 'enum_o_deposit_type_arr_ARRAY_percent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Percent', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_tax_type_arr_ARRAY_amount', 'arrays', 'enum_o_tax_type_arr_ARRAY_amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_tax_type_arr_ARRAY_percent', 'arrays', 'enum_o_tax_type_arr_ARRAY_percent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Percent', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_insurance_payment_type_arr_ARRAY_percent', 'arrays', 'enum_o_insurance_payment_type_arr_ARRAY_percent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Percent', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_insurance_payment_type_arr_ARRAY_perday', 'arrays', 'enum_o_insurance_payment_type_arr_ARRAY_perday', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per day', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_insurance_payment_type_arr_ARRAY_perbooking', 'arrays', 'enum_o_insurance_payment_type_arr_ARRAY_perbooking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Per Reservation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_status_arr_ARRAY_confirmed', 'arrays', 'enum_o_booking_status_arr_ARRAY_confirmed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_status_arr_ARRAY_pending', 'arrays', 'enum_o_booking_status_arr_ARRAY_pending', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_booking_status_arr_ARRAY_cancelled', 'arrays', 'enum_o_booking_status_arr_ARRAY_cancelled', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_payment_status_arr_ARRAY_confirmed', 'arrays', 'enum_o_payment_status_arr_ARRAY_confirmed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_payment_status_arr_ARRAY_pending', 'arrays', 'enum_o_payment_status_arr_ARRAY_pending', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_o_payment_status_arr_ARRAY_cancelled', 'arrays', 'enum_o_payment_status_arr_ARRAY_cancelled', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_1', 'backend', 'enum_arr_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_2', 'backend', 'enum_arr_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_3', 'backend', 'enum_arr_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes (required)', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjBaseBackup_pjActionAutoBackup', 'backend', 'Label / backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Create automatic back-ups for database and files', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjCron_pjActionIndex', 'backend', 'Label / backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send Email and SMS reminders', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wt_title_over', 'backend', 'Label / Warning', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Warning', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wt_body_over', 'backend', 'Label / Overwrite current working time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Do you want to overwrite current working time?', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'invalid_lunch_selected_time', 'backend', 'Label / Invalid lunch time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break From must precede Lunch Break To', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO27', 'arrays', 'error_bodies_ARRAY_AO27', 'script', '2013-11-22 10:10:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set different payment options for your Appointment Scheduler software. Enable or disable the available payment processing companies.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO27', 'arrays', 'error_titles_ARRAY_AO27', 'script', '2013-09-18 08:47:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking payment options', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO25', 'arrays', 'error_titles_ARRAY_AO25', 'script', '2013-09-18 08:44:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO25', 'arrays', 'error_bodies_ARRAY_AO25', 'script', '2013-12-12 19:55:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email notifications will be sent to people who make a booking after the booking form is completed or/and payment is made. If you leave subject field blank no email will be sent.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblNotifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_menu_settings', 'backend', 'Menu / Settings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Settings', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_menu_notifications', 'backend', 'Menu / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_emails', 'backend', 'Label / Emails', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Emails', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_sms', 'backend', 'Label / SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_notifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_send_this_notifications', 'backend', 'Label / Send this notification', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send this notification', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_subject', 'backend', 'Label / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_message', 'backend', 'Label / Message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_change_labels', 'backend', 'Label / Change Labels', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change Labels', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_menu_payments', 'backend', 'Menu / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoPaymentsTitle', 'backend', 'Infobox / Payment options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoPaymentsDesc', 'backend', 'Infobox / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can choose your payment methods and set payment gateway accounts and payment preferences. Note that for cash payments the system will not be able to collect deposit amount online.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_offline_payment_methods', 'backend', 'Label / Offline Payment Methods', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Offline Payment Methods', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_request_antoher_payment', 'backend', 'Label / Request Another Payment Gateway', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Request Another Payment Gateway', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_online_payment_gateway', 'backend', 'Label / Online payment gateway', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Online payment gateway', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'script_offline_payment', 'backend', 'Label / Offline payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Offline payment', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation', 'script', '2018-05-31 06:19:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment', 'script', '2018-05-31 06:20:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel', 'script', '2018-05-31 06:20:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation', 'script', '2018-05-31 06:22:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment', 'script', '2018-05-31 06:23:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel', 'script', '2018-05-31 06:23:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation (title)', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation email sent to Client', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment (title)', 'script', '2018-05-31 06:45:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation email sent to Client', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel (title)', 'script', '2018-05-31 06:45:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Cancellation email sent to Client', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation (title)', 'script', '2018-05-31 06:59:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New Booking Received email sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment (title)', 'script', '2018-05-31 06:59:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Payment Confirmation email sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation email sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation (sub-title)', 'script', '2018-05-31 07:02:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to client when a new reservation is made.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment (sub-title)', 'script', '2018-05-31 07:02:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a payment is made for a new reservation.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel (sub-title)', 'script', '2018-05-31 07:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a client cancels a reservation.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation (sub-title)', 'script', '2018-05-31 07:01:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a new reservation is made.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment (sub-title)', 'script', '2018-05-31 07:01:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a payment for a new reservation is made.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel (sub-title)', 'script', '2018-05-31 07:01:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a client cancels a reservation.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subject', 'backend', 'Subject', 'script', '2018-05-31 09:22:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_message', 'backend', 'Message', 'script', '2018-05-31 09:23:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_is_active', 'backend', 'Send this message', 'script', '2018-05-31 09:23:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send this message', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_sms_na', 'backend', 'SMS not available', 'script', '2018-05-31 09:24:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notifications are currently not available for your website. See details', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_sms_na_here', 'backend', 'here', 'script', '2018-05-31 09:24:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'here', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_send', 'backend', 'Notifications / Send', 'script', '2018-05-31 09:25:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_do_not_send', 'backend', 'Notifications / Do not send', 'script', '2018-05-31 09:26:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Do not send', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_status', 'backend', 'Notifications / Status', 'script', '2018-05-31 09:26:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_client', 'backend', 'Notifications / Messages sent to Clients', 'script', '2018-05-31 09:27:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Clients', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_admin', 'backend', 'Notifications / Messages sent to Admin', 'script', '2018-05-31 09:30:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_default', 'backend', 'Notifications / Messages sent to Default', 'script', '2018-05-31 09:31:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_main_title', 'backend', 'Notifications', 'script', '2018-05-31 09:32:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_main_subtitle', 'backend', 'Notifications (sub-title)', 'script', '2018-05-31 09:33:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Automated messages are sent both to client and administrator(s) on specific events. Select message type to edit it - enable/disable or just change message text. For SMS notifications you need to enable SMS service. See more <a href="https://www.phpjabbers.com/web-sms/" target="_blank">here</a>.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_recipient', 'backend', 'Notifications / Recipient', 'script', '2018-05-31 09:33:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Recipient', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_tokens_note', 'backend', 'Notifications / Tokens (note)', 'script', '2018-05-31 09:35:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Personalize the message by including any of the available tokens and it will be replaced with corresponding data.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_tokens', 'backend', 'Notifications / Tokens', 'script', '2018-05-31 09:38:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens:', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_client', 'arrays', 'Recipients / Client', 'script', '2018-05-31 09:39:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_admin', 'arrays', 'Recipients / Administrator', 'script', '2018-05-31 09:39:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administrator', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'recipient_admin_note', 'backend', 'Recipients / Administrator (note)', 'script', '2018-05-31 09:40:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Go to <a href="index.php?controller=pjBaseUsers&action=pjActionIndex">Users menu</a> and edit each administrator profile to select if they should receive "Admin notifications" or not.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'opt_o_email_body_text', 'backend', 'Options / Email body text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, @id, 'pjField', 1, 'title', '<div class="col-xs-6">
<div><small>{Title}</small></div>
<div><small>{Name}</small></div>
<div><small>{Email}</small></div>
<div><small>{Phone}</small></div>
<div><small>{Country}</small></div>
<div><small>{City}</small></div>
<div><small>{State}</small></div>
<div><small>{Zip}</small></div>
<div><small>{Address}</small></div>
<div><small>{Company}</small></div>
<div><small>{Notes}</small></div>
<div><small>{DtFrom}{DtTo}</small></div>
</div>
<div class="col-xs-6">
<div><small>{PickupLocation}</small></div>
<div><small>{ReturnLocation}</small></div>
<div><small>{Type}</small></div>
<div><small>{Extras}</small></div>
<div><small>{BookingID}</small></div>
<div><small>{UniqueID}</small></div>
<div><small>{Deposit}</small></div>
<div><small>{Total}</small></div>
<div><small>{Tax}</small></div>
<div><small>{Security}</small></div>
<div><small>{Insurance}</small></div>
<div><small>{PaymentMethod}</small></div>
<div><small>{CancelURL}</small></div>
 </div>
', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_confirmation', 'arrays', 'Notifications / New reservation sms', 'script', '2018-05-31 06:20:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New reservation sms', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_confirmation', 'arrays', 'Notifications / New reservation sms (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New Booking Received sms sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_confirmation', 'arrays', 'Notifications / New reservation sms (sub-title)', 'script', '2018-05-31 07:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a new reservation is made.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_payment', 'arrays', 'Notifications / New payment sms', 'script', '2018-05-31 06:20:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New payment sms', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_payment', 'arrays', 'Notifications / New payment sms (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Payment Confirmation sms sent to Admin', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_payment', 'arrays', 'Notifications / New payment sms (sub-title)', 'script', '2018-05-31 07:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a payment for a new reservation is made.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO26', 'arrays', 'error_titles_ARRAY_AO26', 'script', '2013-09-18 08:44:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO26', 'arrays', 'error_bodies_ARRAY_AO26', 'script', '2013-09-18 08:45:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter booking terms and conditions.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO09', 'arrays', 'error_bodies_ARRAY_AO09', 'script', '2013-10-07 11:42:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to terms have been saved.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO09', 'arrays', 'error_titles_ARRAY_AO09', 'script', '2013-10-07 11:42:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms updated!', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_sms_reminder', 'arrays', 'Notifications / Reservation reminder SMS', 'script', '2018-05-31 06:20:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation reminder SMS', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_sms_reminder', 'arrays', 'Notifications / Reservation reminder SMS (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Reservation Reminder sms sent to Client', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_sms_reminder', 'arrays', 'Notifications / Reservation reminder SMS (sub-title)', 'script', '2018-05-31 07:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can send SMS message under the Edit Reservation page', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras', 'backend', 'pjAdminExtras', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionIndex', 'backend', 'pjAdminExtras_pjActionIndex', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extras List', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionCreate', 'backend', 'pjAdminExtras_pjActionCreate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add extra', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionUpdate', 'backend', 'pjAdminExtras_pjActionUpdate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update extra', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionDelete', 'backend', 'pjAdminExtras_pjActionDelete', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete single extra', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionDeleteBulk', 'backend', 'pjAdminExtras_pjActionDeleteBulk', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete multiple extras', 'script');


INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminExtras');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminExtras_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionCreate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionUpdate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionDelete');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionDeleteBulk');
    

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_title', 'backend', 'Install / Title', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install instructions', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_body', 'backend', 'Install / Body', 'script', '2013-09-18 13:30:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In order to install the script on your website copy the code below and add it to your web page.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_1', 'backend', 'Install / Step 1', 'script', '2013-09-18 13:30:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install Code', 'script');
  
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallLanguageConfig', 'backend', 'Install / Language configuration', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Language configuration', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallConfigLocale', 'backend', 'Install / Language', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Language', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallCodeStep1', 'backend', 'Install / Step 1', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 1. (Required) Copy the code below and put it in the HEAD tag of your web page.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblInstallCodeStep2', 'backend', 'Install / Step 2', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2. (Required) Copy the code below and put it in your web page where you want the script to appear.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'prices_invalid_input', 'backend', 'Label / The price value cannot be greater than 99999999999999.99', 'script', '2018-11-19 07:06:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The price value cannot be greater than 99999999999999.99', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'delete_selected', 'backend', 'Grid / Delete selected', 'script', '2013-09-16 14:10:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'delete_confirmation', 'backend', 'Grid / Confirmation Title', 'script', '2013-09-16 14:09:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected records?', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT12', 'arrays', 'error_titles_ARRAY_AT12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT12', 'arrays', 'error_bodies_ARRAY_AT12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New type could not be added because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT13', 'arrays', 'error_titles_ARRAY_AT13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT13', 'arrays', 'error_bodies_ARRAY_AT13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New type has been added, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT14', 'arrays', 'error_titles_ARRAY_AT14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT14', 'arrays', 'error_bodies_ARRAY_AT14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT15', 'arrays', 'error_titles_ARRAY_AT15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT15', 'arrays', 'error_bodies_ARRAY_AT15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type could not be updated because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT16', 'arrays', 'error_titles_ARRAY_AT16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT16', 'arrays', 'error_bodies_ARRAY_AT16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type information has been updated, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT17', 'arrays', 'error_titles_ARRAY_AT17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT17', 'arrays', 'error_bodies_ARRAY_AT17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_select_image', 'backend', 'Label / Select image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select image', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_change_image', 'backend', 'Label / Change image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change image', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_image_dtitle', 'backend', 'Types / Delete confirmation', 'script', '2013-09-18 11:23:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'type_image_dbody', 'backend', 'Types / Delete content', 'script', '2013-09-18 11:23:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete this picture?', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnAddRate', 'backend', 'Button / Add rate', 'script', '2013-09-18 11:23:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add rate', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDuplicatedPeriodTitle', 'backend', 'Label / Duplicated period', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Duplicated period', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDuplicatedPeriodDesc', 'backend', 'Label / Duplicated period', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You have set the same period for the same rate. Please check again.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnOk', 'backend', 'Button / OK', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'OK', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblEmptyRatesTitle', 'backend', 'Label / Warning', 'script', '2016-01-11 03:17:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Warning', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblEmptyRatesDesc', 'backend', 'Label / Warning desc', 'script', '2016-01-11 03:17:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please set your custom rates', 'script');


INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminLocations');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Office Locations menu', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminLocations_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Office Locations List', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionCreate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Add location', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionUpdate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Edit location', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionDelete');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single location', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionDeleteBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete multiple locations', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionGet', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show list elements', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminLocations_pjActionSave', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save location', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminTime_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Working Time Menu', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSetTime');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create Working Time', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSaveTime', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save time', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionGetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Custom Working Time', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionCheckDayOff', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check day off', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionDeleteDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionDeleteDayOffBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionGetUpdate', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get Update', 'data');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations', 'backend', 'Label / Locations menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Office Locations menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionIndex', 'backend', 'Label / Office Locations List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Office Locations List', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionCreate', 'backend', 'Label / Add location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add location', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionUpdate', 'backend', 'Label / Edit location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit location', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionDelete', 'backend', 'Label / Delete single location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single location', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionDeleteBulk', 'backend', 'Label / Delete multiple locations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple locations', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionGet', 'backend', 'Label / Get location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show list elements', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminLocations_pjActionSave', 'backend', 'Label / Get location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save location', 'script');


SET @id := (SELECT `id` FROM `car_rental_plugin_base_fields` WHERE `key`='btnAddLocation');
UPDATE `car_rental_plugin_base_multi_lang` SET `content`='Add location' WHERE `foreign_id`=@id AND `model`='pjField' AND `field`='title';

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_notify_email_ARRAY_T', 'arrays', '_notify_email_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, '_notify_email_ARRAY_F', 'arrays', '_notify_email_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL12', 'arrays', 'error_titles_ARRAY_AL12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL12', 'arrays', 'error_bodies_ARRAY_AL12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New location could not be added because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL13', 'arrays', 'error_titles_ARRAY_AL13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL13', 'arrays', 'error_bodies_ARRAY_AL13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New location has been added, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL14', 'arrays', 'error_titles_ARRAY_AL14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL14', 'arrays', 'error_bodies_ARRAY_AL14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL15', 'arrays', 'error_titles_ARRAY_AL15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL15', 'arrays', 'error_bodies_ARRAY_AL15', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Location could not be updated because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL16', 'arrays', 'error_titles_ARRAY_AL16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL16', 'arrays', 'error_bodies_ARRAY_AL16', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Location information has been updated, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL17', 'arrays', 'error_titles_ARRAY_AL17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL17', 'arrays', 'error_bodies_ARRAY_AL17', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_image_dtitle', 'backend', 'Types / Delete confirmation', 'script', '2013-09-18 11:23:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_image_dbody', 'backend', 'Types / Delete content', 'script', '2013-09-18 11:23:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete this picture?', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'tab_default', 'backend', 'Label / Tab / Default', 'script', '2017-12-22 08:14:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'tab_days_off', 'backend', 'Label / Tab / Days off', 'script', '2017-12-22 08:15:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Days off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_set_wtime', 'backend', 'Label / Button / Set Working Times', 'script', '2017-12-22 08:17:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set Working Times', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day', 'backend', 'Label / Button / Day', 'script', '2017-12-28 08:04:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'hours', 'backend', 'Label / Hours', 'script', '2017-12-22 08:18:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working hours', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lunch_break', 'backend', 'Label / Lunch break', 'script', '2017-12-22 08:18:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch break', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'day_off', 'backend', 'Label / Button / Day off', 'script', '2017-12-22 08:26:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lunch_off', 'backend', 'Label / Button / Lunch off', 'script', '2017-12-22 08:26:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'set_working_times', 'backend', 'Label / Set Working Times', 'script', '2017-12-22 08:48:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set Working Times', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'select_day', 'backend', 'Label / Select day', 'script', '2017-12-22 08:48:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select day', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'choose', 'backend', 'Label / Choose', 'script', '2017-12-22 08:52:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_cancel', 'backend', 'Label / Button / Cancel', 'script', '2017-12-22 08:58:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wokring_from', 'backend', 'Label / Working Time From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time From', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wokring_to', 'backend', 'Label / Working Time To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time To', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'from', 'backend', 'Label / Working Time From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'to', 'backend', 'Label / Working Time To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lunch_from', 'backend', 'Label / Lunch Break From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break From', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lunch_to', 'backend', 'Label / Lunch Break To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break To', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'invalid_selected_time', 'backend', 'Label / End time cannot be less than start time.', 'script', '2017-12-22 10:41:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time From must precede Working Time To', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'duplicated_time', 'backend', 'Label / Duplicated time on weekday', 'script', '2017-12-28 02:23:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Duplicated time on %s.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAMT01', 'arrays', 'error_titles_ARRAY_PAMT01', 'script', '2017-12-28 02:55:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time Updated!', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAMT01', 'arrays', 'error_bodies_ARRAY_PAMT01', 'script', '2017-12-28 02:56:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to the default working time have been saved successfully. ', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_add_day_off', 'backend', 'Label / Button / Add Day Off', 'script', '2017-12-28 03:22:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add Day Off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'add_day_off', 'backend', 'Label / Add Day Off', 'script', '2017-12-28 03:24:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add custom working time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'from_date', 'backend', 'Label / From date', 'script', '2017-12-28 03:24:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Date', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'to_date', 'backend', 'Label / To date', 'script', '2017-12-28 03:24:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To Date', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'from_time', 'backend', 'Label / From time', 'script', '2017-12-28 03:25:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'to_time', 'backend', 'Label / To time', 'script', '2017-12-28 03:25:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'dates', 'backend', 'Label / Date(s)', 'script', '2017-12-28 03:35:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date(s)', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'hour', 'backend', 'Label / Hour', 'script', '2017-12-28 03:36:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Hour', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'all_day', 'backend', 'Label / All day', 'script', '2017-12-28 03:47:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All day', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'invalid_dates_off', 'backend', 'Label / From date must be less than To date.', 'script', '2017-12-28 04:17:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Date must precede To Date', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'invalid_day_off_time', 'backend', 'Label / From time must be less than To time.', 'script', '2017-12-28 04:20:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Time must precede To Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AWT04', 'arrays', 'error_titles_ARRAY_AWT04', 'script', '2013-09-17 07:45:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AWT04', 'arrays', 'error_bodies_ARRAY_AWT04', 'script', '2013-12-12 18:48:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Different working time can be set for each day of the week. You can also set days off and a lunch break. Under Edit Location page you can set up custom working time for each of your locations.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_update_custom', 'backend', 'Working Time / Update custom', 'script', '2013-09-17 07:47:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update custom', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_default', 'backend', 'Working Time / Default', 'script', '2013-09-17 08:42:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'location_address', 'backend', 'Location / Address', 'script', '2013-09-17 08:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_default_wt', 'backend', 'Working Time / Default Working Time', 'script', '2013-09-17 08:42:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_custom_wt', 'backend', 'Working Time / Custom Working Time', 'script', '2013-09-17 08:42:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_lunch_from', 'backend', 'Working Time / Lunch from', 'script', '2013-09-17 10:28:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch from', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'time_lunch_to', 'backend', 'Working Time / Lunch to', 'script', '2013-09-17 10:29:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch to', 'script');


    

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime', 'backend', 'Label / Working Time Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Working Time Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionIndex', 'backend', 'Label / Default Working Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSetTime', 'backend', 'Label / Set time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSaveTime', 'backend', 'Label / Save time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionGetDayOff', 'backend', 'Label / Get day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionCheckDayOff', 'backend', 'Label / Check day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check day off', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSetDayOff', 'backend', 'Label / Set day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionDeleteDayOff', 'backend', 'Label / Delete day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionDeleteDayOffBulk', 'backend', 'Label / Delete day off bulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionGetUpdate', 'backend', 'Label / Get Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update Custom Working Time', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars', 'backend', 'pjAdminCars', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionIndex', 'backend', 'pjAdminCars_pjActionIndex', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cars List', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionCreate', 'backend', 'pjAdminCars_pjActionCreate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionUpdate', 'backend', 'pjAdminCars_pjActionUpdate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionDelete', 'backend', 'pjAdminCars_pjActionDelete', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete single car', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionDeleteBulk', 'backend', 'pjAdminCars_pjActionDeleteBulk', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete multiple cars', 'script');


INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminCars');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminCars_pjActionAvailability');
  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminCars_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCars_pjActionCreate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCars_pjActionUpdate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCars_pjActionDelete');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminCars_pjActionDeleteBulk');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings', 'backend', 'pjAdminBookings', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservations Menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionIndex', 'backend', 'pjAdminBookings_pjActionIndex', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservations List', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCreate', 'backend', 'pjAdminBookings_pjActionCreate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add reservation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionUpdate', 'backend', 'pjAdminBookings_pjActionUpdate', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update reservation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBooking', 'backend', 'pjAdminBookings_pjActionDeleteBooking', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete single reservation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBookingBulk', 'backend', 'pjAdminBookings_pjActionDeleteBookingBulk', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delele multiple reservations', 'script');

INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminBookings');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionCreate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionUpdate');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBooking');
    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBookingBulk');

    

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'advance_search', 'backend', 'Label / Advance Search', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Advance Search', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'label_to', 'backend', 'Label / to', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'to', 'script');
  

SET @id := (SELECT `id` FROM `car_rental_plugin_base_fields` WHERE `key`='btnAddReservation');
UPDATE `car_rental_plugin_base_multi_lang` SET `content`='Add reservation' WHERE `foreign_id`=@id AND `model`='pjField' AND `field`='title';
 
SET @id := (SELECT `id` FROM `car_rental_plugin_base_fields` WHERE `key`='infoAddBookingTitle');
UPDATE `car_rental_plugin_base_multi_lang` SET `content`='Add new reservation' WHERE `foreign_id`=@id AND `model`='pjField' AND `field`='title';
    
SET @id := (SELECT `id` FROM `car_rental_plugin_base_fields` WHERE `key`='infoAddBookingBody');
UPDATE `car_rental_plugin_base_multi_lang` SET `content`='Use the form below to manually add new reservation. You need to fill in the required data in both tabs - Rental details and Customer details. The system will automatically calculate the price based on your selection.' WHERE `foreign_id`=@id AND `model`='pjField' AND `field`='title';

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblExtra', 'backend', 'Label / Extra', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extra', 'script');
  
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblPrice', 'backend', 'Label / Price', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');
  
INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblQty', 'backend', 'Label / Qty', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Qty', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnBookingAddExtra', 'backend', 'Button / Add extra', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add extra', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingTitle', 'backend', 'Info / Update booking title', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update booking', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingDesc', 'backend', 'Info / Update booking body', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the form below to update booking details.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btnBookingAddPayment', 'backend', 'Button / Add payment', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add payment', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_dtitle', 'backend', 'Info / Delete payment title', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete payment', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_payment_dbody', 'backend', 'Info / Delete payment body', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete this payment?', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_c_email', 'backend', 'Label / Email', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_email_confirmation', 'backend', 'Info / Email confirmation', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email confirmation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'booking_sms_confirmation', 'backend', 'Info / SMS confirmation', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS confirmation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblEmailNotificationNotSet', 'backend', 'Email / Email notificaton has not been set', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email notificaton has not been set', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblSmsNotificationNotSet', 'backend', 'Email / SMS notificaton has not been set', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS notificaton has not been set', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'label_today', 'backend', 'Label / Today', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTotalBookingToday', 'backend', 'Label / Total booking today', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total <strong>%s</strong> booking today', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTotalBookingsToday', 'backend', 'Label / Total booking today', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total <strong>%s</strong> bookings today', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTotalPickupToday', 'backend', 'Label / Total pickup today', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total <strong>%s</strong> pick-up today', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashTotalReturnToday', 'backend', 'Label / Total return today', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total <strong>%s</strong> return today', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNoBookingsFound', 'backend', 'Label / No bookings found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No bookings found', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblDashNoCarsFound', 'backend', 'Label / No cars found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No cars found', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblOptionsTermsContent', 'backend', 'Options / Booking terms content', 'script', '2013-09-18 06:54:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking terms content', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'wtime_arr_ARRAY_8', 'arrays', 'wtime_arr_ARRAY_8', 'script', '2016-03-11 09:56:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Office is on lunch break', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_booking_success', 'backend', 'Frontend / Booking success', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your reservation has been successfully sent to the administrator.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'cancel_title', 'frontend', 'Cancel / Page title', 'script', '2014-01-22 08:43:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Cancellation', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminCars_pjActionAvailability', 'backend', 'pjAdminCars_pjActionAvailability', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Availability', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'lblAvailabilityCarsEmpty', 'backend', 'Label / No cars found', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No cars found', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'btn_add_custom', 'backend', 'Button / Add custom', 'script', '2015-03-20 11:37:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add custom', 'script');


INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminTypes');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Types and Rates menu', 'data');

  INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminTypes_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Types and Rates List', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionCreate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Add type', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionUpdate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Edit type', 'data');

      INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminTypes_pjActionDeleteImage');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Image', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionDelete');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single type', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionDeleteBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete multiple types', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionGet', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show list elements', 'data');

    INSERT INTO `car_rental_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTypes_pjActionSave', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save type', 'data');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes', 'backend', 'Label / Types and Rates menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Types and Rates menu', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionIndex', 'backend', 'Label / Types and Rates List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Types and Rates List', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionCreate', 'backend', 'Label / Add type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionUpdate', 'backend', 'Label / Edit type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionDeleteImage', 'backend', 'Label / Delete Image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Image', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionDelete', 'backend', 'Label / Delete single type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionDeleteBulk', 'backend', 'Label / Delete multiple types', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple types', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionGet', 'backend', 'Label / Get type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show list elements', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'pjAdminTypes_pjActionSave', 'backend', 'Label / Get type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save type', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_location_email', 'frontend', 'Label / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_location_phone', 'frontend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');


INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_err_ARRAY_109', 'arrays', 'front_err_ARRAY_109', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Form data is missing.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_err_ARRAY_110', 'arrays', 'front_err_ARRAY_110', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is not correct.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_err_ARRAY_111', 'arrays', 'front_err_ARRAY_111', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing, empty or invalid form data. Please check again the field %s.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_err_ARRAY_112', 'arrays', 'front_err_ARRAY_112', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation data is not valid. The reservation could not be saved correctly.', 'script');

INSERT INTO `car_rental_plugin_base_fields` VALUES (NULL, 'front_err_ARRAY_113', 'arrays', 'front_err_ARRAY_113', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `car_rental_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please correct your email address.', 'script');
	
	