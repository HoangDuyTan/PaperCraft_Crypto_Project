/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3307
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : localhost:3307
 Source Schema         : papercraft_db

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 11/06/2026 10:01:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `fname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `lname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `nation` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `province_id` int NULL DEFAULT 0,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `postcode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_default` bit(1) NULL DEFAULT b'1',
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `fk_user` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 9, 'Hoang', 'Tan', 'VN', 0, 'hcm', 'Tân Phong, Biên Hòa', '750000', NULL, '0373052604', b'1');
INSERT INTO `address` VALUES (2, 3, 'Hinh', 'Thiết', 'VN', 0, 'hcm', '74, Tan Thanh', '12121', '23130110@st.hcmuaf.edu.vn', '0866501452', b'1');

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `img_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_active` bit(1) NULL DEFAULT b'0',
  `sort_order` int NULL DEFAULT 1000,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, 'main', 'benefit-img.webp', b'1', 1, '2026-06-02 12:27:43', b'0');
INSERT INTO `banner` VALUES (2, 'main', 'login-bg.webp', b'1', 2, '2026-06-07 17:44:33', b'0');
INSERT INTO `banner` VALUES (3, 'main', 'introduce-img.webp', b'1', 3, '2026-06-02 08:41:46', b'0');
INSERT INTO `banner` VALUES (14, 'main', 'banner-printer.jpg', b'0', 4, '2026-06-07 17:44:15', b'0');

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `blog_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `type_blog` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `blog_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `blog_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` binary(1) NULL DEFAULT 0x30,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_blog_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_blog_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES (1, 1, 'Bảo Trì Máy In: 7 Bước Đơn Giản Kéo Dài Tuổi Thọ Thiết Bị', 'Bảo Trì', '<p><strong style=\"line-height: 1.5;\">Bảo trì máy in định kỳ là yếu tố then chốt để đảm bảo thiết bị của bạn hoạt động ổn định, cho ra bản in chất lượng và kéo dài tuổi thọ.</strong></p><p><span style=\"line-height: 1.2;\">Nhiều doanh nghiệp thường bỏ qua việc này, chỉ gọi kỹ thuật khi máy đã hỏng. Điều này không chỉ gây gián đoạn công việc mà còn tốn kém chi phí sửa chữa. Thay vào đó, chỉ với 7 bước đơn giản sau đây, bạn có thể tự mình \"chăm sóc\" chiếc máy in của mình ngay tại văn phòng.</span></p><h2><span style=\"line-height: 1.2;\">1. Vệ sinh bên ngoài thường xuyên</span></h2><p><span style=\"line-height: 1.2;\">Bụi bẩn là kẻ thù số một. Sử dụng một chiếc khăn mềm, ẩm (không ướt) để lau sạch bụi bẩn bám trên vỏ máy, khay giấy và các khe hở. Đừng bao giờ sử dụng cồn hoặc dung môi mạnh vì chúng có thể làm hỏng bề mặt nhựa.</span></p><h2><span style=\"line-height: 1.2;\">2. Dọn dẹp bên trong máy</span></h2><p><span style=\"line-height: 1.2;\">Tắt nguồn và rút phích cắm máy in. Mở nắp máy và cẩn thận lấy hộp mực (cartridge) ra. Sử dụng máy hút bụi mini hoặc bình xịt khí nén để loại bỏ bụi giấy, mực vương vãi và các vật thể lạ (như ghim kẹp) bên trong máy.</span></p><h2><span style=\"line-height: 1.2;\">3. Kiểm tra và làm sạch trục kéo giấy (Roller)</span></h2><p><span style=\"line-height: 1.2;\">Trục kéo giấy bẩn hoặc mòn là nguyên nhân chính gây kẹt giấy. Dùng một miếng vải sạch thấm một chút cồn isopropyl (cồn y tế) để lau nhẹ các con lăn cao su. Điều này giúp phục hồi độ bám và kéo giấy tốt hơn.</span></p><blockquote><em style=\"line-height: 1.2;\">Trích dẫn: \"Một máy in được cập nhật firmware đầy đủ có thể giảm đến 30% nguy cơ lỗi vặt liên quan đến kết nối.\" - Chuyên gia từ PaperCraft.</em></blockquote><h2><span style=\"line-height: 1.2;\">4. Cập nhật Firmware/Driver</span></h2><p><span style=\"line-height: 1.2;\">Các nhà sản xuất (như HP, Canon, Brother) thường xuyên phát hành các bản cập nhật phần mềm (firmware) để sửa lỗi và cải thiện hiệu suất. Hãy truy cập trang web của hãng để tải về và cài đặt phiên bản mới nhất cho máy in của bạn.</span></p><ul><li><span style=\"line-height: 1.2;\">Lỗi kết nối Wi-Fi.</span></li><li><span style=\"line-height: 1.2;\">Vấn đề tương thích với hệ điều hành mới.</span></li><li><span style=\"line-height: 1.2;\">Tối ưu hóa tốc độ in.</span></li></ul><h2><span style=\"line-height: 1.2;\">5. Sử dụng mực và giấy chính hãng</span></h2><p><span style=\"line-height: 1.2;\">Đây là điều chúng tôi không thể không nhấn mạnh. Sử dụng mực in giả, kém chất lượng có thể làm hỏng đầu phun và các bộ phận bên trong. Giấy quá mỏng hoặc quá dày (không đúng khuyến cáo) cũng dễ gây kẹt giấy.</span></p>', '2025-12-30 06:10:07', 'Hướng dẫn chi tiết cách bảo trì máy in định kỳ để đảm bảo máy hoạt động tốt và bền bỉ theo thời gian.', 0x31);
INSERT INTO `blog` VALUES (2, 2, 'ọabfkjabfjkfka', 'Văn Phòng Phẩm', '<p>ửteryeryeryerye</p>', '2026-03-25 12:45:10', 'jiolkwhtoiwhto', 0x30);
INSERT INTO `blog` VALUES (3, 2, 'Hòa', 'Máy In', '<p>4</p>\r\n\r\n<p>&nbsp;</p>\r\n', '2026-04-19 08:10:59', 'llm', 0x30);
INSERT INTO `blog` VALUES (9, 1, 'dsfsfd', 'Máy In', '<p><strong>dsfsf</strong></p>\r\n', '2026-04-19 12:54:46', 'sdfsdfs', 0x30);
INSERT INTO `blog` VALUES (10, 3, 'hgbhbh', 'Văn Phòng Phẩm', '<p>ugyugug</p>\r\n', '2026-06-01 09:23:50', 'jbjbj', 0x30);

