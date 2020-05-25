#
# Салон красоты Яблоко Database Dump
# MODX Version:1.4.9
# 
# Host: 
# Generation Time: 25-05-2020 18:47:16
# Server version: 5.6.39-83.1
# PHP Version: 7.1.26
# Database: `yablokoshop_db`
# Description: 
#

# --------------------------------------------------------

#
# Table structure for table `{PREFIX}expectation`
#

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `{PREFIX}expectation`;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

CREATE TABLE `{PREFIX}expectation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `email` varchar(128) NOT NULL,
  `date` int(11) NOT NULL,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

#
# Dumping data for table `{PREFIX}expectation`
#
