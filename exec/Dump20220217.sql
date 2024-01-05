-- MySQL dump 10.13  Distrib 8.0.27, for macos11 (x86_64)
--
-- Host: i6a405.p.ssafy.io    Database: fitshare
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cloth`
--

DROP TABLE IF EXISTS `cloth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cloth` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '옷 id',
  `room_participant_id` int NOT NULL,
  `cloth_url` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '옷 이미지 주소',
  `cloth_path` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '옷 구매 사이트 주소',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시간',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_cloth_room_participant1_idx` (`room_participant_id`),
  CONSTRAINT `fk_cloth_room_participant1` FOREIGN KEY (`room_participant_id`) REFERENCES `room_participant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friend`
--

DROP TABLE IF EXISTS `friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '친구관계 id',
  `member_id` int NOT NULL COMMENT '사용자 id',
  `friend_id` int NOT NULL COMMENT '사용자의 친구 id',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_friend_member_idx` (`member_id`),
  KEY `FK_friend_friend_id_member_id_idx` (`friend_id`),
  CONSTRAINT `FK_friend_friend_id_member_id` FOREIGN KEY (`friend_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK_friend_member_id_member_id` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friend_request`
--

DROP TABLE IF EXISTS `friend_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL COMMENT '친구를 요청한 사용자 id',
  `target_member_id` int NOT NULL COMMENT '친구 요청을 받은 사용자 id',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '친구 요청 시간',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_friend_request_member_id_member_id_idx` (`member_id`),
  KEY `FK_friend_request_target_member_id_member_id_idx` (`target_member_id`),
  CONSTRAINT `FK_friend_request_member_id_member_id` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK_friend_request_target_member_id_member_id` FOREIGN KEY (`target_member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '사용자 id',
  `uid` varchar(200) COLLATE utf8_bin NOT NULL COMMENT '카카오 회원번호',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '사용자 이름',
  `email` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '이메일',
  `phone` varchar(15) COLLATE utf8_bin DEFAULT NULL COMMENT '전화번호',
  `profile_img` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '프로필사진',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '계정 활성화여부 (0: 비활성화, 1: 활성화)',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입 시간',
  `updated_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '마지막 수정 시간',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `uid_UNIQUE` (`uid`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `private_chat`
--

DROP TABLE IF EXISTS `private_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_chat` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '채팅 id',
  `sender_id` int NOT NULL COMMENT '발신 사용자 id',
  `receiver_id` int NOT NULL COMMENT '수신 사용자 id',
  `message` text COLLATE utf8_bin NOT NULL COMMENT '메시지',
  `is_checked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '메시지 확인 여부 (0: 읽지 않음, 1: 읽음)',
  `created_time` varchar(25) COLLATE utf8_bin NOT NULL COMMENT '전송 시간',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_private_chat_sender_id_member_id_idx` (`sender_id`),
  KEY `FK_private_chat_receiver_id_member_id_idx` (`receiver_id`),
  CONSTRAINT `FK_private_chat_receiver_id_member_id` FOREIGN KEY (`receiver_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK_private_chat_sender_id_member_id` FOREIGN KEY (`sender_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room_participant`
--

DROP TABLE IF EXISTS `room_participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_participant` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '쇼핑룸 내 참여자별 고유값',
  `member_id` int NOT NULL,
  `shopping_room_id` int NOT NULL COMMENT '쇼핑룸 id',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_room_participant_room_id_shopping_room_id_idx` (`shopping_room_id`),
  KEY `fk_room_participant_member2_idx` (`member_id`),
  CONSTRAINT `fk_room_participant_member2` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK_room_participant_room_id_shopping_room_id` FOREIGN KEY (`shopping_room_id`) REFERENCES `shopping_room` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_mall`
--

DROP TABLE IF EXISTS `shopping_mall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_mall` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '쇼핑몰 id',
  `name` varchar(45) COLLATE utf8_bin NOT NULL COMMENT '쇼핑몰 이름',
  `url` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '쇼핑몰 사이트 주소',
  `logo` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '쇼핑몰 사이트 로고',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성 시간',
  `updated_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '마지막 수정 시간',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_room`
--

DROP TABLE IF EXISTS `shopping_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_room` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '쇼핑룸 id',
  `host_id` int NOT NULL COMMENT '쇼핑룸 생성자 id',
  `is_custom_shopping_mall` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'shopping_mall 테이블의 쇼핑몰 사용여부 (0: shopping_mall_name, shopping_mall_name 에 직접 입력, 1: shopping_mall 테이블에서 선택)',
  `shopping_mall_id` int DEFAULT NULL COMMENT '쇼핑몰 목록에서 선택했을 때 쇼핑몰 사이트 id',
  `shopping_mall_name` varchar(45) COLLATE utf8_bin DEFAULT NULL COMMENT '쇼핑몰 목록에 없는 사이트일 때 사이트 이름',
  `shopping_mall_url` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '쇼핑몰 목록에 없는 사이트일 때 사이트 주소',
  `participant_count` int NOT NULL COMMENT '쇼핑룸 최대 인원수',
  `is_private` tinyint(1) NOT NULL DEFAULT '0' COMMENT '쇼핑룸 비공개 여부 (0: 공개, 1: 비공개)',
  `password` varchar(8) COLLATE utf8_bin DEFAULT NULL COMMENT '비공개 쇼핑룸일 때의 비밀번호',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '쇼핑룸 활성화 여부 (0: 중지, 1: 활성화)',
  `session_id` varchar(200) COLLATE utf8_bin NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_shopping_room_host_id_member_id_idx` (`host_id`),
  KEY `FK_shopping_room_mall_id_shopping_mall_id_idx` (`shopping_mall_id`),
  CONSTRAINT `FK_shopping_room_host_id_member_id` FOREIGN KEY (`host_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK_shopping_room_mall_id_shopping_mall_id` FOREIGN KEY (`shopping_mall_id`) REFERENCES `shopping_mall` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-17 21:35:07