-- ----------------------------
-- Table structure for cart_item
-- ----------------------------
DROP TABLE IF EXISTS `cart_item`;
CREATE TABLE `cart_item`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_user_product`(`user_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `fk_cart_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_item
-- ----------------------------
INSERT INTO `cart_item` VALUES (16, 3, 56, 1, '2026-06-01 10:17:57', '2026-06-01 10:18:33');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, 'Máy In Laser', 'Printer');
INSERT INTO `category` VALUES (2, 'Máy In Phun', 'Printer');
INSERT INTO `category` VALUES (3, 'Máy In Đa Năng', 'Printer');
INSERT INTO `category` VALUES (4, 'Máy In Kim', 'Printer');
INSERT INTO `category` VALUES (5, 'Giấy & Bìa', 'Stationery');
INSERT INTO `category` VALUES (6, 'Bút & Dụng cụ viết', 'Stationery');
INSERT INTO `category` VALUES (7, 'Sổ tay & Tập vở', 'Stationery');
INSERT INTO `category` VALUES (8, 'File và Bìa Hồ sơ', 'Stationery');
INSERT INTO `category` VALUES (9, 'Dụng cụ văn phòng', 'Stationery');
INSERT INTO `category` VALUES (10, 'Máy scan', 'Stationery');
INSERT INTO `category` VALUES (11, 'Máy photocopy', 'Stationery');
INSERT INTO `category` VALUES (12, 'Máy hủy tài liệu', 'Stationery');
INSERT INTO `category` VALUES (13, 'Bút trình chiếu', 'Stationery');

-- ----------------------------
-- Table structure for contact
-- ----------------------------
DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `user_fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `contact_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `rely` bit(1) NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_contact_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_contact_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contact
-- ----------------------------
INSERT INTO `contact` VALUES (1, NULL, 'Hoang', 'hoangtan130405@gmail.com', 'llll', '61515', b'0', '2026-01-26 08:00:32');
INSERT INTO `contact` VALUES (2, 3, 'Hinh Nguyễn Thiết', '23130110@st.hcmuaf.edu.vn', 'máy in hỏng', 'sddsf', b'1', '2026-06-01 18:31:58');
INSERT INTO `contact` VALUES (3, 3, 'Hinh Nguyễn Thiết', '23130110@st.hcmuaf.edu.vn', 'máy in hỏng', 'dfasdfdsafv', b'1', '2026-06-01 18:41:21');

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int NULL DEFAULT NULL,
  `entity_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `img_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `is_thumbnail` bit(1) NULL DEFAULT b'0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2289 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of image
-- ----------------------------
INSERT INTO `image` VALUES (1, 1, 'Product', 'may-in-phun-mau-hp-smart-tank-215-3d4l4a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (2, 1, 'Product', 'may-in-phun-mau-hp-smart-tank-215-3d4l4a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (3, 1, 'Product', 'may-in-phun-mau-hp-smart-tank-215-3d4l4a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (4, 1, 'Product', 'may-in-phun-mau-hp-smart-tank-215-3d4l4a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (5, 1, 'Product', 'may-in-phun-mau-hp-smart-tank-215-3d4l4a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (6, 2, 'Product', 'may-in-laser-den-trang-lexmark-ms431dn-29s0080-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (7, 2, 'Product', 'may-in-laser-den-trang-lexmark-ms431dn-29s0080-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (8, 2, 'Product', 'may-in-laser-den-trang-lexmark-ms431dn-29s0080-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (9, 2, 'Product', 'may-in-laser-den-trang-lexmark-ms431dn-29s0080-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (10, 2, 'Product', 'may-in-laser-den-trang-lexmark-ms431dn-29s0080-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (11, 3, 'Product', 'may-in-laser-den-trang-lexmark-b2236dw-18m0136-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (12, 3, 'Product', 'may-in-laser-den-trang-lexmark-b2236dw-18m0136-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (13, 3, 'Product', 'may-in-laser-den-trang-lexmark-b2236dw-18m0136-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (14, 3, 'Product', 'may-in-laser-den-trang-lexmark-b2236dw-18m0136-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (15, 4, 'Product', 'may-in-laser-trang-den-canon-lbp6030b-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (16, 4, 'Product', 'may-in-laser-trang-den-canon-lbp6030b-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (17, 4, 'Product', 'may-in-laser-trang-den-canon-lbp6030b-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (18, 4, 'Product', 'may-in-laser-trang-den-canon-lbp6030b-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (19, 4, 'Product', 'may-in-laser-trang-den-canon-lbp6030b-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (20, 5, 'Product', 'may-in-hp-laser-108a-4zb79a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (21, 5, 'Product', 'may-in-hp-laser-108a-4zb79a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (22, 5, 'Product', 'may-in-hp-laser-108a-4zb79a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (23, 5, 'Product', 'may-in-hp-laser-108a-4zb79a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (24, 5, 'Product', 'may-in-hp-laser-108a-4zb79a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (25, 6, 'Product', 'may-in-mau-don-nang-brother-hl-l3280cdw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (26, 6, 'Product', 'may-in-mau-don-nang-brother-hl-l3280cdw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (27, 6, 'Product', 'may-in-mau-don-nang-brother-hl-l3280cdw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (28, 7, 'Product', 'may-in-mau-don-nang-brother-hl-l3240cdw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (29, 7, 'Product', 'may-in-mau-don-nang-brother-hl-l3240cdw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (30, 7, 'Product', 'may-in-mau-don-nang-brother-hl-l3240cdw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (31, 8, 'Product', 'may-in-phun-mau-epson-l1216-std-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (32, 8, 'Product', 'may-in-phun-mau-epson-l1216-std-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (33, 9, 'Product', 'may-in-hp-laserjet-tank-1502w-2r3e2a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (34, 9, 'Product', 'may-in-hp-laserjet-tank-1502w-2r3e2a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (35, 9, 'Product', 'may-in-hp-laserjet-tank-1502w-2r3e2a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (36, 9, 'Product', 'may-in-hp-laserjet-tank-1502w-2r3e2a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (37, 9, 'Product', 'may-in-hp-laserjet-tank-1502w-2r3e2a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (38, 9, 'Product', 'may-in-hp-laser-108w-4zb80a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (39, 10, 'Product', 'may-in-hp-laser-108w-4zb80a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (40, 10, 'Product', 'may-in-hp-laser-108w-4zb80a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (41, 11, 'Product', 'may-in-laser-trang-den-canon-lbp122dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (42, 11, 'Product', 'may-in-laser-trang-den-canon-lbp122dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (43, 11, 'Product', 'may-in-laser-trang-den-canon-lbp122dw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (44, 11, 'Product', 'may-in-laser-trang-den-canon-lbp122dw-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (45, 12, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2180dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (46, 12, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2180dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (47, 12, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2180dw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (48, 13, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2100d-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (49, 13, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2100d-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (50, 13, 'Product', 'may-in-trang-den-don-nang-brother-hl-b2100d-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (51, 14, 'Product', 'may-in-phun-mau-canon-g1730-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (52, 14, 'Product', 'may-in-phun-mau-canon-g1730-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (53, 15, 'Product', 'may-in-hp-smart-tank-210-3d4l3a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (54, 15, 'Product', 'may-in-hp-smart-tank-210-3d4l3a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (55, 15, 'Product', 'may-in-hp-smart-tank-210-3d4l3a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (56, 15, 'Product', 'may-in-hp-smart-tank-210-3d4l3a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (57, 15, 'Product', 'may-in-hp-smart-tank-210-3d4l3a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (58, 16, 'Product', 'may-in-phun-mau-epson-l18050-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (59, 16, 'Product', 'may-in-phun-mau-epson-l18050-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (60, 16, 'Product', 'may-in-phun-mau-epson-l18050-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (61, 17, 'Product', 'may-in-phun-mau-wifi-epson-l8050-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (62, 17, 'Product', 'may-in-phun-mau-wifi-epson-l8050-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (63, 17, 'Product', 'may-in-phun-mau-wifi-epson-l8050-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (64, 18, 'Product', 'may-in-mau-epson-l121-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (65, 18, 'Product', 'may-in-mau-epson-l121-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (66, 18, 'Product', 'may-in-mau-epson-l121-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (67, 19, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdn-499m7a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (68, 19, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdn-499m7a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (69, 19, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdn-499m7a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (70, 19, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdn-499m7a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (71, 19, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdn-499m7a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (72, 20, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t530dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (73, 20, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t530dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (74, 20, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t530dw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (75, 21, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t830dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (76, 21, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t830dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (77, 21, 'Product', 'may-in-phun-da-chuc-nang-brother-dcp-t830dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (78, 22, 'Product', 'may-in-phun-mau-da-nang-hp-officejet-pro-9730-537p5c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (79, 22, 'Product', 'may-in-phun-mau-da-nang-hp-officejet-pro-9730-537p5c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (80, 22, 'Product', 'may-in-phun-mau-da-nang-hp-officejet-pro-9730-537p5c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (81, 22, 'Product', 'may-in-phun-mau-da-nang-hp-officejet-pro-9730-537p5c-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (82, 22, 'Product', 'may-in-phun-mau-da-nang-hp-officejet-pro-9730-537p5c-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (83, 23, 'Product', 'may-in-hp-laser-mfp-136w-4zb86a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (84, 23, 'Product', 'may-in-hp-laser-mfp-136w-4zb86a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (85, 23, 'Product', 'may-in-hp-laser-mfp-136w-4zb86a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (86, 24, 'Product', 'may-in-phun-mau-da-nang-canon-e410-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (87, 24, 'Product', 'may-in-phun-mau-da-nang-canon-e410-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (88, 24, 'Product', 'may-in-phun-mau-da-nang-canon-e410-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (89, 25, 'Product', 'may-in-hp-laser-mfp-139fnw-a0nu1a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (90, 26, 'Product', 'may-in-mau-da-chuc-nang-brother-dcp-l3560cdw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (91, 26, 'Product', 'may-in-mau-da-chuc-nang-brother-dcp-l3560cdw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (92, 26, 'Product', 'may-in-mau-da-chuc-nang-brother-dcp-l3560cdw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (93, 27, 'Product', 'may-in-laser-trang-den-da-nang-canon-mf272dn-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (94, 27, 'Product', 'may-in-laser-trang-den-da-nang-canon-mf272dn-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (95, 27, 'Product', 'may-in-laser-trang-den-da-nang-canon-mf272dn-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (96, 27, 'Product', 'may-in-laser-trang-den-da-nang-canon-mf272dn-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (97, 28, 'Product', 'may-in-laser-da-nang-canon-mf-275dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (98, 29, 'Product', 'may-in-phun-mau-epson-l6270-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (99, 29, 'Product', 'may-in-phun-mau-epson-l6270-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (100, 29, 'Product', 'may-in-phun-mau-epson-l6270-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (101, 29, 'Product', 'may-in-phun-mau-epson-l6270-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (102, 29, 'Product', 'may-in-phun-mau-epson-l6270-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (103, 30, 'Product', 'may-in-hp-laserjet-m440dn-8af47a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (104, 30, 'Product', 'may-in-hp-laserjet-m440dn-8af47a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (105, 30, 'Product', 'may-in-hp-laserjet-m440dn-8af47a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (106, 30, 'Product', 'may-in-hp-laserjet-m440dn-8af47a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (107, 30, 'Product', 'may-in-hp-laserjet-m440dn-8af47a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (108, 31, 'Product', 'may-in-epson-l3250-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (109, 31, 'Product', 'may-in-epson-l3250-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (110, 31, 'Product', 'may-in-epson-l3250-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (111, 32, 'Product', 'may-in-phun-mau-da-nang-epson-l3216-std-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (112, 32, 'Product', 'may-in-phun-mau-da-nang-epson-l3216-std-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (113, 32, 'Product', 'may-in-phun-mau-da-nang-epson-l3216-std-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (114, 33, 'Product', 'may-in-phun-trang-den-da-nang-epson-m2170-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (115, 33, 'Product', 'may-in-phun-trang-den-da-nang-epson-m2170-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (116, 34, 'Product', 'may-in-phun-da-nang-mau-canon-gx4070-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (117, 34, 'Product', 'may-in-phun-da-nang-mau-canon-gx4070-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (118, 34, 'Product', 'may-in-phun-da-nang-mau-canon-gx4070-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (119, 34, 'Product', 'may-in-phun-da-nang-mau-canon-gx4070-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (120, 35, 'Product', 'may-in-phun-da-nang-mau-canon-gx3070-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (121, 35, 'Product', 'may-in-phun-da-nang-mau-canon-gx3070-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (122, 35, 'Product', 'may-in-phun-da-nang-mau-canon-gx3070-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (123, 36, 'Product', 'may-in-epson-l850-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (124, 36, 'Product', 'may-in-epson-l850-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (125, 36, 'Product', 'may-in-epson-l850-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (126, 36, 'Product', 'may-in-epson-l850-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (127, 37, 'Product', 'may-in-epson-lq-2190-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (128, 38, 'Product', 'may-in-epson-lq-310-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (129, 38, 'Product', 'may-in-epson-lq-310-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (130, 38, 'Product', 'may-in-epson-lq-310-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (131, 39, 'Product', 'may-in-kim-epson-lq-780-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (132, 39, 'Product', 'may-in-kim-epson-lq-780-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (133, 39, 'Product', 'may-in-kim-epson-lq-780-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (134, 39, 'Product', 'may-in-kim-epson-lq-780-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (135, 39, 'Product', 'may-in-kim-epson-lq-780-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (136, 40, 'Product', 'may-in-epson-lq-680-pro-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (137, 40, 'Product', 'may-in-epson-lq-680-pro-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (138, 41, 'Product', 'may-in-kim-epson-lq350-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (139, 41, 'Product', 'may-in-kim-epson-lq350-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (140, 41, 'Product', 'may-in-kim-epson-lq350-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (141, 42, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdw-1y-wty-499m8a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (142, 42, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdw-1y-wty-499m8a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (143, 42, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdw-1y-wty-499m8a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (144, 42, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdw-1y-wty-499m8a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (145, 42, 'Product', 'may-in-mau-da-chuc-nang-hp-color-laserjet-pro-mfp-3303fdw-1y-wty-499m8a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (146, 43, 'Product', 'may-in-epson-l5290-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (147, 43, 'Product', 'may-in-epson-l5290-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (148, 43, 'Product', 'may-in-epson-l5290-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (149, 43, 'Product', 'may-in-epson-l5290-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (150, 44, 'Product', 'may-in-canon-1643i-da-nang-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (151, 44, 'Product', 'may-in-canon-1643i-da-nang-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (152, 44, 'Product', 'may-in-canon-1643i-da-nang-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (153, 45, 'Product', 'may-in-epson-ecotank-m15140-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (154, 45, 'Product', 'may-in-epson-ecotank-m15140-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (155, 45, 'Product', 'may-in-epson-ecotank-m15140-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (156, 46, 'Product', 'may-in-epson-m3170-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (157, 46, 'Product', 'may-in-epson-m3170-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (158, 47, 'Product', 'may-in-da-chuc-nang-hp-laserjet-m440n-mfp-1y-wty-8af46a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (159, 47, 'Product', 'may-in-da-chuc-nang-hp-laserjet-m440n-mfp-1y-wty-8af46a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (160, 47, 'Product', 'may-in-da-chuc-nang-hp-laserjet-m440n-mfp-1y-wty-8af46a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (161, 47, 'Product', 'may-in-da-chuc-nang-hp-laserjet-m440n-mfp-1y-wty-8af46a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (162, 47, 'Product', 'may-in-da-chuc-nang-hp-laserjet-m440n-mfp-1y-wty-8af46a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (163, 48, 'Product', 'may-in-mau-laser-da-chuc-nang-brother-mfc-l8340cdw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (164, 48, 'Product', 'may-in-mau-laser-da-chuc-nang-brother-mfc-l8340cdw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (165, 48, 'Product', 'may-in-mau-laser-da-chuc-nang-brother-mfc-l8340cdw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (166, 49, 'Product', 'may-in-laser-mau-hp-color-laserjet-pro-m283fdw-7kw75a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (167, 49, 'Product', 'may-in-laser-mau-hp-color-laserjet-pro-m283fdw-7kw75a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (168, 49, 'Product', 'may-in-laser-mau-hp-color-laserjet-pro-m283fdw-7kw75a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (169, 49, 'Product', 'may-in-laser-mau-hp-color-laserjet-pro-m283fdw-7kw75a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (170, 50, 'Product', 'may-in-epson-l15150-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (171, 50, 'Product', 'may-in-epson-l15150-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (172, 50, 'Product', 'may-in-epson-l15150-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (173, 50, 'Product', 'may-in-epson-l15150-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (174, 51, 'Product', 'may-in-hp-laserjet-pro-mfp-4103fdw-2z629a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (175, 51, 'Product', 'may-in-hp-laserjet-pro-mfp-4103fdw-2z629a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (176, 51, 'Product', 'may-in-hp-laserjet-pro-mfp-4103fdw-2z629a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (177, 52, 'Product', 'may-in-da-nang-canon-ir2224n-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (178, 52, 'Product', 'may-in-da-nang-canon-ir2224n-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (179, 52, 'Product', 'may-in-da-nang-canon-ir2224n-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (180, 52, 'Product', 'may-in-da-nang-canon-ir2224n-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (181, 53, 'Product', 'may-in-da-nang-canon-ir1643i-ii-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (182, 53, 'Product', 'may-in-da-nang-canon-ir1643i-ii-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (183, 53, 'Product', 'may-in-da-nang-canon-ir1643i-ii-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (184, 54, 'Product', 'may-in-phun-mau-da-chuc-nang-epson-am-c5000-c11cj42502-thummb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (185, 54, 'Product', 'may-in-phun-mau-da-chuc-nang-epson-am-c5000-c11cj42502-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (186, 54, 'Product', 'may-in-phun-mau-da-chuc-nang-epson-am-c5000-c11cj42502-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (187, 55, 'Product', 'may-in-hp-laserjet-m507dn-1pv87a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (188, 55, 'Product', 'may-in-hp-laserjet-m507dn-1pv87a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (189, 55, 'Product', 'may-in-hp-laserjet-m507dn-1pv87a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (190, 55, 'Product', 'may-in-hp-laserjet-m507dn-1pv87a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (191, 56, 'Product', 'may-in-laser-canon-lbp243dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (192, 56, 'Product', 'may-in-laser-canon-lbp243dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (193, 56, 'Product', 'may-in-laser-canon-lbp243dw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (194, 56, 'Product', 'may-in-laser-canon-lbp243dw-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (195, 56, 'Product', 'may-in-laser-canon-lbp243dw-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (196, 57, 'Product', 'may-in-laser-trang-den-canon-lbp-121dn-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (197, 57, 'Product', 'may-in-laser-trang-den-canon-lbp-121dn-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (198, 57, 'Product', 'may-in-laser-trang-den-canon-lbp-121dn-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (199, 57, 'Product', 'may-in-laser-trang-den-canon-lbp-121dn-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (200, 58, 'Product', 'may-in-hp-laserjet-m712dn-cf236a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (201, 58, 'Product', 'may-in-hp-laserjet-m712dn-cf236a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (202, 58, 'Product', 'may-in-hp-laserjet-m712dn-cf236a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (203, 58, 'Product', 'may-in-hp-laserjet-m712dn-cf236a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (204, 59, 'Product', 'may-in-epson-m1120-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (205, 59, 'Product', 'may-in-epson-m1120-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (206, 59, 'Product', 'may-in-epson-m1120-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (207, 59, 'Product', 'may-in-epson-m1120-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (208, 60, 'Product', 'may-in-phun-mau-canon-pixma-g570-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (209, 60, 'Product', 'may-in-phun-mau-canon-pixma-g570-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (210, 60, 'Product', 'may-in-phun-mau-canon-pixma-g570-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (211, 61, 'Product', 'may-in-hp-laserjet-m454dw-w1y45a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (212, 61, 'Product', 'may-in-hp-laserjet-m454dw-w1y45a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (213, 61, 'Product', 'may-in-hp-laserjet-m454dw-w1y45a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (214, 61, 'Product', 'may-in-hp-laserjet-m454dw-w1y45a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (215, 61, 'Product', 'may-in-hp-laserjet-m454dw-w1y45a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (216, 62, 'Product', 'may-in-laser-hp-m255nw-7kw63a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (217, 62, 'Product', 'may-in-laser-hp-m255nw-7kw63a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (218, 62, 'Product', 'may-in-laser-hp-m255nw-7kw63a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (219, 63, 'Product', 'may-in-hp-color-laserjet-pro-m255dw-7kw64a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (220, 63, 'Product', 'may-in-hp-color-laserjet-pro-m255dw-7kw64a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (221, 63, 'Product', 'may-in-hp-color-laserjet-pro-m255dw-7kw64a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (222, 63, 'Product', 'may-in-hp-color-laserjet-pro-m255dw-7kw64a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (223, 63, 'Product', 'may-in-hp-color-laserjet-pro-m255dw-7kw64a-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (224, 64, 'Product', 'may-in-brother-hl-l2361dn-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (225, 64, 'Product', 'may-in-brother-hl-l2361dn-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (226, 64, 'Product', 'may-in-brother-hl-l2361dn-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (227, 65, 'Product', 'may-in-phun-da-nang-mau-canon-g3770-do-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (228, 65, 'Product', 'may-in-phun-da-nang-mau-canon-g3770-do-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (229, 66, 'Product', 'may-in-phun-da-nang-mau-canon-g3770-den-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (230, 67, 'Product', 'may-in-brother-dcp-b7535dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (231, 67, 'Product', 'may-in-brother-dcp-b7535dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (232, 68, 'Product', 'may-in-phun-mau-da-nang-brother-dcp-t420w-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (233, 68, 'Product', 'may-in-phun-mau-da-nang-brother-dcp-t420w-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (234, 68, 'Product', 'may-in-phun-mau-da-nang-brother-dcp-t420w-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (235, 69, 'Product', 'may-in-phun-da-chuc-nang-brother-mfc-t930dw-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (236, 69, 'Product', 'may-in-phun-da-chuc-nang-brother-mfc-t930dw-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (237, 69, 'Product', 'may-in-phun-da-chuc-nang-brother-mfc-t930dw-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (238, 70, 'Product', 'may-in-hp-smart-tank-670-all-in-one-6uu48a-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (239, 70, 'Product', 'may-in-hp-smart-tank-670-all-in-one-6uu48a-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (240, 70, 'Product', 'may-in-hp-smart-tank-670-all-in-one-6uu48a-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (241, 70, 'Product', 'may-in-hp-smart-tank-670-all-in-one-6uu48a-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (242, 71, 'product', 'but_long_dau_Thien_Long_PM-04-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (243, 71, 'product', 'but-long-dau-thien-long-pm-04-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (244, 71, 'product', 'but-long-dau-thien-long-pm-04-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (245, 71, 'product', 'but-long-dau-thien-long-pm-04-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (246, 72, 'product', 'combo-but-long-dau-flexoffice-flex-marker-fo-pm06-xk-hang-xuat-khau-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (247, 72, 'product', 'combo-but-long-dau-flexoffice-flex-marker-fo-pm06-xk-hang-xuat-khau-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (248, 72, 'product', 'combo-but-long-dau-flexoffice-flex-marker-fo-pm06-xk-hang-xuat-khau-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (249, 72, 'product', 'combo-but-long-dau-flexoffice-flex-marker-fo-pm06-xk-hang-xuat-khau-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (250, 73, 'product', 'but-long-bi-cao-cap-parker-ingenuity-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (251, 73, 'product', 'but-long-bi-cao-cap-parker-ingenuity-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (252, 74, 'product', 'but-cao-cap-parker-51-collection-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (253, 74, 'product', 'but-cao-cap-parker-51-collection-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (254, 74, 'product', 'but-cao-cap-parker-51-collection-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (255, 74, 'product', 'but-cao-cap-parker-51-collection-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (256, 75, 'product', 'but-cao-cap-parker-im-writing-rituals-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (257, 75, 'product', 'but-cao-cap-parker-im-writing-rituals-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (258, 75, 'product', 'but-cao-cap-parker-im-writing-rituals-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (259, 76, 'product', 'but-cao-cap-parker-im-writing-rituals-grey-ct-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (260, 76, 'product', 'but-cao-cap-parker-im-writing-rituals-grey-ct-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (261, 76, 'product', 'but-cao-cap-parker-im-writing-rituals-grey-ct-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (262, 77, 'product', 'but-cao-cap-parker-im-monochrome-chmpgn-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (263, 77, 'product', 'but-cao-cap-parker-im-monochrome-chmpgn-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (264, 77, 'product', 'but-cao-cap-parker-im-monochrome-chmpgn-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (265, 78, 'product', 'but-cao-cap-parker-im-monochrome-brgndy-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (266, 78, 'product', 'but-cao-cap-parker-im-monochrome-brgndy-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (267, 78, 'product', 'but-cao-cap-parker-im-monochrome-brgndy-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (268, 79, 'product', 'but-cao-cap-parker-im-monochrome-ttnm-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (269, 79, 'product', 'but-cao-cap-parker-im-monochrome-ttnm-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (270, 79, 'product', 'but-cao-cap-parker-im-monochrome-ttnm-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (271, 80, 'product', 'but-cao-cap-parker-im-monochrome-blue-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (272, 80, 'product', 'but-cao-cap-parker-im-monochrome-blue-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (273, 80, 'product', 'but-cao-cap-parker-im-monochrome-blue-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (274, 81, 'product', 'but-chi-khuc-thien-long-diem-10-tp-pc005-loi-chac-chan-net-dam-it-bot-chi-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (275, 81, 'product', 'but-chi-khuc-thien-long-diem-10-tp-pc005-loi-chac-chan-net-dam-it-bot-chi-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (276, 81, 'product', 'but-chi-khuc-thien-long-diem-10-tp-pc005-loi-chac-chan-net-dam-it-bot-chi-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (277, 82, 'product', 'but-chi-go-2b-thien-long-gp-027-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (278, 82, 'product', 'but-chi-go-2b-thien-long-gp-027-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (279, 82, 'product', 'but-chi-go-2b-thien-long-gp-027-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (280, 82, 'product', 'but-chi-go-2b-thien-long-gp-027-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (281, 83, 'product', 'but-chi-go-thien-long-gp-01-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (282, 83, 'product', 'but-chi-go-thien-long-gp-01-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (283, 83, 'product', 'but-chi-go-thien-long-gp-01-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (284, 83, 'product', 'but-chi-go-thien-long-gp-01-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (285, 84, 'product', 'but-chi-go-nhan-vat-akooland-thien-long-tp-gp021-ak-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (286, 84, 'product', 'but-chi-go-nhan-vat-akooland-thien-long-tp-gp021-ak-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (287, 84, 'product', 'but-chi-go-nhan-vat-akooland-thien-long-tp-gp021-ak-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (288, 84, 'product', 'but-chi-go-nhan-vat-akooland-thien-long-tp-gp021-ak-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (289, 85, 'product', 'but-chi-go-hb-diem-10-tp-gp05-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (290, 85, 'product', 'but-chi-go-hb-diem-10-tp-gp05-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (291, 85, 'product', 'but-chi-go-hb-diem-10-tp-gp05-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (292, 85, 'product', 'but-chi-go-hb-diem-10-tp-gp05-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (293, 86, 'product', 'but-chi-bam-thien-long-pc-029-tich-hop-chuot-chi-tren-than-but-mau-than-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (294, 86, 'product', 'but-chi-bam-thien-long-pc-029-tich-hop-chuot-chi-tren-than-but-mau-than-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (295, 86, 'product', 'but-chi-bam-thien-long-pc-029-tich-hop-chuot-chi-tren-than-but-mau-than-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (296, 86, 'product', 'but-chi-bam-thien-long-pc-029-tich-hop-chuot-chi-tren-than-but-mau-than-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (297, 87, 'product', 'but-chi-khuc-thien-long-pc-09-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (298, 87, 'product', 'but-chi-khuc-thien-long-pc-09-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (299, 87, 'product', 'but-chi-khuc-thien-long-pc-09-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (300, 87, 'product', 'but-chi-khuc-thien-long-pc-09-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (301, 88, 'product', 'but-chi-go-thien-long-diem-10-2b-tp-gp009-do-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (302, 88, 'product', 'but-chi-go-thien-long-diem-10-2b-tp-gp009-do-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (303, 88, 'product', 'but-chi-go-thien-long-diem-10-2b-tp-gp009-do-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (304, 88, 'product', 'but-chi-go-thien-long-diem-10-2b-tp-gp009-do-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (305, 89, 'product', 'but-chi-bam-thien-long-pc-01-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (306, 89, 'product', 'but-chi-bam-thien-long-pc-01-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (307, 89, 'product', 'but-chi-bam-thien-long-pc-01-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (308, 89, 'product', 'but-chi-bam-thien-long-pc-01-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (309, 90, 'product', 'combo-10-but-chi-go-den-nhan-vat-demon-slayer-thien-long-gp-030-ds-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (310, 90, 'product', 'combo-10-but-chi-go-den-nhan-vat-demon-slayer-thien-long-gp-030-ds-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (311, 90, 'product', 'combo-10-but-chi-go-den-nhan-vat-demon-slayer-thien-long-gp-030-ds-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (312, 90, 'product', 'combo-10-but-chi-go-den-nhan-vat-demon-slayer-thien-long-gp-030-ds-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (313, 91, 'product', 'bia-hop-flexoffice-pp-150-a4-fo-bf05-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (314, 91, 'product', 'bia-hop-flexoffice-pp-150-a4-fo-bf05-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (315, 91, 'product', 'bia-hop-flexoffice-pp-150-a4-fo-bf05-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (316, 91, 'product', 'bia-hop-flexoffice-pp-150-a4-fo-bf05-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (317, 92, 'product', 'bia-nut-a5-thien-long-flexoffice-fo-cbf06-trong-suot-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (318, 92, 'product', 'bia-nut-a5-thien-long-flexoffice-fo-cbf06-trong-suot-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (319, 92, 'product', 'bia-nut-a5-thien-long-flexoffice-fo-cbf06-trong-suot-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (320, 92, 'product', 'bia-nut-a5-thien-long-flexoffice-fo-cbf06-trong-suot-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (321, 93, 'product', 'bia-la-thien-long-f4-e355-fs-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (322, 93, 'product', 'bia-la-thien-long-f4-e355-fs-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (323, 93, 'product', 'bia-la-thien-long-f4-e355-fs-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (324, 93, 'product', 'bia-la-thien-long-f4-e355-fs-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (325, 94, 'product', 'bia-la-a4-thien-long-flexoffice-fo-ch168-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (326, 94, 'product', 'bia-la-a4-thien-long-flexoffice-fo-ch168-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (327, 94, 'product', 'bia-la-a4-thien-long-flexoffice-fo-ch168-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (328, 94, 'product', 'bia-la-a4-thien-long-flexoffice-fo-ch168-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (329, 95, 'product', 'bia-nut-mau-pastel-f4-thien-long-cbf-003-suc-chua-125-to-a4-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (330, 95, 'product', 'bia-nut-mau-pastel-f4-thien-long-cbf-003-suc-chua-125-to-a4-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (331, 95, 'product', 'bia-nut-mau-pastel-f4-thien-long-cbf-003-suc-chua-125-to-a4-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (332, 95, 'product', 'bia-nut-mau-pastel-f4-thien-long-cbf-003-suc-chua-125-to-a4-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (333, 96, 'product', 'bia-acco-a4-thien-long-flexoffice-fo-ppffa4-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (334, 96, 'product', 'bia-acco-a4-thien-long-flexoffice-fo-ppffa4-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (335, 96, 'product', 'bia-acco-a4-thien-long-flexoffice-fo-ppffa4-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (336, 96, 'product', 'bia-acco-a4-thien-long-flexoffice-fo-ppffa4-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (337, 97, 'product', 'bia-trinh-ky-a5-thien-long-flexoffice-pp-fo-cb012-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (338, 97, 'product', 'bia-trinh-ky-a5-thien-long-flexoffice-pp-fo-cb012-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (339, 97, 'product', 'bia-trinh-ky-a5-thien-long-flexoffice-pp-fo-cb012-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (340, 97, 'product', 'bia-trinh-ky-a5-thien-long-flexoffice-pp-fo-cb012-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (341, 98, 'product', 'bia-nhan-2-oring-30-flexoffice-fo-orb02-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (342, 98, 'product', 'bia-nhan-2-oring-30-flexoffice-fo-orb02-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (343, 98, 'product', 'bia-nhan-2-oring-30-flexoffice-fo-orb02-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (344, 98, 'product', 'bia-nhan-2-oring-30-flexoffice-fo-orb02-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (345, 99, 'product', 'bia-trinh-ky-kep-mau-pastel-nhua-pp-thien-long-flexoffice-fo-cb03-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (346, 99, 'product', 'bia-trinh-ky-kep-mau-pastel-nhua-pp-thien-long-flexoffice-fo-cb03-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (347, 99, 'product', 'bia-trinh-ky-kep-mau-pastel-nhua-pp-thien-long-flexoffice-fo-cb03-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (348, 99, 'product', 'bia-trinh-ky-kep-mau-pastel-nhua-pp-thien-long-flexoffice-fo-cb03-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (349, 100, 'product', 'bia-cong-flexoffice-50f4-fo-bc13-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (350, 100, 'product', 'bia-cong-flexoffice-50f4-fo-bc13-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (351, 100, 'product', 'bia-cong-flexoffice-50f4-fo-bc13-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (352, 100, 'product', 'bia-cong-flexoffice-50f4-fo-bc13-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (353, 101, 'product', 'giay-ghi-chu-giay-notes-neon-thien-long-nhieu-kich-thuoc-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (354, 101, 'product', 'giay-ghi-chu-giay-notes-neon-thien-long-nhieu-kich-thuoc-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (355, 101, 'product', 'giay-ghi-chu-giay-notes-neon-thien-long-nhieu-kich-thuoc-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (356, 101, 'product', 'giay-ghi-chu-giay-notes-neon-thien-long-nhieu-kich-thuoc-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (357, 102, 'product', 'giay-thu-cong-colokit-gtc-c002-12-mau-kho-vua-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (358, 102, 'product', 'giay-thu-cong-colokit-gtc-c002-12-mau-kho-vua-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (359, 102, 'product', 'giay-thu-cong-colokit-gtc-c002-12-mau-kho-vua-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (360, 102, 'product', 'giay-thu-cong-colokit-gtc-c002-12-mau-kho-vua-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (361, 103, 'product', 'giay-kiem-tra-diem-10-tp-gkt011-5-oly-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (362, 103, 'product', 'giay-kiem-tra-diem-10-tp-gkt011-5-oly-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (363, 103, 'product', 'giay-kiem-tra-diem-10-tp-gkt011-5-oly-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (364, 103, 'product', 'giay-kiem-tra-diem-10-tp-gkt011-5-oly-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (365, 104, 'product', 'tui-20-to-doi-giay-kiem-tra-100gsm-thien-long-diem-10-tp-gkt012-4-oly-vuong-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (366, 104, 'product', 'tui-20-to-doi-giay-kiem-tra-100gsm-thien-long-diem-10-tp-gkt012-4-oly-vuong-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (367, 104, 'product', 'tui-20-to-doi-giay-kiem-tra-100gsm-thien-long-diem-10-tp-gkt012-4-oly-vuong-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (368, 104, 'product', 'tui-20-to-doi-giay-kiem-tra-100gsm-thien-long-diem-10-tp-gkt012-4-oly-vuong-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (369, 105, 'product', 'keo-dan-giay-glubby-liquid-glue-thien-long-g-025-mau-than-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (370, 105, 'product', 'keo-dan-giay-glubby-liquid-glue-thien-long-g-025-mau-than-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (371, 105, 'product', 'keo-dan-giay-glubby-liquid-glue-thien-long-g-025-mau-than-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (372, 105, 'product', 'keo-dan-giay-glubby-liquid-glue-thien-long-g-025-mau-than-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (373, 106, 'product', 'combo-5-ream-giay-a4-80-gsm-ik-copy-500-to-hang-nhap-khau-indonesia-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (374, 106, 'product', 'combo-5-ream-giay-a4-80-gsm-ik-copy-500-to-hang-nhap-khau-indonesia-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (375, 106, 'product', 'combo-5-ream-giay-a4-80-gsm-ik-copy-500-to-hang-nhap-khau-indonesia-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (376, 106, 'product', 'combo-5-ream-giay-a4-80-gsm-ik-copy-500-to-hang-nhap-khau-indonesia-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (377, 107, 'product', 'giay-phan-trang-thien-long-giay-notes-ghi-chu-nhieu-kich-thuoc-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (378, 107, 'product', 'giay-phan-trang-thien-long-giay-notes-ghi-chu-nhieu-kich-thuoc-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (379, 107, 'product', 'giay-phan-trang-thien-long-giay-notes-ghi-chu-nhieu-kich-thuoc-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (380, 107, 'product', 'giay-phan-trang-thien-long-giay-notes-ghi-chu-nhieu-kich-thuoc-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (381, 108, 'product', 'giay-kiem-tra-thien-long-diem-10-tp-gkt06-dong-ke-ngang-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (382, 108, 'product', 'giay-kiem-tra-thien-long-diem-10-tp-gkt06-dong-ke-ngang-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (383, 108, 'product', 'giay-kiem-tra-thien-long-diem-10-tp-gkt06-dong-ke-ngang-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (384, 108, 'product', 'giay-kiem-tra-thien-long-diem-10-tp-gkt06-dong-ke-ngang-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (385, 109, 'product', 'bo-5-giay-goi-qua-giang-sinh-thien-long-mon-qua-them-y-nghia-mua-noel-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (386, 109, 'product', 'bo-5-giay-goi-qua-giang-sinh-thien-long-mon-qua-them-y-nghia-mua-noel-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (387, 109, 'product', 'bo-5-giay-goi-qua-giang-sinh-thien-long-mon-qua-them-y-nghia-mua-noel-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (388, 109, 'product', 'bo-5-giay-goi-qua-giang-sinh-thien-long-mon-qua-them-y-nghia-mua-noel-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (389, 110, 'product', 'giay-goi-qua-thien-long-70x50cm-phu-mo-ggq-004-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (390, 110, 'product', 'giay-goi-qua-thien-long-70x50cm-phu-mo-ggq-004-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (391, 110, 'product', 'giay-goi-qua-thien-long-70x50cm-phu-mo-ggq-004-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (392, 110, 'product', 'giay-goi-qua-thien-long-70x50cm-phu-mo-ggq-004-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (393, 111, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-60-gsm-diem-10-tp-nb039-hinh-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (394, 111, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-60-gsm-diem-10-tp-nb039-hinh-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (395, 111, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-60-gsm-diem-10-tp-nb039-hinh-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (396, 111, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-60-gsm-diem-10-tp-nb039-hinh-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (397, 112, 'product', 'tap-to-mau-colokit-cb-012-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (398, 112, 'product', 'tap-to-mau-colokit-cb-012-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (399, 112, 'product', 'tap-to-mau-colokit-cb-012-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (400, 112, 'product', 'tap-to-mau-colokit-cb-012-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (401, 113, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-ngang-70-gsm-diem-10-tp-nb048-hinh-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (402, 113, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-ngang-70-gsm-diem-10-tp-nb048-hinh-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (403, 113, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-ngang-70-gsm-diem-10-tp-nb048-hinh-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (404, 113, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-ngang-70-gsm-diem-10-tp-nb048-hinh-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (405, 114, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-70-gsm-diem-10-tp-nb044-hinh-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (406, 114, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-70-gsm-diem-10-tp-nb044-hinh-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (407, 114, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-70-gsm-diem-10-tp-nb044-hinh-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (408, 114, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-70-gsm-diem-10-tp-nb044-hinh-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (409, 115, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-80-gsm-diem-10-tp-nb074-hinh-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (410, 115, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-80-gsm-diem-10-tp-nb074-hinh-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (411, 115, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-80-gsm-diem-10-tp-nb074-hinh-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (412, 115, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-80-gsm-diem-10-tp-nb074-hinh-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (413, 116, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-80-100gsm-thien-long-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (414, 116, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-80-100gsm-thien-long-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (415, 116, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-80-100gsm-thien-long-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (416, 116, 'product', 'tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-80-100gsm-thien-long-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (417, 117, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-2mm-cham-ke-2-3-100gsm-nb-118-thien-long-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (418, 117, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-2mm-cham-ke-2-3-100gsm-nb-118-thien-long-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (419, 117, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-2mm-cham-ke-2-3-100gsm-nb-118-thien-long-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (420, 117, 'product', 'tap-hoc-sinh-96-trang-5-o-ly-vuong-2mm-cham-ke-2-3-100gsm-nb-118-thien-long-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (421, 118, 'product', 'tap-vo-thien-long-80-120-trang-ke-ngang-7mm-70gsm-danh-cho-hoc-sinh-sinh-vien-phien-ban-demon-slayer-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (422, 118, 'product', 'tap-vo-thien-long-80-120-trang-ke-ngang-7mm-70gsm-danh-cho-hoc-sinh-sinh-vien-phien-ban-demon-slayer-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (423, 118, 'product', 'tap-vo-thien-long-80-120-trang-ke-ngang-7mm-70gsm-danh-cho-hoc-sinh-sinh-vien-phien-ban-demon-slayer-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (424, 118, 'product', 'tap-vo-thien-long-80-120-trang-ke-ngang-7mm-70gsm-danh-cho-hoc-sinh-sinh-vien-phien-ban-demon-slayer-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (425, 119, 'product', 'tap-hoc-sinh-chong-loa-96-trang-4-o-ly-vuong-2mm-100gsm-thien-long-nb-117-ak-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (426, 119, 'product', 'tap-hoc-sinh-chong-loa-96-trang-4-o-ly-vuong-2mm-100gsm-thien-long-nb-117-ak-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (427, 119, 'product', 'tap-hoc-sinh-chong-loa-96-trang-4-o-ly-vuong-2mm-100gsm-thien-long-nb-117-ak-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (428, 119, 'product', 'tap-hoc-sinh-chong-loa-96-trang-4-o-ly-vuong-2mm-100gsm-thien-long-nb-117-ak-akooland-the-gioi-hoc-cu-than-ky-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (429, 120, 'product', 'tap-hoc-sinh-120-trang-diem-10-nb-083-hinh-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (430, 120, 'product', 'tap-hoc-sinh-120-trang-diem-10-nb-083-hinh-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (431, 120, 'product', 'tap-hoc-sinh-120-trang-diem-10-nb-083-hinh-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (432, 120, 'product', 'tap-hoc-sinh-120-trang-diem-10-nb-083-hinh-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (433, 121, 'product', 'tap-to-mau-colokit-doraemon-cb-c019-do-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (434, 121, 'product', 'tap-to-mau-colokit-doraemon-cb-c019-do-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (435, 121, 'product', 'tap-to-mau-colokit-doraemon-cb-c019-do-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (436, 121, 'product', 'tap-to-mau-colokit-doraemon-cb-c019-do-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (437, 122, 'product', 'tang-02-cuon-combo-10-tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-100gsm-nb-124-thien-long-mau-ngau-nhien-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (438, 122, 'product', 'tang-02-cuon-combo-10-tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-100gsm-nb-124-thien-long-mau-ngau-nhien-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (439, 122, 'product', 'tang-02-cuon-combo-10-tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-100gsm-nb-124-thien-long-mau-ngau-nhien-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (440, 122, 'product', 'tang-02-cuon-combo-10-tap-hoc-sinh-96-trang-4-o-ly-vuong-2mm-100gsm-nb-124-thien-long-mau-ngau-nhien-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (441, 123, 'product', 'sach-huong-dan-to-mau-theo-chu-de-cho-be-kham-pha-thien-nhien-arty-mouse-colokit-coloring-ab-c001-ar-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (442, 123, 'product', 'sach-huong-dan-to-mau-theo-chu-de-cho-be-kham-pha-thien-nhien-arty-mouse-colokit-coloring-ab-c001-ar-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (443, 123, 'product', 'sach-huong-dan-to-mau-theo-chu-de-cho-be-kham-pha-thien-nhien-arty-mouse-colokit-coloring-ab-c001-ar-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (444, 123, 'product', 'sach-huong-dan-to-mau-theo-chu-de-cho-be-kham-pha-thien-nhien-arty-mouse-colokit-coloring-ab-c001-ar-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (445, 124, 'product', 'sach-huong-dan-cat-dan-thu-cong-cho-be-arty-mouse-colokit-sticking-ab-c006-ar-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (446, 124, 'product', 'sach-huong-dan-cat-dan-thu-cong-cho-be-arty-mouse-colokit-sticking-ab-c006-ar-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (447, 124, 'product', 'sach-huong-dan-cat-dan-thu-cong-cho-be-arty-mouse-colokit-sticking-ab-c006-ar-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (448, 124, 'product', 'sach-huong-dan-cat-dan-thu-cong-cho-be-arty-mouse-colokit-sticking-ab-c006-ar-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (449, 125, 'product', 'combo-my-thuat-sac-mau-5-mon-vo-ve-a3-but-chi-go-2b-but-sap-mau-but-sap-dau-sach-tuong-tac-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (450, 125, 'product', 'combo-my-thuat-sac-mau-5-mon-vo-ve-a3-but-chi-go-2b-but-sap-mau-but-sap-dau-sach-tuong-tac-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (451, 125, 'product', 'combo-my-thuat-sac-mau-5-mon-vo-ve-a3-but-chi-go-2b-but-sap-mau-but-sap-dau-sach-tuong-tac-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (452, 125, 'product', 'combo-my-thuat-sac-mau-5-mon-vo-ve-a3-but-chi-go-2b-but-sap-mau-but-sap-dau-sach-tuong-tac-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (453, 126, 'product', 'gateway-2-ed-b1-plus-student-book-pack-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (454, 126, 'product', 'gateway-2-ed-b1-plus-student-book-pack-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (455, 126, 'product', 'gateway-2-ed-b1-plus-student-book-pack-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (456, 126, 'product', 'gateway-2-ed-b1-plus-student-book-pack-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (457, 127, 'product', 'gateway-2-ed-b1-workbook-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (458, 127, 'product', 'gateway-2-ed-b1-workbook-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (459, 127, 'product', 'gateway-2-ed-b1-workbook-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (460, 127, 'product', 'gateway-2-ed-b1-workbook-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (461, 128, 'product', 'gateway-2-ed-a2-workbook-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (462, 128, 'product', 'gateway-2-ed-a2-workbook-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (463, 128, 'product', 'gateway-2-ed-a2-workbook-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (464, 128, 'product', 'gateway-2-ed-a2-workbook-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (465, 129, 'product', 'bundle-pathways-reading-writing-and-critical-thinking-foundations-2nd-student-edition-online-workbook-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (466, 129, 'product', 'bundle-pathways-reading-writing-and-critical-thinking-foundations-2nd-student-edition-online-workbook-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (467, 129, 'product', 'bundle-pathways-reading-writing-and-critical-thinking-foundations-2nd-student-edition-online-workbook-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (468, 129, 'product', 'bundle-pathways-reading-writing-and-critical-thinking-foundations-2nd-student-edition-online-workbook-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (469, 130, 'product', 'impact-bre-4-workbook-wb-audio-cd-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (470, 130, 'product', 'impact-bre-4-workbook-wb-audio-cd-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (471, 130, 'product', 'impact-bre-4-workbook-wb-audio-cd-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (472, 130, 'product', 'impact-bre-4-workbook-wb-audio-cd-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (473, 131, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-1-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (474, 131, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-1-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (475, 131, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-1-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (476, 131, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-1-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (477, 132, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-2-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (478, 132, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-2-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (479, 132, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-2-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (480, 132, 'product', 'goi-dung-cu-van-phong-ghi-chu-co-ban-2-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (481, 133, 'product', 'goi-dung-cu-van-phong-tien-ich-3-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (482, 133, 'product', 'goi-dung-cu-van-phong-tien-ich-3-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (483, 133, 'product', 'goi-dung-cu-van-phong-tien-ich-3-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (484, 133, 'product', 'goi-dung-cu-van-phong-tien-ich-3-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (485, 134, 'product', 'goi-dung-cu-van-phong-tien-ich-1-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (486, 134, 'product', 'goi-dung-cu-van-phong-tien-ich-1-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (487, 134, 'product', 'goi-dung-cu-van-phong-tien-ich-1-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (488, 134, 'product', 'goi-dung-cu-van-phong-tien-ich-1-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (489, 135, 'product', 'goi-dung-cu-van-phong-tien-ich-4-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (490, 135, 'product', 'goi-dung-cu-van-phong-tien-ich-4-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (491, 135, 'product', 'goi-dung-cu-van-phong-tien-ich-4-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (492, 135, 'product', 'goi-dung-cu-van-phong-tien-ich-4-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (493, 136, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx509vn-co-hon-240-tinh-nang-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (494, 136, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx509vn-co-hon-240-tinh-nang-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (495, 136, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx509vn-co-hon-240-tinh-nang-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (496, 136, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx509vn-co-hon-240-tinh-nang-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (497, 137, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx799vn-4-mau-pastel-moi-bao-hanh-7-nam-1-doi-1-trong-1-nam-dau-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (498, 137, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx799vn-4-mau-pastel-moi-bao-hanh-7-nam-1-doi-1-trong-1-nam-dau-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (499, 137, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx799vn-4-mau-pastel-moi-bao-hanh-7-nam-1-doi-1-trong-1-nam-dau-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (500, 137, 'product', 'may-tinh-khoa-hoc-thien-long-flexio-fx799vn-4-mau-pastel-moi-bao-hanh-7-nam-1-doi-1-trong-1-nam-dau-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (501, 138, 'product', 'dao-roc-giay-thien-long-khoa-tu-dong-thong-minh-khay-dung-dao-nang-cap-chac-chan-an-toan-hon-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (502, 138, 'product', 'dao-roc-giay-thien-long-khoa-tu-dong-thong-minh-khay-dung-dao-nang-cap-chac-chan-an-toan-hon-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (503, 138, 'product', 'dao-roc-giay-thien-long-khoa-tu-dong-thong-minh-khay-dung-dao-nang-cap-chac-chan-an-toan-hon-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (504, 138, 'product', 'dao-roc-giay-thien-long-khoa-tu-dong-thong-minh-khay-dung-dao-nang-cap-chac-chan-an-toan-hon-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (505, 139, 'product', 'keo-flexoffice-fo-sc03-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (506, 139, 'product', 'keo-flexoffice-fo-sc03-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (507, 139, 'product', 'keo-flexoffice-fo-sc03-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (508, 139, 'product', 'keo-flexoffice-fo-sc03-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (509, 140, 'product', 'combo-10-but-long-dau-hoshi-thien-long-pm-019-hs-cong-nghe-nhat-ban-tn.jpg', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (510, 140, 'product', 'combo-10-but-long-dau-hoshi-thien-long-pm-019-hs-cong-nghe-nhat-ban-1.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (511, 140, 'product', 'combo-10-but-long-dau-hoshi-thien-long-pm-019-hs-cong-nghe-nhat-ban-2.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (512, 140, 'product', 'combo-10-but-long-dau-hoshi-thien-long-pm-019-hs-cong-nghe-nhat-ban-3.jpg', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (513, 140, 'Product', 'scanner-epson-ds-530ii-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (514, 140, 'Product', 'scanner-epson-ds-530ii-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (515, 140, 'Product', 'scanner-epson-ds-530ii-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (516, 140, 'Product', 'scanner-epson-ds-530ii-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (517, 141, 'Product', 'scanner-epson-ds-c330-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (518, 141, 'Product', 'scanner-epson-ds-c330-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (519, 141, 'Product', 'scanner-epson-ds-c330-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (520, 141, 'Product', 'scanner-epson-ds-c330-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (521, 142, 'Product', 'scanner-brother-ads-3100-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (522, 142, 'Product', 'scanner-brother-ads-3100-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (523, 142, 'Product', 'scanner-brother-ads-3100-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (524, 143, 'Product', 'scanner-hp-pro-2600-f1-scanner-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (525, 143, 'Product', 'scanner-hp-pro-2600-f1-scanner-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (526, 143, 'Product', 'scanner-hp-pro-2600-f1-scanner-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (527, 143, 'Product', 'scanner-hp-pro-2600-f1-scanner-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (528, 144, 'Product', 'scanner-hp-pro-3000-s4-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (529, 144, 'Product', 'scanner-hp-pro-3000-s4-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (530, 144, 'Product', 'scanner-hp-pro-3000-s4-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (531, 144, 'Product', 'scanner-hp-pro-3000-s4-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (532, 145, 'Product', 'scanner-canon-lide-300-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (533, 145, 'Product', 'scanner-canon-lide-300-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (534, 146, 'Product', 'scanner-brother-ads-4700w-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (535, 146, 'Product', 'scanner-brother-ads-4700w-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (536, 146, 'Product', 'scanner-brother-ads-4700w-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (537, 147, 'Product', 'scanner-epson-es-c320w-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (538, 147, 'Product', 'scanner-epson-es-c320w-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (539, 147, 'Product', 'scanner-epson-es-c320w-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (540, 147, 'Product', 'scanner-epson-es-c320w-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (541, 147, 'Product', 'scanner-epson-es-c320w-4.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (542, 148, 'Product', 'scanner-canon-dr-c225-ii-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (543, 148, 'Product', 'scanner-canon-dr-c225-ii-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (544, 148, 'Product', 'scanner-canon-dr-c225-ii-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (545, 149, 'Product', 'scanner-canon-dr-f120-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (546, 149, 'Product', 'scanner-canon-dr-f120-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (547, 149, 'Product', 'scanner-canon-dr-f120-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (548, 149, 'Product', 'scanner-canon-dr-f120-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (549, 150, 'Product', 'scanner-epson-ds-570wii-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (550, 150, 'Product', 'scanner-epson-ds-570wii-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (551, 150, 'Product', 'scanner-epson-ds-570wii-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (552, 151, 'Product', 'scanner-hp-scanjet-pro-3600-f1-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (553, 151, 'Product', 'scanner-hp-scanjet-pro-3600-f1-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (554, 151, 'Product', 'scanner-hp-scanjet-pro-3600-f1-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (555, 151, 'Product', 'scanner-hp-scanjet-pro-3600-f1-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (556, 152, 'Product', 'scanner-hp-scanjet-pro-n4000-snw1-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (557, 152, 'Product', 'scanner-hp-scanjet-pro-n4000-snw1-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (558, 152, 'Product', 'scanner-hp-scanjet-pro-n4000-snw1-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (559, 152, 'Product', 'scanner-hp-scanjet-pro-n4000-snw1-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (560, 153, 'Product', 'scanner-hp-enterprise-flow-5000-s5-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (561, 153, 'Product', 'scanner-hp-enterprise-flow-5000-s5-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (562, 153, 'Product', 'scanner-hp-enterprise-flow-5000-s5-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (563, 153, 'Product', 'scanner-hp-enterprise-flow-5000-s5-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (564, 154, 'Product', 'scanner-hp-2000-s2-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (565, 154, 'Product', 'scanner-hp-2000-s2-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (566, 154, 'Product', 'scanner-hp-2000-s2-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (567, 154, 'Product', 'scanner-hp-2000-s2-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (568, 155, 'Product', 'scanner-canon-p-215ii-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (569, 155, 'Product', 'scanner-canon-p-215ii-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (570, 155, 'Product', 'scanner-canon-p-215ii-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (571, 155, 'Product', 'scanner-canon-p-215ii-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (572, 156, 'Product', 'scanner-epson-ds-1630-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (573, 156, 'Product', 'scanner-epson-ds-1630-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (574, 156, 'Product', 'scanner-epson-ds-1630-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (575, 156, 'Product', 'scanner-epson-ds-1630-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (576, 157, 'Product', 'scanner-brother-ads-1200-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (577, 157, 'Product', 'scanner-brother-ads-1200-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (578, 157, 'Product', 'scanner-brother-ads-1200-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (579, 158, 'Product', 'scanner-brother-ads-1300-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (580, 158, 'Product', 'scanner-brother-ads-1300-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (581, 158, 'Product', 'scanner-brother-ads-1300-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (582, 159, 'Product', 'scanner-canon-lide-400-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (583, 159, 'Product', 'scanner-canon-lide-400-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (584, 160, 'Product', 'photocopy-canon-ir2425-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (585, 160, 'Product', 'photocopy-canon-ir2425-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (586, 161, 'Product', 'photocopy-canon-ir2925i-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (587, 161, 'Product', 'photocopy-canon-ir2925i-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (588, 162, 'Product', 'photocopy-konica-minolta-bizhub-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (589, 162, 'Product', 'photocopy-konica-minolta-bizhub-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (590, 163, 'Product', 'photocopy-konica-minolta-bizhub-451i-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (591, 163, 'Product', 'photocopy-konica-minolta-bizhub-451i-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (592, 164, 'Product', 'photocopy-konica-minolta-bizhub-361i-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (593, 164, 'Product', 'photocopy-konica-minolta-bizhub-361i-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (594, 165, 'Product', 'photocopy-konica-minolta-bizhub-301i-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (595, 165, 'Product', 'photocopy-konica-minolta-bizhub-301i-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (596, 166, 'Product', 'photocopy-konica-minolta-bizhub-367-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (597, 166, 'Product', 'photocopy-konica-minolta-bizhub-367-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (598, 167, 'Product', 'photocopy-konica-minolta-bizhub-287-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (599, 167, 'Product', 'photocopy-konica-minolta-bizhub-287-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (600, 168, 'Product', 'may-huy-tai-lieu-bosser-240x-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (601, 168, 'Product', 'may-huy-tai-lieu-bosser-240x-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (602, 169, 'Product', 'may-huy-tai-lieu-bosser-240x-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (603, 169, 'Product', 'may-huy-tai-lieu-bosser-240x-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (604, 169, 'Product', 'may-huy-tai-lieu-bosser-240x-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (605, 170, 'Product', 'may-huy-tai-lieu-bosser-220cd-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (606, 170, 'Product', 'may-huy-tai-lieu-bosser-220cd-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (607, 170, 'Product', 'may-huy-tai-lieu-bosser-220cd-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (608, 171, 'Product', 'may-huy-giay-bosser-180x-gold-demo-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (609, 172, 'Product', 'may-huy-vun-bingo-c46cdt-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (610, 173, 'Product', 'may-huy-vun-bingo-c40cd-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (611, 174, 'Product', 'may-huy-tai-lieu-silicon-ps-800cn-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (612, 174, 'Product', 'may-huy-tai-lieu-silicon-ps-800cn-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (613, 174, 'Product', 'may-huy-tai-lieu-silicon-ps-800cn-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (614, 175, 'Product', 'may-huy-giay-bosser-150x-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (615, 176, 'Product', 'may-huy-giay-magitech-dm-300c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (616, 176, 'Product', 'may-huy-giay-magitech-dm-300c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (617, 176, 'Product', 'may-huy-giay-magitech-dm-300c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (618, 176, 'Product', 'may-huy-giay-magitech-dm-300c-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (619, 177, 'Product', 'may-huy-giay-magitech-dm-300m-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (620, 178, 'Product', 'may-huy-giay-magitech-dm-120m-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (621, 179, 'Product', 'may-huy-vun-bingo-c30-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (622, 179, 'Product', 'may-huy-vun-bingo-c30-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (623, 179, 'Product', 'may-huy-vun-bingo-c30-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (624, 179, 'Product', 'may-huy-vun-bingo-c30-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (625, 180, 'Product', 'may-huy-vun-bingo-c32-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (626, 180, 'Product', 'may-huy-vun-bingo-c32-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (627, 180, 'Product', 'may-huy-vun-bingo-c32-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (628, 180, 'Product', 'may-huy-vun-bingo-c32-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (629, 181, 'Product', 'may-huy-vun-bingo-c35-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (630, 181, 'Product', 'may-huy-vun-bingo-c35-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (631, 181, 'Product', 'may-huy-vun-bingo-c35-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (632, 181, 'Product', 'may-huy-vun-bingo-c35-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (633, 182, 'Product', 'may-huy-vun-bingo-elegant-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (634, 183, 'Product', 'may-huy-tai-lieu-silicon-ps-508m-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (635, 183, 'Product', 'may-huy-tai-lieu-silicon-ps-508m-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (636, 183, 'Product', 'may-huy-tai-lieu-silicon-ps-508m-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (637, 184, 'Product', 'may-huy-tai-lieu-silicon-ps-620c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (638, 184, 'Product', 'may-huy-tai-lieu-silicon-ps-620c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (639, 184, 'Product', 'may-huy-tai-lieu-silicon-ps-620c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (640, 184, 'Product', 'may-huy-tai-lieu-silicon-ps-620c-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (641, 185, 'Product', 'may-huy-tai-lieu-silicon-ps-836c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (642, 185, 'Product', 'may-huy-tai-lieu-silicon-ps-836c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (643, 185, 'Product', 'may-huy-tai-lieu-silicon-ps-836c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (644, 185, 'Product', 'may-huy-tai-lieu-silicon-ps-836c-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (645, 186, 'Product', 'may-huy-vun-bingo-c36-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (646, 186, 'Product', 'may-huy-vun-bingo-c36-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (647, 186, 'Product', 'may-huy-vun-bingo-c36-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (648, 187, 'Product', 'may-huy-tai-lieu-bosser-220cc-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (649, 187, 'Product', 'may-huy-tai-lieu-bosser-220cc-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (650, 187, 'Product', 'may-huy-tai-lieu-bosser-220cc-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (651, 188, 'Product', 'may-huy-tai-lieu-magitech-dm-120c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (652, 188, 'Product', 'may-huy-tai-lieu-magitech-dm-120c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (653, 188, 'Product', 'may-huy-tai-lieu-magitech-dm-120c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (654, 189, 'Product', 'may-huy-tai-lieu-magitech-dm-220c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (655, 189, 'Product', 'may-huy-tai-lieu-magitech-dm-220c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (656, 189, 'Product', 'may-huy-tai-lieu-magitech-dm-220c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (657, 190, 'Product', 'may-huy-tai-lieu-dsb-fd-506m-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (658, 190, 'Product', 'may-huy-tai-lieu-dsb-fd-506m-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (659, 190, 'Product', 'may-huy-tai-lieu-dsb-fd-506m-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (660, 191, 'Product', 'may-huy-tai-lieu-silicon-ps-650c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (661, 191, 'Product', 'may-huy-tai-lieu-silicon-ps-650c-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (662, 191, 'Product', 'may-huy-tai-lieu-silicon-ps-650c-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (663, 192, 'Product', 'may-huy-vun-bingo-c45cd-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (664, 193, 'Product', 'may-huy-giay-magitech-om-16xc-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (665, 194, 'Product', 'may-huy-cong-nghiep-hoat-dong-lien-tuc-24-24-gio-silicon-ps-3500c-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (666, 195, 'Product', 'but-trinh-chieu-presenter-targus-p32-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (667, 195, 'Product', 'but-trinh-chieu-presenter-targus-p32-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (668, 195, 'Product', 'but-trinh-chieu-presenter-targus-p32-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (669, 196, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr310-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (670, 196, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr310-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (671, 196, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr310-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (672, 197, 'Product', 'but-trinh-chieu-baseus-orange-dot-wireless-presenter-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (673, 197, 'Product', 'but-trinh-chieu-baseus-orange-dot-wireless-presenter-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (674, 197, 'Product', 'but-trinh-chieu-baseus-orange-dot-wireless-presenter-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (675, 197, 'Product', 'but-trinh-chieu-baseus-orange-dot-wireless-presenter-3.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (676, 198, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr100-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (677, 198, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr100-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (678, 198, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr100-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (679, 199, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr200-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (680, 199, 'Product', 'but-trinh-chieu-pin-sac-rapoo-xr200-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (681, 200, 'Product', 'but-trinh-chieu-logitech-r500s-thumb.webp', b'1', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (682, 200, 'Product', 'but-trinh-chieu-logitech-r500s-1.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (683, 200, 'Product', 'but-trinh-chieu-logitech-r500s-2.webp', b'0', '2026-01-27 19:37:51');
INSERT INTO `image` VALUES (2274, 1, 'Blog', 'about-img-large.webp', b'1', '2025-12-30 06:10:07');
INSERT INTO `image` VALUES (2275, 2, 'Blog', 'z7657167332308_66dbeb62f48ad1650a8725ed0d733e25.jpg', b'1', '2026-03-25 12:45:10');
INSERT INTO `image` VALUES (2276, 3, 'Blog', 'Screenshot 2026-04-18 092252.png', b'1', '2026-04-19 08:10:59');
INSERT INTO `image` VALUES (2277, 4, 'Blog', 'Screenshot 2026-04-18 092252.png', b'1', '2026-04-19 08:14:39');
INSERT INTO `image` VALUES (2278, 5, 'Blog', 'Screenshot 2026-04-18 092252.png', b'1', '2026-04-19 08:15:40');
INSERT INTO `image` VALUES (2279, 6, 'Blog', 'Screenshot 2026-04-18 092252.png', b'1', '2026-04-19 08:17:15');
INSERT INTO `image` VALUES (2280, 7, 'Blog', 'Screenshot 2026-04-18 095653.png', b'1', '2026-04-19 08:20:48');
INSERT INTO `image` VALUES (2281, 8, 'Blog', 'Screenshot 2026-04-19 190348.png', b'1', '2026-04-19 12:52:21');
INSERT INTO `image` VALUES (2282, 9, 'Blog', 'Screenshot 2026-04-19 190348.png', b'1', '2026-04-19 12:54:46');
INSERT INTO `image` VALUES (2283, 10, 'Blog', 'Screenshot (1).png', b'1', '2026-06-01 09:23:50');
INSERT INTO `image` VALUES (2284, 11, 'Blog', 'Screenshot (1).png', b'1', '2026-06-01 18:20:24');
INSERT INTO `image` VALUES (2285, 12, 'Blog', 'Screenshot (1).png', b'1', '2026-06-01 18:21:32');
INSERT INTO `image` VALUES (2286, 13, 'Blog', 'Screenshot (1).png', b'1', '2026-06-01 18:29:51');
INSERT INTO `image` VALUES (2287, 202, 'Product', 'navicat_icon.png', b'1', '2026-06-02 17:56:51');
INSERT INTO `image` VALUES (2288, 202, 'Product', 'navicat_icon.png', b'0', '2026-06-02 17:56:51');

-- ----------------------------
-- Table structure for inventory_transaction_details
-- ----------------------------
DROP TABLE IF EXISTS `inventory_transaction_details`;
CREATE TABLE `inventory_transaction_details`  (
  `transaction_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(15, 2) NOT NULL,
  PRIMARY KEY (`transaction_id`, `product_id`) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `inventory_transaction_details_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `inventory_transactions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `inventory_transaction_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory_transaction_details
-- ----------------------------
INSERT INTO `inventory_transaction_details` VALUES (4, 11, 3, 6590000.00);
INSERT INTO `inventory_transaction_details` VALUES (4, 13, 4, 3890000.00);
INSERT INTO `inventory_transaction_details` VALUES (5, 8, 6, 3990000.00);
INSERT INTO `inventory_transaction_details` VALUES (5, 11, 4, 6590000.00);
INSERT INTO `inventory_transaction_details` VALUES (6, 1, 10, 3190000.00);
INSERT INTO `inventory_transaction_details` VALUES (6, 2, 9, 6190000.00);
INSERT INTO `inventory_transaction_details` VALUES (6, 17, 10, 8090000.00);
INSERT INTO `inventory_transaction_details` VALUES (7, 96, 10, 8900.00);
INSERT INTO `inventory_transaction_details` VALUES (7, 122, 10, 14000.00);
INSERT INTO `inventory_transaction_details` VALUES (8, 122, 1, 14000.00);

-- ----------------------------
-- Table structure for inventory_transactions
-- ----------------------------
DROP TABLE IF EXISTS `inventory_transactions`;
CREATE TABLE `inventory_transactions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('IMPORT','EXPORT') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `total_value` decimal(15, 2) NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of inventory_transactions
-- ----------------------------
INSERT INTO `inventory_transactions` VALUES (4, 'IMPORT', '2026-05-22 15:40:05', 1, '', 35330000.00);
INSERT INTO `inventory_transactions` VALUES (5, 'EXPORT', '2026-05-22 23:33:42', 1, '', 50300000.00);
INSERT INTO `inventory_transactions` VALUES (6, 'IMPORT', '2026-05-23 01:25:45', 1, 'Nhập hàng đợt 1 tháng 6', 168510000.00);
INSERT INTO `inventory_transactions` VALUES (7, 'IMPORT', '2026-05-23 01:48:30', 1, '', 229000.00);
INSERT INTO `inventory_transactions` VALUES (8, 'IMPORT', '2026-06-07 18:07:14', 3, '', 14000.00);

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` int NULL DEFAULT NULL,
  `is_seen` bit(1) NULL DEFAULT b'0',
  `is_read` bit(1) NULL DEFAULT b'0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_notification_user_type_ref`(`user_id` ASC, `type` ASC, `reference_id` ASC) USING BTREE,
  CONSTRAINT `notifications_fk_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO `notifications` VALUES (1, 3, 'Đơn hàng #123 đã được xác nhận', 'ORDER_SHIPPED', 13, b'1', b'1', '2026-06-01 10:47:53');
INSERT INTO `notifications` VALUES (9, 3, 'Đơn hàng #11 đã được giao thành công.', 'ORDER_SHIPPED', 11, b'1', b'1', '2026-06-01 11:43:25');
INSERT INTO `notifications` VALUES (13, 3, 'Đơn hàng #12 đã được xác nhận.', 'ORDER_SHIPPED', 12, b'1', b'1', '2026-06-01 11:56:27');
INSERT INTO `notifications` VALUES (14, 3, 'Đơn hàng #10 đang được giao.', 'ORDER_SHIPPED', 10, b'1', b'1', '2026-06-01 12:16:44');
INSERT INTO `notifications` VALUES (15, 3, 'Đơn hàng #10 đã được giao thành công.', 'ORDER_COMPLETED', 10, b'1', b'0', '2026-06-01 12:16:46');
INSERT INTO `notifications` VALUES (16, 3, 'Đơn hàng #9 đang được giao.', 'ORDER_SHIPPED', 9, b'1', b'0', '2026-06-01 12:17:25');
INSERT INTO `notifications` VALUES (17, 3, 'Đơn hàng #9 đã được giao thành công.', 'ORDER_COMPLETED', 9, b'1', b'0', '2026-06-01 12:17:29');
INSERT INTO `notifications` VALUES (18, 3, 'Đơn hàng #8 đang được giao.', 'ORDER_SHIPPED', 8, b'1', b'1', '2026-06-01 12:17:33');
INSERT INTO `notifications` VALUES (19, 3, 'Đơn hàng #8 đã được giao thành công.', 'ORDER_COMPLETED', 8, b'1', b'1', '2026-06-01 12:17:35');
INSERT INTO `notifications` VALUES (20, 3, 'Blog #11 đã được duyệt và hiển thị công khai.', 'BLOG_APPROVED', 11, b'1', b'1', '2026-06-01 18:20:36');
INSERT INTO `notifications` VALUES (22, 3, 'Blog #12 đã được duyệt và hiển thị công khai.', 'BLOG_APPROVED', 12, b'1', b'1', '2026-06-01 18:25:41');
INSERT INTO `notifications` VALUES (23, 3, 'Blog #13 đã được duyệt và hiển thị công khai.', 'BLOG_APPROVED', 13, b'1', b'1', '2026-06-01 18:30:08');
INSERT INTO `notifications` VALUES (24, 3, 'Blog của bạn đã bị xóa.', 'BLOG_DELETED', 13, b'1', b'1', '2026-06-01 18:30:26');
INSERT INTO `notifications` VALUES (25, 3, 'Yêu cầu liên hệ của bạn đã được gửi thành công.', 'CONTACT_SUBMITTED', NULL, b'1', b'1', '2026-06-01 18:41:21');
INSERT INTO `notifications` VALUES (26, 3, 'Yêu cầu liên hệ của bạn đã được phản hồi.Vui lòng kiểm tra email!', 'CONTACT_REPLIED', 3, b'0', b'0', '2026-06-07 18:02:25');
INSERT INTO `notifications` VALUES (27, 10, 'Mật khẩu tài khoản của bạn đã được thay đổi thành công.', 'PASSWORD_CHANGED', NULL, b'1', b'1', '2026-06-01 19:07:21');
INSERT INTO `notifications` VALUES (29, 3, 'Yêu cầu liên hệ của bạn đã được phản hồi.Vui lòng kiểm tra email!', 'CONTACT_REPLIED', 2, b'0', b'0', '2026-06-07 18:02:30');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NULL DEFAULT NULL,
  `quantity` int NULL DEFAULT NULL,
  `price` decimal(18, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_orderitem_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_orderitem_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `chk_order_item` CHECK (`quantity` > 0)
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 1, 56, 10, 3230700.00);
INSERT INTO `order_item` VALUES (2, 2, 53, 1, 11080800.00);
INSERT INTO `order_item` VALUES (3, 3, 56, 1, 3230700.00);
INSERT INTO `order_item` VALUES (4, 3, 11, 1, 1581600.00);
INSERT INTO `order_item` VALUES (5, 4, 56, 1, 3230700.00);
INSERT INTO `order_item` VALUES (6, 4, 11, 1, 1581600.00);
INSERT INTO `order_item` VALUES (7, 5, 11, 1, 1581600.00);
INSERT INTO `order_item` VALUES (8, 6, 115, 2, 2800.00);
INSERT INTO `order_item` VALUES (9, 6, 53, 1, 11080800.00);
INSERT INTO `order_item` VALUES (10, 6, 119, 2, 2240.00);
INSERT INTO `order_item` VALUES (11, 6, 123, 4, 2140.00);
INSERT INTO `order_item` VALUES (12, 7, 53, 2, 29959200.00);
INSERT INTO `order_item` VALUES (13, 7, 56, 1, 6559300.00);
INSERT INTO `order_item` VALUES (14, 7, 11, 1, 5008400.00);
INSERT INTO `order_item` VALUES (15, 8, 19, 1, 16901100.00);
INSERT INTO `order_item` VALUES (16, 9, 125, 1, 159000.00);
INSERT INTO `order_item` VALUES (17, 10, 56, 1, 6559300.00);
INSERT INTO `order_item` VALUES (18, 11, 53, 1, 29959200.00);
INSERT INTO `order_item` VALUES (19, 12, 11, 1, 5008400.00);
INSERT INTO `order_item` VALUES (20, 13, 11, 1, 5008400.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `total_price` decimal(18, 2) NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `shipping_provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shipping_fee` decimal(18, 2) NULL DEFAULT NULL,
  `shipping_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shipping_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shipping_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 3, 'shipped', 68872650.00, ' (PTTT: COD)', NULL, 0.00, 'Hinh Nguyen', '0866501452', 'Hcm, hcm, VN', '2026-03-06 12:09:56');
