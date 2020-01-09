/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `lb_book` */

DROP TABLE IF EXISTS `lb_book`;

CREATE TABLE `lb_book` (
  `bk_id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `bk_rd_id` BIGINT(20) UNSIGNED DEFAULT NULL COMMENT 'id из таблицы lb_reader',
  `bk_title` CHAR(255) NOT NULL COMMENT 'название книги',
  `bk_date` DATE NOT NULL COMMENT 'дата публикации',
  `bk_writer_counter` INT(11) NOT NULL DEFAULT '0' COMMENT 'счетчик соавторов',
  `bk_created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время добавления',
  `bk_updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время последнего обновления',
  PRIMARY KEY (`bk_id`),
  KEY `bk_writer_counter` (`bk_writer_counter`),
  KEY `bk_rd_id` (`bk_rd_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY HASH (bk_id)
PARTITIONS 100 */;

/*Table structure for table `lb_reader` */

DROP TABLE IF EXISTS `lb_reader`;

CREATE TABLE `lb_reader` (
  `rd_id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `rd_full_name` CHAR(255) NOT NULL COMMENT 'имя',
  `rd_date` DATE NOT NULL COMMENT 'дата рождения',
  `rd_created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время добавления',
  `rd_updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время последнего обновления',
  PRIMARY KEY (`rd_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY HASH (rd_id)
PARTITIONS 100 */;

/*Table structure for table `lb_writer` */

DROP TABLE IF EXISTS `lb_writer`;

CREATE TABLE `lb_writer` (
  `wt_id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `wt_full_name` CHAR(255) NOT NULL COMMENT 'имя',
  `wt_date` DATE NOT NULL COMMENT 'дата рождения',
  `wt_reader_counter` INT(11) NOT NULL DEFAULT '0' COMMENT 'счетчик читателей',
  `wt_created_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время добавления',
  `wt_updated_at` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'время последнего обновления',
  PRIMARY KEY (`wt_id`),
  KEY `wt_reader_counter` (`wt_reader_counter`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY HASH (wt_id)
PARTITIONS 100 */;

/*Table structure for table `lb_writer_book` */

DROP TABLE IF EXISTS `lb_writer_book`;

CREATE TABLE `lb_writer_book` (
  `wb_wt_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'id из таблицы lb_writer',
  `wb_bk_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'id из таблицы lb_book',
  PRIMARY KEY (`wb_wt_id`,`wb_bk_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY HASH (wb_bk_id)
PARTITIONS 100 */;

/* Trigger structure for table `lb_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_book_bi` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_book_bi` BEFORE INSERT ON `lb_book` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- проверяем уникальность названия и даты издания книги
	SET flag = lb_book_uniq(NEW.bk_title, NEW.bk_date);
	IF flag=0 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_book_uniq';
	END IF;
	
	-- выставляем существование читателя если указан
	SET flag = 0;
	IF NEW.bk_rd_id IS NOT NULL THEN 
		SET flag = lb_reader_fk(NEW.bk_rd_id);
		IF flag=0 THEN
			 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_book_fk';
		END IF;
	END IF;
	
	-- выставляем дату создания записи
	SET NEW.bk_created_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_book_ai` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_book_ai` AFTER INSERT ON `lb_book` FOR EACH ROW BEGIN
	-- если для книги добавлен читатель обновляем счётчик читателей всем писателям
	IF NEW.bk_rd_id IS NOT NULL THEN 
		CALL lb_wt_reader_counter(NEW.bk_id, 1);
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_book_bu` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_book_bu` BEFORE UPDATE ON `lb_book` FOR EACH ROW BEGIN
	-- выставляем дату последнего обновления записи
	SET NEW.bk_updated_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_book_au` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_book_au` AFTER UPDATE ON `lb_book` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- если добавляется читатель проверяем существует ли он
	IF OLD.bk_rd_id IS NULL AND NEW.bk_rd_id IS NOT NULL THEN 
		SET flag = lb_reader_fk(NEW.bk_rd_id);
		IF flag=0 THEN
			 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_book_fk';
		END IF;
	END IF;
	
	-- если для книги добавлен читатель обновляем счётчик читателей всем писателям
	IF OLD.bk_rd_id IS NULL AND NEW.bk_rd_id IS NOT NULL THEN
		call lb_wt_reader_counter(NEW.bk_id, 1);
	END IF;
	
	-- если для книги удален читатель обновляем счётчик читателей всем писателям
	IF OLD.bk_rd_id IS NOT NULL AND NEW.bk_rd_id IS NULL THEN 
		CALL lb_wt_reader_counter(NEW.bk_id, -1);
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_book_bd` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_book_bd` BEFORE DELETE ON `lb_book` FOR EACH ROW BEGIN
	-- если книга находится у читателя её нельзя удалить
	IF OLD.bk_rd_id IS NOT NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_book_fk';
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_reader` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_reader_bi` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_reader_bi` BEFORE INSERT ON `lb_reader` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- проверяем уникальность имени и даты рождения читателя
	SET flag = lb_reader_uniq(NEW.rd_full_name, NEW.rd_date);
	IF flag=0 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_reader_uniq';
	END IF;
	
	-- выставляем дату создания записи
	SET NEW.rd_created_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_reader` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_reader_bu` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_reader_bu` BEFORE UPDATE ON `lb_reader` FOR EACH ROW BEGIN
	-- выставляем дату последнего обновления записи
	SET NEW.rd_updated_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_reader` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_reader_bd` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_reader_bd` BEFORE DELETE ON `lb_reader` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- если у читателя есть несданные книги его нельзя удалить
	SELECT COUNT(*)>0 FROM `lb_book` WHERE bk_rd_id=OLD.rd_id INTO flag;
	IF flag=1 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_book_fk';
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_bi` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_bi` BEFORE INSERT ON `lb_writer` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- проверяем уникальность имени и даты рождения писателя
	SET flag = lb_writer_uniq(NEW.wt_full_name, NEW.wt_date);
	IF flag=0 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_writer_uniq';
	END IF;
	
	-- при добавлении счетчик читателей у писателя может быть только нулевым
	SET NEW.wt_reader_counter = 0;
	
	-- выставляем дату создания записи
	SET NEW.wt_created_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_bu` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_bu` BEFORE UPDATE ON `lb_writer` FOR EACH ROW BEGIN
	-- выставляем дату последнего обновления записи
	SET NEW.wt_updated_at = NOW();
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_bd` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_bd` BEFORE DELETE ON `lb_writer` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- если у писателя есть написанные книги его нельзя удалить
	SELECT COUNT(*)>0 FROM `lb_writer_book` WHERE wb_wt_id=OLD.wt_id INTO flag;
	IF flag=1 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_writer_book_fk';
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_book_bi` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_book_bi` BEFORE INSERT ON `lb_writer_book` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- проверяем существование добавляемой книги и писателя
	SET flag = lb_writer_book_fk(NEW.wb_wt_id, NEW.wb_bk_id);
	IF flag=0 THEN
		 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error lb_writer_book_fk';
	END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_book_ai` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_book_ai` AFTER INSERT ON `lb_writer_book` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- если добавляемая книга находится у читателя обновляем счетик читателей писателю
	SELECT COUNT(*)>0 FROM `lb_book` WHERE bk_id=NEW.wb_bk_id AND bk_rd_id IS NOT NULL INTO flag;
	
	IF flag=1 THEN
		-- обновляем счетчик соавторов книги
		UPDATE `lb_writer` SET wt_reader_counter = wt_reader_counter + 1 WHERE wt_id = NEW.wb_wt_id;
	END IF;
	
	UPDATE `lb_book` SET bk_writer_counter = bk_writer_counter + 1 WHERE bk_id = NEW.wb_bk_id;
	
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_book_bu` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_book_bu` BEFORE UPDATE ON `lb_writer_book` FOR EACH ROW BEGIN
	-- данная таблица не предусматривает обновления
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error update is not permitted';
    END */$$


DELIMITER ;

/* Trigger structure for table `lb_writer_book` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `lb_writer_book_ad` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `lb_writer_book_ad` AFTER DELETE ON `lb_writer_book` FOR EACH ROW BEGIN
	DECLARE flag TINYINT(1) DEFAULT 0;
	
	-- если добавляемая книга находится у читателя обновляем счетик читателей писателю
	SELECT COUNT(*)>0 FROM `lb_book` WHERE bk_id=OLD.wb_bk_id AND bk_rd_id IS NOT NULL INTO flag;
	
	IF flag=1 THEN
		UPDATE `lb_writer` SET wt_reader_counter = wt_reader_counter - 1 WHERE wt_id = OLD.wb_wt_id;
	END IF;
	
	-- обновляем счетчик соавторов книги
	UPDATE `lb_book` SET bk_writer_counter = bk_writer_counter - 1 WHERE bk_id = OLD.wb_bk_id;
	
    END */$$


DELIMITER ;

/* Function  structure for function  `lb_book_uniq` */

/*!50003 DROP FUNCTION IF EXISTS `lb_book_uniq` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `lb_book_uniq`(in_bk_title char(255), in_bk_date dATETIME) RETURNS tinyint(1)
BEGIN
	DECLARE book TINYINT(1) DEFAULT 0;
	
	SELECT COUNT(*)=0 FROM `lb_book` WHERE bk_title=in_bk_title and bk_date=in_bk_date INTO book;
	IF book=0 THEN
		RETURN 0;
	END IF;
	
	RETURN 1;
    END */$$
DELIMITER ;

/* Function  structure for function  `lb_reader_fk` */

/*!50003 DROP FUNCTION IF EXISTS `lb_reader_fk` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `lb_reader_fk`(in_rd_id int(11)) RETURNS tinyint(1)
BEGIN
	DECLARE reader TINYINT(1) DEFAULT 0;
	
	SELECT COUNT(*)=1 FROM `lb_reader` WHERE rd_id=in_rd_id INTO reader;
	IF reader=0 THEN
		RETURN 0;
	END IF;
	
	RETURN 1;
    END */$$
DELIMITER ;

/* Function  structure for function  `lb_reader_uniq` */

/*!50003 DROP FUNCTION IF EXISTS `lb_reader_uniq` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `lb_reader_uniq`(in_rd_full_name char(255), in_rd_date dATETIME) RETURNS tinyint(1)
BEGIN
	DECLARE reader TINYINT(1) DEFAULT 0;
	
	SELECT COUNT(*)=0 FROM `lb_reader` WHERE rd_full_name=in_rd_full_name and rd_date=in_rd_date INTO reader;
	IF reader=0 THEN
		RETURN 0;
	END IF;
	
	RETURN 1;
    END */$$
DELIMITER ;

/* Function  structure for function  `lb_writer_book_fk` */

/*!50003 DROP FUNCTION IF EXISTS `lb_writer_book_fk` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `lb_writer_book_fk`(in_wt_id int(11), in_bk_id int(11)) RETURNS tinyint(1)
BEGIN
	DECLARE writer tinyint(1) DEFAULT 0;
	DECLARE book TINYINT(1) DEFAULT 0;
	
	SELECT COUNT(*)=1 FROM `lb_writer` WHERE wt_id=in_wt_id INTO writer;
	IF writer=0 THEN
		RETURN 0;
	END IF;
	
	SELECT COUNT(*)=1 FROM `lb_book` WHERE bk_id=in_bk_id INTO book;
	IF book=0 THEN
		RETURN 0;
	END IF;
	
	RETURN 1;
    END */$$
DELIMITER ;

/* Function  structure for function  `lb_writer_uniq` */

/*!50003 DROP FUNCTION IF EXISTS `lb_writer_uniq` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `lb_writer_uniq`(in_wt_full_name char(255), in_wt_date dATETIME) RETURNS tinyint(1)
BEGIN
	DECLARE writer TINYINT(1) DEFAULT 0;
	
	SELECT COUNT(*)=0 FROM `lb_writer` WHERE wt_full_name=in_wt_full_name and wt_date=in_wt_date INTO writer;
	IF writer=0 THEN
		RETURN 0;
	END IF;
	
	RETURN 1;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_book` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_book` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_book`(in_num_rows int(11), in_offset INT(11), in_buffer INT(11))
BEGIN	
	DECLARE end_offset INT DEFAULT 0;
	DECLARE rcount INT DEFAULT 0;
	SET end_offset = in_offset + in_num_rows;
	SELECT COUNT(*) FROM `lb_reader` INTO rcount;
	
	WHILE in_offset < end_offset DO
		INSERT INTO `lb_book` (bk_rd_id, bk_title, bk_date, bk_created_at)
		SELECT IF(FLOOR(RAND()*10)=5, FLOOR(RAND()*rcount), NULL) as bk_rd_id, bk_title, bk_date, bk_created_at FROM `benerator`.`lb_book` LIMIT in_buffer offset in_offset;
		
		SET in_offset = in_offset + in_buffer;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_reader` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_reader` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_reader`(in_num_rows int(11), in_offset INT(11), in_buffer INT(11))
BEGIN	
	DECLARE end_offset INT DEFAULT 0;
	SET end_offset = in_offset + in_num_rows;
	
	WHILE in_offset < end_offset DO
		INSERT INTO `lb_reader` (rd_full_name, rd_date, rd_created_at)
		SELECT rd_full_name, rd_date, rd_created_at FROM `benerator`.`lb_reader` LIMIT in_buffer offset in_offset;
		
		SET in_offset = in_offset + in_buffer;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_writer` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_writer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_writer`(in_num_rows int(11), in_offset INT(11), in_buffer INT(11))
BEGIN	
	DECLARE end_offset int default 0;
	SET end_offset = in_offset + in_num_rows;
	
	WHILE in_offset < end_offset do
		INSERT INTO `lb_writer` (wt_full_name, wt_date, wt_created_at)
		SELECT rd_full_name as wt_full_name, rd_date as wt_date, rd_created_at as wt_created_at FROM `benerator`.`lb_reader` LIMIT in_buffer offset in_offset;
		
		SET in_offset = in_offset + in_buffer;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_writer_book` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_writer_book` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_writer_book`(in_num_rows INT(11), in_buffer INT(11))
BEGIN	
	DECLARE cur_num_rows INT DEFAULT 0;
	DECLARE cur_buffer INT DEFAULT in_buffer;
	DECLARE wcount INT DEFAULT 0;
	DECLARE bcount INT DEFAULT 0;
	SELECT COUNT(*) FROM `lb_writer` INTO wcount;
	SELECT COUNT(*) FROM `lb_book` INTO bcount;
	
	WHILE cur_num_rows < in_num_rows DO
		DROP TEMPORARY TABLE IF EXISTS tmp_wt;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_wt AS
		SELECT wt_id from `lb_writer` wt LEFT JOIN `lb_writer_book` wb ON wb.wb_wt_id=wt.wt_id where wb.wb_wt_id is null order by rand()*wcount LIMIT in_buffer;
		
		DROP TEMPORARY TABLE IF EXISTS tmp_bk;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_bk AS
		SELECT bk_id FROM `lb_book` bk left join `lb_writer_book` wb on wb.wb_bk_id=bk.bk_id where wb.wb_bk_id is null and bk.bk_rd_id is null ORDER BY RAND()*bcount LIMIT in_buffer;
		
		INSERT IGNORE INTO `lb_writer_book` (wb_wt_id, wb_bk_id)
		SELECT wt.wt_id AS wb_wt_id, bk.bk_id AS wb_bk_id FROM tmp_wt wt, tmp_bk bk;
		 
		SELECT COUNT(*) FROM `lb_writer_book` INTO cur_num_rows;
		
		IF in_num_rows - cur_num_rows  < in_buffer THEN
			SET cur_buffer = in_num_rows - cur_num_rows;
		END IF;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_writer_book_add_book` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_writer_book_add_book` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_writer_book_add_book`(in_num_rows INT(11), in_offset INT(11), in_buffer INT(11))
BEGIN	
	DECLARE end_offset INT DEFAULT 0;
	DECLARE bcount INT DEFAULT 0;
	DECLARE rcount INT DEFAULT 0;
	SET end_offset = in_offset + in_num_rows;
	
	SELECT COUNT(*) FROM `lb_book` INTO bcount;
	SELECT COUNT(*) FROM `lb_reader` INTO rcount;
	
	WHILE in_offset < end_offset DO
		DROP TEMPORARY TABLE IF EXISTS tmp;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp AS
		SELECT wt_id as wb_wt_id, FLOOR(RAND()*bcount) as wb_bk_id from `lb_writer` order by wt_id LIMIT in_buffer OFFSET in_offset;
		
		INSERT IGNORE INTO `lb_writer_book` (wb_wt_id, wb_bk_id)
		SELECT * FROM tmp;
		
		UPDATE `lb_book` SET bk_rd_id=FLOOR(RAND()*rcount) WHERE bk_rd_id is null and bk_id IN( 
		SELECT wb_bk_id FROM tmp);
		
		SET in_offset = in_offset + in_buffer;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_fill_writer_book_add_writer` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_fill_writer_book_add_writer` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_fill_writer_book_add_writer`(in_num_rows INT(11), in_offset INT(11), in_buffer INT(11))
BEGIN	
	DECLARE end_offset INT DEFAULT 0;
	DECLARE wcount INT DEFAULT 0;
	DECLARE rcount INT DEFAULT 0;
	SET end_offset = in_offset + in_num_rows;
	
	SELECT COUNT(*) FROM `lb_writer` INTO wcount;
	SELECT COUNT(*) FROM `lb_reader` INTO rcount;
	
	WHILE in_offset < end_offset DO
		DROP TEMPORARY TABLE IF EXISTS tmp;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp AS
		SELECT FLOOR(RAND()*wcount) as wb_wt_id, bk_id as wb_bk_id from `lb_book` order by bk_id LIMIT in_buffer OFFSET in_offset;
		
		INSERT IGNORE INTO `lb_writer_book` (wb_wt_id, wb_bk_id)
		SELECT * FROM tmp;
		
		UPDATE `lb_book` SET bk_rd_id=FLOOR(RAND()*rcount) WHERE bk_rd_id is null and bk_id IN( 
		SELECT wb_bk_id FROM tmp);
		
		SET in_offset = in_offset + in_buffer;
	END WHILE;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_random_book` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_random_book` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_random_book`(in_limit int(11))
BEGIN	
	DECLARE bincrement INT DEFAULT 0;
	DECLARE rcount INT DEFAULT 0;
	SELECT `auto_increment` FROM `information_schema`.`TABLES` WHERE table_schema=DATABASE() AND table_name='lb_book' into bincrement;
	
	IF bincrement < in_limit THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error not enough rows in table';
	END IF;
	
	DROP TEMPORARY TABLE IF EXISTS tmp;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp AS
	SELECT floor(rand()*bincrement) AS bk_rnd_id FROM lb_book LIMIT in_limit;
	
	DROP TEMPORARY TABLE IF EXISTS res;
	CREATE TEMPORARY TABLE IF NOT EXISTS res AS
	SELECT bk.* FROM tmp JOIN `lb_book` bk ON tmp.bk_rnd_id=bk.bk_id;
	
	SELECT COUNT(*) FROM res INTO rcount;
		
	WHILE rcount < in_limit DO
		DROP TEMPORARY TABLE IF EXISTS tmp;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp AS
		SELECT FLOOR(RAND()*bincrement) AS bk_rnd_id FROM lb_book LIMIT in_limit;
	
		INSERT IGNORE INTO res
		SELECT bk.* FROM tmp JOIN `lb_book` bk ON tmp.bk_rnd_id=bk.bk_id;
		
		SELECT COUNT(*) FROM res INTO rcount;
	END WHILE;
	
	SELECT * FROM res LIMIT in_limit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lb_wt_reader_counter` */

/*!50003 DROP PROCEDURE IF EXISTS  `lb_wt_reader_counter` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lb_wt_reader_counter`(in in_bk_id INT(11),in in_act TINYINT(1))
BEGIN
	DECLARE ret INT DEFAULT 0;
	DECLARE done INT DEFAULT FALSE;
	DECLARE writer_id INT DEFAULT NULL;
	DECLARE cur CURSOR FOR SELECT wb_wt_id FROM `lb_writer_book` WHERE wb_bk_id=in_bk_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	OPEN cur;
	
	the_loop: LOOP
		FETCH cur INTO writer_id;
		IF done THEN
			LEAVE the_loop;
		END IF;
		UPDATE `lb_writer` SET wt_reader_counter = wt_reader_counter + in_act WHERE wt_id = writer_id;
	END LOOP the_loop;
	
	CLOSE cur;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