INSERT INTO `orders` VALUES (2, 3, 'shipped', 31457160.00, ' (PTTT: COD)', NULL, 0.00, 'Hinh Nguyen', '0866501452', 'Hcm, hcm, VN', '2026-01-27 18:07:15');
INSERT INTO `orders` VALUES (3, 3, 'shipped', 12146085.00, 'fdsafdsfds (PTTT: COD)', NULL, 0.00, 'Hinh Nguyen', '0866501452', 'Hcm, hcm, VN', '2026-01-27 18:31:13');
INSERT INTO `orders` VALUES (4, 3, 'pending', 12146085.00, ' (PTTT: COD)', NULL, 0.00, 'Hinh Nguyen', '0866501452', 'Hcm, hcm, VN', '2026-01-27 10:18:46');
INSERT INTO `orders` VALUES (5, 3, 'pending', 5258820.00, 'hjgjghjgh (PTTT: COD)', NULL, 0.00, 'jvghjkh', '0373052604', 'jhjhjgh, TP.Hồ Chí Minh, VN', '2026-01-28 02:10:01');
INSERT INTO `orders` VALUES (6, 2, 'pending', 31535448.00, ' (PTTT: COD)', NULL, 0.00, 'Tân Hoàng Duy', '0373052605', '83/16, Tân Phong, Biên Hòa, TP.Hồ Chí Minh, VN', '2026-03-05 07:55:37');
INSERT INTO `orders` VALUES (7, 2, 'completed', 75060405.00, ' (PTTT: COD)', NULL, 0.00, 'Tân Hoàng Duy', '0123456780', '83/16, Tân Phong, Biên Hòa, TP.Hồ Chí Minh, VN', '2026-05-23 10:03:11');
INSERT INTO `orders` VALUES (8, 3, 'completed', 17746155.00, '', NULL, 0.00, 'Hinh Nguyen', '034034343', 'sdjfsdkfjkdsaf, sdfsdoifklsdfjkldsf, VN', '2026-06-01 12:17:35');
INSERT INTO `orders` VALUES (9, 3, 'completed', 196950.00, '', NULL, 30000.00, 'Hinh Nguyen', '0866501452', '74, Tan Thanh, TP. Hồ Chí Minh, VN', '2026-06-01 12:17:28');
INSERT INTO `orders` VALUES (10, 3, 'completed', 6951266.00, '', 'GHN', 64001.00, 'Hinh Nguyen', '0866501452', '74, Tan Thanh, Xã Cát Hanh, Huyện Phù Cát, Bình Định, VN', '2026-06-01 12:16:46');
INSERT INTO `orders` VALUES (11, 3, 'completed', 31531160.00, '', 'GHN', 74000.00, 'Hinh Nguyen', '0866501452', 'Tiểu Than, Xã Vạn Ninh, Huyện Gia Bình, Bắc Ninh, VN', '2026-06-01 11:43:24');
INSERT INTO `orders` VALUES (12, 3, 'completed', 5322821.00, '', 'GHN', 64001.00, 'Hinh Nguyen', '0866501452', '74, Tan Thanh, Xã Suối Dây, Huyện Tân Châu, Tây Ninh, VN', '2026-06-01 11:56:27');
INSERT INTO `orders` VALUES (13, 3, 'completed', 5317821.00, '', 'GHN', 59001.00, 'Hinh Thiết', '0866501452', '74, Tan Thanh, Phường 2, Thành phố Tuy Hòa, Phú Yên, VN', '2026-06-01 10:23:45');

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `payment_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `payment_amount` decimal(18, 2) NULL DEFAULT NULL,
  `status` bit(1) NULL DEFAULT b'0',
  `transaction_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_payment_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment
-- ----------------------------
INSERT INTO `payment` VALUES (1, 8, 'COD', 17746155.00, b'0', NULL, NULL);
INSERT INTO `payment` VALUES (2, 9, 'COD', 196950.00, b'0', NULL, NULL);
INSERT INTO `payment` VALUES (3, 10, 'COD', 6951266.00, b'0', NULL, NULL);
INSERT INTO `payment` VALUES (4, 11, 'COD', 31531160.00, b'0', NULL, NULL);
INSERT INTO `payment` VALUES (5, 12, 'COD', 5322821.00, b'0', NULL, NULL);
INSERT INTO `payment` VALUES (6, 13, 'COD', 5317821.00, b'1', NULL, '2026-06-01 08:35:24');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NULL DEFAULT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description_thumbnail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `product_description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `product_detail` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `price` decimal(15, 2) GENERATED ALWAYS AS (ceiling((`origin_price` * (1 - `discount`)))) STORED NULL,
  `origin_price` decimal(15, 2) NULL DEFAULT NULL,
  `discount` decimal(3, 2) NULL DEFAULT NULL,
  `stock_quantity` int NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_category`(`category_id` ASC) USING BTREE,
  CONSTRAINT `fk_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, 1, 'Máy in phun màu HP Smart Tank 215 (3D4L4A)', 'Phù hợp: Văn phòng, Gia đình#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 12 trang/phút (trắng đen) - 5 trang/phút (màu) A4; B5; A6', 'HP Smart Tank 215 là máy in HP đến từ dòng máy in phun màu không dây mới, được thiết kế dành cho gia đình, sinh viên và văn phòng nhỏ Sản phẩm nổi bật với khả năng in hai mặt, kết nối Wi-Fi ổn định và dung lượng mực lớn, giúp tiết kiệm tối đa chi phí vận hành Với thiết kế gọn gàng và tính năng thông minh, đây chính là lựa chọn lý tưởng cho những ai cần sự tiện lợi, linh hoạt và hiệu quả in ấn hàng ngày', 'Loại máy in: Máy In Laser#Tính năng: In#Tốc độ in: Màu (A4, ISO): Tối đa 5 ipm; A4: Lên đến 16 trang/phút; Giấy nhớ A4; Đen trắng (A4, ISO): Tối đa 12 ipm; A4: Lên đến 22 trang/phút; Giấy nhớ A4: Tối đa 30 ppm (trắng đen): Lên đến 24 trang/phút (màu)#Độ phân giải: 1200 x 1200 dpi#Kết nối: 1 x Hi-Speed USB 20#Khổ giấy hỗ trợ: A4; B5; A6; DL envelope, legal#Dung lượng khay giấy: Tiêu chuẩn: Lên đến 100 tờ; Phong bì: Tối đa 10 phong bì; Thẻ: Lên đến 30 thẻ#Mực in kèm máy: HP GT53XL; HP GT52 Cyan: HP GT52 Magenta#Kích thước: 435 x 591 x 269 mm#Trọng lượng: 373 Kg - HP GT52 Yellow', 'HP', DEFAULT, 3190000.00, 0.00, 110, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (2, 1, 'Máy in laser đen trắng Lexmark MS431dn (29S0080)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 40-42 trang/phút A6', 'Lexmark MS431DN là máy in laser đen trắng tầm trung, phù hợp cho nhóm làm việc nhỏ với nhu cầu in ấn thường xuyên Sản phẩm nổi bật với tốc độ in 40 trang/phút cùng thiết kế gọn nhẹ 9,3 kg, giúp xử lý tài liệu nhanh chóng và giảm thiểu thời gian chờ Tính năng in hai mặt tự động hỗ trợ tiết kiệm giấy, đáp ứng tốt nhu cầu in văn bản và báo cáo trong môi trường văn phòng Đây là lựa chọn đáng tin cậy cho doanh nghiệp cần một chiếc máy in bền bỉ và hiệu quả chi phí', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 40 ppm (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: LAN#Khổ giấy hỗ trợ: A6; Oficio; 7 3/4 Envelope; 9 Envelope; JIS-B5; A4; Pháp lý; A5; Thư; B5 Envelope; Statement; C5 Envelope; Executive; Universal; DL Envelope; Folio; 10 Envelope#Dung lượng khay giấy: Tiêu chuẩn: 350 trang; Tối đa: 900 trang; Khay ra: 150 trang#Mực in kèm máy: Lexmark MS/MX331 (55B3000)#Kích thước: 222 x 368 x 363 mm#Trọng lượng: 93 Kg', 'Lexmark', DEFAULT, 6190000.00, 0.06, 59, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (3, 1, 'Máy in laser đen trắng Lexmark B2236dw (18M0136)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 34-36 trang/phút A6', 'Máy in laser đen trắng Lexmark B2236DW thuộc dòng máy in văn phòng đến từ thương hiệu Lexmark Sản phẩm đáp ứng nhu cầu in ấn văn phòng và gia đình nhờ thiết kế nhỏ gọn Tốc độ in ấn tượng lên đến 34 trang/phút và khả năng in hai mặt tự động tiết kiệm thời gian Máy in Lexmark còn tích hợp kết nối Wi-Fi linh hoạt, hỗ trợ in di động qua AirPrint và Mopria Với hiệu suất ổn định, chi phí vận hành hợp lý, đây là giải pháp hoàn hảo cho văn phòng nhỏ, doanh nghiệp vừa, gia đình và sinh viên', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 34 ppm (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 20; Ethernet 10/100BaseTX; Wireless 80211b/g/n#Khổ giấy hỗ trợ: A6; Oficio; 7 3/4 Envelope; 9 Envelope; JIS-B5; A4; Pháp lý; A5; Thư; B5 Envelope; Statement; C5 Envelope; Executive; Universal; DL Envelope; Folio; 10 Envelope#Dung lượng khay giấy: Nạp: 251 trang; Ra: 150 trang#Mực in kèm máy: Lexmark B223000#Kích thước: 215 x 355 x 333 cm#Trọng lượng: 68 Kg', 'Lexmark', DEFAULT, 3990000.00, 0.09, 150, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (4, 1, 'Máy in laser trắng đen Canon LBP6030B', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 18 trang/phút  A4/A5', 'Máy in laser trắng đen Canon LBP6030B thiết kế nhỏ gọn, hiện đại cùng khả năng in ấn nhanh chóng, sắc nét là lựa chọn tối ưu dành cho các văn phòng Thiết bị không chỉ đảm bảo chất lượng in đen trắng vượt trội mà còn giúp tiết kiệm chi phí nhờ khả năng tiết kiệm năng lượng và mực in hiệu quả Nếu bạn đang tìm kiếm một chiếc máy in laser đen trắng hiệu quả và dễ sử dụng, Canon LBP6030B chính là lựa chọn không thể bỏ qua', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In#Tốc độ in: 18 trang/phút (trắng đen)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: Canon Cartridge 325#Kích thước: 364 x 249 x 199 mm#Trọng lượng: 5 Kg', 'Canon', DEFAULT, 2990000.00, 0.09, 100, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (5, 1, 'Máy in HP Laser 108a (4ZB79A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 21 trang/phút A4/A5/B5', 'Máy in HP Laser 108a (4ZB79A) là lựa chọn lý tưởng cho văn phòng hiện đại với nhu cầu in ấn tài liệu cơ bản tăng cao Thiết kế nhỏ gọn, công nghệ máy in laser tiên tiến và hiệu suất ấn tượng giúp máy đáp ứng tốt yêu cầu in ấn hàng ngày Khả năng kết nối đa dạng và tính năng in di động qua  USB 20 mang lại sự linh hoạt tối đa, khiến HP Laser 108a trở thành trợ thủ đắc lực trong mọi văn phòng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In#Tốc độ in: 21 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5; B5#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 110A (W1110A)#Kích thước: 331 x 215 x 178 mm#Trọng lượng: 418 Kg', 'HP', DEFAULT, 2990000.00, 0.13, 70, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (6, 1, 'Máy in Laser màu đơn năng Brother HL-L3280CDW', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 26-27 trang/phút A4, A5, A6', 'Máy in Laser màu đơn năng Brother HL-L3280CDW là một trong những thiết bị in ấn lý tưởng cho các văn phòng hiện đại Với thiết kế nhỏ gọn ấn tượng, tính năng in ấn hiệu suất cao, tốc độ in nhanh, in đa dạng loại giấy và kích cỡ, cùng nhiều lựa chọn kết nối, máy in này mang lại sự tiện lợi và hiệu quả cho công việc hàng ngày tại các văn phòng', 'Loại máy in: Máy In Laser màu#Tính năng: In, In 2 mặt#Tốc độ in: 26 trang/phút (trắng đen); 26 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; Letter; B5 (JIS/ISO); A5; B6 (JIS); A6; Executive; Legal; Folio; Mexico Legal; India Legal; 16K; COM-10; DL; C5; Monarch#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 150 tờ#Mực in kèm máy: Brother TN269BK; TN269C; TN269M; TN269Y#Kích thước: 399 × 399 × 274 mm#Trọng lượng: 156 Kg', 'Brother', DEFAULT, 7890000.00, 0.05, 95, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (7, 1, 'Máy in Laser màu đơn năng Brother HL-L3240CDW', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 26-27 trang/phút A4, A5, A6', 'Máy in Laser màu đơn năng Brother HL-L3240CDW là giải pháp in ấn lý tưởng cho những ai đang tìm kiếm thiết bị nhỏ gọn, hiệu quả cao và mang đến những bản in chất lượng sắc nét Với khả năng in nhanh, hỗ trợ in màu chất lượng và nhiều tính năng tiện lợi, sản phẩm này sẽ đáp ứng tốt nhu cầu in ấn cho văn phòng, mang đến sự linh hoạt và tiết kiệm thời gian Hãy cùng Phong Vũ tìm hiểu chi tiết về những đặc điểm của sản phẩm này nhé!', 'Loại máy in: Máy In Laser màu#Tính năng: In, In 2 mặt#Tốc độ in: 26 trang/phút (trắng đen); 26 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; Letter; B5 (JIS/ISO); A5; A5 (Long Edge); B6 (JIS); A6; Executive; Legal; Folio; Mexico Legal; India Legal; 16K; A4 Short; COM-10; DL; C5; Monarch#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 150 tờ#Mực in kèm máy: Brother TN269BK; TN269C; TN269M; TN269Y#Kích thước: 399 x 399 x 239 mm#Trọng lượng: 154 Kg', 'Brother', DEFAULT, 7390000.00, 0.05, 55, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (8, 2, 'Máy in phun màu Epson L1216 STD', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 10-33 trang/phút A4', 'Trong thời đại công nghệ số hiện nay, nhu cầu in ấn vẫn đóng một vai trò quan trọng trong công việc và cuộc sống hàng ngày Từ các tài liệu văn bản, báo cáo, hợp đồng đến hình ảnh, bản vẽ thiết kế, việc sở hữu một chiếc máy in đáng tin cậy và hiệu quả là điều cần thiết Máy in phun màu Epson L1216 STD là một sản phẩm nổi bật, đáp ứng đầy đủ các yêu cầu của người dùng văn phòng với tính năng đa dạng, hiệu suất ổn định và chi phí vận hành tiết kiệm Máy in Epson L1216 STD được thiết kế với kiểu dáng nhỏ gọn, hiện đại, phù hợp với mọi không gian làm việc Với kích thước 482 x 300 x 145mm và trọng lượng chỉ 2,8kg, máy in dễ dàng di chuyển và bố trí ở bất kỳ vị trí nào trong văn phòng Bên cạnh đó, hệ thống bình mực tích hợp được đặt ở phía trước giúp việc nạp mực trở nên dễ dàng và thuận tiện hơn bao giờ hết', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 10 ipm (ISO đen); 5 ipm (ISO màu); 33 trang/phút (nháp đen); 15 trang/phút (nháp màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: Legal; Indian-Legal; Letter; A4; 16K; B5; A5; B6; A6; Hagaki; 5x7\"; 5x8\"; 4x6\"; Envelopes (#10, DL, C6)#Dung lượng khay giấy: Tiêu chuẩn: 100 tờ; Khay ra: 20 tờ#Mực in kèm máy: Epson 003 Đen (C13T00V100)#Kích thước: 375 x 347 x 169 mm#Trọng lượng: 28 Kg', 'Epson', DEFAULT, 3990000.00, 0.18, 42, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (9, 1, 'Máy in HP LaserJet Tank 1502w (2R3E2A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 22-23 trang/phút A6; A5; A4', 'Máy in HP LaserJet Tank 1502w là một trong những sản phẩm mới nhất của HP, được thiết kế đặc biệt để đáp ứng nhu cầu in ấn văn bản chất lượng cao với chi phí thấp cho các văn phòng nhỏ, hộ gia đình và cá nhân Với hệ thống mực in tích hợp và kết nối không dây linh hoạt, máy in laser này hứa hẹn sẽ mang đến trải nghiệm in ấn chuyên nghiệp và tiện lợi Máy in HP LaserJet Tank 1502w (2R3E2A) mang trên mình thiết kế tinh tế với kích thước nhỏ gọn trở thành lựa chọn hoàn hảo cho mọi không gian, từ những văn phòng rộng lớn đến những góc làm việc nhỏ bé trong ngôi nhà của bạn Sắc trắng đen tinh tế của máy in HP LaserJet Tank 1502w hòa quyện một cách hài hòa với các thiết bị văn phòng khác, tạo nên một không gian làm việc thống nhất và phong cách', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In#Tốc độ in: 22 trang/phút (trắng đen)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A6; A5; A4; Env số 10; C5 Env; DL Env; B5 Env; B5(JIS); B6 (JIS); Officio 216 x 340; Tùy chỉnh#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 154A Black#Kích thước: 3487 x 3905 x 2148 mm#Trọng lượng: 62 Kg', 'HP', DEFAULT, 4890000.00, 0.08, 36, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (10, 1, 'Máy in HP Laser 108w (4ZB80A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 20 trang/phút A4; A5; B5', 'Máy in HP Laser 108w là một trong những sản phẩm nổi bật, được thiết kế đặc biệt dành cho các văn phòng nhỏ, gia đình và những cá nhân có nhu cầu in ấn văn bản và đồ họa chất lượng cao Với tốc độ in nhanh, độ phân giải cao, kích thước nhỏ gọn và dễ sử dụng, máy in laser đáp ứng nhu cầu in ấn hàng ngày, mang đến trải nghiệm người dùng tuyệt vời với các tính năng thông minh và hiện đại Máy in HP Laser 108w (4ZB80A) được thiết kế nhỏ gọn, tinh tế và hiện đại, phù hợp với mọi không gian làm việc từ văn phòng lớn đến góc làm việc nhỏ trong nhà Với kích thước nhỏ gọn 178 x 215x 331 mm và trọng lượng chỉ 418kg, Máy in HP Laser 108w có thể dễ dàng di chuyển và đặt ở bất kỳ đâu trong văn phòng hoặc nhà bạn mà không chiếm nhiều không gian', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In#Tốc độ in: 20 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; WiFi#Khổ giấy hỗ trợ: A4; A5; A5(LEF); B5 (JIS); Oficio; Envelope (DL, C5); Tùy chỉnh (76 x 127 - 216 x 356 mm)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 110A (W1112A)#Kích thước: 331 x 215 x 178 mm#Trọng lượng: 418 Kg', 'HP', DEFAULT, 3490000.00, 0.11, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (11, 1, 'Máy in laser trắng đen Canon LBP122DW', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 185-29 trang/phút A4, A5, A6, B5', 'Máy in laser trắng đen Canon LBP122WD là dòng máy in đơn năng hiện đại, được trang bị tính năng in 2 mặt tự động Máy in LBP122DW đáp ứng mọi nhu cầu in ấn văn phòng cơ bản Phù hợp với các doanh nghiệp vừa và nhỏMáy in Canon LBP122DW sở hữu thiết kế nhỏ gọn với kích thước 356 x 283 x 213mm (rộng - sâu - cao), nhỏ gọn hơn nhiều so với các dòng máy in có mặt trên thị trường Trọng lượng chỉ 6kg dễ dàng di chuyển và lắp đặt ở bất kỳ đâu như: kệ sách, bàn làm việc, hay những góc bàn chật hẹp mà không chiếm quá nhiều diện tích Máy in LBP122DW có kiểu dáng thiết kế tối giản, với màu đen chủ đạo phù hợp cho không gian văn phòng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 29 trang/phút (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; B5; A6; Legal; Letter; Executive; Statement; OFFICIO; B-OFFICIO; M-OFFICIO; GLTR; GLGL; Foolscap; 16K; Envelop (COM10, Monarch, DL, C5); Tùy chỉnh#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 50 tờ#Mực in kèm máy: Canon 071 Black (5645C003)#Kích thước: 356 x 283 x 213 mm#Trọng lượng: 65 Kg', 'Canon', DEFAULT, 6590000.00, 0.24, 76, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (12, 1, 'Máy in trắng đen đơn năng Brother HL-B2180DW', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 34-36 trang/phút A4, A5, A6, B5', 'Máy in trắng đen đơn năng Brother HL-B2180DW sẽ là sản phẩm hoàn hảo cho nhu cầu văn phòng Không chỉ nổi bật với tốc độ in nhanh chóng và chất lượng sắc nét, thiết bị còn hỗ trợ in ấn không dây tiện lợi cùng khả năng tiết kiệm mực vượt trội Hãy cùng tìm hiểu về mẫu máy in Brother thông minh này qua các ưu điểm bên dưới nhé! Máy in trắng đen đơn năng Brother HL-B2180DW kích thước 356 mm × 360 mm × 183 mm tối ưu diện tích Máy in trắng đen đơn năng Brother HL-B2180DW tốc độ in lên đến 34/36 trang mỗi phút Độ phân giải 1200 x 1200 dpi tạo nên bản in sắc nét ', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 34/36 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; Wifi 24GHz; Wifi 5GHz#Khổ giấy hỗ trợ: A4; Letter; B5 (JIS/ISO); A5; A5 (Long Edge); B6 (JIS); A6; Executive; Legal; Mexico Legal; India Legal; Folio; 16K; A4 Short; COM-10; DL; C5; Monarch#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 150 tờ#Mực in kèm máy: Brother TN-B027#Kích thước: 360 x 356 x 183 mm#Trọng lượng: 75 Kg', 'Brother', DEFAULT, 4790000.00, 0.00, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (13, 1, 'Máy in trắng đen đơn năng Brother HL-B2100D', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 34-36 trang/phút A4, A5, A6, B5', 'Trong thời đại số hóa hiện nay, việc sở hữu một chiếc máy in chất lượng là rất cần thiết cho cả văn phòng hay nơi làm việc tại gia Brother HL-B2100D là kiểu máy in laser với thiết kế nhỏ gọn và hiệu suất ấn ấn tượng, trở thành sự lựa chọn lý tưởng và tiết kiệm cho người dùng Với khả năng in nhanh chóng, chất lượng bản in sắc nét, Brother HL-B2100D sẽ giúp bạn tiết kiệm thời gian và nâng cao hiệu suất Hãy cùng Phong Vũ tìm hiểu chi tiết các đặc điểm của sản phẩm này nhé!', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 34/36 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; Letter; B5 (JIS/ISO); A5; A5 (Long Edge); B6 (JIS); A6; Executive; Legal; Mexico Legal; India Legal; Folio; 16K; A4 Short; COM-10; DL; C5; Monarch#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 150 tờ#Mực in kèm máy: Brother TN-B027#Kích thước: 360 x 356 x 183 mm#Trọng lượng: 75 Kg', 'Brother', DEFAULT, 3890000.00, 0.00, 265, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (14, 2, 'Máy in phun màu Canon G1730', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 11 trang/phút A4, A5, A6, B5', 'Máy in phun màu Canon G1730 là một giải pháp hoàn hảo cho nhu cầu in ấn đa dạng của bạn Với thiết kế nhỏ gọn, chất lượng bản in độ phân giải in tối đa lên đến 4,800 x 1,200 dpi và tốc độ in lên tới 11 trang mỗi phút giúp bạn tạo ra những bản in sắc nét và nhanh chóng Đây là sản phẩm in ấn ấn tượng trong phân khúc giá rẻ, phù hợp với nhu cầu in ấn thường ngày trong văn phòng', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 11 trang/phút (trắng đen); 6 trang/phút (màu)#Độ phân giải: 1200 x 4800 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5; A6; B5; LTR; LGL; Executive; Oficio2; B-Oficio; M-Oficio; Legal; Foolscap#Mực in kèm máy: Canon GI-71 (Pigment Black)#Kích thước: 416 x 557 x 267 mm#Trọng lượng: 46 Kg', 'Canon', DEFAULT, 3590000.00, 0.25, 97, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (15, 1, 'Máy in HP Smart Tank 210 (3D4L3A)', 'Phù hợp: Văn phòng, Học sinh - Sinh viên#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 12-22 trang/phút (trắng đen) - 5-16 trang/phút (màu) A4; B5; A6; DL envelope, legal', 'Máy in HP Smart Tank 210 là một trong những lựa chọn hàng đầu cho những ai tìm kiếm sự tiện lợi, hiệu suất vượt trội và tiết kiệm chi phí Sản phẩm trang bị công nghệ in phun màu tiên tiến, đảm bảo bản in sắc nét và giúp tiết kiệm mực một cách hiệu quả Với thiết kế thông minh và tính năng kết nối không dây, HP Smart Tank 210 sẽ là giải pháp hoàn hảo cho mọi nhu cầu in ấn văn phòng Hãy cùng khám phá chi tiết những tính năng nổi bật của sản phẩm này nhé! Máy in HP Smart Tank 210 là sản phẩm đáp ứng nhu cầu in ấn văn phòng, học sinh và sinh viên một cách thuận lợi với khả năng kết nối không dây, công nghệ in phun màu tiên tiến Tốc độ in ấn nhanh chóng, ổn định cùng độ phân giải 1200 x 1200 dpi sẽ đảm bảo chất lượng in rõ nét, chuyên nghiệp Nếu bạn đang cần tìm loại máy in chất lượng, hãy đến ngay hệ thống showroom Phong Vũ để chọn cho mình các sản phẩm chính hãng cùng nhiều ưu đãi hấp dẫn nhé!', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 12 trang/phút (ISO trắng đen); 22 trang/phút (nháp trắng đen); 5 trang/phút (ISO màu); 16 trang/phút (nháp màu)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; Wi-Fi Direct#Khổ giấy hỗ trợ: A4; B5; A6; DL envelope; legal#Dung lượng khay giấy: Tiêu chuẩn: 100 tờ; Khay ra: 30 tờ; Phong bì: 10; Thẻ: 30#Mực in kèm máy: HP GT53 (Black); HP GT52 (Cyan); HP GT52 (Magenta)#Kích thước: 4341 x 360 x 1345 mm#Trọng lượng: 373 Kg', 'HP', DEFAULT, 3490000.00, 0.00, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (16, 2, 'Máy in phun màu Epson L18050', 'Phù hợp: Văn phòng, Doanh nghiệp#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 22 trang/phút A6, A5, A4, A3', 'Máy in phun màu Epson L18050 là một trong những sản phẩm nổi bật của Epson, được thiết kế để đáp ứng nhu cầu in ấn đa dạng, từ văn bản đến hình ảnh chất lượng cao Với khả năng in ấn linh hoạt và hiệu suất cao, sản phẩm này phù hợp cho cả văn phòng và nhu cầu cá nhân', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 15 trang/phút (màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20; Wi-Fi; Wi-Fi Direct#Khổ giấy hỗ trợ: A6; A5; A4; A3; A3+; B6; B5; B4; 8K; 16K; Indian-Legal; Letter#Mực in kèm máy: Epson 057 (Black)#Kích thước: 523 x 369 x 150 mm#Trọng lượng: 8 Kg', 'Epson', DEFAULT, 20190000.00, 0.08, 185, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (17, 2, 'Máy in phun màu wifi EPSON L8050', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 8-22 trang/phút A4', 'Máy in phun màu wifi EPSON L8050 là một trong những lựa chọn hàng đầu cho những ai đang tìm kiếm một thiết bị in ấn chất lượng cao, tiện lợi và đa năng Với khả năng in ấn sắc nét, kết nối không dây linh hoạt và thiết kế nhỏ gọn, EPSON L8050 không chỉ đáp ứng tốt nhu cầu in ấn văn phòng mà còn phù hợp cho những dự án sáng tạo cá nhân', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 8 trang/phút (trắng đen); 8 trang/phút (màu); 22 trang/phút (nháp); 12 giây/ảnh (10x15)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20; Wifi; Wi-Fi Direct#Khổ giấy hỗ trợ: A4; Letter; 8 x 10\"; 5 x 7\"; 4 x 6\"; 16:9 Wide; 100 x 148 mm; 35 x 5\"; Envelopes (#10, DL, C6)#Mực in kèm máy: Epson 057 (Black)#Kích thước: 403 x 369 x 149 mm#Trọng lượng: 6 Kg', 'Epson', DEFAULT, 8090000.00, 0.14, 34, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (18, 2, 'Máy in màu Epson L121', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 9 ipm A4, Letter, Legal (85 x 14\")', 'Máy in màu Epson L121 là một trong những lựa chọn hàng đầu cho những ai đang tìm kiếm một thiết bị in ấn hiệu quả và tiết kiệm chi phí Với thiết kế nhỏ gọn, công nghệ in tiên tiến và khả năng in ấn vượt trội, Epson L121 không chỉ đáp ứng nhu cầu in ấn hàng ngày mà còn mang lại chất lượng bản in sắc nét và sống động Sự kết hợp hoàn hảo giữa hiệu suất và tính năng thân thiện với người dùng khiến máy in này trở thành một trợ thủ đắc lực cho cả cá nhân và doanh nghiệp', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 9 trang/phút (trắng đen); 48 trang/phút (màu)#Độ phân giải: 720 x 720 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; Letter; Legal (85 x 14\")#Mực in kèm máy: Epson 664 Black (C13T664100 / C13T664199)#Kích thước: 461 x 215 x 130 mm#Trọng lượng: 24 Kg', 'Epson', DEFAULT, 2890000.00, 0.00, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (19, 3, 'Máy in màu đa chức năng HP Color LaserJet Pro MFP 3303fdn (499M7A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, copy, scan, fax#Tốc độ/Khổ giấy: 25 trang/phút A4;A5;A6', 'Máy in HP Color LaserJet Pro MFP 3303FDN thuộc thương hiệu HP Sản phẩm là giải pháp in ấn đa chức năng lý tưởng dành cho văn phòng hiện đại, doanh nghiệp vừa và nhỏ, cũng như người dùng cá nhân Máy in đồng thời mang lại hiệu suất cao nhờ tốc độ in lên đến 25 trang/phút Khả năng in hai mặt tự động và kết nối linh hoạt qua Ethernet hoặc ứng dụng HP Smart Thiết kế gọn gàng, dễ sử dụng cùng khả năng tích hợp nhiều chức năng giúp tối ưu hóa không gian và quy trình làm việc', 'Loại máy in: Máy In Laser màu#Tính năng: In, Copy, Scan, Fax, In 2 mặt#Tốc độ in: 25 trang/phút (trắng đen); 25 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A4; A5; A6; B5 (JIS); B6 (JIS); 10 x 15 cm; Oficio 216 x 340 mm; 16K; Postcard (JIS); Envelope (B5, C5, DL); A5-R#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 222A Black (W2220A)#Kích thước: 418 x 41912 x 34132 mm#Trọng lượng: 171 Kg', 'HP', DEFAULT, 18990000.00, 0.11, 49, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (20, 2, 'Máy in phun đa chức năng Brother DCP-T530DW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Copy, Scan#Tốc độ/Khổ giấy: 16 trang/phút A4, A5, A6', 'Máy in phun đa chức năng Brother DCP-T530DW là thiết bị phù hợp cho nhu cầu văn phòng Với khả năng in, scan, copy trong một máy nhỏ gọn, DCP-T530DW nổi bật với tốc độ in trắng đen lên đến 16 trang/phút và in màu 9 trang/ phút Máy có thể kết nối không dây tiện lợi và hệ thống mực liên tục tiết kiệm chi phí vận hành Máy in thiết kế hiện đại, hiệu suất ổn định giúp tối ưu công việc in ấn hàng ngày, phù hợp cho văn phòng và các gia đình cần giải pháp in ấn hiệu quả', 'Loại máy in: Máy In Phun màu#Tính năng: In, Copy, Scan, In 2 mặt#Tốc độ in: 16 trang/phút (trắng đen); 9 trang/phút (màu)#Độ phân giải: 1200 x 6000 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; LTR; LGL; Folio; EXE; A5; A6; Photo; Indexcard; Photo-2L; C5 Envelope; Com-10; DL Envelope; Monarch; Photo-L; Mexico Legal; India Legal#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 20 tờ#Mực in kèm máy: Brother BTD100BK#Kích thước: 390 x 343 x 1485 mm#Trọng lượng: 72 Kg', 'Brother', DEFAULT, 4890000.00, 0.00, 46, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (21, 2, 'Máy in phun đa chức năng Brother DCP-T830DW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Copy, Scan#Tốc độ/Khổ giấy: 17 trang/phút A4, A5, A6', 'Máy in phun Brother DCP-T830DW là thiết bị đa chức năng 3 trong 1, tích hợp in, scan và copy, đáp ứng nhu cầu đa dạng của văn phòng nhỏ và gia đình Với tốc độ in nhanh 17 trang/phút (trắng đen) và 165 trang/phút (màu), cùng khả năng in hai mặt tự động, máy in giúp tiết kiệm thời gian và chi phí Kết nối không dây qua Wifi, AirPrint, Mopria và USB 20 mang lại sự linh hoạt khi in từ điện thoại, máy tính bảng hay laptop Hộp mực dung tích lớn cho phép in đến 7500 trang đen trắng, phù hợp với nhu cầu in ấn liên tục', 'Loại máy in: Máy In Phun màu#Tính năng: In, Copy, Scan, In 2 mặt#Tốc độ in: 17 trang/phút (trắng đen); 165 trang/phút (màu)#Độ phân giải: 1200 x 6000 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; LTR; LGL; Folio; EXE; A5; A6; Photo; Indexcard; Photo-2L; C5 Envelope; Com-10; DL Envelope; Monarch; Photo-L; Mexico Legal; India Legal#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 20 tờ#Mực in kèm máy: Brother BTD100BK#Kích thước: 435 x 418 x 180 mm#Trọng lượng: 96 Kg', 'Brother', DEFAULT, 6500000.00, 0.00, 79, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (22, 2, 'Máy in phun màu đa năng HP OfficeJet Pro 9730 (537P5C)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 18-22 trang/phút A4; A5; A6; B5', 'Máy in HP OfficeJet Pro 9730 (537P5C) là giải pháp máy in phun màu đa năng, hỗ trợ in, quét, sao chép khổ lớn đến A3, đáp ứng nhu cầu của doanh nghiệp hiện đại Thuộc phân khúc cao cấp, máy đạt tốc độ in 34 trang/phút với chế độ nháp và độ phân giải 4800 x 1200 dpi, mang lại bản in sắc nét, sống động Công nghệ Wi-Fi băng tần kép tự phục hồi và HP Wolf Pro Security đảm bảo kết nối an toàn', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 22 trang/phút (ISO trắng đen); 18 trang/phút (ISO màu); 34 trang/phút (nháp)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; WiFi 80211n 24/5GHz#Khổ giấy hỗ trợ: A4; A5; A6; B5 (JIS); Envelope (DL, C5, C6, Chou #3, Chou #4); Card (Hagaki); A3#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 75 tờ#Mực in kèm máy: HP 938 Black#Kích thước: 581 x 467 x 386 mm#Trọng lượng: 195 Kg', 'HP', DEFAULT, 13990000.00, 0.00, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (23, 1, 'Máy in HP Laser MFP 136w (4ZB86A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 20 trang/phút A4, A5', 'Máy in HP Laser MFP 136w (4ZB86A) chính là giải pháp hoàn hảo cho các doanh nghiệp cũng như văn phòng nhỏ và vừa, đáp ứng nhu cầu in ấn đa dạng một cách hiệu quả Là dòng máy in laser với thiết kế tinh tế và nhỏ gọn, máy không chỉ tiết kiệm không gian mà còn mang đến những tính năng vượt trội như In, Copy và Scan, giúp tối ưu hóa quy trình làm việc', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy#Tốc độ in: 20 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; A5; A5 (LEF); B5 (JIS); Oficio; Phong bì (DL, C5)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 110A Đen#Kích thước: 406 x 3596 x 253 mm#Trọng lượng: 746 Kg', 'HP', DEFAULT, 4590000.00, 0.04, 205, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (24, 2, 'Máy in phun màu đa năng Canon E410', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 8 ipm A4/A5', 'Máy in phun màu đa năng Canon E410 là lựa chọn hàng đầu cho những ai cần một thiết bị in ấn chất lượng cao trong văn phòng Thiết kế nhỏ gọn, hiệu suất vượt trội trong in ấn, quét và sao chép, cùng khả năng kết nối linh hoạt, Canon E410 không chỉ tiết kiệm không gian mà còn nâng cao hiệu quả công việc Với giá cả phải chăng, việc sở hữu máy in đa năng Canon E410 là quyết định thông minh, giúp bạn hoàn thành công việc in ấn nhanh chóng và chuyên nghiệp', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 80 ipm (trắng đen); 40 ipm (màu)#Độ phân giải: 4800 x 600 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5; B5; Letter; Legal; 4 x 6\"; 5 x 7\"; Envelopes (DL, COM10); Custom size (width 1016 - 2159mm, length 1524 - 676mm)#Mực in kèm máy: Canon PG-47#Kích thước: 426 x 306 x 145 mm#Trọng lượng: 34 Kg', 'Canon', DEFAULT, 1390000.00, 0.00, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (25, 1, 'Máy in HP Laser MFP 139FNW (A0NU1A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 20 trang/phút A4; A5; A5(LEF); B5 (JIS)', 'Máy in HP Laser MFP 139FNW (A0NU1A) có thiết kế nhỏ gọn, giao diện thân thiện và hiệu suất in ấn ấn tượng, máy in này đáp ứng tốt nhu cầu in ấn tài liệu cơ bản, từ các báo cáo, hợp đồng đến tài liệu nội bộ Sự kết hợp giữa công nghệ in laser tiên tiến và các tính năng tiện ích như sao chép, quét, cùng với khả năng kết nối đa dạng, giúp người dùng dễ dàng thực hiện các tác vụ văn phòng một cách nhanh chóng và thuận tiện', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy#Tốc độ in: 20 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A5 (LEF); B5 (JIS); Oficio; Envelope (DL, C5)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 110A (W1112A)#Kích thước: 406 x 3596 x 3087 mm#Trọng lượng: 858 Kg', 'HP', DEFAULT, 4890000.00, 0.04, 105, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (26, 1, 'Máy in Laser màu đa năng Brother DCP-L3560CDW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 26-27 trang/phút A4, A5, A6', 'Máy in Laser màu đa năng Brother DCP-L3560CDW là lựa chọn lý tưởng cho văn phòng hiện đại, với thiết kế sang trọng, tính năng đa dạng và kết nối linh hoạt Máy giúp tiết kiệm thời gian và nâng cao chất lượng in ấn nhờ công nghệ tiên tiến, đáp ứng tốt nhu cầu in, quét và sao chép tài liệu độ phân giải cao Máy phù hợp với mọi công việc in ấn tài liệu, giấy tờ hoặc các ấn phẩm báo cáo trong văn phòng', 'Loại máy in: Máy In Laser màu#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 26 trang/phút (trắng đen); 26 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; Letter; B5 (JIS); B5 (ISO); A5; A5 (Long Edge); B6 (JIS); A6; Executive; Legal; Folio; Mexico Legal; India Legal; 16K (195x270mm); A4 Short (270mm Paper); COM-10; DL; C5; Monarch#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 150 tờ#Mực in kèm máy: Brother TN269BK#Kích thước: 410 x 444 x 401 mm#Trọng lượng: 202 Kg', 'Brother', DEFAULT, 11790000.00, 0.00, 154, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (27, 1, 'Máy in laser trắng đen đa năng Canon MF272DW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 29-30 trang/phút A4, A5, A6, B5', 'Máy in đa năng Canon MF272dw là sản phẩm tích hợp khả năng in, sao chép, quét màu và in đảo mặt, đáp ứng đầy đủ các nhu cầu công việc văn phòng Thiết kế máy nhỏ gọn với kích thước 372 x 320 x 271 mm, trọng lượng 85 kg dễ dàng bố trí trong mọi không gian, mang lại sự tiện nghi tối ưu Nếu bạn đang cần tìm sản phẩm in ấn thuộc chất lượng, Canon MF272dw sẽ cung cấp những ưu điểm tuyệt vời đến người dùng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 29 trang/phút (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; Legal; Letter; Executive; Statement; Foolscap; Government Letter; Government Legal; Indian Legal; Index Card; Postcard; Envelope (COM10, Monarch, DL, C5); Custom (Min 76 x 127 mm to Max 216 x 356 mm)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: Canon 071 Black (5645C003)#Kích thước: 372 x 320 x 271 mm#Trọng lượng: 85 Kg', 'Canon', DEFAULT, 9690000.00, 0.02, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (28, 1, 'Máy in Laser đa năng Canon MF 275DW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 18-19 trang/phút A4, A5, A6, B5', 'Máy in Laser đa năng Canon MF 275DW là lựa chọn hoàn hảo cho văn phòng và gia đình có nhu cầu in ấn tài liệu với nhiều tính năng vượt trội Máy in Laser Canon không chỉ cho phép in, sao chép và quét tài liệu mà còn tiết kiệm thời gian với tốc độ in nhanh và chất lượng bản in sắc nét Với khả năng kết nối Wi-Fi, bạn có thể dễ dàng in từ điện thoại di động hoặc máy tính bảng, mang lại sự tiện lợi tối đa', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 30 trang/phút (trắng đen)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; Legal; Letter; Executive; Statement; Foolscap; Government Letter; Government Legal; Indian Legal; Index Card; Postcard; Envelope (COM10, Monarch, DL, C5); Custom (min 76 x 127 mm to max 216 x 356 mm)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: Canon 071#Kích thước: 390 x 374 x 368 mm#Trọng lượng: 111 Kg', 'Canon', DEFAULT, 11790000.00, 0.09, 94, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (29, 2, 'Máy in phun màu Epson L6270', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 33 trang/phút A4, B5, A5, A6', 'Máy in phun màu Epson L6270 một sản phẩm với khả năng in ra  chất lượng hình ảnh sắc nét, chân thực thích hợp cho các công việc in quảng cáo, thiệp mời…Sản phẩm máy in Epson với thiết kế nhỏ gọn nhưng cũng không kém phần hiện đại phù hợp với nhiều môi trường làm việc', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 33 trang/phút (trắng đen); 20 trang/phút (màu)#Độ phân giải: 1200 x 4800 dpi#Kết nối: USB 20; LAN; Wifi; Wi-Fi Direct#Khổ giấy hỗ trợ: Legal (85 x 14\"); 85 x 13\"; Letter; A4; B5; A5; A6; Hagaki (100 x 148 mm); 16K (195 x 270 mm); Indian-Legal (215 x 345 mm); B6; 5 x 7\"; 4 x 6\"; Phong bì (#10, DL, C6)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 30 tờ#Mực in kèm máy: Epson 001 Black (C13T03Y100)#Kích thước: 375 x 347 x 231 mm#Trọng lượng: 67 Kg', 'Epson', DEFAULT, 10690000.00, 0.03, 56, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (30, 1, 'Máy in đa chức năng HP LaserJet M440dn (8AF47A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 24 trang/phút A3; A4; A5; A6; B4', 'Máy in đa chức năng HP LaserJet M440dn là thiết bị in ấn chuyên nghiệp với khả năng in, sao chép, quét trong cùng một thiết bị Sở hữu độ phân giải in tối đa 1200 x 1200 dpi, tốc độ in 24 trang/phút, và khả năng in hai mặt tự động, máy đáp ứng tốt nhu cầu sử dụng trong văn phòng hiện đại Với kết nối USB 20, Ethernet 10/100 Base TX, và hỗ trợ đa dạng hệ điều hành, là dòng máy in laser HP LaserJet M440dn mang đến sự tiện lợi và hiệu quả Hộp mực chính hãng HP 335A, 335X đảm bảo chất lượng in tối ưu, tiết kiệm chi phí vận hành', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 13 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A3; A4; A5; A6; B4 (JIS); B5 (JIS); 8K; 16K; Oficio 216x340mm#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 335A (W1335A)#Kích thước: 560 x 540 x 417 mm#Trọng lượng: 315 Kg', 'HP', DEFAULT, 18190000.00, 0.00, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (31, 2, 'Máy in Epson L3250', 'Phù hợp: Văn phòng, Đồ họa - Kỹ thuật, Doanh nghiệp#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 10-33 trang/phút A4; A5; A6; B4', 'Máy in Epson L3250 được thiết kế để cải thiện được việc tiết kiệm chi phí kinh doanh và năng suất in Máy in đa năng EcoTank L3250 còn mang đến cho người dùng khả năng kết nối không dây tiện lợi, cho phép in trực tiếp từ các thiết bị thông minh Thiết kế Máy in Epson L3250 nhỏ gọn, bình mực năng suất cao Máy in Epson L3250 được thiết kế nhỏ gọn và có kiểu dáng đẹp, máy có màu đen truyền thống toát lên vẻ chuyên nghiệp và sang trọng nhưng vẫn không kém phần nổi bật Máy sẽ giúp bạn tiết kiệm được không gian để có thể trưng bày các vật dụng khác, máy dễ vệ sinh và bảo quản', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 33 trang/phút (nháp trắng đen); 10 trang/phút (tiêu chuẩn trắng đen); 15 trang/phút (nháp màu); 5 trang/phút (tiêu chuẩn màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20; Wifi; Wi-Fi Direct#Khổ giấy hỗ trợ: Legal (85 x 14\"); Indian-Legal (215 x 345 mm); 85 x 13\"; Letter; A4; 16K (195 x 270 mm); B5; A5; B6; A6; Hagaki (100 x 148 mm); 5 x 7\"; 5 x 8\"; 4 x 6\"; Phong bì (#10, DL, C6)#Dung lượng khay giấy: Tiêu chuẩn: 100 tờ; Khay ra: 30 tờ#Mực in kèm máy: Epson 003 Black (C13T00V100)#Kích thước: 375 x 347 x 179 mm#Trọng lượng: 39 Kg', 'Epson', DEFAULT, 4790000.00, 0.00, 78, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (32, 2, 'Máy in phun màu đa năng Epson L3216 STD', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 10-33 trang/phút A4, A5, A6', 'Máy in phun màu đa năng Epson L3216 STD là một thiết bị in ấn tích hợp nhiều tính năng vượt trội, mang đến sự tiện lợi tối đa cho người dùng Với khả năng in, scan và photo, Epson L3216 STD sẽ đáp ứng mọi nhu cầu in ấn tại văn phòng Nổi bật với thiết kế nhỏ gọn, hệ thống mực tiết kiệm và chất lượng in sắc nét, sản phẩm này sẽ giúp tối ưu hóa công việc của bạn', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 33 trang/phút (nháp trắng đen); 10 trang/phút (ISO trắng đen); 15 trang/phút (nháp màu); 5 trang/phút (ISO màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: Legal (85 x 14\"); Indian-Legal (215 x 345 mm); 85 x 13\"; Letter; A4; 16K (195 x 270 mm); B5; A5; B6; A6; Hagaki (100 x 148 mm); 5 x 7\"; 5 x 8\"; 4 x 6\"; Envelopes (#10, DL, C6)#Dung lượng khay giấy: Tiêu chuẩn: 100 tờ; Khay ra: 20 tờ#Mực in kèm máy: Epson 003 Black (C13T00V100)#Kích thước: 375 x 347 x 179 mm#Trọng lượng: 39 Kg', 'Epson', DEFAULT, 4590000.00, 0.02, 45, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (33, 2, 'Máy in phun trắng đen đa năng Epson M2170', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 39 trang/phút A4, A5, A6', 'Máy in phun trắng đen đa năng Epson M2170 là giải pháp in ấn văn bản đơn sắc chuyên nghiệp, hiệu quả và tiết kiệm chi phí, nhờ vào những tính năng ưu việt, tối ưu hóa quy trình in ấn và hiệu suất vượt trội mà nó mang lại Với thiết kế nhỏ gọn và tính năng đa năng, Máy in Epson M2170 là sự lựa chọn lý tưởng cho các doanh nghiệp, cơ quan hay nhu cầu cá nhân', 'Loại máy in: Máy In Phun trắng đen#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 20 trang/phút (trắng đen)#Độ phân giải: 1200 x 2400 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: Legal; Indian-Legal (215 x 345 mm); 85 x 13\"; Letter; A4; 16K (195 x 270 mm); B5; A5; B6; A6; Hagaki (100 x 148 mm); Envelopes (#10, DL, C6)#Mực in kèm máy: Epson 005S Black (C13T01P100)#Kích thước: 375 x 347 x 346 mm#Trọng lượng: 73 Kg', 'Epson', DEFAULT, 8390000.00, 0.01, 87, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (34, 2, 'Máy in phun đa năng màu Canon GX4070', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 18 trang/phút  A4, A5, A6, B5', 'Máy in phun đa năng màu Canon GX4070 là giải pháp hoàn hảo cho những ai tìm kiếm thiết bị in ấn chất lượng cao, tiết kiệm chi phí Sản phẩm có thiết kế tinh tế và tích hợp các tính năng đa dạng in, copy, scan và Fax đáp ứng nhu cầu văn phòng vượt trội Độ phân giải tối đa lên đến 1200 x 2400 dpi mang đến chất lượng in ấn rõ nét, chân thực', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 18 trang/phút (trắng đen); 13 trang/phút (màu)#Độ phân giải: 1200 x 2400 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; LTR; LGL; B-Oficio; M-Oficio; Foolscap; FS; Executive; Envelope#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ#Mực in kèm máy: Canon GI-76 Black#Kích thước: 399 x 719 x 304 mm#Trọng lượng: 95 Kg', 'Canon', DEFAULT, 20690000.00, 0.24, 64, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (35, 2, 'Máy in phun đa năng màu Canon GX3070', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 18 trang/phút  A4, A5, A6, B5', 'Máy in phun đa năng màu Canon GX3070 mang lại sự tiện lợi và hiệu quả cho công việc in ấn và góp phần nâng cao năng suất làm việc Với thiết kế hiện đại, tính năng đa dạng và chất lượng in vượt trội, sản phẩm này sẽ là trợ thủ đắc lực cho mọi văn phòng mà bạn nên đầu tư Nếu đang cần tìm loại máy in phun đa năng chất lượng, Canon GX3070 sẽ đáp ứng các tiêu chí một cách hoàn hảo', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 18 trang/phút (trắng đen); 13 trang/phút (màu)#Độ phân giải: 1200 x 2400 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; LTR; LGL; Foolsca; FS; Envelope; Card size#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ#Mực in kèm máy: Canon GI-76 PGBK#Kích thước: 399 x 719 x 303 mm#Trọng lượng: 83 Kg', 'Canon', DEFAULT, 15290000.00, 0.21, 64, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (36, 2, 'Máy in phun màu EPSON L850', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 37 trang/phút A4, A5, A6, B5', 'Máy in phun màu EPSON L850 là dòng máy in phun màu cao cấp với độ phân giải cao cho chất lượng bản in sắc nét và ấn tượng  Máy in L850 có thiết kế bắt mắt bởi tông màu đen quen thuộc đi kèm là kiểu dáng gọn gàng, dễ dàng bố trí ở các khu vực làm việc Máy in Epson L850 còn hỗ trợ nhiều chức năng như: scan, copy… giúp hỗ trợ công việc với tốc độ nhanh chóng và tiện lợi', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 37 trang/phút (trắng đen); 38 trang/phút (màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5; A6; B5; 10x15cm(4x6in); 13x18cm(5x7in); 9x13cm(35x5in); Letter(85x11in); Legal(85x14in); Half Letter(55x85in); 13x20cm(5x8in); 20x25cm(8x10in); 16:9 wide size; 100x148mm#Mực in kèm máy: Epson T6731 Black#Kích thước: 542 x 386 x 196 mm#Trọng lượng: 91 Kg', 'Epson', DEFAULT, 14999000.00, 0.00, 48, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (37, 4, 'Máy in kim EPSON LQ-2190', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 480-576 cpi', 'Máy in kim EPSON LQ-2190 là một lựa chọn tuyệt vời cho những doanh nghiệp và văn phòng có nhu cầu in ấn nhanh chóng, hiệu quả và linh hoạt Với công nghệ in kim Serial Impact Dot Matrix tiên tiến, máy in này mang lại tốc độ in ấn ấn tượng và khả năng in trên nhiều loại giấy khác nhau, từ giấy cắt đơn lẻ đến giấy cuộn và nhãn Được thiết kế với kích thước nhỏ gọn và trọng lượng nhẹ, EPSON LQ-2190 không chỉ tiết kiệm không gian mà còn dễ dàng sử dụng và vận hành', 'Loại máy in: Máy in Kim#Tính năng: In#Tốc độ in: 480 - 576 cpi (trắng đen)#Độ phân giải: 720 x 720 dpi#Kết nối: USB 20#Mực in kèm máy: Epson C13S015531#Kích thước: 639 x 402 x 256 mm#Trọng lượng: 13 Kg', 'Epson', DEFAULT, 19990000.00, 0.08, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (38, 4, 'Máy in kim EPSON LQ-310', 'Phù hợp: Văn phòng, Đồ họa - Kỹ thuật, Doanh nghiệp#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 347 ký tự/ giây A4/A5', 'Máy in kim EPSON LQ-310 xuất hiện đầu tiên với những cải tiến vượt trội so với các dòng máy in cũ Được trang bị đầu in 24 kim, độ phân giải 360 x 360 dpi, và tốc độ in tối đa lên đến 416 ký tự/giây, LQ-310 mang lại hiệu suất ấn tượng cho công việc in ấn khối lượng lớn Máy hỗ trợ in tối đa 4 bản (1 bản gốc và 3 bản sao), kết nối linh hoạt qua cổng USB, Serial và Parallel, cùng tuổi thọ lên đến 10,000 giờ, là giải pháp lý tưởng cho các doanh nghiệp', 'Loại máy in: Máy in Kim#Tính năng: In#Tốc độ in: High Speed Draft: 10cpi: 347 cps / 12cpi: 416 cps (trắng đen)#Độ phân giải: 360 x 360 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A4; A5#Mực in kèm máy: Epson C13S015639#Kích thước: 362 x 275 x 154 mm#Trọng lượng: 41 Kg', 'Epson', DEFAULT, 6100000.00, 0.00, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (39, 4, 'Máy in kim Epson LQ-780', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 10 cpi', 'Máy in kim Epson LQ-780 được thiết kế cho nhu cầu in ấn tài liệu liên tục và chứng từ nhiều liên Với tốc độ in đạt 487 ký tự/giây cùng bộ nhớ 128KB, thiết bị mang lại hiệu suất ổn định cho môi trường làm việc chuyên nghiệp Kết nối USB 20 giúp thao tác in nhanh và tiện lợi, tương thích tốt với các hệ điều hành Windows mới nhất Đây là lựa chọn phù hợp cho doanh nghiệp, phòng kế toán hay bộ phận hành chính cần in ấn khối lượng lớn', 'Loại máy in: Máy in Kim#Tính năng: In#Tốc độ in: 487 cps (10cpi) (trắng đen)#Độ phân giải: 360 x 180 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: Giấy tờ (một lớp và nhiều lớp); Giấy liên tục (một lớp và nhiều lớp); Giấy cuộn; Phong bì; Bìa cứng#Mực in kèm máy: Ribbon LQ780 (C13S015658)#Kích thước: 480 x 3013 x 211 mm#Trọng lượng: 67 Kg', 'Epson', DEFAULT, 17490000.00, 0.03, 78, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (40, 4, 'Máy in kim A4 EPSON LQ-680 Pro (khổ ngang)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 413 ký tự / giây A4, A5', 'Nếu doanh nghiệp của bạn đang tìm kiếm một sản phẩm máy in để đáp ứng nhu cầu in ấn tài liệu thường xuyên của mình thì sản phẩm máy in Epson LQ-680 Pro là thứ bạn cần Máy in kim có độ phân giải tương đối tốt Máy in Epson LQ-680 Pro là dạng máy in kim sử dụng băng mực kết hợp với sự kết hợp của các đầu mũi kim in lên giấy in để cho ra bản in có độ bền cao so với máy in nhiệt Máy in Epson LQ-680 Pro có độ phân giải 360 x 360 dpi, chất lượng tương đối ổn định để sử dụng trên các bản in đòi hỏi cần phải lưu trữ một thời gian dài', 'Loại máy in: Máy in Kim#Tính năng: In#Tốc độ in: 413 ký tự/giây (trắng đen)#Độ phân giải: 360 x 360 dpi#Khổ giấy hỗ trợ: A4; A5#Mực in kèm máy: Epson S015508#Kích thước: 497 x 387 x 230 mm#Trọng lượng: 94 Kg', 'Epson', DEFAULT, 20490000.00, 0.12, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (41, 4, 'Máy In Kim Epson LQ-350', 'Phù hợp: Văn phòng, Đồ họa - Kỹ thuật, Doanh nghiệp#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 347 ký tự/ giây A4/A5', 'Máy in hóa đơn Epson LQ-350 với khả năng in 24 kim trên khổ hẹp, là phiên bản nâng cấp của Epson LQ-300 Máy có thể in đồng thời 4 bản (1 bản chính và 3 bản sao) với tốc độ in ấn tượng 347 ký tự/giây ở chế độ nháp tốc độ cao, đảm bảo hiệu quả cao cho các nhu cầu in tài liệu nhiều bản Được trang bị tuổi thọ cao hơn các dòng máy trước, LQ-350 còn hỗ trợ đa dạng các cổng kết nối như Bidirectional parallel, USB 20 Type B, và RS-232, cho phép linh hoạt trong việc kết nối với nhiều thiết bị khác nhau LQ-350 giúp giảm chi phí kinh tế nhờ khả năng tiêu thụ điện năng thấp và hiệu suất cao Được thiết kế để phù hợp gọn gàng trên bàn làm việc, LQ-350 là lựa chọn lý tưởng cho các ứng dụng văn phòng phía trước và phía sau, cần liên tục in trên giấy liên tục hoặc giấy nhiều lớp', 'Loại máy in: Máy in Kim#Tính năng: In#Tốc độ in: Bản thảo tốc độ cao: 347 ký tự/giây (10 cpi); Nháp: 260 ký tự/giây (10 cpi); LQ: 86 ký tự/giây (10 cpi)#Độ phân giải: 360 x 180 DPI#Kết nối: USB 20; RS-232; Song song hai chiều#Khổ giấy hỗ trợ: Giấy tờ (đơn và đa lớp); Giấy liên tục (đơn và đa lớp); Nhãn; Giấy cuộn; Phong bì#Mực in kèm máy: Epson S015633 (Black)#Kích thước: 348 x 275 x 154 mm#Trọng lượng: 41 kg', 'Epson', DEFAULT, 5299000.00, 0.00, 61, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (42, 3, 'Máy in màu đa chức năng HP Color LaserJet Pro MFP 3303fdw,1Y WTY_499M8A', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, copy, scan, fax#Tốc độ/Khổ giấy: 25 trang/phút A4; A5; A6; B5 (JIS)', 'Máy in màu đa chức năng HP Color LaserJet Pro MFP 3303fdw,1Y WTY_499M8A thuộc thương hiệu HP Sản phẩm là giải pháp in ấn đa chức năng lý tưởng dành cho văn phòng hiện đại, doanh nghiệp vừa và nhỏ, cũng như người dùng cá nhân Máy in đồng thời mang lại hiệu suất cao nhờ tốc độ in lên đến 25 trang/phút Khả năng in hai mặt tự động và kết nối linh hoạt qua Ethernet hoặc ứng dụng HP Smart Thiết kế gọn gàng, dễ sử dụng cùng khả năng tích hợp nhiều chức năng giúp tối ưu hóa không gian và quy trình làm việc', 'Loại máy in: Máy In Laser màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 25 trang/phút (trắng đen); 25 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi; Fax#Khổ giấy hỗ trợ: A4; A5; A6; B5 (JIS); B6 (JIS); 10 x 15 cm; Oficio 216 x 340 mm; 16K (195 x 270 mm; 184 x 260 mm; 197 x 273 mm); Postcard (JIS); Envelope (B5; C5; DL); A5-R#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 222A Black (W2220A)#Kích thước: 418 x 41912 x 34132 mm#Trọng lượng: 171 Kg', 'HP', DEFAULT, 19190000.00, 0.00, 74, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (43, 3, 'Máy in Epson L5290', 'Phù hợp: Văn phòng, Đồ họa - Kỹ thuật#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 33 trang/phút A4, A5, A6, B5', 'Máy in Epson L5290 là một trong những lựa chọn hàng đầu cho những nhân viên văn phòng, đồ họa, kỹ thuật hoặc người dùng đang tìm kiếm một thiết bị in ấn đa năng và hiệu quả Với thiết kế nhỏ gọn, tính năng in ấn vượt trội cùng khả năng kết nối linh hoạt, máy in này không chỉ đáp ứng tốt nhu cầu in tài liệu mà còn hỗ trợ quét, sao chép và fax Đặc biệt, Epson L5290 còn nổi bật với độ phân giải in tối đa lên đến 5760 x 1440 DPI, cho chất lượng bản in sắc nét và sống động', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, Fax#Tốc độ in: 33 trang/phút (trắng đen); 15 trang/phút (màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: Legal (85 x 14\"); Indian-Legal (215 x 345 mm); 85 x 13\"; Letter; A4; 16K (195 x 270 mm); B5; A5; B6; A6; Hagaki (100 x 148 mm); 5 x 7\"; 5 x 8\"; 4 x 6\"; Envelopes (#10, DL, C6)#Mực in kèm máy: Epson 003 Black#Kích thước: 375 x 347 x 237 mm#Trọng lượng: 5 Kg', 'Epson', DEFAULT, 8390000.00, 0.00, 32, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (44, 3, 'Máy in canon 1643i Đa Năng', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 43 trang/phút A4, B5, A5, A5R, A6v', 'Máy in Canon 1643i đa năng nổi bật với hiệu suất mạnh mẽ và tốc độ in nhanh, hứa hẹn sẽ đáp ứng nhu cầu in ấn và sao chép tài liệu người dùng một cách chuyên nghiệp Sản phẩm có thiết kế tinh tế và tích hợp nhiều tính năng thông minh, bao gồm in, scan, copy và send đa năng trong một thiết bị duy nhất Đây là chiếc máy in đa năng lý tưởng giúp tối ưu hóa quy trình làm việc, tiết kiệm thời gian và chi phí, đồng thời đảm bảo chất lượng in ấn cao nhất', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, Fax#Tốc độ in: 33 trang/phút (trắng đen); 15 trang/phút (màu)#Độ phân giải: 5760 x 1440 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: Legal (85 x 14\"); Indian-Legal (215 x 345 mm); 85 x 13\"; Letter; A4; 16K (195 x 270 mm); B5; A5; B6; A6; Hagaki (100 x 148 mm); 5 x 7\"; 5 x 8\"; 4 x 6\"; Envelopes (#10, DL, C6)#Mực in kèm máy: Epson 003 Black#Kích thước: 375 x 347 x 237 mm#Trọng lượng: 5 Kg', 'Canon', DEFAULT, 34499000.00, 0.00, 97, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (45, 3, 'Máy in Epson Ecotank M15140', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 32 trang/phút A4, A3, B4, B5, A5', 'Máy in Epson Ecotank M15140 - máy in có thiết kế sang trọng, đẹp mắt cùng hiệu suất cao của thương hiệu Epson Đây là dòng máy cao cấp nhất phù hợp cho các doanh nghiệp, văn phòng, cửa hàng dịch vụ, muốn in tài liệu với số lượng nhiều với một mức giá cực phải chăn', 'Loại máy in: Máy In Phun trắng đen#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 32 trang/phút (trắng đen)#Độ phân giải: 4800 x 2400 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A3; Super B (13 x 19\"); Indian Legal; Letter; A4; 16K (195 x 270mm); 8K (270 x 390mm); Executive (725 x 105\"); B4; B5; A5; B6; A6; 85 x 13\"; Legal (85 x 14\"); 8 x 10\"; Phong bì (# 10, DL, C6, C4)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 50 tờ#Mực in kèm máy: Epson 008 Black#Kích thước: 515 x 500 x 350 mm#Trọng lượng: 202 Kg', 'Epson', DEFAULT, 18120000.00, 0.10, 132, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (46, 3, 'Máy in Epson M3170', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 39 trang/phút A4, A5, A6, B5, B6, C6, Letter, Legal, DL', 'Máy in Epson M3170 đến từ thương hiệu Epson thuộc kiểu máy in phun trắng đen sử dụng kết nối wifi và wifi trực tuyến Kết hợp với kiểu dáng sang trọng, hiện đại cũng như tiết kiệm được không gian diện tích nên sản phẩm rất phù hợp với doanh nghiệp và gia đình có nhu cầu in ấn', 'Loại máy in: Máy In Phun trắng đen#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 39 trang/phút (trắng đen)#Độ phân giải: 1200 x 2400 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; B6; C6; Letter; Legal; DL#Mực in kèm máy: Epson 005S Black (C13T01P100)#Kích thước: 375 x 347 x 346 mm#Trọng lượng: 73 Kg', 'Epson', DEFAULT, 9290000.00, 0.00, 81, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (47, 3, 'Máy in đa chức năng HP LaserJet M440n MFP,1Y WTY_8AF46A', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 13-24 trang/phút A3, A4, A5, A6,B4', 'Máy in đa chức năng HP LaserJet M440n MFP,1Y WTY_8AF46A hỗ trợ các chức năng như in, sao chép, quét hình ảnh, các loại tài liệu phù hợp với công việc văn phòng hàng ngày Chiếc máy in cao cấp với thiết kế hiện đại, kết nối nhanh chóng, sẽ giúp ích hiệu quả cho công việc của nhiều người dùng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, Fax#Tốc độ in: 24 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A3; A4; A5; A6; B4 (EXP); B5 (JIS)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ#Mực in kèm máy: HP 335A Black (W1335A)#Kích thước: 960 x 1090 x 933 mm#Trọng lượng: 25 Kg', 'HP', DEFAULT, 18999000.00, 0.23, 62, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (48, 3, 'Máy in màu Laser đa chức năng Brother MFC-L8340CDW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 30-31 trang/phút A4, A5, A6, B5', 'Máy in Brother MFC-L8340CDW với khả năng khởi động tức thì, bảng điều khiển cảm ứng trực quan và thiết kế nhỏ gọn, MFC-L8340CDW còn sở hữu tốc độ in ấn ấn tượng, chất lượng bản in sắc nét và khả năng tiết kiệm năng lượng vượt trội Các tính năng đa dạng như in, sao chụp, quét và fax được tích hợp một cách hoàn hảo, giúp người dùng tối ưu hóa hiệu suất công việc và tiết kiệm thời gian làm việc', 'Loại máy in: Máy In Laser màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 24 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A3; A4; A5; A6; B4 (EXP); B5 (JIS)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ#Mực in kèm máy: HP 335A Black (W1335A)#Kích thước: 960 x 1090 x 933 mm#Trọng lượng: 25 Kg', 'Brother', DEFAULT, 14990000.00, 0.00, 28, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (49, 3, 'Máy in laser màu HP Color LaserJet Pro M283fdw (7KW75A)', 'Phù hợp: Văn phòng - Tính năng: Đa chức năng Print, Scan, Copy, Fax - Tốc độ/Khổ giấy: 22 trang/phút A4; A5; A6; B5', 'Máy in laser màu HP Color LaserJet Pro M283fdw (7KW75A) là một trong những lựa chọn hàng đầu cho các văn phòng hiện đại nhờ vào thiết kế nhỏ gọn, hiệu suất in nhanh ấn ấn tượng và tính năng đa chức năng như sao chép, quét và fax Sản phẩm máy in này không chỉ đáp ứng tốt nhu cầu in ấn tài liệu mà còn giúp tối ưu hóa quy trình làm việc', 'Loại máy in: Máy In Laser màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 22 trang/phút (trắng đen); 22 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; 16K; A5-R; Executive; Oficio 85x13; 4 x 6; 5 x 8#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ#Mực in kèm máy: HP 207A Black (W2210A)#Kích thước: 424 x 475 x 338 mm#Trọng lượng: 187 Kg', 'HP', DEFAULT, 23390000.00, 0.00, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (50, 3, 'Máy in phun màu đa chức năng A3 Epson L15150', 'Phù hợp: Văn phòng, Đồ họa - Kỹ thuật#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 32 trang/phút A3, A4, B4, B5, A5', 'Máy in phun màu đa chức năng A3 Epson L15150 là một lựa chọn tuyệt vời cho những ai cần một thiết bị in ấn hiệu quả và chất lượng Với công nghệ in tiên tiến, máy in không chỉ mang lại tốc độ in nhanh chóng mà còn đảm bảo độ sắc nét và sống động cho từng bản in L15150 phù hợp cho cả công việc Văn phòng, Đồ họa - Kỹ thuật lẫn nhu cầu in ấn cá nhân, từ tài liệu đến hình ảnh Đặc biệt, máy còn hỗ trợ chức năng in hai mặt tự động, giúp tiết kiệm giấy và thời gian', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 32 trang/phút (trắng đen); 22 trang/phút (màu)#Độ phân giải: 4800 x 2400 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A3; Super B (13 x 19\"); Indian Legal; Letter; A4; 16K (195 x 270mm); 8K (270 x 390mm); Executive (725 x 105\"); B4; B5; A5; B6; A6; 85 x 13\"; 5 x 7\"; 4 x 6\"; 8 x 10\"; Legal (85 x 14\"); 16:9 wide; Envelopes (#10, DL, C6, C4)#Mực in kèm máy: Epson 008 Black#Kích thước: 515 x 500 x 350 mm#Trọng lượng: 207 Kg', 'Epson', DEFAULT, 27190000.00, 0.07, 71, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (51, 3, 'Máy in HP LaserJet Pro MFP 4103FDW (2Z629A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 40-42 trang/phút A4, B5, A5, A6', 'Máy in HP LaserJet Pro MFP 4103FDW (2Z629A) là sự lựa chọn hàng đầu dành cho các văn phòng hiện đại, mang lại hiệu suất in ấn mạnh mẽ với chất lượng sắc nét và tốc độ vượt trội Sản phẩm tích hợp nhiều tính năng thông minh như in hai mặt tự động, kết nối không dây tiện lợi đáp ứng đầy đủ nhu cầu in, quét, sao chép và fax trong một chiếc máy in đa năng nhỏ gọn Hãy cùng tìm hiểu các đặc điểm của thiết bị in ấn này, giúp công việc văn phòng trở nên đơn giản và hiệu quả hơn bao giờ hết nhé!', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 40 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5 (JIS); Oficio (216 x 340 mm); 16K (195 x 270 mm; 184 x 260 mm; 197 x 273 mm); Custom Size; A5-R; 4 x 6 in; B6 (JIS)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 151A Black (W1510A)#Kích thước: 420 x 390 x 323 mm#Trọng lượng: 126 Kg', 'HP', DEFAULT, 10890000.00, 0.00, 35, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (52, 3, 'Máy in đa năng Canon iR2224N', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng In, Sao chép, Quét và Gửi#Tốc độ/Khổ giấy: 12-24 trang/phút', 'Máy in đa năng Canon iR2224N nổi bật với hiệu suất mạnh mẽ và tốc độ in nhanh, hứa hẹn sẽ đáp ứng nhu cầu in ấn và sao chép tài liệu người dùng một cách chuyên nghiệp Sản phẩm có thiết kế tinh tế và tích hợp nhiều tính năng thông minh, bao gồm in, scan, copy và send đa năng trong một thiết bị duy nhất Đây là chiếc máy in đa năng lý tưởng giúp tối ưu hóa quy trình làm việc, tiết kiệm thời gian và chi phí, đồng thời đảm bảo chất lượng in ấn cao nhất', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, Gửi, In 2 mặt#Tốc độ in: 24 trang/phút (A4) (trắng đen)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A3; A4; A4R; A5; A5R; B4; B5; B5R; Phong bì (COM10, Monarch, DL, ISO-C5)#Dung lượng khay giấy: Tiêu chuẩn: 350 tờ; Khay ra: 250 tờ#Mực in kèm máy: Canon NPG-59 Black#Kích thước: 627 x 607 x 606 mm#Trọng lượng: 303 Kg', 'Canon', DEFAULT, 43092000.00, 0.27, 50, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (53, 3, 'Máy in đa năng Canon iR1643i II', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng In, sao chụp, quét, fax#Tốc độ/Khổ giấy: 43 trang/phút', 'Máy in đa năng Canon iR1643i II nổi bật với hiệu suất mạnh mẽ và tốc độ in nhanh, hứa hẹn sẽ đáp ứng nhu cầu in ấn và sao chép tài liệu người dùng một cách chuyên nghiệp Sản phẩm có thiết kế tinh tế và tích hợp nhiều tính năng thông minh, bao gồm in, scan, copy và send đa năng trong một thiết bị duy nhất Đây là chiếc máy in đa năng lý tưởng giúp tối ưu hóa quy trình làm việc, tiết kiệm thời gian và chi phí, đồng thời đảm bảo chất lượng in ấn cao nhất', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 43 trang/phút (A4) (trắng đen)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; B5; A5; A5R; A6; Khổ tùy chỉnh (105 x 148 mm - 216 x 3556 mm)#Dung lượng khay giấy: Tiêu chuẩn: 550 tờ; Khay tay: 100 tờ#Mực in kèm máy: Canon Toner T06 Black#Kích thước: 480 x 464 x 452 mm#Trọng lượng: 20 Kg', 'Canon', DEFAULT, 41040000.00, 0.27, 94, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (54, 3, 'Máy in phun màu đa chức năng EPSON AM-C5000 (C11CJ42502)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy, Fax#Tốc độ/Khổ giấy: 30-50 trang/phút A5, A4, A3, B5, B4', 'Máy in phun màu đa chức năng EPSON AM-C5000 là lựa chọn hoàn hảo cho nhân viên văn phòng, các văn phòng lớn và doanh nghiệp lớn với nhu cầu in ấn hàng tháng cao từ 8,000 đến 60,000 tờ Với thiết kế đặc biệt để đáp ứng khối lượng công việc lớn, mang lại hiệu suất in ấn vượt trội Cùng với công nghệ mực DURABrite Pro pigment ink, EPSON AM-C5000 giúp tạo ra những tài liệu và hình ảnh sống động, bền màu, lý tưởng cho các báo cáo, tài liệu marketing hay các ấn phẩm quan trọng khác', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy, Fax, In 2 mặt#Tốc độ in: 50 trang/phút (trắng đen); 30 trang/phút (màu)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 30; Wifi#Khổ giấy hỗ trợ: A5; A4; A3; B5; B4; Letter; Legal; 11x17”#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ#Mực in kèm máy: Epson T08E100#Kích thước: 681 × 669 × 1062 mm#Trọng lượng: 42 Kg', 'Epson', DEFAULT, 167900000.00, 0.00, 85, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (55, 1, 'Máy in HP LaserJet M507dn (1PV87A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 43-50 trang/phút A4, A5, A6, RA4, B5', 'Máy in HP LaserJet M507dn - 1PV87A sở hữu vẻ ngoài nhỏ gọn, hiện đại để người dùng có thể đặt ở các không gian làm việc nổi bật Chiếc Máy in này có khả năng in với tốc độ nhanh chóng, được hỗ trợ đa dạng các khổ giấy in khác nhau phục vụ tốt cho nhu cầu sử dụng của bạn trong công việc văn phòng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 43 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A4; A5; A6; RA4; B5 (JIS); B6 (JIS); 10 x 15 cm; Oficio (216 x 340); 16K; Postcards (JIS single and double); Envelopes (B5, C5, C6, DL)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 89A (CF289A)#Kích thước: 418 x 639 x 299 mm#Trọng lượng: 1148 Kg', 'HP', DEFAULT, 38499000.00, 0.00, 75, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (56, 1, 'Máy in laser Canon LBP243dw', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 36-588 trang/phút A4, A5, A6, B5', 'Máy in laser Canon LBP243dw có độ phân giải 1200 x 1200 dpi và khả năng in ấn nhanh chóng, chất lượng sắc nét giúp bạn tiết kiệm thời gian và giảm thiểu chi phí cho văn phòng Sản phẩm có thiết kế nhỏ gọn và tính năng kết nối linh hoạt, dễ dàng tích hợp không gian làm việc', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 36 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; Legal; Letter; Executive; Statement; Foolscap; Government Letter; Government Legal; Indian Legal; Custom#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: Canon 070 Black (5639C003)#Kích thước: 399 x 373 x 249 mm#Trọng lượng: 95 Kg', 'Canon', DEFAULT, 9790000.00, 0.33, 60, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (57, 1, 'Máy in Laser trắng đen Canon LBP 121DN', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 29-30 trang/phút A4, A5, A6, B5', 'Máy in Laser trắng đen Canon LBP 121DN là một trong những sản phẩm nổi bật trong phân khúc máy in văn phòng hiện nay, được thiết kế đặc biệt để đáp ứng nhu cầu in ấn của các doanh nghiệp nhỏ và cá nhân Với những tính năng vượt trội như tốc độ in nhanh, độ phân giải cao và khả năng xử lý đa dạng kích thước giấy, máy in này không chỉ giúp tiết kiệm thời gian mà còn nâng cao hiệu quả công việc Bên cạnh đó, thiết kế chắc chắn và giao diện thân thiện với người dùng cũng là những điểm cộng lớn, khiến Canon LBP 121DN trở thành sự lựa chọn lý tưởng cho bất kỳ không gian làm việc nào', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 29 trang/phút (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A4; A5; A6; B5; Legal; Letter; Executive; Statement; Foolscap; Government Letter; Government Legal; Indian Legal; Index Card; Postcard; Envelope (COM10, Monarch, DL, C5); Custom (76 x 127 mm - 216 x 356 mm)#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 100 tờ#Mực in kèm máy: Canon 071 Black (5645C003)#Kích thước: 356 x 283 x 213 mm#Trọng lượng: 6 Kg', 'Canon', DEFAULT, 5690000.00, 0.19, 8, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (58, 1, 'Máy in HP LaserJet M712dn (CF236A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 41 trang/phút  A3; A4; A5; B4 (JIS); B5 (JIS)', 'Máy in HP LaserJet M712dn - CF236A với thiết kế nhỏ gọn thân thiện phù hợp với các doanh nghiệp và văn phòng Máy có tốc độ in ấn cực kỳ nhanh chóng giúp tiết kiệm phần lớn thời gian cho khách hàng Nếu bạn vẫn đang băn khoăn tìm một chiếc máy in chất lượng thì đây là một sản phẩm mà bạn không nên bỏ qua', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 41 trang/phút (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20#Khổ giấy hỗ trợ: A3; A4; A5; B4 (JIS); B5 (JIS)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 700 M712dn#Kích thước: 858 x 989 x 392 mm#Trọng lượng: 385 Kg', 'HP', DEFAULT, 71999000.00, 0.00, 16, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (59, 2, 'Máy in phun trắng đen Epson M1120', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 32 trang/phút A4, B5, A5, B6, A6, DL, C6', 'Máy in phun trắng đen Epson M1120 với thiết kế đẹp mắt tiện lợi cho việc bố trí trong góc làm việc trên văn phòng, tại nhà Máy sở hữu cho mình khả năng in được với nhiều khổ giấy khác nhau A4, B5, A5, B6, A6, DL, C6 với chất lượng sắc nét và chân thực giúp tăng hiệu quả công việc', 'Loại máy in: Máy In Phun trắng đen#Tính năng: In#Tốc độ in: 32 trang/phút (trắng đen)#Độ phân giải: 1440 x 720 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; B5; A5; B6; A6; DL; C6#Dung lượng khay giấy: Tiêu chuẩn: 150 tờ; Khay ra: 30 tờ#Mực in kèm máy: Epson 005S#Kích thước: 375 x 267 x 161 mm#Trọng lượng: 35 Kg', 'Epson', DEFAULT, 4790000.00, 0.08, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (60, 2, 'Máy in phun màu Canon PIXMA G570', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 39 ipm A4', 'Máy in phun màu Canon PIXMA G570 là một sản phẩm nổi bật trong dòng máy in phun của Canon, được thiết kế để đáp ứng nhu cầu in ấn đa dạng từ tài liệu đến ảnh của người dùng Với sự kết hợp hoàn hảo giữa tính năng, hiệu suất và thiết kế nhỏ gọn, máy in này đã nhanh chóng trở thành sự lựa chọn hàng đầu cho cả văn phòng và những người dùng cá nhân trong gia đình', 'Loại máy in: Máy In Phun màu#Tính năng: In#Tốc độ in: 39 ipm (trắng đen); 39 ipm (màu)#Độ phân giải: 1200 x 4800 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; LTR; 4 x 6\"; 5 x 7\"; 7 x 10\"; 8 x 10\"; Square (35 x 35\", 5 x 5\"); Card Size (91 x 55 mm)#Dung lượng khay giấy: Khay ra: 100 tờ#Mực in kèm máy: Canon GI-73 Black#Kích thước: 445 x 564 x 249 mm#Trọng lượng: 51 Kg', 'Canon', DEFAULT, 7890000.00, 0.13, 5, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (61, 1, 'Máy in HP LaserJet M454dw (W1Y45A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 27 trang/phút A4; A5; A6', 'Máy in HP LaserJet M454dw - W1Y45A là kiểu máy in laser được HP cho ra mắt thị trường với kiểu dáng thiết kế hiện đại và được hỗ trợ nhiều tính năng tiện ích cùng độ phân giải cao 600 x 600dpi Sản phẩm sẽ mang đến chất lượng in ấn tuyệt vời cho cá nhân hoặc doanh nghiệp khi sử dụng', 'Loại máy in: Máy In Laser màu#Tính năng: In, In 2 mặt#Tốc độ in: 27 trang/phút (trắng đen); 27 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5 (JIS); B6 (JIS); 16K (195 x 270 mm, 184 x 260 mm, 197 x 273 mm); 10 x 15 cm; Oficio (216 x 340 mm); postcards (JIS single, JIS double); envelopes (DL, C5, B5)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 50 tờ#Mực in kèm máy: HP 415A Black#Kích thước: 412 x 649 x 340 mm#Trọng lượng: 189 Kg', 'HP', DEFAULT, 38999000.00, 0.00, 48, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (62, 1, 'Máy in laser HP M255NW (7KW63A)', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 22 trang/phút A4; A5; A6; B5; B6', 'Máy in laser HP M255NW (7KW63A) là một sản phẩm lý tưởng khi sở hữu tốc độ in trang ổn định 21 trang/phút, trang bị cổng kết nối không dây hiện đại Vẻ ngoài nhỏ gọn là lựa chọn hàng đầu cho các văn phòng tại nhà hay các doanh nghiệp nhỏ', 'Loại máy in: Máy In Laser màu#Tính năng: In#Tốc độ in: 21 trang/phút (trắng đen); 21 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; B6; (JIS); Oficio (216 x 340); 16K (195x270mm, 184x260mm); Letter; Legal; Executive#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 206A Black (W2110A)#Kích thước: 392 x 435 x 2475 mm#Trọng lượng: 116 Kg', 'HP', DEFAULT, 12390000.00, 0.02, 161, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (63, 1, 'Máy in HP Color LaserJet Pro M255dw - 7KW64A', 'Phù hợp: Văn phòng#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 21 trang/phút A4, A5, A6, B5', 'Máy in HP Color LaserJet Pro M255dw - 7KW64A là phiên bản máy in laser cao cấp với thiết kế hiện đại, tinh tế và các tính năng được cải tiến, nâng cao đem lại hiệu suất hoạt động tối đa Đây là sản phẩm tối ưu tiện ích, phù hợp với nhiều đối tượng cá nhân, văn phòng hay cả doanh nghiệp', 'Loại máy in: Máy In Laser màu#Tính năng: In, In 2 mặt#Tốc độ in: 22 trang/phút (trắng đen); 22 trang/phút (màu)#Độ phân giải: 600 x 600 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: Letter (216 x 280); Legal (216 x 356); Executive (184 x 267); Oficio 85x13 (216 x 330); 4 x 6 (102 x 152); 5 x 8 (127 x 203); A4 (210 x 299); A5 (148 x 210); A6 (105x148); B5 (JIS) (182 x 257); B6 (JIS) (128 x 182); 10x15cm (100 x 150); Oficio 216x340mm (216 x 340)#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: HP 207A Black (W2210A)#Kích thước: 392 x 475 x 297 mm#Trọng lượng: 148 Kg', 'HP', DEFAULT, 17990000.00, 0.00, 20, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (64, 1, 'Máy in laser trắng đen BROTHER HL-L2361DN', 'Phù hợp: Văn phòng, Doanh nghiệp#Tính năng: Đơn năng In#Tốc độ/Khổ giấy: 30-32 trang/phút A4, Letter, A5, A6', 'Máy in laser trắng đen BROTHER HL-L2361DN là dòng máy in nhỏ gọn, sử dụng công nghệ in laser đen trắng phù hợp với nhu cầu sử dụng cho gia đình hay những công ty nhỏ với mức giá hợp lý Bên cạnh việc tiết kiệm chi phí thì dòng máy in này còn hỗ trợ chức năng in 2 mặt tự động giúp bạn tiết kiệm thời gian hơn khi sử dụng', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, In 2 mặt#Tốc độ in: 30 trang/phút (Độ phủ 5%) (trắng đen)#Độ phân giải: 2400 x 600 dpi#Kết nối: USB 20; LAN#Khổ giấy hỗ trợ: A4; Letter; A5; A5(Long Edge); A6; Executive; Legal; Folio#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: Brother TN - 2385#Kích thước: 356 × 360 × 183 mm#Trọng lượng: 68 Kg', 'Brother', DEFAULT, 4490000.00, 0.04, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (65, 2, 'Máy in phun đa năng màu Canon G3770 (Đỏ)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 11 trang/phút  A4, A5, A6, B5', 'Máy in phun đa năng màu Canon G3770 là dòng máy lý tưởng cho những ai đang tìm kiếm một giải pháp chất lượng Ngoài in ấn, máy còn có khả năng scan và copy trong cùng một thiết bị Với khả năng in màu sắc nét và công nghệ mực liên tục tiết kiệm, sản phẩm này sẽ mang đến hiệu suất vượt trội cho cả văn phòng bạn', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 11 trang/phút (trắng đen); 6 trang/phút (màu)#Độ phân giải: 1200 x 4800 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; LTR; LGL; Executive; Oficio2; B-Oficio; M-Oficio; Legal; Foolsca#Mực in kèm máy: Canon GI-71 Black#Kích thước: 416 x 557 x 268 mm#Trọng lượng: 6 Kg', 'Canon', DEFAULT, 6890000.00, 0.15, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (66, 2, 'Máy in phun đa năng màu Canon G3770 (Đen)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 11 trang/phút  A4, A5, A6, B5', 'Máy in phun đa năng màu Canon G3770 là dòng máy lý tưởng cho những ai đang tìm kiếm một giải pháp chất lượng Ngoài in ấn, máy còn có khả năng scan và copy trong cùng một thiết bị Với khả năng in màu sắc nét và công nghệ mực liên tục tiết kiệm, sản phẩm này sẽ mang đến hiệu suất vượt trội cho cả văn phòng bạn', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 11 trang/phút (trắng đen); 6 trang/phút (màu)#Độ phân giải: 1200 x 4800 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; A5; A6; B5; LTR; LGL; Executive; Oficio2; B-Oficio; M-Oficio; Legal; Foolsca#Mực in kèm máy: Canon GI-71 Black#Kích thước: 416 x 557 x 268 mm#Trọng lượng: 6 Kg', 'Canon', DEFAULT, 6890000.00, 0.15, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (67, 1, 'Máy in laser trắng đen Brother DCP-B7535DW', 'Phù hợp: Văn phòng, Doanh nghiệp#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 34-36 trang/phút A4, A5, A6', 'Khi cân nhắc về một mẫu máy in cho doanh nghiệp thì máy in Laser trắng đen đa năng Brother DCP-B7535DW wifi chắc chắn là sự lựa chọn lý tưởng, không chỉ có thiết kế ngoại hình hiện đại và sang trọng, mà máy in còn tích hợp một loạt các công nghệ in ấn tiên tiến', 'Loại máy in: Máy In Laser trắng đen#Tính năng: In, Scan, Copy, In 2 mặt#Tốc độ in: 34 trang/phút (A4) (trắng đen)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; LAN; Wifi#Khổ giấy hỗ trợ: A4; Letter; A5; A5 (Long Edge); A6; Executive; Legal; Folio; Mexico Legal; India Legal#Dung lượng khay giấy: Tiêu chuẩn: 250 tờ; Khay ra: 100 tờ#Mực in kèm máy: Brother TN-B022#Kích thước: 410 x 3985 x 3185 mm#Trọng lượng: 118 Kg', 'Brother', DEFAULT, 6090000.00, 0.13, 92, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (68, 2, 'Máy in phun màu đa năng Brother DCP-T420W', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 16 ảnh/phút A4, A5, A6, B5', 'Máy in phun màu đa năng Brother DCP-T420W là thiết bị in ấn hiện đại tích hợp ba chức năng in, quét và copy Với tốc độ in 16 trang/phút (trắng đen) và 9 trang/phút (màu), độ phân giải in lên đến 1,200 x 6,000 dpi, máy mang lại hiệu suất vượt trội Dung lượng khay chứa giấy lên đến 150 tờ, hỗ trợ đa dạng kích thước giấy như A4, Letter, Legal, và các loại giấy ảnh Máy in màu Brother này có kết nối linh hoạt qua Hi-Speed USB 20 và Wi-Fi IEEE 80211b/g/n, tương thích Windows và macOS Trọng lượng 64 kg và thiết kế nhỏ gọn giúp tiết kiệm không gian', 'Loại máy in: Máy In Phun màu#Tính năng: In, Scan, Copy#Tốc độ in: 16 ảnh/phút (trắng đen); 9 ảnh/phút (màu)#Độ phân giải: 1200 x 6000 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; Letter; Legal; Folio; Executive; B5; A5; B6; A6; Photo; Envelope#Mực in kèm máy: Brother BTD60BK; Brother BT5000 C/M/Y#Kích thước: 435 × 359 × 159 mm#Trọng lượng: 64 Kg', 'Brother', DEFAULT, 3890000.00, 0.08, 90, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (69, 2, 'Máy in phun đa chức năng Brother MFC-T930DW', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Copy, Scan, Print#Tốc độ/Khổ giấy: 17 trang/phút A4, A5, A6', 'Máy in phun đa chức năng Brother MFC-T930DW là lựa chọn cho văn phòng hiện đại và người dùng cần thiết bị in ấn linh hoạt Sản phẩm nổi bật với tốc độ in nhanh, khả năng in hai mặt tự động và kết nối tiện lợi Điều này giúp bạn tối ưu hiệu suất công việc và giảm chi phí vận hành Với thiết kế nhỏ gọn, chất lượng bản in sắc nét, Brother MFC-T930DW sẽ đáp ứng tốt nhu cầu in ấn cho cả gia đình và doanh nghiệp', 'Loại máy in: Máy In Phun màu#Tính năng: In 2 mặt tự động, Scan, Copy, Fax#Tốc độ in: 17 trang/phút (trắng đen); 165 trang/phút (màu)#Độ phân giải: 1200 x 6000 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; LTR; LGL; Folio; EXE; A5; A6; Photo; Envelope#Mực in kèm máy: Brother BTD100BK; Brother BTD100 C/M/Y#Kích thước: 435 x 418 x 18 cm#Trọng lượng: 97 Kg', 'Brother', DEFAULT, 8600000.00, 0.00, 69, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (70, 2, 'Máy in HP Smart Tank 670 All-in-One (6UU48A)', 'Phù hợp: Văn phòng#Tính năng: Đa chức năng Print, Scan, Copy#Tốc độ/Khổ giấy: 12-22 trang/phút A4; B5; A6; DL envelope, legal', 'Máy in HP Smart Tank 670 All-in-One (6UU48A) đáp ứng những nhu cầu thiết yếu về in ấn tài liệu chất lượng cao Với thiết kế đa chức năng, công nghệ in tiên tiến và hệ thống mực dung tích lớn, sản phẩm này không chỉ mang đến hiệu suất tuyệt vời mà còn giúp tiết kiệm chi phí tối đa cho người dùng', 'Loại máy in: Máy In Phun màu#Tính năng: In 2 mặt, Scan, Copy#Tốc độ in: 12 trang/phút (trắng đen); 7 trang/phút (màu)#Độ phân giải: 1200 x 1200 dpi#Kết nối: USB 20; Wifi#Khổ giấy hỗ trợ: A4; B5; A6; Legal; DL envelope#Mực in kèm máy: HP GT53 (Black); HP GT52 C/M/Y#Kích thước: 4275 x 3640 x 1986 cm#Trọng lượng: 638 Kg', 'HP', DEFAULT, 5490000.00, 0.00, 78, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (71, 6, 'Bút lông dầu Thiên Long PM-04', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút lông dầu Thiên Long PM-04 là một trong những loại bút lông dầu được sử dụng phổ biến nhất tại Việt Nam. Bút có thiết kế rất hợp lý, dễ sử dụng, chất lượng ổn định. Bút lông dầu Thiên Long PM-04 là sản phẩm mới thuộc nhóm dụng cụ văn phòng, do Tập đoàn Thiên Long sản xuất. Sản phẩm được sản xuất theo công nghệ hiện đại, đạt tiêu chuẩn chất lượng quốc tế, kiểu dáng được cải tiến ấn tượng, thân bút cầm chắc tay, dễ cầm nắm, không gây mỏi tay khi sử dụng .', 'Loại sản phẩm: Bút lông dầu#Thương hiệu: Thiên Long#Bề rộng nét viết: 1 mm & 0.4 mm#Số đầu bút: 2#Đóng gói: 10 cây/hộp#Trọng lượng: 10 gram#Màu mực: Xanh/Đỏ/Đen', 'Thiên Long', DEFAULT, 13000.00, 0.25, 100, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (72, 6, 'Combo Bút lông dầu Flexoffice Flex Marker FO-PM06/XK - Hàng xuất khẩu', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút lông dầu Flexoffice là công cụ đánh dấu và ghi nhãn đa năng, thiết yếu trong văn phòng, trường học và gia đình. Được thiết kế để đáp ứng các nhu cầu viết trên nhiều bề mặt khác nhau, bút lông dầu Flexoffice nổi bật với chất lượng mực vượt trội và tính năng tiện dụng.', 'Loại sản phẩm: Bút lông dầu#Thương hiệu: Flexoffice#Xuất xứ: Việt Nam#Khuyến cáo: Tránh xa nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi.', 'Flexoffice', DEFAULT, 39000.00, 0.00, 60, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (73, 6, 'Bút lông bi cao cấp Parker Ingenuity', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Sản phẩm được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu:Thép không gỉ#Trọng lượng: 150 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 6159000.00, 0.00, 150, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (74, 6, 'Bút cao cấp Parker 51 Collection', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút cao cấp Parker 51 Collection - mang tính đột phá từ lần đầu tiên ra mắt vào năm 1941, vẫn giữ nguyên hình dáng thon gọn đặc trưng và ngòi bút trùm đầu mang tính biểu tượng 84 năm qua; nhưng được tạo ra cho tương lai - cây bút này được lắp ráp thủ công và làm từ nhựa quý bền bỉ. Từ khâu hình thành ý tưởng đến lắp ráp, sự chú ý đến từng chi tiết là không gì sánh bằng.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 4051000.00, 0.00, 100, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (75, 6, 'Bút cao cấp Parker IM Writing Rituals', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2459000.00, 0.00, 70, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (76, 6, 'Bút cao cấp Parker IM Writing Rituals GREY CT', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2459001.00, 0.00, 95, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (77, 6, 'Bút cao cấp Parker IM Monochrome CHMPGN', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2304000.00, 0.00, 55, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (78, 6, 'Bút cao cấp Parker IM Monochrome BRGNDY', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2304000.00, 0.00, 48, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (79, 6, 'Bút cao cấp Parker IM Monochrome TTNM', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2304000.00, 0.00, 36, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (80, 6, 'Bút cao cấp Parker IM Monochrome Blue', 'Thương hiệu: Parker#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Newell', 'Bút máy cao cấp Parker được chế tác đẹp mắt và thanh lịch theo phong cách cổ điển. Parker IM được kiểm tra chất lượng hoàn hảo, mang lại độ chính xác cao và sự thoải mái khi viết.', 'Loại sản phẩm: Bút cao cấp#Thương hiệu: Parker#Chất liệu: Thép không gỉ#Trọng lượng: 280 gram#Xuất xứ: Mỹ#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'parker', DEFAULT, 2304000.00, 0.00, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (81, 6, 'Bút chì khúc Thiên Long Điểm 10 TP-PC005 - Lõi chắc chắn nét đậm, ít bột chì', 'Thương hiệu: Điểm 10#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long, bao gồm cả Bút Chì Gỗ và Bút Chì Bấm/Khúc, là lựa chọn hàng đầu cho học tập và sáng tạo nhờ chất lượng vượt trội và sự đa dạng. Sản phẩm nổi bật với lõi chì cao cấp (2B, HB) chắc chắn, cho nét viết mượt mà, đậm nét và ít bột chì, giúp giữ sạch tập vở. Thiên Long cung cấp nhiều mẫu mã từ Điểm 10 đến Flexoffice, với thiết kế thân thiện, dễ cầm nắm và vật liệu an toàn, đảm bảo mang lại hiệu quả và sự hứng thú tối đa cho người sử dụng.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 4100.00, 0.15, 79, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (82, 6, 'Bút chì gỗ 2B Thiên Long GP-027', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long, bao gồm cả Bút Chì Gỗ và Bút Chì Bấm/Khúc, là lựa chọn hàng đầu cho học tập và sáng tạo nhờ chất lượng vượt trội và sự đa dạng. Sản phẩm nổi bật với lõi chì cao cấp (2B, HB) chắc chắn, cho nét viết mượt mà, đậm nét và ít bột chì, giúp giữ sạch tập vở. Thiên Long cung cấp nhiều mẫu mã từ Điểm 10 đến Flexoffice, với thiết kế thân thiện, dễ cầm nắm và vật liệu an toàn, đảm bảo mang lại hiệu quả và sự hứng thú tối đa cho người sử dụng.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 4100.00, 0.15, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (83, 6, 'Bút chì gỗ Thiên Long GP-01', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long, bao gồm cả Bút Chì Gỗ và Bút Chì Bấm/Khúc, là lựa chọn hàng đầu cho học tập và sáng tạo nhờ chất lượng vượt trội và sự đa dạng. Sản phẩm nổi bật với lõi chì cao cấp (2B, HB) chắc chắn, cho nét viết mượt mà, đậm nét và ít bột chì, giúp giữ sạch tập vở. Thiên Long cung cấp nhiều mẫu mã từ Điểm 10 đến Flexoffice, với thiết kế thân thiện, dễ cầm nắm và vật liệu an toàn, đảm bảo mang lại hiệu quả và sự hứng thú tối đa cho người sử dụng.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 4500.00, 0.15, 261, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (84, 6, 'Bút chì gỗ nhân vật Akooland Thiên Long TP-GP021/AK - Mẫu ngẫu nhiên', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long, bao gồm cả Bút Chì Gỗ và Bút Chì Bấm/Khúc, là lựa chọn hàng đầu cho học tập và sáng tạo nhờ chất lượng vượt trội và sự đa dạng. Sản phẩm nổi bật với lõi chì cao cấp (2B, HB) chắc chắn, cho nét viết mượt mà, đậm nét và ít bột chì, giúp giữ sạch tập vở. Thiên Long cung cấp nhiều mẫu mã từ Điểm 10 đến Flexoffice, với thiết kế thân thiện, dễ cầm nắm và vật liệu an toàn, đảm bảo mang lại hiệu quả và sự hứng thú tối đa cho người sử dụng.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 5000.00, 0.00, 97, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (85, 6, 'Bút chì gỗ HB Điểm 10 TP-GP05', 'Thương hiệu: Điểm 10#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là biểu tượng của sự đáng tin cậy trong học đường và văn phòng. Dòng sản phẩm này cung cấp giải pháp viết và vẽ toàn diện, từ Bút Chì Gỗ truyền thống với độ cứng tiêu chuẩn (2B, HB) cho nét đậm và bền, đến Bút Chì Bấm tiện lợi, linh hoạt. Điểm chung của mọi sản phẩm là chất lượng lõi chì ổn định, ít gãy, dễ tẩy xóa, cùng với thiết kế bền bỉ, an toàn. Chọn Thiên Long để đảm bảo hiệu suất học tập và làm việc luôn được duy trì ở mức cao nhất.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 5300.00, 0.50, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (86, 6, 'Bút chì bấm Thiên Long PC-029 - Tích hợp chuốt chì trên thân bút - Màu thân ngẫu nhiên', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là biểu tượng của sự đáng tin cậy trong học đường và văn phòng. Dòng sản phẩm này cung cấp giải pháp viết và vẽ toàn diện, từ Bút Chì Gỗ truyền thống với độ cứng tiêu chuẩn (2B, HB) cho nét đậm và bền, đến Bút Chì Bấm tiện lợi, linh hoạt. Điểm chung của mọi sản phẩm là chất lượng lõi chì ổn định, ít gãy, dễ tẩy xóa, cùng với thiết kế bền bỉ, an toàn. Chọn Thiên Long để đảm bảo hiệu suất học tập và làm việc luôn được duy trì ở mức cao nhất.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 5800.00, 0.15, 185, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (87, 6, 'Bút chì khúc Thiên Long PC-09', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là biểu tượng của sự đáng tin cậy trong học đường và văn phòng. Dòng sản phẩm này cung cấp giải pháp viết và vẽ toàn diện, từ Bút Chì Gỗ truyền thống với độ cứng tiêu chuẩn (2B, HB) cho nét đậm và bền, đến Bút Chì Bấm tiện lợi, linh hoạt. Điểm chung của mọi sản phẩm là chất lượng lõi chì ổn định, ít gãy, dễ tẩy xóa, cùng với thiết kế bền bỉ, an toàn. Chọn Thiên Long để đảm bảo hiệu suất học tập và làm việc luôn được duy trì ở mức cao nhất.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 5800.00, 0.28, 24, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (88, 6, 'Bút chì gỗ Thiên Long Điểm 10 2B TP-GP009/DO', 'Thương hiệu: Điểm 10#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là biểu tượng của sự đáng tin cậy trong học đường và văn phòng. Dòng sản phẩm này cung cấp giải pháp viết và vẽ toàn diện, từ Bút Chì Gỗ truyền thống với độ cứng tiêu chuẩn (2B, HB) cho nét đậm và bền, đến Bút Chì Bấm tiện lợi, linh hoạt. Điểm chung của mọi sản phẩm là chất lượng lõi chì ổn định, ít gãy, dễ tẩy xóa, cùng với thiết kế bền bỉ, an toàn. Chọn Thiên Long để đảm bảo hiệu suất học tập và làm việc luôn được duy trì ở mức cao nhất.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 7300.00, 0.15, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (89, 6, 'Bút chì bấm Thiên Long PC-018', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là công cụ lý tưởng khơi nguồn sáng tạo. Với sự kết hợp giữa chất lượng lõi chì mượt mà, đậm nét và thiết kế thân bút được tối ưu hóa, Thiên Long mang lại trải nghiệm cầm nắm thoải mái và kiểm soát tuyệt vời. Dù bạn cần Bút Chì Gỗ để phác thảo nhanh chóng hay Bút Chì Bấm với thiết kế hiện đại, sản phẩm đều đảm bảo độ chính xác cao, nét vẽ đồng đều. Thiên Long không chỉ là một cây bút, mà là cầu nối giúp mọi ý tưởng trở thành hiện thực một cách dễ dàng và đẹp mắt.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 9700.00, 0.50, 49, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (90, 6, 'Combo 10 Bút chì gỗ đen nhân vật Demon Slayer Thiên Long GP-030/DS - Mẫu ngẫu nhiên', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Bút chì Thiên Long là công cụ lý tưởng khơi nguồn sáng tạo. Với sự kết hợp giữa chất lượng lõi chì mượt mà, đậm nét và thiết kế thân bút được tối ưu hóa, Thiên Long mang lại trải nghiệm cầm nắm thoải mái và kiểm soát tuyệt vời. Dù bạn cần Bút Chì Gỗ để phác thảo nhanh chóng hay Bút Chì Bấm với thiết kế hiện đại, sản phẩm đều đảm bảo độ chính xác cao, nét vẽ đồng đều. Thiên Long không chỉ là một cây bút, mà là cầu nối giúp mọi ý tưởng trở thành hiện thực một cách dễ dàng và đẹp mắt.', 'Loại sản phẩm: Bút chì#Thương hiệu: Điểm 10#Chất liệu: Nhựa PS, PP, AS, PE#Trọng lượng: 7 gram#Khuyến cáo: Tránh hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 91000.00, 0.30, 46, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (91, 8, 'Bìa hộp Flexoffice PP 150-A4 FO-BF05', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa giấy#Thương hiệu: Flexoffice#Chất liệu:nhựa PP#Trọng lượng: 235 gram#Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 132000.00, 0.10, 79, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (92, 8, 'Bìa nút A5 Thiên Long Flexoffice FO-CBF06 - Trong suốt', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Nút A5#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP#Trọng lượng: 25 gram#Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 3300.00, 0.50, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (93, 8, 'Bìa lá Thiên Long F4 E355 (FS)', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu mẹ với bề dày lịch sử, nổi tiếng với sự đáng tin cậy, chất lượng ổn định và là biểu tượng gắn liền với tuổi học trò qua các sản phẩm viết chủ lực như bút bi, bút chì và dụng cụ học tập.', 'Loại sản phẩm: Bìa Lá F4#Thương hiệu: Thiên Long#Chất liệu: Nhựa PP#Trọng lượng: #Khuyến cáo:Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 3300.00, 0.00, 205, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (94, 8, 'Bìa lá A4 Thiên Long Flexoffice FO-CH168', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Lá A4#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP#Trọng lượng: 22.5 gram#Khuyến cáo: Tránh xa nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Flexoffice', DEFAULT, 3600.00, 0.00, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (95, 8, 'Bìa nút màu Pastel F4 Thiên Long CBF-003 - Sức chứa 125 tờ A4', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu mẹ với bề dày lịch sử, nổi tiếng với sự đáng tin cậy, chất lượng ổn định và là biểu tượng gắn liền với tuổi học trò qua các sản phẩm viết chủ lực như bút bi, bút chì và dụng cụ học tập.', 'Loại sản phẩm: Bìa Nút F4#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP#Trọng lượng: 33 gram#Khuyến cáo: Tránh xa nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi', 'Thiên Long', DEFAULT, 7900.00, 0.10, 105, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (96, 8, 'Bìa Acco A4 Thiên Long Flexoffice FO-PPFFA4', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Acco A4#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP và Thép#Trọng lượng: 15 gram#Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 8900.00, 0.10, 164, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (97, 8, 'Bìa trình ký A5 Thiên Long Flexoffice PP FO-CB012', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Trình Ký A5#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP và Kim loại#Trọng lượng: 169 gram#Khuyến cáo: Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 27200.00, 0.10, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (98, 8, 'Bìa nhẫn 2-ORing 30 Flexoffice FO-ORB02', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Nhẫn A4#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP#Trọng lượng: 140 gram#Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 30500.00, 0.00, 94, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (99, 8, 'Bìa trình ký kép màu Pastel nhựa PP Thiên Long Flexoffice FO-CB03', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Trình Ký A4#Thương hiệu: Flexoffice#Chất liệu: Nhựa PP#Trọng lượng: 169.6 gram#Khuyến cáo: Để nơi thoáng mát, tránh nguồn nhiệt. Không thích hợp cho trẻ dưới 3 tuổi', 'Flexoffice', DEFAULT, 47000.00, 0.10, 56, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (100, 8, 'Bìa còng Flexoffice 50F4 FO-BC13', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Flexoffice là thương hiệu con tập trung vào nhóm Văn phòng phẩm cao cấp và đa dạng, từ các giải pháp lưu trữ tài liệu (bìa còng, bìa hộp), các loại mực và bút lông dầu chuyên dụng, đến dụng cụ văn phòng phẩm thiết yếu. Flexoffice mang lại sự chuyên nghiệp, thiết kế hiện đại và tính năng tối ưu cho môi trường công sở.', 'Loại sản phẩm: Bìa Còng F4 (Gáy 50mm)#Thương hiệu: Flexoffice#Chất liệu: Simili và Thép#Trọng lượng: 15gram#Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Flexoffice', DEFAULT, 68500.00, 0.00, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (101, 5, 'Giấy ghi chú - Giấy notes Neon Thiên Long - Nhiều kích thước', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Giấy ghi chú Neon#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: 50 gram #Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 12000.00, 0.10, 78, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (102, 5, 'Giấy thủ công Colokit GTC-C002 12 màu khổ vừa', 'Thương hiệu: Colokit#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Colokit là thương hiệu mang màu sắc sáng tạo, vui tươi và nghệ thuật. Colokit chuyên cung cấp các dụng cụ tô màu, vẽ và thủ công như bút màu, sáp màu, màu nước, giấy thủ công và keo dán. Colokit khuyến khích trẻ em và người trẻ khám phá, thể hiện cá tính và phát triển trí tưởng tượng thông qua những sản phẩm an toàn, đa dạng màu sắc và chất lượng cao.', 'Loại sản phẩm: Giấy thủ công#Thương hiệu: Colokit#Chất liệu: Giấy#Trọng lượng: 45 gram#Khuyến cáo:Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Colokit ', DEFAULT, 8100.00, 0.10, 45, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (103, 5, 'Giấy kiểm tra Điểm 10 TP-GKT011 5 ôly', 'Thương hiệu: Điểm 10#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu hướng đến đối tượng học sinh, sinh viên, chuyên về các sản phẩm hỗ trợ học tập như vở, tập, giấy kiểm tra, và các dụng cụ học đường. Với chất lượng giấy tốt, thiết kế phù hợp với quy chuẩn giáo dục, Điểm 10 đồng hành cùng học sinh trên con đường chinh phục thành tích cao, thể hiện tinh thần học hỏi, nỗ lực và sự hoàn hảo.', 'Loại sản phẩm: Giấy Kiểm Tra#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 170 gram#Khuyến cáo:Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Điểm 10', DEFAULT, 19000.00, 0.10, 87, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (104, 5, 'Túi 20 tờ đôi giấy kiểm tra 100gsm Thiên Long Điểm 10 TP-GKT012 4 ôly vuông', 'Thương hiệu: Điểm 10#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu hướng đến đối tượng học sinh, sinh viên, chuyên về các sản phẩm hỗ trợ học tập như vở, tập, giấy kiểm tra, và các dụng cụ học đường. Với chất lượng giấy tốt, thiết kế phù hợp với quy chuẩn giáo dục, Điểm 10 đồng hành cùng học sinh trên con đường chinh phục thành tích cao, thể hiện tinh thần học hỏi, nỗ lực và sự hoàn hảo.', 'Loại sản phẩm: Giấy Kiểm Tra#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: #Khuyến cáo:Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Điểm 10', DEFAULT, 22000.00, 0.10, 64, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (105, 5, 'Keo dán giấy - Glubby Liquid Glue Thiên Long G-025 - Mẫu thân ngẫu nhiên', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Keo Dán Giấy Lỏng#Thương hiệu: Thiên Long#Chất liệu: nhựa #Trọng lượng: 100gram #Khuyến cáo: Tránh nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi. Đậy nắp ngay sau khi sử dụng. Lưu trữ nơi khô ráo, thoáng mát, tránh để ánh sáng mặt trời chiếu trực tiếp vào sản phẩm', 'Thiên Long', DEFAULT, 6600.00, 0.10, 64, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (106, 5, 'Combo 5 Ream giấy A4 80 gsm IK Copy (500 tờ) - Hàng nhập khẩu Indonesia', 'Thương hiệu: IK Copy#Tình trạng: Hết hàng#Đơn vị chịu trách nhiệm: Tập đoàn APP (Asia Pulp & Paper) (Indonesia)', 'IK Copy là thương hiệu chuyên về giấy in, giấy photo với chất lượng ổn định và giá trị cạnh tranh. IK Copy (thường là sản phẩm nhập khẩu được phân phối) tập trung vào nhu cầu in ấn văn phòng và học tập hàng ngày, đảm bảo tài liệu được in rõ nét, không kẹt giấy, phù hợp cho môi trường văn phòng đòi hỏi sự hiệu quả, kinh tế và chuyên nghiệp.', 'Loại sản phẩm: Giấy in A4#Thương hiệu: IK Copy#Chất liệu: Giấy#Trọng lượng: 200gram #Khuyến cáo: Trưng bày, lưu trữ nơi khô ráo, thoáng mát, tuyệt đối tránh xa nguồn nhiệt, hóa chất, tránh ánh nắng trực tiếp chiếu vào sản phẩm', 'IK Copy ', DEFAULT, 505000.00, 0.20, 48, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (107, 5, 'Giấy Phân trang Thiên Long - Giấy notes - Ghi chú - Nhiều kích thước, mẫu ngẫu nhiên', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: #Thương hiệu: Thiên Long#Chất liệu: giấy #Trọng lượng: 100gram #Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 12000.00, 0.10, 98, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (108, 5, 'Giấy kiểm tra Thiên Long Điểm 10 TP-GKT06 - Dòng kẻ ngang', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Giấy Kiểm Tra#Thương hiệu: Điểm 10#Chất liệu: giấy #Trọng lượng: 22 gram#Khuyến cáo:Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 22000.00, 0.10, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (109, 5, 'Bộ 5 giấy gói quà Giáng Sinh Thiên Long - Món quà thêm ý nghĩa mùa Noel', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Giấy Gói Quà#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 38000.00, 0.10, 78, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (110, 5, 'Giấy gói quà Thiên Long 70x50cm phủ mờ GGQ-004', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Giấy Gói Quà#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng:100 gram #Khuyến cáo: Nhiệt độ: 10 ~ 55º C, Độ ẩm: 55 ~ 95% RH, Tránh xa nguồn nhiệt, dầu mỡ', 'Thiên Long', DEFAULT, 38000.00, 0.10, 58, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (111, 7, 'Tập học sinh 96 trang 4 ô ly vuông 60 gsm Điểm 10 TP-NB039 (hình ngẫu nhiên)', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, tập trung vào việc tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe học đường cho học sinh. Với các dòng tập vở chống lóa, bút luyện chữ đẹp và dụng cụ hỗ trợ học tập thông minh, Điểm 10 đại diện cho sự chuyên sâu, tinh thần tiên phong và sứ mệnh đồng hành cùng học sinh Việt Nam chinh phục những nấc thang tri thức.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 110 gram#Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Điểm 10', DEFAULT, 10000.00, 0.28, 61, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (112, 7, 'Tập tô màu Colokit CB-012', 'Thương hiệu: Colokit# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Colokit là thương hiệu mỹ thuật và sáng tạo hàng đầu của Tập đoàn Thiên Long, mang sứ mệnh khơi dậy tiềm năng nghệ thuật và tư duy sáng tạo cho trẻ em. Qua các dòng sản phẩm tập tô màu, bút màu và dụng cụ mỹ thuật đa sắc màu, Colokit không chỉ mang đến sự vui nhộn trong học tập mà còn là biểu tượng cho sự kết nối giữa niềm vui và giáo dục, giúp trẻ phát triển trí tưởng tượng phong phú.', 'Loại sản phẩm: Tập tô màu#Thương hiệu: Colokit#Chất liệu: Giấy#Trọng lượng: 60 gram#Khuyến cáo: Nơi khô ráo, tránh lửa', 'Colokit', DEFAULT, 14000.00, 0.50, 74, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (113, 7, 'Tập học sinh 96 trang 4 ô ly ngang 70 gsm Điểm 10 TP-NB048 (hình ngẫu nhiên)', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 130 gram#Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Điểm 10', DEFAULT, 10700.00, 0.20, 32, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (114, 7, 'Tập học sinh 96 trang 4 ô ly vuông 70 gsm Điểm 10 TP-NB044 (hình ngẫu nhiên)', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 130 gram#Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Điểm 11', DEFAULT, 11200.00, 0.20, 97, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (115, 7, 'Tập học sinh 96 trang 5 ô ly vuông 80 gsm Điểm 10 TP-NB074 (hình ngẫu nhiên)', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 140 gram#Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Điểm 12', DEFAULT, 14000.00, 0.20, 132, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (116, 7, 'Tập học sinh 96 trang 4 ô ly vuông 2mm 80-100gsm Thiên Long - Akooland thế giới học cụ thần kỳ - Mẫu ngẫu nhiên', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Giấy in A4#Thương hiệu: IK Copy#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Trưng bày, lưu trữ nơi khô ráo, thoáng mát, tuyệt đối tránh xa nguồn nhiệt, hóa chất, tránh ánh nắng trực tiếp chiếu vào sản phẩm', 'Điểm 13', DEFAULT, 10000.00, 0.28, 81, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (117, 7, 'Tập học sinh 96 trang 5 ô ly vuông 2mm chấm kẻ 2/3 100gsm NB-118 Thiên Long - Mẫu ngẫu nhiên', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: 100 gram#Khuyến cáo: Tránh nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi.', 'Điểm 14', DEFAULT, 14000.00, 0.50, 62, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (118, 7, 'Tập vở Thiên Long 80/120 trang kẻ ngang 7mm 70gsm - dành cho học sinh, sinh viên - Phiên bản Demon Slayer', 'Thương hiệu: Thiên Long# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi.', 'Thiên Long', DEFAULT, 10700.00, 0.20, 28, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (119, 7, 'Tập học sinh chống lóa 96 trang 4 ô ly vuông 2mm 100gsm Thiên Long NB-117/AK - Akooland thế giới học cụ thần kỳ - Mẫu ngẫu nhiên', 'Thương hiệu: Thiên Long# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: 100 gram#Khuyến cáo: Tránh nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi.', 'Thiên Long', DEFAULT, 11200.00, 0.20, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (120, 7, 'Tập học sinh 120 trang Điểm 10 NB-083 (hình ngẫu nhiên)', 'Thương hiệu: Điểm 10# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Điểm 10 là thương hiệu chuyên biệt về dụng cụ học tập của Tập đoàn Thiên Long, được thiết kế nhằm tối ưu hóa trải nghiệm học đường và bảo vệ sức khỏe thị lực cho học sinh. Với các dòng tập vở đa dạng và bút luyện chữ đẹp, Điểm 10 đại diện cho tinh thần nỗ lực vươn tới sự hoàn thiện, đồng hành cùng thế hệ trẻ Việt Nam trên con đường chinh phục tri thức và đạt được những thành tích xuất sắc.', 'Loại sản phẩm: Tập học sinh#Thương hiệu: Điểm 10#Chất liệu: Bột giấy#Trọng lượng: 180 gram#Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Điểm 10', DEFAULT, 14000.00, 0.20, 71, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (121, 7, 'Tập tô màu Colokit Doraemon CB-C019/DO', 'Thương hiệu: Colokit# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu cốt lõi, lâu đời và là biểu tượng của Tập đoàn, nổi tiếng với sự tin cậy, chất lượng bền bỉ và sự gắn bó với nhiều thế hệ học sinh, sinh viên Việt Nam. Thiên Long cung cấp các sản phẩm viết chủ lực như bút bi, bút máy, và các dụng cụ học tập thiết yếu, đại diện cho giá trị truyền thống, sự ổn định và chất lượng hàng đầu trong ngành văn phòng phẩm.', 'Loại sản phẩm: Tập tô màu#Thương hiệu: Colokit#Chất liệu: Giấy#Trọng lượng: 95 gram#Khuyến cáo: Nơi khô ráo, tránh lửa', 'Thiên Long', DEFAULT, 11200.00, 0.20, 35, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (122, 7, '[TẶNG 02 CUỐN] Combo 10 Tập học sinh 96 trang 4 ô ly vuông 2mm 100gsm NB-124 Thiên Long - Mẫu ngẫu nhiên', 'Thương hiệu: Thiên Long# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', NULL, 'Loại sản phẩm: Tập học sinh#Thương hiệu: Thiên Long#Chất liệu: Giấy#Trọng lượng: 100 gram#Khuyến cáo: Tránh nguồn nhiệt, hóa chất. Không thích hợp cho trẻ dưới 3 tuổi.', 'Thiên Long', DEFAULT, 14000.00, 0.20, 61, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (123, 7, 'Sách hướng dẫn tô màu theo chủ đề cho bé khám phá thiên nhiên Arty Mouse Colokit COLORING AB-C001/AR', 'Thương hiệu: Colokit# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Colokit là thương hiệu mỹ thuật và sáng tạo hàng đầu của Tập đoàn Thiên Long, mang sứ mệnh khơi dậy tiềm năng nghệ thuật và tư duy sáng tạo cho trẻ em. Qua các dòng sản phẩm tập tô màu, bút màu và dụng cụ mỹ thuật đa sắc màu, Colokit không chỉ mang đến sự vui nhộn trong học tập mà còn là biểu tượng cho sự kết nối giữa niềm vui và giáo dục, giúp trẻ phát triển trí tưởng tượng phong phú.', 'Loại sản phẩm: Sách tương tác#Thương hiệu: Colokit#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Nơi khô ráo, tránh lửa', 'Colokit là', DEFAULT, 10700.00, 0.20, 95, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (124, 7, 'Sách hướng dẫn Cắt dán thủ công cho bé Arty Mouse Colokit STICKING AB-C006/AR', 'Thương hiệu: Colokit# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Colokit là thương hiệu mỹ thuật và sáng tạo hàng đầu của Tập đoàn Thiên Long, mang sứ mệnh khơi dậy tiềm năng nghệ thuật và tư duy sáng tạo cho trẻ em. Qua các dòng sản phẩm tập tô màu, bút màu và dụng cụ mỹ thuật đa sắc màu, Colokit không chỉ mang đến sự vui nhộn trong học tập mà còn là biểu tượng cho sự kết nối giữa niềm vui và giáo dục, giúp trẻ phát triển trí tưởng tượng phong phú.', 'Loại sản phẩm: Sách tương tác#Thương hiệu: Colokit#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Nơi khô ráo, tránh lửa', 'Colokit là', DEFAULT, 45000.00, 0.20, 85, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (125, 7, 'Combo Mỹ thuật SẮC MÀU - 5 Món (Vở vẽ A3, Bút chì gỗ 2B, Bút sáp màu, Bút sáp dầu, Sách tương tác)', 'Thương hiệu: Colokit# Tình trạng: Còn hàng# Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Colokit là thương hiệu mỹ thuật và sáng tạo hàng đầu của Tập đoàn Thiên Long, mang sứ mệnh khơi dậy tiềm năng nghệ thuật và tư duy sáng tạo cho trẻ em. Qua các dòng sản phẩm tập tô màu, bút màu và dụng cụ mỹ thuật đa sắc màu, Colokit không chỉ mang đến sự vui nhộn trong học tập mà còn là biểu tượng cho sự kết nối giữa niềm vui và giáo dục, giúp trẻ phát triển trí tưởng tượng phong phú.', 'Loại sản phẩm: Combo Mỹ thuật#Thương hiệu: Colokit#Chất liệu: Nhiều chất liệu#Trọng lượng: #Khuyến cáo: Bảo quản nơi khô ráo, thoáng mát, tránh xa nguồn nhiệt, hóa chất và ánh nắng trực tiếp.', 'Colokit là', DEFAULT, 212000.00, 0.25, 74, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (126, 7, 'Gateway (2 Ed.) B1+: Student Book Pack', 'Thương hiệu: Mamilan Education# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: IES Việt Nam', 'Macmillan Education là một trong những nhà xuất bản giáo dục hàng đầu thế giới với lịch sử lâu đời, nổi tiếng bởi các chương trình đào tạo ngôn ngữ và tài liệu học thuật chất lượng cao. Tại Việt Nam, thông qua sự hợp tác cùng các đơn vị uy tín như IES, Macmillan Education cung cấp các giải pháp học tập tiên tiến, từ giáo trình tiếng Anh chuẩn quốc tế đến các tài liệu bổ trợ kỹ năng, đại diện cho tinh thần hội nhập, tư duy toàn cầu và cam kết mang lại giá trị giáo dục vượt trội cho mọi lứa tuổi.', 'Loại sản phẩm: Sách tiếng Anh#Thương hiệu: Macmillan Education#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Macmillan ', DEFAULT, 307000.00, 0.15, 61, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (127, 7, 'Gateway (2 Ed.) B1: Workbook', 'Thương hiệu: Mamilan Education# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: IES Việt Nam', 'Macmillan Education là một trong những nhà xuất bản giáo dục hàng đầu thế giới với lịch sử lâu đời, nổi tiếng bởi các chương trình đào tạo ngôn ngữ và tài liệu học thuật chất lượng cao. Tại Việt Nam, thông qua sự hợp tác cùng các đơn vị uy tín như IES, Macmillan Education cung cấp các giải pháp học tập tiên tiến, từ giáo trình tiếng Anh chuẩn quốc tế đến các tài liệu bổ trợ kỹ năng, đại diện cho tinh thần hội nhập, tư duy toàn cầu và cam kết mang lại giá trị giáo dục vượt trội cho mọi lứa tuổi.', 'Loại sản phẩm: Sách tiếng Anh#Thương hiệu: Macmillan Education#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Macmillan ', DEFAULT, 210000.00, 0.15, 8, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (128, 7, 'Gateway (2 Ed.) A2: Workbook', 'Thương hiệu: Mamilan Education# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: IES Việt Nam', 'Macmillan Education là một trong những nhà xuất bản giáo dục hàng đầu thế giới với lịch sử lâu đời, nổi tiếng bởi các chương trình đào tạo ngôn ngữ và tài liệu học thuật chất lượng cao. Tại Việt Nam, thông qua sự hợp tác cùng các đơn vị uy tín như IES, Macmillan Education cung cấp các giải pháp học tập tiên tiến, từ giáo trình tiếng Anh chuẩn quốc tế đến các tài liệu bổ trợ kỹ năng, đại diện cho tinh thần hội nhập, tư duy toàn cầu và cam kết mang lại giá trị giáo dục vượt trội cho mọi lứa tuổi.', 'Loại sản phẩm: Sách tiếng Anh#Thương hiệu: Macmillan Education#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Macmillan ', DEFAULT, 210000.00, 0.15, 16, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (129, 7, 'Bundle: Pathways: Reading, Writing, and Critical Thinking Foundations, 2nd Student Edition + Online Workbook', 'Thương hiệu: Mamilan Education# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: IES Việt Nam', 'Macmillan Education là một trong những nhà xuất bản giáo dục hàng đầu thế giới với lịch sử lâu đời, nổi tiếng bởi các chương trình đào tạo ngôn ngữ và tài liệu học thuật chất lượng cao. Tại Việt Nam, thông qua sự hợp tác cùng các đơn vị uy tín như IES, Macmillan Education cung cấp các giải pháp học tập tiên tiến, từ giáo trình tiếng Anh chuẩn quốc tế đến các tài liệu bổ trợ kỹ năng, đại diện cho tinh thần hội nhập, tư duy toàn cầu và cam kết mang lại giá trị giáo dục vượt trội cho mọi lứa tuổi.', 'Loại sản phẩm: Sách tiếng Anh#Thương hiệu: Macmillan Education#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Macmillan ', DEFAULT, 210000.00, 0.15, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (130, 7, 'IMPACT BRE 4 WORKBOOK & WB AUDIO CD', 'Thương hiệu: Mamilan Education# Tình trạng: Hết hàng# Đơn vị chịu trách nhiệm: IES Việt Nam', 'Macmillan Education là một trong những nhà xuất bản giáo dục hàng đầu thế giới với lịch sử lâu đời, nổi tiếng bởi các chương trình đào tạo ngôn ngữ và tài liệu học thuật chất lượng cao. Tại Việt Nam, thông qua sự hợp tác cùng các đơn vị uy tín như IES, Macmillan Education cung cấp các giải pháp học tập tiên tiến, từ giáo trình tiếng Anh chuẩn quốc tế đến các tài liệu bổ trợ kỹ năng, đại diện cho tinh thần hội nhập, tư duy toàn cầu và cam kết mang lại giá trị giáo dục vượt trội cho mọi lứa tuổi.', 'Loại sản phẩm: Sách tiếng Anh#Thương hiệu: Macmillan Education#Chất liệu: Giấy#Trọng lượng: #Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Macmillan ', DEFAULT, 210000.00, 0.15, 5, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (131, 9, 'Gói dụng cụ văn phòng ghi chú cơ bản 1', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: Thiên Long - FlexOffice#Chất liệu: Nhựa, giấy, kim loại#Trọng lượng: 399g#Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Thiên Long', DEFAULT, 151800.00, 0.10, 48, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (132, 9, 'Gói dụng cụ văn phòng ghi chú cơ bản 2', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: Thiên Long - FlexOffice#Chất liệu: Nhựa, giấy, kim loại#Trọng lượng: 400g#Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Thiên Long', DEFAULT, 236500.00, 0.10, 161, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (133, 9, 'Gói dụng cụ văn phòng tiện ích 3', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: Thiên Long - FlexOffice#Chất liệu: Nhựa, giấy, kim loại#Trọng lượng: 500g#Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Thiên Long', DEFAULT, 249700.00, 0.10, 20, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (134, 9, 'Gói dụng cụ văn phòng tiện ích 1', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: Thiên Long - FlexOffice#Chất liệu: Nhựa, giấy, kim loại#Trọng lượng: 450g#Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Thiên Long', DEFAULT, 361900.00, 0.15, 54, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (135, 9, 'Gói dụng cụ văn phòng tiện ích 4', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: Thiên Long - FlexOffice#Chất liệu: Nhựa, giấy, kim loại#Trọng lượng: 550g#Khuyến cáo: Tránh nguồn nhiệt, hóa chất.', 'Thiên Long', DEFAULT, 511500.00, 0.15, 65, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (136, 9, 'Máy tính khoa học Thiên Long Flexio Fx509VN - Có hơn 240 tính năng', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Máy tính điện tử#Thương hiệu: Flexio (Thiên Long)#Chất liệu: Nhựa cao cấp#Trọng lượng: 150g#Khuyến cáo: Tránh va đập mạnh, tránh nguồn nhiệt và nước.', 'Thiên Long', DEFAULT, 158400.00, 0.15, 89, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (137, 9, 'Máy tính khoa học Thiên Long Flexio Fx799VN, 4 màu pastel mới, bảo hành 7 năm, 1 đổi 1 trong 1 năm đầu', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Máy tính điện tử#Thương hiệu: Flexio (Thiên Long)#Chất liệu: Nhựa cao cấp#Trọng lượng: 160g#Khuyến cáo: Tránh va đập mạnh, tránh nguồn nhiệt và nước.', 'Thiên Long', DEFAULT, 856000.00, 0.10, 92, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (138, 9, 'Dao rọc giấy Thiên Long - Khóa tự động thông minh - Khay đựng dao nâng cấp chắc chắn an toàn hơn', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Máy tính điện tử#Thương hiệu: Flexio (Thiên Long)#Chất liệu: Nhựa cao cấp#Trọng lượng: 160g#Khuyến cáo: Tránh va đập mạnh, tránh nguồn nhiệt và nước.', 'Thiên Long', DEFAULT, 37100.00, 0.10, 90, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (139, 9, 'Kéo Flexoffice FO-SC03', 'Thương hiệu: Flexoffice#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'FlexOffice là thương hiệu cao cấp thuộc tập đoàn Thiên Long, tập trung chuyên biệt vào các giải pháp dụng cụ văn phòng hiện đại và chuyên nghiệp. Với tiêu chuẩn chất lượng quốc tế, FlexOffice cung cấp hệ sinh thái sản phẩm đa dạng từ file hồ sơ, bìa trình ký, máy tính khoa học đến các loại bút viết chuyên dụng. Đây là sự lựa chọn ưu tiên cho các doanh nghiệp và văn phòng hiện đại nhờ thiết kế tối giản, tinh tế và tính ứng dụng tối ưu trong công việc.', 'Loại sản phẩm: Dụng cụ văn phòng#Thương hiệu: FlexOffice#Chất liệu: Nhựa, thép không gỉ#Trọng lượng: 80g#Khuyến cáo: Sản phẩm có vật sắc nhọn, để xa tầm tay trẻ em.', 'FlexOffice', DEFAULT, 29700.00, 0.10, 69, '2026-01-27 19:49:37', 0);
INSERT INTO `product` VALUES (140, 9, 'Combo 10 Bút lông dầu Hoshi Thiên Long PM-019/HS - Công nghệ Nhật Bản', 'Thương hiệu: Thiên Long#Tình trạng: Còn hàng#Đơn vị chịu trách nhiệm: Tập đoàn Thiên Long', 'Thiên Long là thương hiệu \"quốc dân\" hàng đầu tại Việt Nam trong lĩnh vực văn phòng phẩm và dụng cụ học tập. Với lịch sử hơn 40 năm phát triển, Thiên Long khẳng định vị thế bằng các dòng sản phẩm chất lượng cao, thiết kế sáng tạo và gần gũi như bút bi, bút chì, tập học sinh và dụng cụ mỹ thuật Colokit. Sản phẩm Thiên Long không chỉ bền bỉ mà còn luôn cải tiến để đồng hành cùng mọi thế hệ người Việt từ trường học đến công sở.', 'Loại sản phẩm: Bút lông dầu#Thương hiệu: Thiên Long#Chất liệu: Nhựa, mực dầu#Trọng lượng: 120g#Khuyến cáo: Đậy nắp sau khi sử dụng, tránh nguồn nhiệt.', 'Thiên Long', DEFAULT, 149000.00, 0.15, 78, '2026-01-27 19:49:37', 0);

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NULL DEFAULT NULL,
  `rating` int NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_review_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_review_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_review_product'` FOREIGN KEY (`user_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_rating` CHECK (`rating` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO `review` VALUES (1, 1, 56, 5, 'Sản phẩm chất lượng', '2025-12-25 04:53:22');
INSERT INTO `review` VALUES (2, 1, 56, 3, 'Giá rẻ ghê', '2025-12-25 04:53:59');
INSERT INTO `review` VALUES (3, 1, 56, 5, 'hmm', '2025-12-25 04:54:07');
INSERT INTO `review` VALUES (4, 1, 53, 4, 'Hiệu năng rất tốt', '2025-12-25 05:12:51');
INSERT INTO `review` VALUES (5, 1, 14, 3, 'Sản phẩm khá tốt', '2025-12-25 06:30:54');
INSERT INTO `review` VALUES (6, 1, 14, 2, 'Màu dễ bám bụi', '2025-12-25 06:33:55');
INSERT INTO `review` VALUES (7, 1, 11, 4, 'Mua được lúc giảm giá, khá hời', '2025-12-25 06:44:04');
INSERT INTO `review` VALUES (8, 2, 115, 4, 'Chất lượng giấy khá tốt', '2026-04-11 02:25:14');

-- ----------------------------
-- Table structure for setting
-- ----------------------------
DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting`  (
  `setting_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `setting_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`setting_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of setting
-- ----------------------------
INSERT INTO `setting` VALUES ('address', '159 QL1K, P.Đông Hòa, Dĩ An, TP.HCM');
INSERT INTO `setting` VALUES ('email', 'hotro@papercraft.com');
INSERT INTO `setting` VALUES ('facebook', 'https://www.facebook.com');
INSERT INTO `setting` VALUES ('instagram', 'https://www.instagram.com/odaecnorb_hg/');
INSERT INTO `setting` VALUES ('phone', '+84 036363636');
INSERT INTO `setting` VALUES ('policy_guarantee', '<p style=\"text-align:center\"><em>Cập nhật lần cuối: 15/11/2025</em></p>\r\n\r\n<p>PaperCraft cam kết mang đến sự an t&acirc;m tuyệt đối cho kh&aacute;ch h&agrave;ng. Ch&uacute;ng t&ocirc;i tự h&agrave;o cung cấp chương tr&igrave;nh Bảo H&agrave;nh V&agrave;ng 3 Năm cho c&aacute;c sản phẩm m&aacute;y in ch&iacute;nh h&atilde;ng v&agrave; dịch vụ Hỗ Trợ Kỹ Thuật 24/7, đảm bảo thiết bị của bạn lu&ocirc;n hoạt động ổn định.</p>\r\n\r\n<h2>1. Cam Kết &quot;Bảo H&agrave;nh 3 Năm&quot;</h2>\r\n\r\n<p>Đ&acirc;y l&agrave; chương tr&igrave;nh bảo h&agrave;nh to&agrave;n diện, &aacute;p dụng cho c&aacute;c sản phẩm m&aacute;y in được mua tại PaperCraft (c&oacute; quy định cụ thể theo từng d&ograve;ng sản phẩm).</p>\r\n\r\n<h3>A. Phạm vi bảo h&agrave;nh (Những g&igrave; được bảo h&agrave;nh)</h3>\r\n\r\n<ul>\r\n	<li>Bảo h&agrave;nh miễn ph&iacute; 100% cho bất kỳ lỗi n&agrave;o li&ecirc;n quan đến phần cứng, linh kiện ph&aacute;t sinh từ ph&iacute;a nh&agrave; sản xuất.</li>\r\n	<li>C&aacute;c lỗi kỹ thuật như: M&aacute;y kh&ocirc;ng l&ecirc;n nguồn, kh&ocirc;ng kết nối được với m&aacute;y t&iacute;nh (đ&atilde; loại trừ lỗi phần mềm/driver), lỗi cơ học b&ecirc;n trong m&aacute;y.</li>\r\n	<li>Bo mạch chủ, bộ nguồn v&agrave; c&aacute;c linh kiện điện tử quan trọng của m&aacute;y.</li>\r\n</ul>\r\n\r\n<h3>B. C&aacute;c trường hợp kh&ocirc;ng được bảo h&agrave;nh (Miễn trừ)</h3>\r\n\r\n<p>Ch&iacute;nh s&aacute;ch bảo h&agrave;nh 3 năm kh&ocirc;ng &aacute;p dụng cho c&aacute;c trường hợp sau:</p>\r\n\r\n<ul>\r\n	<li>Lỗi do người sử dụng: L&agrave;m rơi vỡ, va đập mạnh, để nước hoặc h&oacute;a chất lọt v&agrave;o m&aacute;y.</li>\r\n	<li>Sử dụng vật tư kh&ocirc;ng ch&iacute;nh h&atilde;ng: Sử dụng mực nạp, mực in kh&ocirc;ng tương th&iacute;ch, hoặc giấy in kh&ocirc;ng đ&uacute;ng ti&ecirc;u chuẩn g&acirc;y hỏng h&oacute;c (v&iacute; dụ: hỏng đầu phun, hỏng bộ sấy).</li>\r\n	<li>Bộ phận ti&ecirc;u hao: Bảo h&agrave;nh kh&ocirc;ng &aacute;p dụng cho c&aacute;c vật tư ti&ecirc;u hao như hộp mực (toner/ink cartridge), trống (drum), bao lụa, trục cao su. C&aacute;c linh kiện n&agrave;y sẽ được bảo h&agrave;nh theo ti&ecirc;u chuẩn ri&ecirc;ng của nh&agrave; sản xuất (v&iacute; dụ: bảo h&agrave;nh &quot;đến giọt mực cuối c&ugrave;ng&quot; đối với lỗi mực).</li>\r\n	<li>Tự &yacute; can thiệp: Sản phẩm bị hỏng do tự &yacute; th&aacute;o dỡ, sửa chữa bởi c&aacute;c c&aacute; nh&acirc;n hoặc đơn vị kh&ocirc;ng được PaperCraft ủy quyền.</li>\r\n	<li>Nguy&ecirc;n nh&acirc;n kh&aacute;ch quan: Hỏng h&oacute;c do thi&ecirc;n tai, hỏa hoạn, chập điện (do nguồn điện kh&ocirc;ng ổn định)...</li>\r\n</ul>\r\n\r\n<h2>2. Cam Kết &quot;Hỗ Trợ 24/7&quot;</h2>\r\n\r\n<p>Ch&uacute;ng t&ocirc;i hiểu rằng c&ocirc;ng việc của bạn kh&ocirc;ng thể gi&aacute;n đoạn. Đội ngũ kỹ thuật của PaperCraft lu&ocirc;n sẵn s&agrave;ng hỗ trợ bạn bất cứ khi n&agrave;o bạn cần.</p>\r\n\r\n<ul>\r\n	<li>Hỗ trợ qua điện thoại &amp; Zalo: Chẩn đo&aacute;n v&agrave; xử l&yacute; nhanh c&aacute;c lỗi phần mềm (c&agrave;i đặt driver, thiết lập mạng LAN/Wifi cho m&aacute;y in) từ xa.</li>\r\n	<li>Hỗ trợ kỹ thuật chuy&ecirc;n nghiệp: Đối với c&aacute;c lỗi phần cứng, kỹ thuật vi&ecirc;n sẽ hướng dẫn bạn c&aacute;c bước kiểm tra cơ bản. Nếu kh&ocirc;ng thể khắc phục từ xa, ch&uacute;ng t&ocirc;i sẽ sắp xếp lịch bảo h&agrave;nh.</li>\r\n	<li>Cam kết phản hồi: Mọi y&ecirc;u cầu hỗ trợ sẽ được tiếp nhận v&agrave; phản hồi trong thời gian sớm nhất, kể cả ngo&agrave;i giờ h&agrave;nh ch&iacute;nh v&agrave; ng&agrave;y lễ.</li>\r\n</ul>\r\n\r\n<h2>3. Quy Tr&igrave;nh Y&ecirc;u Cầu Bảo H&agrave;nh</h2>\r\n\r\n<p>Khi m&aacute;y in hoặc thiết bị văn ph&ograve;ng phẩm gặp sự cố, vui l&ograve;ng thực hiện theo c&aacute;c bước sau:</p>\r\n\r\n<ol>\r\n	<li>Bước 1: Li&ecirc;n hệ ngay lập tức với Bộ phận Hỗ Trợ 24/7 của PaperCraft qua Hotline hoặc Email.</li>\r\n	<li>Bước 2: Cung cấp th&ocirc;ng tin:\r\n	<ul>\r\n		<li>T&ecirc;n sản phẩm, Model m&aacute;y.</li>\r\n		<li>M&atilde; số đơn h&agrave;ng hoặc số điện thoại mua h&agrave;ng.</li>\r\n		<li>M&ocirc; tả chi tiết sự cố, k&egrave;m theo h&igrave;nh ảnh hoặc video quay lại lỗi (nếu c&oacute; thể).</li>\r\n	</ul>\r\n	</li>\r\n	<li>Bước 3: Kỹ thuật vi&ecirc;n sẽ hỗ trợ bạn xử l&yacute; từ xa.</li>\r\n	<li>Bước 4: Nếu kh&ocirc;ng thể xử l&yacute; từ xa, ch&uacute;ng t&ocirc;i sẽ hướng dẫn bạn gửi sản phẩm về trung t&acirc;m bảo h&agrave;nh PaperCraft hoặc sắp xếp dịch vụ bảo h&agrave;nh tận nơi (t&ugrave;y theo ch&iacute;nh s&aacute;ch cụ thể của sản phẩm).</li>\r\n</ol>\r\n\r\n<p>Mọi thắc mắc về ch&iacute;nh s&aacute;ch, vui l&ograve;ng li&ecirc;n hệ trực tiếp <a href=\"mailto:hotro@papercraft.vn\">hotro@papercraft.vn</a> để được giải đ&aacute;p.</p>\r\n');
INSERT INTO `setting` VALUES ('policy_privacy', '<p style=\"text-align:center\"><em>Cập nhật lần cuối: 15/11/2025</em></p>\r\n\r\n<p>Tại PaperCraft, sự h&agrave;i l&ograve;ng của bạn l&agrave; ưu ti&ecirc;n h&agrave;ng đầu. Ch&uacute;ng t&ocirc;i cung cấp ch&iacute;nh s&aacute;ch đổi trả v&agrave; bảo h&agrave;nh r&otilde; r&agrave;ng, minh bạch để đảm bảo trải nghiệm mua sắm tốt nhất. Đặc biệt, ch&uacute;ng t&ocirc;i tự h&agrave;o với chương tr&igrave;nh Bảo H&agrave;nh 3 Năm cho nhiều sản phẩm m&aacute;y in.</p>\r\n\r\n<h2>1. Quy Định Đổi Trả H&agrave;ng (Trong 7 ng&agrave;y đầu)</h2>\r\n\r\n<p>Bạn c&oacute; quyền y&ecirc;u cầu đổi hoặc trả lại sản phẩm trong v&ograve;ng 7 ng&agrave;y kể từ ng&agrave;y nhận h&agrave;ng nếu sản phẩm gặp c&aacute;c lỗi sau:</p>\r\n\r\n<ul>\r\n	<li>Sản phẩm bị lỗi kỹ thuật từ nh&agrave; sản xuất (v&iacute; dụ: m&aacute;y in kh&ocirc;ng l&ecirc;n nguồn, bản in bị lỗi h&agrave;ng loạt kh&ocirc;ng phải do c&agrave;i đặt).</li>\r\n	<li>Sản phẩm giao kh&ocirc;ng đ&uacute;ng model, chủng loại, hoặc th&ocirc;ng số kỹ thuật so với đơn đặt h&agrave;ng.</li>\r\n	<li>Sản phẩm bị hỏng h&oacute;c, trầy xước trong qu&aacute; tr&igrave;nh vận chuyển của PaperCraft.</li>\r\n</ul>\r\n\r\n<h2>2. Điều Kiện Đổi Trả</h2>\r\n\r\n<p>Để được chấp nhận đổi trả, sản phẩm của bạn cần đ&aacute;p ứng:</p>\r\n\r\n<ul>\r\n	<li>Sản phẩm phải c&ograve;n nguy&ecirc;n vẹn, đầy đủ phụ kiện, s&aacute;ch hướng dẫn, th&ugrave;ng xốp v&agrave; hộp (carton) đi k&egrave;m.</li>\r\n	<li>Sản phẩm kh&ocirc;ng c&oacute; dấu hiệu đ&atilde; qua sử dụng (đối với lỗi kh&ocirc;ng phải từ nh&agrave; sản xuất) hoặc bị can thiệp, sửa chữa từ b&ecirc;n ngo&agrave;i.</li>\r\n	<li>Lưu &yacute; đặc biệt với mực in, vật tư: C&aacute;c sản phẩm như hộp mực (toner), băng mực, giấy in... nếu đ&atilde; bị b&oacute;c ra khỏi bao b&igrave; ni&ecirc;m phong (seal) sẽ kh&ocirc;ng được hỗ trợ đổi trả, trừ trường hợp lỗi từ nh&agrave; sản xuất.</li>\r\n</ul>\r\n\r\n<h2>3. Quy Tr&igrave;nh Bảo H&agrave;nh (Chương Tr&igrave;nh 3 Năm)</h2>\r\n\r\n<p>PaperCraft cung cấp ch&iacute;nh s&aacute;ch Bảo H&agrave;nh 3 Năm to&agrave;n diện cho c&aacute;c sản phẩm m&aacute;y in được chỉ định.</p>\r\n\r\n<ul>\r\n	<li>Điều kiện bảo h&agrave;nh: Sản phẩm được bảo h&agrave;nh miễn ph&iacute; nếu lỗi ph&aacute;t sinh l&agrave; do linh kiện hoặc lỗi sản xuất.</li>\r\n	<li>C&aacute;c trường hợp kh&ocirc;ng được bảo h&agrave;nh:\r\n	<ul>\r\n		<li>Sản phẩm hỏng h&oacute;c do thi&ecirc;n tai, hỏa hoạn, rơi vỡ, ẩm ướt.</li>\r\n		<li>Sử dụng kh&ocirc;ng đ&uacute;ng điện &aacute;p quy định, hoặc sử dụng mực nạp, mực kh&ocirc;ng ch&iacute;nh h&atilde;ng g&acirc;y hỏng h&oacute;c.</li>\r\n		<li>Sản phẩm bị tự &yacute; th&aacute;o dỡ, sửa chữa bởi c&aacute;c c&aacute; nh&acirc;n kh&ocirc;ng phải kỹ thuật vi&ecirc;n của PaperCraft.</li>\r\n		<li>C&aacute;c bộ phận ti&ecirc;u hao (như hộp mực, trống (drum), bao lụa...) sẽ được bảo h&agrave;nh theo quy định ri&ecirc;ng của nh&agrave; sản xuất, kh&ocirc;ng nằm trong g&oacute;i 3 năm.</li>\r\n	</ul>\r\n	</li>\r\n	<li>Quy tr&igrave;nh: Khi sản phẩm gặp sự cố, vui l&ograve;ng li&ecirc;n hệ hotline. Ch&uacute;ng t&ocirc;i cung cấp dịch vụ Hỗ Trợ 24/7 để chẩn đo&aacute;n sự cố từ xa hoặc sắp xếp kỹ thuật vi&ecirc;n đến tận nơi (nếu &aacute;p dụng).</li>\r\n</ul>\r\n\r\n<h2>4. Quy Tr&igrave;nh Xử L&yacute; Đổi Trả / Bảo H&agrave;nh</h2>\r\n\r\n<p>Bước 1: Li&ecirc;n hệ bộ phận Hỗ Trợ 24/7 của PaperCraft qua email <a href=\"mailto:hotro@papercraft.vn\">hotro@papercraft.vn</a> hoặc hotline. Vui l&ograve;ng cung cấp m&atilde; đơn h&agrave;ng v&agrave; h&igrave;nh ảnh/video về sự cố.</p>\r\n\r\n<p>Bước 2: Sau khi x&aacute;c nhận, ch&uacute;ng t&ocirc;i sẽ hướng dẫn bạn c&aacute;ch gửi trả sản phẩm về trung t&acirc;m bảo h&agrave;nh của PaperCraft.</p>\r\n\r\n<p>Bước 3: Đối với h&agrave;ng đổi trả, ch&uacute;ng t&ocirc;i sẽ gửi sản phẩm mới cho bạn trong v&ograve;ng 2-3 ng&agrave;y l&agrave;m việc sau khi nhận được h&agrave;ng lỗi. Đối với bảo h&agrave;nh, thời gian xử l&yacute; sẽ phụ thuộc v&agrave;o mức độ lỗi của sản phẩm.</p>\r\n\r\n<h2>5. Ho&agrave;n Tiền</h2>\r\n\r\n<p>Trong trường hợp trả h&agrave;ng (do lỗi từ PaperCraft) m&agrave; kh&ocirc;ng c&oacute; sản phẩm tương tự để đổi, ch&uacute;ng t&ocirc;i sẽ ho&agrave;n lại 100% gi&aacute; trị đơn h&agrave;ng cho bạn qua chuyển khoản ng&acirc;n h&agrave;ng trong v&ograve;ng 5-7 ng&agrave;y l&agrave;m việc.</p>\r\n');
INSERT INTO `setting` VALUES ('policy_return', '<p style=\"text-align:center\"><em>Cập nhật lần cuối: 15/11/2025</em></p>\r\n\r\n<p>Tại PaperCraft, sự h&agrave;i l&ograve;ng của bạn l&agrave; ưu ti&ecirc;n h&agrave;ng đầu. Ch&uacute;ng t&ocirc;i cung cấp ch&iacute;nh s&aacute;ch đổi trả v&agrave; bảo h&agrave;nh r&otilde; r&agrave;ng, minh bạch để đảm bảo trải nghiệm mua sắm tốt nhất. Đặc biệt, ch&uacute;ng t&ocirc;i tự h&agrave;o với chương tr&igrave;nh Bảo H&agrave;nh 3 Năm cho nhiều sản phẩm m&aacute;y in.</p>\r\n\r\n<h2>1. Quy Định Đổi Trả H&agrave;ng (Trong 7 ng&agrave;y đầu)</h2>\r\n\r\n<p>Bạn c&oacute; quyền y&ecirc;u cầu đổi hoặc trả lại sản phẩm trong v&ograve;ng 7 ng&agrave;y kể từ ng&agrave;y nhận h&agrave;ng nếu sản phẩm gặp c&aacute;c lỗi sau:</p>\r\n\r\n<ul>\r\n	<li>Sản phẩm bị lỗi kỹ thuật từ nh&agrave; sản xuất (v&iacute; dụ: m&aacute;y in kh&ocirc;ng l&ecirc;n nguồn, bản in bị lỗi h&agrave;ng loạt kh&ocirc;ng phải do c&agrave;i đặt).</li>\r\n	<li>Sản phẩm giao kh&ocirc;ng đ&uacute;ng model, chủng loại, hoặc th&ocirc;ng số kỹ thuật so với đơn đặt h&agrave;ng.</li>\r\n	<li>Sản phẩm bị hỏng h&oacute;c, trầy xước trong qu&aacute; tr&igrave;nh vận chuyển của PaperCraft.</li>\r\n</ul>\r\n\r\n<h2>2. Điều Kiện Đổi Trả</h2>\r\n\r\n<p>Để được chấp nhận đổi trả, sản phẩm của bạn cần đ&aacute;p ứng:</p>\r\n\r\n<ul>\r\n	<li>Sản phẩm phải c&ograve;n nguy&ecirc;n vẹn, đầy đủ phụ kiện, s&aacute;ch hướng dẫn, th&ugrave;ng xốp v&agrave; hộp (carton) đi k&egrave;m.</li>\r\n	<li>Sản phẩm kh&ocirc;ng c&oacute; dấu hiệu đ&atilde; qua sử dụng (đối với lỗi kh&ocirc;ng phải từ nh&agrave; sản xuất) hoặc bị can thiệp, sửa chữa từ b&ecirc;n ngo&agrave;i.</li>\r\n	<li>Lưu &yacute; đặc biệt với mực in, vật tư: C&aacute;c sản phẩm như hộp mực (toner), băng mực, giấy in... nếu đ&atilde; bị b&oacute;c ra khỏi bao b&igrave; ni&ecirc;m phong (seal) sẽ kh&ocirc;ng được hỗ trợ đổi trả, trừ trường hợp lỗi từ nh&agrave; sản xuất.</li>\r\n</ul>\r\n\r\n<h2>3. Quy Tr&igrave;nh Bảo H&agrave;nh (Chương Tr&igrave;nh 3 Năm)</h2>\r\n\r\n<p>PaperCraft cung cấp ch&iacute;nh s&aacute;ch Bảo H&agrave;nh 3 Năm to&agrave;n diện cho c&aacute;c sản phẩm m&aacute;y in được chỉ định.</p>\r\n\r\n<ul>\r\n	<li>Điều kiện bảo h&agrave;nh: Sản phẩm được bảo h&agrave;nh miễn ph&iacute; nếu lỗi ph&aacute;t sinh l&agrave; do linh kiện hoặc lỗi sản xuất.</li>\r\n	<li>C&aacute;c trường hợp kh&ocirc;ng được bảo h&agrave;nh:\r\n	<ul>\r\n		<li>Sản phẩm hỏng h&oacute;c do thi&ecirc;n tai, hỏa hoạn, rơi vỡ, ẩm ướt.</li>\r\n		<li>Sử dụng kh&ocirc;ng đ&uacute;ng điện &aacute;p quy định, hoặc sử dụng mực nạp, mực kh&ocirc;ng ch&iacute;nh h&atilde;ng g&acirc;y hỏng h&oacute;c.</li>\r\n		<li>Sản phẩm bị tự &yacute; th&aacute;o dỡ, sửa chữa bởi c&aacute;c c&aacute; nh&acirc;n kh&ocirc;ng phải kỹ thuật vi&ecirc;n của PaperCraft.</li>\r\n		<li>C&aacute;c bộ phận ti&ecirc;u hao (như hộp mực, trống (drum), bao lụa...) sẽ được bảo h&agrave;nh theo quy định ri&ecirc;ng của nh&agrave; sản xuất, kh&ocirc;ng nằm trong g&oacute;i 3 năm.</li>\r\n	</ul>\r\n	</li>\r\n	<li>Quy tr&igrave;nh: Khi sản phẩm gặp sự cố, vui l&ograve;ng li&ecirc;n hệ hotline. Ch&uacute;ng t&ocirc;i cung cấp dịch vụ Hỗ Trợ 24/7 để chẩn đo&aacute;n sự cố từ xa hoặc sắp xếp kỹ thuật vi&ecirc;n đến tận nơi (nếu &aacute;p dụng).</li>\r\n</ul>\r\n\r\n<h2>4. Quy Tr&igrave;nh Xử L&yacute; Đổi Trả / Bảo H&agrave;nh</h2>\r\n\r\n<p>Bước 1: Li&ecirc;n hệ bộ phận Hỗ Trợ 24/7 của PaperCraft qua email <a href=\"mailto:hotro@papercraft.vn\">hotro@papercraft.vn</a> hoặc hotline. Vui l&ograve;ng cung cấp m&atilde; đơn h&agrave;ng v&agrave; h&igrave;nh ảnh/video về sự cố.</p>\r\n\r\n<p>Bước 2: Sau khi x&aacute;c nhận, ch&uacute;ng t&ocirc;i sẽ hướng dẫn bạn c&aacute;ch gửi trả sản phẩm về trung t&acirc;m bảo h&agrave;nh của PaperCraft.</p>\r\n\r\n<p>Bước 3: Đối với h&agrave;ng đổi trả, ch&uacute;ng t&ocirc;i sẽ gửi sản phẩm mới cho bạn trong v&ograve;ng 2-3 ng&agrave;y l&agrave;m việc sau khi nhận được h&agrave;ng lỗi. Đối với bảo h&agrave;nh, thời gian xử l&yacute; sẽ phụ thuộc v&agrave;o mức độ lỗi của sản phẩm.</p>\r\n\r\n<h2>5. Ho&agrave;n Tiền</h2>\r\n\r\n<p>Trong trường hợp trả h&agrave;ng (do lỗi từ PaperCraft) m&agrave; kh&ocirc;ng c&oacute; sản phẩm tương tự để đổi, ch&uacute;ng t&ocirc;i sẽ ho&agrave;n lại 100% gi&aacute; trị đơn h&agrave;ng cho bạn qua chuyển khoản ng&acirc;n h&agrave;ng trong v&ograve;ng 5-7 ng&agrave;y l&agrave;m việc.</p>\r\n');
INSERT INTO `setting` VALUES ('policy_terms', '<p style=\"text-align:center\"><em>Cập nhật lần cuối: 15/11/2025</em></p>\r\n\r\n<p>Ch&agrave;o mừng bạn đến với PaperCraft! Bằng c&aacute;ch truy cập hoặc sử dụng website của ch&uacute;ng t&ocirc;i v&agrave; mua c&aacute;c sản phẩm (m&aacute;y in, văn ph&ograve;ng phẩm...), bạn đồng &yacute; tu&acirc;n thủ v&agrave; bị r&agrave;ng buộc bởi c&aacute;c điều khoản v&agrave; dịch vụ dưới đ&acirc;y. Vui l&ograve;ng đọc kỹ trước khi sử dụng.</p>\r\n\r\n<h2>1. Chấp nhận Điều khoản</h2>\r\n\r\n<p>C&aacute;c điều khoản n&agrave;y &aacute;p dụng cho tất cả người d&ugrave;ng, bao gồm kh&aacute;ch truy cập, kh&aacute;ch h&agrave;ng v&agrave; bất kỳ ai kh&aacute;c truy cập hoặc sử dụng dịch vụ. Nếu bạn kh&ocirc;ng đồng &yacute; với bất kỳ phần n&agrave;o của điều khoản, bạn kh&ocirc;ng được ph&eacute;p truy cập dịch vụ.</p>\r\n\r\n<h2>2. T&agrave;i khoản Người d&ugrave;ng</h2>\r\n\r\n<p>Khi bạn tạo t&agrave;i khoản với ch&uacute;ng t&ocirc;i, bạn phải cung cấp th&ocirc;ng tin ch&iacute;nh x&aacute;c, đầy đủ v&agrave; cập nhật. Bạn c&oacute; tr&aacute;ch nhiệm bảo mật mật khẩu của m&igrave;nh v&agrave; chịu ho&agrave;n to&agrave;n tr&aacute;ch nhiệm cho mọi hoạt động diễn ra dưới t&ecirc;n t&agrave;i khoản của bạn.</p>\r\n\r\n<h2>3. Sản phẩm v&agrave; Gi&aacute; cả</h2>\r\n\r\n<p>Ch&uacute;ng t&ocirc;i nỗ lực hiển thị th&ocirc;ng tin sản phẩm (m&aacute;y in, mực in, giấy...) một c&aacute;ch ch&iacute;nh x&aacute;c nhất. Tuy nhi&ecirc;n, ch&uacute;ng t&ocirc;i kh&ocirc;ng đảm bảo rằng m&ocirc; tả sản phẩm hoặc nội dung kh&aacute;c l&agrave; ho&agrave;n to&agrave;n kh&ocirc;ng c&oacute; lỗi.</p>\r\n\r\n<p>Gi&aacute; cả c&oacute; thể thay đổi m&agrave; kh&ocirc;ng cần th&ocirc;ng b&aacute;o trước. Ch&uacute;ng t&ocirc;i c&oacute; quyền từ chối hoặc hủy bỏ bất kỳ đơn h&agrave;ng n&agrave;o nếu ph&aacute;t hiện c&oacute; lỗi về gi&aacute; hoặc th&ocirc;ng tin sản phẩm.</p>\r\n\r\n<h2>4. Đặt h&agrave;ng v&agrave; Thanh to&aacute;n</h2>\r\n\r\n<p>Việc bạn đặt h&agrave;ng l&agrave; một đề nghị mua sản phẩm. Ch&uacute;ng t&ocirc;i c&oacute; quyền chấp nhận hoặc từ chối đơn h&agrave;ng n&agrave;y v&igrave; bất kỳ l&yacute; do g&igrave;. Đơn h&agrave;ng chỉ được xem l&agrave; chấp nhận khi ch&uacute;ng t&ocirc;i gửi email x&aacute;c nhận vận chuyển.</p>\r\n\r\n<p>Bạn đồng &yacute; cung cấp th&ocirc;ng tin thanh to&aacute;n hợp lệ v&agrave; đầy đủ cho tất cả c&aacute;c giao dịch.</p>\r\n\r\n<h2>5. Vận chuyển v&agrave; Giao h&agrave;ng</h2>\r\n\r\n<p>Ch&uacute;ng t&ocirc;i sẽ xử l&yacute; v&agrave; vận chuyển đơn h&agrave;ng theo &quot;Ch&iacute;nh s&aacute;ch Vận chuyển&quot; được c&ocirc;ng bố. Ch&uacute;ng t&ocirc;i cung cấp miễn ph&iacute; vận chuyển cho c&aacute;c đơn h&agrave;ng c&oacute; gi&aacute; trị từ 500.000 VNĐ. Thời gian giao h&agrave;ng dự kiến chỉ l&agrave; ước t&iacute;nh v&agrave; c&oacute; thể thay đổi.</p>\r\n\r\n<h2>6. Bảo h&agrave;nh v&agrave; Đổi trả</h2>\r\n\r\n<p>PaperCraft tự h&agrave;o cung cấp ch&iacute;nh s&aacute;ch bảo h&agrave;nh ưu việt, bao gồm chương tr&igrave;nh Bảo H&agrave;nh 3 Năm cho nhiều danh mục sản phẩm chủ lực. C&aacute;c điều kiện, quy tr&igrave;nh v&agrave; chi tiết về bảo h&agrave;nh, đổi trả được quy định r&otilde; r&agrave;ng trong &quot;Ch&iacute;nh s&aacute;ch Bảo h&agrave;nh &amp; Đổi trả&quot; của ch&uacute;ng t&ocirc;i.</p>\r\n\r\n<h2>7. Sở hữu tr&iacute; tuệ</h2>\r\n\r\n<p>To&agrave;n bộ nội dung tr&ecirc;n website n&agrave;y, bao gồm văn bản, đồ họa, logo (PaperCraft), h&igrave;nh ảnh, v&agrave; phần mềm, l&agrave; t&agrave;i sản của PaperCraft hoặc c&aacute;c nh&agrave; cung cấp của ch&uacute;ng t&ocirc;i v&agrave; được bảo vệ bởi luật bản quyền. Bạn kh&ocirc;ng được ph&eacute;p sao ch&eacute;p, ph&acirc;n phối hoặc sử dụng bất kỳ nội dung n&agrave;o m&agrave; kh&ocirc;ng c&oacute; sự cho ph&eacute;p bằng văn bản của ch&uacute;ng t&ocirc;i.</p>\r\n\r\n<h2>8. Giới hạn Tr&aacute;ch nhiệm</h2>\r\n\r\n<p>PaperCraft sẽ kh&ocirc;ng chịu tr&aacute;ch nhiệm ph&aacute;p l&yacute; cho bất kỳ thiệt hại gi&aacute;n tiếp, ngẫu nhi&ecirc;n hoặc hậu quả n&agrave;o ph&aacute;t sinh từ việc bạn sử dụng hoặc kh&ocirc;ng thể sử dụng website, sản phẩm hoặc dịch vụ của ch&uacute;ng t&ocirc;i.</p>\r\n\r\n<h2>9. Thay đổi Điều khoản</h2>\r\n\r\n<p>Ch&uacute;ng t&ocirc;i c&oacute; quyền sửa đổi hoặc thay thế c&aacute;c Điều khoản n&agrave;y bất kỳ l&uacute;c n&agrave;o. Việc bạn tiếp tục sử dụng dịch vụ sau khi c&aacute;c thay đổi c&oacute; hiệu lực đồng nghĩa với việc bạn chấp nhận c&aacute;c điều khoản mới.</p>\r\n\r\n<h2>10. Luật &aacute;p dụng</h2>\r\n\r\n<p>C&aacute;c Điều khoản n&agrave;y sẽ được điều chỉnh v&agrave; hiểu theo luật ph&aacute;p của Việt Nam, m&agrave; kh&ocirc;ng x&eacute;t đến xung đột c&aacute;c quy định ph&aacute;p luật.</p>\r\n\r\n<h2>11. Li&ecirc;n hệ</h2>\r\n\r\n<p>Nếu bạn c&oacute; bất kỳ c&acirc;u hỏi n&agrave;o về c&aacute;c Điều khoản n&agrave;y, vui l&ograve;ng li&ecirc;n hệ với ch&uacute;ng t&ocirc;i qua email: <a href=\"mailto:hotro@papercraft.vn\">hotro@papercraft.vn</a> hoặc hotline hỗ trợ.</p>\r\n');
INSERT INTO `setting` VALUES ('twitter', 'https://www.twitter.com');
INSERT INTO `setting` VALUES ('working_hours', 'Từ thứ 2- thứ 6: 9h-18h');

-- ----------------------------
-- Table structure for user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `user_permissions`;
CREATE TABLE `user_permissions`  (
  `user_id` int NOT NULL,
  `permission` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`user_id`, `permission`) USING BTREE,
  CONSTRAINT `fk_user_permission` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_permissions
-- ----------------------------
INSERT INTO `user_permissions` VALUES (2, 'blog-manage');
INSERT INTO `user_permissions` VALUES (2, 'dashboard');
INSERT INTO `user_permissions` VALUES (2, 'order-manage');
INSERT INTO `user_permissions` VALUES (2, 'product-manage');
INSERT INTO `user_permissions` VALUES (2, 'review-manage');

-- ----------------------------
-- Table structure for user_vouchers
-- ----------------------------
DROP TABLE IF EXISTS `user_vouchers`;
CREATE TABLE `user_vouchers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int NOT NULL,
  `is_used` bit(1) NULL DEFAULT b'0',
  `used_at` timestamp NULL DEFAULT NULL,
  `received_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_user_voucher`(`user_id` ASC, `voucher_id` ASC) USING BTREE,
  INDEX `voucher_id`(`voucher_id` ASC) USING BTREE,
  CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_vouchers
-- ----------------------------
INSERT INTO `user_vouchers` VALUES (1, 3, 1, b'1', '2026-06-01 08:32:50', '2026-05-24 09:50:03');
INSERT INTO `user_vouchers` VALUES (2, 3, 2, b'0', NULL, '2026-05-24 09:50:51');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fullname` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci GENERATED ALWAYS AS (concat(`fname`,_utf8mb4'  ',`lname`)) STORED NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'Hoang', 'Tan', 'admin@gmail.com', '40e297abc926e09c2ead69e10ea02959', '0123456789', 'admin', 'male', b'1', '2025-12-24 14:12:11', DEFAULT);
INSERT INTO `users` VALUES (2, 'Hoang', 'Tan', '23130291@st.hcmuaf.edu.vn', '07b7f1730a730bfcc4bd4c5fe2a648e2', '0373052604', 'mod', 'male', b'1', '2025-12-30 15:50:08', DEFAULT);
INSERT INTO `users` VALUES (3, 'Hinh', 'Nguyen', '23130110@st.hcmuaf.edu.vn', '827ccb0eea8a706c4c34a16891f84e7b', '0866501452', 'admin', 'male', b'1', '2026-01-26 10:43:32', DEFAULT);
INSERT INTO `users` VALUES (5, 'com', 'papercraft', 'papercraft1784@gmail.com', '07b7f1730a730bfcc4bd4c5fe2a648e2', '0373052604', 'user', 'male', b'1', '2026-03-29 09:49:51', DEFAULT);
INSERT INTO `users` VALUES (9, 'Hoang', 'Tan', 'hoangtan130405@gmail.com', '938aa11814b70daa7fdae24f971012a9', '0373052604', 'user', 'male', b'1', '2026-04-16 14:35:44', DEFAULT);
INSERT INTO `users` VALUES (10, 'Hinh Nguyễn', 'Thiết', 'thiethinhnguyen@gmail.com', '625f752bb355920386f088bf1f4dd16f', '0866501452', 'user', 'male', b'1', '2026-06-01 09:03:49', DEFAULT);

-- ----------------------------
-- Table structure for vouchers
-- ----------------------------
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE `vouchers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `discount_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(10, 2) NOT NULL,
  `max_discount` decimal(10, 2) NULL DEFAULT NULL,
  `min_order_value` decimal(10, 2) NULL DEFAULT 0.00,
  `quantity` int NULL DEFAULT 0,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vouchers
-- ----------------------------
INSERT INTO `vouchers` VALUES (1, 'GIAM500K', 'D500K', 'Giảm ngay 500 nghìn đồng khi mua đơn trên 1.000.000 đồng', 'FIXED', 500000.00, 500000.00, 1000000.00, 100, '2026-05-22 01:00:00', '2026-06-06 01:00:00', 'ACTIVE', '2026-05-24 06:12:09', b'0');
INSERT INTO `vouchers` VALUES (2, 'FREESHIP', 'Mã free shipping tháng 5', 'giảm thêm 30k cho đơn tối thiểu 100k', 'FIXED', 30000.00, NULL, 100000.00, 1000, '2026-05-23 18:00:00', '2026-07-10 18:00:00', 'ACTIVE', '2026-05-24 07:36:48', b'0');

SET FOREIGN_KEY_CHECKS = 1;
