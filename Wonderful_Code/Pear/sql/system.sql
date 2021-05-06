/*
 Navicat Premium Data Transfer

 Source Server         : 101.200.153.46
 Source Server Type    : MySQL
 Source Server Version : 80022
 Source Host           : 101.200.153.46:3306
 Source Schema         : pear-admin-boot

 Target Server Type    : MySQL
 Target Server Version : 80022
 File Encoding         : 65001

 Date: 14/03/2021 13:49:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`(
                            `table_id`          varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
                            `table_name`        varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
                            `table_comment`     varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
                            `sub_table_name`    varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
                            `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
                            `class_name`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
                            `tpl_category`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作 sub主子表操作）',
                            `package_name`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
                            `module_name`       varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
                            `business_name`     varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
                            `function_name`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
                            `function_author`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
                            `gen_type`          char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
                            `gen_path`          varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
                            `options`           varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
                            `create_by`         varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
                            `create_time`       datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
                            `update_by`         varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
                            `update_time`       datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
                            `remark`            varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
                            `parent_menu_id`    varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父级菜单',
                            `parent_menu_name`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父级菜单名称',
                            PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table`
VALUES ('1328525218309734400', 'sys_user', 'App用户', NULL, NULL, 'SysUser', 'crud', 'com.pearadmin.system', 'system',
        'user', 'App用户', 'å°±ç&nbsp;ä»ªå¼', '1', '/', 'null', '', '2020-11-17 10:24:33', '', '2021-01-27 18:09:40',
        '', '1', '系统管理');
INSERT INTO `gen_table`
VALUES ('1370410322996756480', 'sys_notice', '站内消息', NULL, NULL, 'SysNotice', 'crud', 'com.pearadmin.system', 'system',
        'notice', 'notice', 'jmys', '0', '/', 'null', '', '2021-03-12 16:24:16', '', '2021-03-12 16:31:27', '生成', '1',
        '系统管理');

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`
(
    `column_id`      varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
    `table_id`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '归属表编号',
    `column_name`    varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
    `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
    `column_type`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
    `java_type`      varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
    `java_field`     varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
    `is_pk`          char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
    `is_increment`   char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
    `is_required`    char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
    `is_insert`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
    `is_edit`        char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
    `is_list`        char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
    `is_query`       char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
    `query_type`     varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
    `html_type`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
    `dict_type`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
    `sort`           int(0) NULL DEFAULT NULL COMMENT '排序',
    `create_by`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`    datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`    datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column`
VALUES ('1328525219052126208', '1328525218309734400', 'user_id', '编号', 'char(19)', 'String', 'userId', '1', '0', NULL,
        '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 1, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column`
VALUES ('1328525219400253440', '1328525218309734400', 'username', '账户', 'char(20)', 'String', 'username', '0', '0',
        NULL, '1', '1', '1', '1', 'LIKE', 'input', 'input', 2, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column`
VALUES ('1328525219786129408', '1328525218309734400', 'password', '密码', 'char(60)', 'String', 'password', '0', '0',
        NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 3, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column`
VALUES ('1328525220104896512', '1328525218309734400', 'salt', '姓名', 'char(10)', 'String', 'salt', '0', '0', NULL, '1',
        '1', '1', '1', 'EQ', 'input', 'input', 4, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column`
VALUES ('1328525220423663616', '1328525218309734400', 'status', '状态', 'char(1)', 'String', 'status', '0', '0', NULL,
        '1', '1', '1', '1', 'EQ', 'radio', 'input', 5, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column`
VALUES ('1328525220734042112', '1328525218309734400', 'real_name', '姓名', 'char(8)', 'String', 'realName', '0', '0',
        NULL, '1', '1', '1', '1', 'LIKE', 'input', 'input', 6, '', '2020-11-17 10:24:33', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525221044420608', '1328525218309734400', 'email', '邮箱', 'char(20)', 'String', 'email', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 7, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525221363187712', '1328525218309734400', 'avatar', '头像', 'varchar(30)', 'String', 'avatar', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', 'input', 8, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525221677760512', '1328525218309734400', 'sex', '性别', 'char(1)', 'String', 'sex', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'select', 'user_sex', 9, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525222000721920', '1328525218309734400', 'phone', '电话', 'char(11)', 'String', 'phone', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 10, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525222415958016', '1328525218309734400', 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'datetime', 'input', 11, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525222764085248', '1328525218309734400', 'create_by', '创建人', 'char(1)', 'String', 'createBy', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 12, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525223091240960', '1328525218309734400', 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, '1', '1', NULL, NULL, 'EQ', 'datetime', 'input', 13, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525223552614400', '1328525218309734400', 'update_by', '修改人', 'char(1)', 'String', 'updateBy', '0', '0', NULL, '1', '1', NULL, NULL, 'EQ', 'input', 'input', 14, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:40');
INSERT INTO `gen_table_column` VALUES ('1328525223896547328', '1328525218309734400', 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', NULL, '1', '1', '1', NULL, 'EQ', 'input', 'input', 15, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:41');
INSERT INTO `gen_table_column` VALUES ('1328525224206925824', '1328525218309734400', 'enable', '是否启用', 'char(1)', 'String', 'enable', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 16, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:41');
INSERT INTO `gen_table_column` VALUES ('1328525224542470144', '1328525218309734400', 'login', '是否登录', 'char(1)', 'String', 'login', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 17, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:41');
INSERT INTO `gen_table_column` VALUES ('1328525224861237248', '1328525218309734400', 'dept_id', '部门编号', 'char(19)', 'String', 'deptId', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', 'input', 18, '', '2020-11-17 10:24:34', NULL, '2021-01-27 18:09:41');
INSERT INTO `gen_table_column` VALUES ('1370410323613319168', '1370410322996756480', 'id', '编号', 'char(20)', 'String', 'id', '1', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 1, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410323856588800', '1370410322996756480', 'title', '标题', 'varchar(255)', 'String', 'title', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', 'input', 2, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410324095664128', '1370410322996756480', 'content', '内容', 'text', 'String', 'content', '0', '0', '1', '1', '1', '1', NULL, 'EQ', 'input', 'input', 3, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410324317962240', '1370410322996756480', 'sender', '发送人', 'char(20)', 'String', 'sender', '0', '0', '1', '1', NULL, '1', NULL, 'EQ', 'select', 'input', 4, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410324557037568', '1370410322996756480', 'accept', '接收者', 'char(20)', 'String', 'accept', '0', '0', '1', '1', '1', '1', NULL, 'EQ', 'input', 'input', 5, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410324766752768', '1370410322996756480', 'type', '类型', 'char(10)', 'String', 'type', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'sys_notice_type', 6, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410325018411008', '1370410322996756480', 'create_by', '创建人', 'char(20)', 'String', 'createBy', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 7, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:27');
INSERT INTO `gen_table_column` VALUES ('1370410325240709120', '1370410322996756480', 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'datetime', 'input', 8, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:28');
INSERT INTO `gen_table_column` VALUES ('1370410325471395840', '1370410322996756480', 'update_by', '修改人', 'char(20)', 'String', 'updateBy', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 9, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:28');
INSERT INTO `gen_table_column` VALUES ('1370410325702082560', '1370410322996756480', 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'datetime', 'input', 10, '', '2021-03-12 16:24:16', NULL, '2021-03-12 16:31:28');
INSERT INTO `gen_table_column` VALUES ('1370410325928574976', '1370410322996756480', 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', 'input', 11, '', '2021-03-12 16:24:17', NULL, '2021-03-12 16:31:28');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`
(
    `config_id`    varchar(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置标识',
    `config_name`  char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置名称',
    `config_code`  char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置标识',
    `config_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置值',
    `create_time`  datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `create_by`    char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `update_by`    char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time`  datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `config_type`  char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置类型',
    PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config`
VALUES ('1', '1', 'oss_point', 'oss-cn-beijing.aliyuncs.com', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_config`
VALUES ('1307313917164257280', '网站描述', 'system_desc', '网站描述', '2020-11-08 19:19:32', NULL, NULL, NULL, '网站描述',
        'custom');
INSERT INTO `sys_config`
VALUES ('1309118169381601280', '网站数据', 'system_meta', '网站数据', '2020-11-03 19:20:48', NULL, NULL, NULL, '网站数据',
        'custom');
INSERT INTO `sys_config`
VALUES ('1356140265433202688', '系统配置', 'main_from', '854085467@qq.com', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config`
VALUES ('1356140265865216000', '系统配置', 'main_user', '854085467', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config`
VALUES ('1356140266297229312', '系统配置', 'main_pass', 'xzzjzgincnymcaae', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1356140266754408448', '系统配置', 'main_port', '456', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1356140267211587584', '系统配置', 'main_host', 'smtp.qq.com', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1356178612746715136', '系统配置', 'oss_path', 'D://upload', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1356178613115813888', '系统配置', 'oss_type', 'local', NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1370975131278508032', '上传方式', 'upload_kind', NULL, NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('1370975131630829568', '上传路径', 'upload_path', NULL, NULL, NULL, NULL, NULL, NULL, 'system');
INSERT INTO `sys_config` VALUES ('2', '2', 'oss_key', 'LTAI4G8ZDXDU6DiibSVd8G2b', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_config` VALUES ('3', '3', 'oss_secret', '9apyAWE7Xfu7NP5jgFHFdXeyPa28jL', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_config` VALUES ('4', '4', 'oss_bucket', 'pearadmin-bbs', NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`
(
    `dept_id`     varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '部门名称',
    `parent_id`   varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父级编号',
    `dept_name`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门名称',
    `sort`        int(0) NULL DEFAULT NULL COMMENT '排序',
    `leader`      varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
    `phone`       varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
    `email`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
    `status`      varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门状态',
    `create_by`   varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`   varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
    `address`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
    PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept`
VALUES ('1', '0', '济南总公司', 1, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept`
VALUES ('10', '8', '设计部', 3, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept`
VALUES ('1316361008259792896', '1316360459930042368', '软件部', 1, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL,
        NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept`
VALUES ('1316361192645591040', '1316360459930042368', '市场部', 1, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL,
        NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept`
VALUES ('3', '1', '杭州分公司', 1, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '浙江杭州');
INSERT INTO `sys_dept`
VALUES ('4', '2', '软件部', 2, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept` VALUES ('5', '2', '市场部', 2, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept` VALUES ('6', '3', '软件部', 3, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept` VALUES ('7', '3', '设计部', 3, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept` VALUES ('8', '1', '深圳分公司', 3, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');
INSERT INTO `sys_dept` VALUES ('9', '8', '软件部', 3, '就眠仪式', '15553726531', 'pearadmin@gmail.com', '0', NULL, NULL, NULL, NULL, NULL, '山东济南');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`
(
    `data_id`     char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
    `data_label`  char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典标签',
    `data_value`  char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典值',
    `type_code`   char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '所属类型',
    `is_default`  char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否默认',
    `update_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `create_by`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `enable`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否启用',
    PRIMARY KEY (`data_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data`
VALUES ('1', '男', '0', 'system_user_sex', '0', NULL, NULL, NULL, NULL, '描述', '1');
INSERT INTO `sys_dict_data`
VALUES ('1302833449496739840', '字典名称', '字典值', 'dict_code', '1', NULL, NULL, NULL, NULL, 'aw', '0');
INSERT INTO `sys_dict_data`
VALUES ('1317401149287956480', '男', 'boy', 'user_sex', NULL, NULL, NULL, NULL, NULL, '男 : body', '0');
INSERT INTO `sys_dict_data`
VALUES ('1317402976670711808', '女', 'girl', 'user_sex', NULL, NULL, NULL, NULL, NULL, '女 : girl', '0');
INSERT INTO `sys_dict_data`
VALUES ('1370411072367886336', '公告', 'public', 'sys_notice_type', NULL, NULL, NULL, NULL, NULL, '公告', '0');
INSERT INTO `sys_dict_data`
VALUES ('1370411179544936448', '私信', 'private', 'sys_notice_type', NULL, NULL, NULL, NULL, NULL, '私信', '0');
INSERT INTO `sys_dict_data` VALUES ('2', '女', '1', 'system_user_sex', '1', NULL, NULL, NULL, NULL, '描述', '0');
INSERT INTO `sys_dict_data` VALUES ('447572898392182784', 'awd', 'awd', 'dict_code', '1', NULL, NULL, NULL, NULL, 'awd', '0');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`
(
    `id`          char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
    `type_name`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典类型名称',
    `type_code`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典类型标识',
    `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典类型描述',
    `enable`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否启用',
    `create_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type`
VALUES ('1317360314219495424', '登录类型', 'login', '登录类型', '0', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type`
VALUES ('1317400519127334912', '用户类型', 'user_status', '用户类型', '0', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type`
VALUES ('1317400823096934400', '配置类型', 'config_type', '配置类型', '0', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type`
VALUES ('1370410853110644736', '消息类型', 'sys_notice_type', '消息类型', '0', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type`
VALUES ('455184568505470976', '用户性别', 'user_sex', '用户性别', '0', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_dict_type`
VALUES ('455184935989415936', '全局状态', 'sys_status', '状态描述\n', '0', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`
(
    `id`          varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
    `file_name`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名称',
    `file_desc`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件描述',
    `file_path`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径',
    `file_type`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型',
    `create_by`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `target_date` datetime(0) NULL DEFAULT NULL COMMENT '所属时间',
    `file_size`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件大小',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file
-- ----------------------------
INSERT INTO `sys_file`
VALUES ('1304852561307631616', '1304852561307631616.png', NULL, NULL, '.png', NULL, '2020-09-13 02:41:08', NULL, NULL,
        NULL, NULL, NULL);
INSERT INTO `sys_file`
VALUES ('1304852561307631617', '1304852561307631617.png', NULL, NULL, '.png', NULL, '2020-09-13 02:41:08', NULL, NULL,
        NULL, NULL, NULL);
INSERT INTO `sys_file`
VALUES ('1304852561307631618', '1304852561307631618.png', NULL, NULL, '.png', NULL, '2020-09-13 02:41:08', NULL, NULL,
        NULL, NULL, NULL);
INSERT INTO `sys_file`
VALUES ('1304852963906289664', '1304852963906289664.png', NULL, 'D:\\file\\1304852963906289664.png', '.png', NULL,
        '2020-09-13 02:42:44', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file`
VALUES ('1304852963906289665', '1304852963906289665.png', NULL, 'D:\\file\\1304852963906289665.png', '.png', NULL,
        '2020-09-13 02:42:44', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file`
VALUES ('1304852963906289666', '1304852963906289666.png', NULL, 'D:\\file\\1304852963906289666.png', '.png', NULL,
        '2020-09-13 02:42:44', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304853303087071232', '1304853303087071232.png', NULL, 'D:\\file\\1304853303087071232.png', '.png', NULL, '2020-09-13 02:44:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304853303087071233', '1304853303087071233.png', NULL, 'D:\\file\\1304853303087071233.png', '.png', NULL, '2020-09-13 02:44:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304853303087071234', '1304853303087071234.png', NULL, 'D:\\file\\1304853303087071234.png', '.png', NULL, '2020-09-13 02:44:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304856867222061056', '1304856867222061056.png', NULL, 'D:\\file\\1304856867222061056.png', '.png', NULL, '2020-09-13 02:58:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304856867222061057', '1304856867222061057.png', NULL, 'D:\\file\\1304856867222061057.png', '.png', NULL, '2020-09-13 02:58:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304856867222061058', '1304856867222061058.png', NULL, 'D:\\file\\1304856867222061058.png', '.png', NULL, '2020-09-13 02:58:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304857208520966144', '1304857208520966144.png', NULL, 'D:\\file\\1304857208520966144.png', '.png', NULL, '2020-09-13 02:59:36', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304857208520966145', '1304857208520966145.png', NULL, 'D:\\file\\1304857208520966145.png', '.png', NULL, '2020-09-13 02:59:36', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304857208520966146', '1304857208520966146.png', NULL, 'D:\\file\\1304857208520966146.png', '.png', NULL, '2020-09-13 02:59:36', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304857250015215616', '1304857250015215616.zip', NULL, 'D:\\file\\1304857250015215616.zip', '.zip', NULL, '2020-09-13 02:59:46', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304857250036187136', '1304857250036187136.zip', NULL, 'D:\\file\\1304857250036187136.zip', '.zip', NULL, '2020-09-13 02:59:46', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859273464905728', '1304859273464905728.png', NULL, 'D:\\file\\1304859273464905728.png', '.png', NULL, '2020-09-13 03:07:49', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859273464905729', '1304859273464905729.png', NULL, 'D:\\file\\1304859273464905729.png', '.png', NULL, '2020-09-13 03:07:49', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859273464905730', '1304859273464905730.png', NULL, 'D:\\file\\1304859273464905730.png', '.png', NULL, '2020-09-13 03:07:49', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859768921260032', '1304859768921260032.png', NULL, 'D:\\file\\1304859768921260032.png', '.png', NULL, '2020-09-13 03:09:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859768921260033', '1304859768921260033.png', NULL, 'D:\\file\\1304859768921260033.png', '.png', NULL, '2020-09-13 03:09:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304859768921260034', '1304859768921260034.png', NULL, 'D:\\file\\1304859768921260034.png', '.png', NULL, '2020-09-13 03:09:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860386071150592', '1304860386071150592.png', NULL, 'D:\\file\\1304860386071150592.png', '.png', NULL, '2020-09-13 03:12:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860386071150593', '1304860386071150593.png', NULL, 'D:\\file\\1304860386071150593.png', '.png', NULL, '2020-09-13 03:12:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860386071150594', '1304860386071150594.png', NULL, 'D:\\file\\1304860386071150594.png', '.png', NULL, '2020-09-13 03:12:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860457890217984', '1304860457890217984.png', NULL, 'D:\\file\\1304860457890217984.png', '.png', NULL, '2020-09-13 03:12:31', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860457890217985', '1304860457890217985.png', NULL, 'D:\\file\\1304860457890217985.png', '.png', NULL, '2020-09-13 03:12:31', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860457894412288', '1304860457894412288.png', NULL, 'D:\\file\\1304860457894412288.png', '.png', NULL, '2020-09-13 03:12:31', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860863466831872', '1304860863466831872.png', NULL, 'D:\\file\\1304860863466831872.png', '.png', NULL, '2020-09-13 03:14:08', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860863466831873', '1304860863466831873.png', NULL, 'D:\\file\\1304860863466831873.png', '.png', NULL, '2020-09-13 03:14:08', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304860863466831874', '1304860863466831874.png', NULL, 'D:\\file\\1304860863466831874.png', '.png', NULL, '2020-09-13 03:14:08', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304864809178628096', '1304864809178628096.png', 'QQ图片20200912142050.png', 'D:\\file\\1304864809178628096.png', '.png', NULL, '2020-09-13 03:29:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304864809178628097', '1304864809178628097.png', 'QQ图片20200912003258.png', 'D:\\file\\1304864809178628097.png', '.png', NULL, '2020-09-13 03:29:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304864809178628098', '1304864809178628098.png', 'QQ图片20200912000740.png', 'D:\\file\\1304864809178628098.png', '.png', NULL, '2020-09-13 03:29:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865101748109312', '1304865101748109312.png', 'QQ图片20200912003258.png', 'D:\\file\\1304865101748109312.png', '.png', NULL, '2020-09-13 03:30:58', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865101748109313', '1304865101748109313.png', 'QQ图片20200912000740.png', 'D:\\file\\1304865101748109313.png', '.png', NULL, '2020-09-13 03:30:58', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865101748109314', '1304865101748109314.png', 'QQ图片20200912142050.png', 'D:\\file\\1304865101748109314.png', '.png', NULL, '2020-09-13 03:30:58', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865309806559232', '1304865309806559232.png', 'QQ图片20200912000740.png', 'D:\\file\\1304865309806559232.png', '.png', NULL, '2020-09-13 03:31:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865309806559233', '1304865309806559233.png', 'QQ图片20200912142050.png', 'D:\\file\\1304865309806559233.png', '.png', NULL, '2020-09-13 03:31:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865309806559234', '1304865309806559234.png', 'QQ图片20200912003258.png', 'D:\\file\\1304865309806559234.png', '.png', NULL, '2020-09-13 03:31:48', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865341884596224', '1304865341884596224.png', 'QQ图片20200912003258.png', 'D:\\file\\1304865341884596224.png', '.png', NULL, '2020-09-13 03:31:55', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865341884596225', '1304865341884596225.png', 'QQ图片20200912000740.png', 'D:\\file\\1304865341884596225.png', '.png', NULL, '2020-09-13 03:31:55', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865341897179136', '1304865341897179136.png', 'QQ图片20200912142050.png', 'D:\\file\\1304865341897179136.png', '.png', NULL, '2020-09-13 03:31:55', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865409400307712', '1304865409400307712.png', 'QQ图片20200912003258.png', 'D:\\file\\1304865409400307712.png', '.png', NULL, '2020-09-13 03:32:11', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865409400307713', '1304865409400307713.png', 'QQ图片20200912000740.png', 'D:\\file\\1304865409400307713.png', '.png', NULL, '2020-09-13 03:32:11', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304865409400307714', '1304865409400307714.png', 'QQ图片20200912142050.png', 'D:\\file\\1304865409400307714.png', '.png', NULL, '2020-09-13 03:32:11', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304870783130009600', '1304870783130009600.zip', 'nbnat-layui-filemanage-master.zip', 'D:\\file\\1304870783130009600.zip', '.zip', NULL, '2020-09-13 03:53:33', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304870783142592512', '1304870783142592512.zip', 'fly-3.0.zip', 'D:\\file\\1304870783142592512.zip', '.zip', NULL, '2020-09-13 03:53:33', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304872214419472384', '1304872214419472384.png', 'QQ图片20200912142050.png', 'D:\\file\\1304872214419472384.png', '.png', NULL, '2020-09-13 03:59:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304872214419472385', '1304872214419472385.png', 'QQ图片20200912003258.png', 'D:\\file\\1304872214419472385.png', '.png', NULL, '2020-09-13 03:59:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304872214419472386', '1304872214419472386.png', 'QQ图片20200912000740.png', 'D:\\file\\1304872214419472386.png', '.png', NULL, '2020-09-13 03:59:14', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873398404382720', '1304873398404382720.png', 'QQ图片20200912003258.png', 'D:\\file\\1304873398404382720.png', '.png', NULL, '2020-09-13 04:03:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873398404382721', '1304873398404382721.png', 'QQ图片20200912000740.png', 'D:\\file\\1304873398404382721.png', '.png', NULL, '2020-09-13 04:03:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873398404382722', '1304873398404382722.png', 'QQ图片20200912142050.png', 'D:\\file\\1304873398404382722.png', '.png', NULL, '2020-09-13 04:03:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873433544261632', '1304873433544261632.png', 'QQ图片20200912003258.png', 'D:\\file\\1304873433544261632.png', '.png', NULL, '2020-09-13 04:04:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873433544261633', '1304873433544261633.png', 'QQ图片20200912000740.png', 'D:\\file\\1304873433544261633.png', '.png', NULL, '2020-09-13 04:04:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873433544261634', '1304873433544261634.png', 'QQ图片20200912142050.png', 'D:\\file\\1304873433544261634.png', '.png', NULL, '2020-09-13 04:04:05', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873476523294720', '1304873476523294720.png', 'QQ图片20200912003258.png', 'D:\\file\\1304873476523294720.png', '.png', NULL, '2020-09-13 04:04:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873476523294721', '1304873476523294721.png', 'QQ图片20200912000740.png', 'D:\\file\\1304873476523294721.png', '.png', NULL, '2020-09-13 04:04:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1304873476527489024', '1304873476527489024.png', 'QQ图片20200912142050.png', 'D:\\file\\1304873476527489024.png', '.png', NULL, '2020-09-13 04:04:15', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351580047900672', '1305351580047900672.jpg', '微信图片_20200914001233.jpg', '/home/upload/1305351580047900672.jpg', '.jpg', NULL, '2020-09-14 11:44:04', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351580152758272', '1305351580152758272.png', 'QQ图片20200912003258.png', '/home/upload/1305351580152758272.png', '.png', NULL, '2020-09-14 11:44:04', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351580270198784', '1305351580270198784.png', 'QQ图片20200912000740.png', '/home/upload/1305351580270198784.png', '.png', NULL, '2020-09-14 11:44:04', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351580433776640', '1305351580433776640.png', 'QQ图片20200912142050.png', '/home/upload/1305351580433776640.png', '.png', NULL, '2020-09-14 11:44:04', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351725011435520', '1305351725011435520.png', 'QQ图片20200912003258.png', '/home/upload/1305351725011435520.png', '.png', NULL, '2020-09-14 11:44:38', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351725120487424', '1305351725120487424.png', 'QQ图片20200912142050.png', '/home/upload/1305351725120487424.png', '.png', NULL, '2020-09-14 11:44:38', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351725279870976', '1305351725279870976.png', 'QQ图片20200912000740.png', '/home/upload/1305351725279870976.png', '.png', NULL, '2020-09-14 11:44:38', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351761422188544', '1305351761422188544.png', 'QQ图片20200912003258.png', '/home/upload/1305351761422188544.png', '.png', NULL, '2020-09-14 11:44:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351761602543616', '1305351761602543616.png', 'QQ图片20200912142050.png', '/home/upload/1305351761602543616.png', '.png', NULL, '2020-09-14 11:44:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351761908727808', '1305351761908727808.png', 'QQ图片20200912000740.png', '/home/upload/1305351761908727808.png', '.png', NULL, '2020-09-14 11:44:47', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351800538267648', '1305351800538267648.png', 'QQ图片20200912003258.png', '/home/upload/1305351800538267648.png', '.png', NULL, '2020-09-14 11:44:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351800659902464', '1305351800659902464.png', 'QQ图片20200912000740.png', '/home/upload/1305351800659902464.png', '.png', NULL, '2020-09-14 11:44:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351800873811968', '1305351800873811968.png', 'QQ图片20200912142050.png', '/home/upload/1305351800873811968.png', '.png', NULL, '2020-09-14 11:44:56', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351843647324160', '1305351843647324160.png', 'QQ图片20200912003258.png', '/home/upload/1305351843647324160.png', '.png', NULL, '2020-09-14 11:45:06', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351843722821632', '1305351843722821632.png', 'QQ图片20200912000740.png', '/home/upload/1305351843722821632.png', '.png', NULL, '2020-09-14 11:45:06', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1305351843873816576', '1305351843873816576.png', 'QQ图片20200912142050.png', '/home/upload/1305351843873816576.png', '.png', NULL, '2020-09-14 11:45:07', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1306799295369838593', '1306799295369838593.png', 'QQ图片20200912003258.png', '/home/upload/1306799295369838593.png', '.png', NULL, '2020-09-18 11:36:46', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_file` VALUES ('1316394782032920576', '1316394782032920576.jpg', '微信图片_20201005171233.jpg', 'D:\\home\\upload\\2020-10-14\\1316394782032920576.jpg', '.jpg', NULL, '2020-10-14 23:05:48', NULL, NULL, NULL, '2020-10-14 00:00:00', '0');
INSERT INTO `sys_file` VALUES ('1316394782032920577', '1316394782032920577.png', '微信图片_20200927153749.png', 'D:\\home\\upload\\2020-10-14\\1316394782032920577.png', '.png', NULL, '2020-10-14 23:05:48', NULL, NULL, NULL, '2020-10-14 00:00:00', '0');
INSERT INTO `sys_file` VALUES ('1316394782032920578', '1316394782032920578.jpg', '微信图片_20201005171435.jpg', 'D:\\home\\upload\\2020-10-14\\1316394782032920578.jpg', '.jpg', NULL, '2020-10-14 23:05:48', NULL, NULL, NULL, '2020-10-14 00:00:00', '0');
INSERT INTO `sys_file` VALUES ('1316394782032920579', '1316394782032920579.jpg', '微信图片_20200914001233.jpg', 'D:\\home\\upload\\2020-10-14\\1316394782032920579.jpg', '.jpg', NULL, '2020-10-14 23:05:48', NULL, NULL, NULL, '2020-10-14 00:00:00', '0');
INSERT INTO `sys_file` VALUES ('1316395206165135360', '1316395206165135360.png', 'QQ图片20200926191647.png', 'D:\\home\\upload\\2020-10-14\\1316395206165135360.png', '.png', NULL, '2020-10-14 23:07:29', NULL, NULL, NULL, '2020-10-14 00:00:00', '23326');
INSERT INTO `sys_file` VALUES ('1316395206177718272', '1316395206177718272.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316395206177718272.png', '.png', NULL, '2020-10-14 23:07:29', NULL, NULL, NULL, '2020-10-14 00:00:00', '134989');
INSERT INTO `sys_file` VALUES ('1316395206177718273', '1316395206177718273.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316395206177718273.png', '.png', NULL, '2020-10-14 23:07:29', NULL, NULL, NULL, '2020-10-14 00:00:00', '82028');
INSERT INTO `sys_file` VALUES ('1316396344318885888', '1316396344318885888.png', 'QQ图片20200926191647.png', 'D:\\home\\upload\\2020-10-14\\1316396344318885888.png', '.png', NULL, '2020-10-14 23:12:01', NULL, NULL, NULL, '2020-10-14 00:00:00', '22KB');
INSERT INTO `sys_file` VALUES ('1316396344323080192', '1316396344323080192.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396344323080192.png', '.png', NULL, '2020-10-14 23:12:01', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316396344344051712', '1316396344344051712.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396344344051712.png', '.png', NULL, '2020-10-14 23:12:01', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396395015438336', '1316396395015438336.png', 'QQ图片20200926191647.png', 'D:\\home\\upload\\2020-10-14\\1316396395015438336.png', '.png', NULL, '2020-10-14 23:12:13', NULL, NULL, NULL, '2020-10-14 00:00:00', '22KB');
INSERT INTO `sys_file` VALUES ('1316396395023826944', '1316396395023826944.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396395023826944.png', '.png', NULL, '2020-10-14 23:12:13', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396435851182080', '1316396435851182080.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396435851182080.png', '.png', NULL, '2020-10-14 23:12:22', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396435851182081', '1316396435851182081.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396435851182081.png', '.png', NULL, '2020-10-14 23:12:22', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316396491765448704', '1316396491765448704.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396491765448704.png', '.png', NULL, '2020-10-14 23:12:36', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396491769643008', '1316396491769643008.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396491769643008.png', '.png', NULL, '2020-10-14 23:12:36', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316396537323978752', '1316396537323978752.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396537323978752.png', '.png', NULL, '2020-10-14 23:12:47', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396537328173056', '1316396537328173056.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396537328173056.png', '.png', NULL, '2020-10-14 23:12:47', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316396597327691776', '1316396597327691776.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396597327691776.png', '.png', NULL, '2020-10-14 23:13:01', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316396597327691777', '1316396597327691777.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396597327691777.png', '.png', NULL, '2020-10-14 23:13:01', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396641216888832', '1316396641216888832.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316396641216888832.png', '.png', NULL, '2020-10-14 23:13:11', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316396641221083136', '1316396641221083136.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316396641221083136.png', '.png', NULL, '2020-10-14 23:13:11', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316397016552570880', '1316397016552570880png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316397016552570880png', 'png', NULL, '2020-10-14 23:14:41', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316397016573542400', '1316397016573542400png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316397016573542400png', 'png', NULL, '2020-10-14 23:14:41', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316397061297405952', '1316397061297405952png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316397061297405952png', 'png', NULL, '2020-10-14 23:14:52', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316397061309988864', '1316397061309988864png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316397061309988864png', 'png', NULL, '2020-10-14 23:14:52', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316397109003419648', '1316397109003419648png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316397109003419648png', 'png', NULL, '2020-10-14 23:15:03', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316397109036974080', '1316397109036974080png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316397109036974080png', 'png', NULL, '2020-10-14 23:15:03', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316397174589751296', '1316397174589751296png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316397174589751296png', 'png', NULL, '2020-10-14 23:15:19', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316397174598139904', '1316397174598139904png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316397174598139904png', 'png', NULL, '2020-10-14 23:15:19', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316397269146140672', '1316397269146140672png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316397269146140672png', 'png', NULL, '2020-10-14 23:15:41', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316397269171306496', '1316397269171306496png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316397269171306496png', 'png', NULL, '2020-10-14 23:15:41', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316399288065982464', '1316399288065982464.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316399288065982464.png', 'png', NULL, '2020-10-14 23:23:42', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316399288078565376', '1316399288078565376.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316399288078565376.png', 'png', NULL, '2020-10-14 23:23:42', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316399335914602496', '1316399335914602496.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316399335914602496.png', 'png', NULL, '2020-10-14 23:23:54', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316399335943962624', '1316399335943962624.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316399335943962624.png', 'png', NULL, '2020-10-14 23:23:54', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316399373751418880', '1316399373751418880.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316399373751418880.png', 'png', NULL, '2020-10-14 23:24:03', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316399373759807488', '1316399373759807488.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316399373759807488.png', 'png', NULL, '2020-10-14 23:24:03', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316399404084625408', '1316399404084625408.png', 'QQ图片20200912003258.png', 'D:\\home\\upload\\2020-10-14\\1316399404084625408.png', 'png', NULL, '2020-10-14 23:24:10', NULL, NULL, NULL, '2020-10-14 00:00:00', '80KB');
INSERT INTO `sys_file` VALUES ('1316399404088819712', '1316399404088819712.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316399404088819712.png', 'png', NULL, '2020-10-14 23:24:10', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1316399440394715137', '1316399440394715137.png', 'QQ图片20200912000740.png', 'D:\\home\\upload\\2020-10-14\\1316399440394715137.png', 'png', NULL, '2020-10-14 23:24:19', NULL, NULL, NULL, '2020-10-14 00:00:00', '131KB');
INSERT INTO `sys_file` VALUES ('1348497036814581760', '1348497036814581760.jpg', '1610341722000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348497036814581760.jpg', 'jpg', NULL, '2021-01-11 13:08:42', NULL, NULL, NULL, '2021-01-11 00:00:00', '56KB');
INSERT INTO `sys_file` VALUES ('1348497256864546816', '1348497256864546816.jpg', '1610341774000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348497256864546816.jpg', 'jpg', NULL, '2021-01-11 13:09:35', NULL, NULL, NULL, '2021-01-11 00:00:00', '19KB');
INSERT INTO `sys_file` VALUES ('1348497814073638912', '1348497814073638912.jpg', '1610341907000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348497814073638912.jpg', 'jpg', NULL, '2021-01-11 13:11:47', NULL, NULL, NULL, '2021-01-11 00:00:00', '155KB');
INSERT INTO `sys_file` VALUES ('1348498396687630336', '1348498396687630336.jpg', '1610342046000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348498396687630336.jpg', 'jpg', NULL, '2021-01-11 13:14:06', NULL, NULL, NULL, '2021-01-11 00:00:00', '11KB');
INSERT INTO `sys_file` VALUES ('1348499365668323328', '1348499365668323328.jpg', '1610342277000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348499365668323328.jpg', 'jpg', NULL, '2021-01-11 13:17:57', NULL, NULL, NULL, '2021-01-11 00:00:00', '8KB');
INSERT INTO `sys_file` VALUES ('1348502371503702016', '1348502371503702016.jpg', '1610342993000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348502371503702016.jpg', 'jpg', NULL, '2021-01-11 13:29:54', NULL, NULL, NULL, '2021-01-11 00:00:00', '22KB');
INSERT INTO `sys_file` VALUES ('1348503016684126208', '1348503016684126208.jpg', '1610343147000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348503016684126208.jpg', 'jpg', NULL, '2021-01-11 13:32:28', NULL, NULL, NULL, '2021-01-11 00:00:00', '66KB');
INSERT INTO `sys_file` VALUES ('1348503282384896000', '1348503282384896000.jpg', '1610343211000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348503282384896000.jpg', 'jpg', NULL, '2021-01-11 13:33:31', NULL, NULL, NULL, '2021-01-11 00:00:00', '149KB');
INSERT INTO `sys_file` VALUES ('1348503389981376512', '1348503389981376512.jpg', '1610343236000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348503389981376512.jpg', 'jpg', NULL, '2021-01-11 13:33:57', NULL, NULL, NULL, '2021-01-11 00:00:00', '149KB');
INSERT INTO `sys_file` VALUES ('1348504061611081728', '1348504061611081728.jpg', '1610343396000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348504061611081728.jpg', 'jpg', NULL, '2021-01-11 13:36:37', NULL, NULL, NULL, '2021-01-11 00:00:00', '19KB');
INSERT INTO `sys_file` VALUES ('1348504180649623552', '1348504180649623552.jpg', '1610343425000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348504180649623552.jpg', 'jpg', NULL, '2021-01-11 13:37:05', NULL, NULL, NULL, '2021-01-11 00:00:00', '19KB');
INSERT INTO `sys_file` VALUES ('1348504823791616000', '1348504823791616000.jpg', '1610343578000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348504823791616000.jpg', 'jpg', NULL, '2021-01-11 13:39:39', NULL, NULL, NULL, '2021-01-11 00:00:00', '36KB');
INSERT INTO `sys_file` VALUES ('1348505594381729792', '1348505594381729792.jpg', '1610343762000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348505594381729792.jpg', 'jpg', NULL, '2021-01-11 13:42:42', NULL, NULL, NULL, '2021-01-11 00:00:00', '155KB');
INSERT INTO `sys_file` VALUES ('1348507914062528512', '1348507914062528512.jpg', '1610344315000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348507914062528512.jpg', 'jpg', NULL, '2021-01-11 13:51:55', NULL, NULL, NULL, '2021-01-11 00:00:00', '28KB');
INSERT INTO `sys_file` VALUES ('1348508659428098048', '1348508659428098048.jpg', '1610344493000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348508659428098048.jpg', 'jpg', NULL, '2021-01-11 13:54:53', NULL, NULL, NULL, '2021-01-11 00:00:00', '10KB');
INSERT INTO `sys_file` VALUES ('1348510190223228928', '1348510190223228928.jpg', '1610344858000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348510190223228928.jpg', 'jpg', NULL, '2021-01-11 14:00:58', NULL, NULL, NULL, '2021-01-11 00:00:00', '56KB');
INSERT INTO `sys_file` VALUES ('1348511904598851584', '1348511904598851584.jpg', '1610345266000.jpg', 'D:\\home\\uploads\\2021-01-11\\1348511904598851584.jpg', 'jpg', NULL, '2021-01-11 14:07:47', NULL, NULL, NULL, '2021-01-11 00:00:00', '54KB');
INSERT INTO `sys_file` VALUES ('1353360104015003648', '1353360104015003648.png', '配置文件.png', 'D:\\home\\uploads\\2021-01-24\\1353360104015003648.png', 'png', NULL, '2021-01-24 23:12:48', NULL, NULL, NULL, '2021-01-24 00:00:00', '44KB');

-- ----------------------------
-- Table structure for sys_logging
-- ----------------------------
DROP TABLE IF EXISTS `sys_logging`;
CREATE TABLE `sys_logging`
(
    `id`              char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '相应消息体',
    `title`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
    `method`          varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方式',
    `business_type`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务类型',
    `request_method`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法',
    `operate_name`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
    `operate_url`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作路径',
    `operate_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作地址',
    `request_param`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求参数',
    `response_body`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相应消息体',
    `success`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否成功',
    `error_msg`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '异常信息',
    `create_time`     datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `description`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
    `request_body`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求消息体',
    `browser`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用浏览器',
    `system_os`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作系统',
    `logging_type`    varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志类型，登录日志，操作日志',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logging
-- ----------------------------

-- ----------------------------
-- Table structure for sys_mail
-- ----------------------------
DROP TABLE IF EXISTS `sys_mail`;
CREATE TABLE `sys_mail`
(
    `mail_id`     varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL COMMENT '邮件id(主键)',
    `receiver`    varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '收件人邮箱',
    `subject`     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮件主体',
    `content`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '邮件正文',
    `create_by`   varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送人',
    `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP (0) COMMENT '创建时间',
    PRIMARY KEY (`mail_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_mail
-- ----------------------------
INSERT INTO `sys_mail`
VALUES ('1349598576807772160', '1218600762@qq.com', 'macbook pro', '13.3寸\nm1处理器\n16G内存', 'admin',
        '2021-01-14 06:06:23');
INSERT INTO `sys_mail`
VALUES ('1357215518368464896', 'BoscoKuo@aliyun.com', '湖人总冠军', '湖人总冠军', 'admin', '2021-02-04 06:33:36');
INSERT INTO `sys_mail`
VALUES ('1357219037586653184', 'BoscoKuo@aliyun.com', 'LebronJames', 'Lakers', 'admin', '2021-02-04 06:47:35');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`
(
    `id`          char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
    `title`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
    `content`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
    `sender`      char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送人',
    `accept`      char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接收者',
    `type`        char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型',
    `create_by`   char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`   char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice`
VALUES ('1370769290961092608', '公告测试', '公告测试', '1309861917694623744', NULL, 'public', NULL, '2021-03-14 00:10:41', NULL,
        NULL, NULL);
INSERT INTO `sys_notice`
VALUES ('1370769348204953600', '私信测试', '私信测试', '1309861917694623744', '1310409555649232897', 'private', NULL,
        '2021-03-14 00:10:55', NULL, NULL, NULL);
INSERT INTO `sys_notice`
VALUES ('1370771980034244608', '公告测试', '公告测试', '1309861917694623744', NULL, 'public', NULL, '2021-03-14 00:21:22', NULL,
        NULL, NULL);
INSERT INTO `sys_notice`
VALUES ('1370772014771470336', '公告测试', '公告测试', '1309861917694623744', NULL, 'public', NULL, '2021-03-14 00:21:31', NULL,
        NULL, NULL);
INSERT INTO `sys_notice`
VALUES ('1370772050439831552', '公告测试', '公告测试', '1309861917694623744', NULL, 'public', NULL, '2021-03-14 00:21:39', NULL,
        NULL, NULL);
INSERT INTO `sys_notice`
VALUES ('1370772089446858752', '私信测试', '私信测试', '1309861917694623744', '1310409555649232897', 'private', NULL,
        '2021-03-14 00:21:48', NULL, NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1370772143918284800', '私信测试', '私信测试', '1309861917694623744', '1310409555649232897', 'private', NULL, '2021-03-14 00:22:01', NULL, NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1370772363838226432', '私信测试', '私信测试', '1309861917694623744', '1349021166525743105', 'private', NULL, '2021-03-14 00:22:54', NULL, NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1370772466212798464', '私信测试', '私信测试', '1309861917694623744', '1349021166525743105', 'private', NULL, '2021-03-14 00:23:18', NULL, NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1370971086266564608', '私信测试', '私信测试', '1309861917694623744', '1309861917694623744', 'private', NULL, '2021-03-14 13:32:33', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_power
-- ----------------------------
DROP TABLE IF EXISTS `sys_power`;
CREATE TABLE `sys_power`
(
    `power_id`    char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限编号',
    `power_name`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限名称',
    `power_type`  char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限类型',
    `power_code`  char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
    `power_url`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限路径',
    `open_type`   char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '打开方式',
    `parent_id`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父类编号',
    `icon`        varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
    `sort`        int(0) NULL DEFAULT NULL COMMENT '排序',
    `create_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `update_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `enable`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否开启',
    PRIMARY KEY (`power_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_power
-- ----------------------------
INSERT INTO `sys_power`
VALUES ('1', '系统管理', '0', '', '', NULL, '0', 'layui-icon layui-icon-set-fill', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power`
VALUES ('1284020948269268992', '用户列表', '2', 'sys:user:data', '', '', '2', 'layui-icon-username', 0, NULL, NULL, NULL,
        NULL, NULL, '1');
INSERT INTO `sys_power`
VALUES ('1284022967767924736', '用户保存', '2', 'sys:user:add', '', '', '2', 'layui-icon-username', 1, NULL, NULL, NULL,
        NULL, NULL, '1');
INSERT INTO `sys_power`
VALUES ('1302180351979814912', '布局构建', '1', 'generator:from:main', 'component/code/index.html', '_iframe',
        '442417411065516032', 'layui-icon-senior', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power`
VALUES ('1304387665067507712', '数据字典', '1', 'sys:dictType:main', '/system/dictType/main', '_iframe', '1',
        'layui-icon layui-icon layui-icon layui-icon layui-icon-flag', 4, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power`
VALUES ('1304793451996381184', '文件管理', '1', 'sys:file:main', '/system/file/main', '_iframe', '1',
        'layui-icon layui-icon layui-icon-read', 5, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1305870685385523200', '百度一下', '1', '', 'http://www.baidu.com', '0', '474356044148117504', 'layui-icon-search', 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_power` VALUES ('1305875436139446272', '百度一下', '1', 'http://www.baidu.com', 'http://www.baidu.com', '0', '451002662209589248', 'layui-icon-search', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1307299332784914432', '系统配置', '1', 'sys:config:main', '/system/config/main', '0', '1', 'layui-icon layui-icon layui-icon-note', 6, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1307562196556840960', '工作流程', '0', '', '', '0', '0', 'layui-icon layui-icon-chat', 5, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1307562519451140096', '模型管理', '1', '/process/model/main', '/process/model/main', '0', '1307562196556840960', 'layui-icon-circle', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1308571483794046976', '流程定义', '1', 'process:defined:main', '/process/defined/main', '0', '1307562196556840960', 'layui-icon-chart-screen', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310206853057085440', '用户修改', '2', 'sys:user:edit', '', '', '2', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310208636370288640', '用户删除', '2', 'sys:user:remove', '', '', '2', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310209696916832256', '角色新增', '2', 'sys:role:add', '', '', '3', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310209900478988288', '角色删除', '2', 'sys:role:remove', '', '', '3', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310210054728712192', '角色修改', '2', 'sys:role:edit', '', '', '3', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310211965188046848', '角色授权', '2', 'sys:role:power', '', '', '3', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310226416867999744', '权限列表', '2', 'sys:power:data', '', '', '4', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310226976593674240', '权限新增', '2', 'sys:power:add', '', '', '4', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310227130998587392', '权限修改', '2', 'sys:power:edit', '', '', '4', 'layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310227300935008256', '权限删除', '2', 'sys:power:remove', '', '', '4', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310232350285627392', '操作日志', '2', 'sys:log:operateLog', '', '', '450300705362808832', 'layui-icon layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310232462562951168', '登录日志', '2', 'sys:log:loginLog', '', '', '450300705362808832', 'layui-icon layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310238229588344832', '配置列表', '2', 'sys:config:data', '', '', '1307299332784914432', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310238417082122240', '配置新增', '2', 'sys:config:add', '', '', '1307299332784914432', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310238574355939328', '配置修改', '2', 'sys:config:edit', '', '', '1307299332784914432', 'layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310238700705153024', '配置删除', '2', 'sys:config:remove', '', '', '1307299332784914432', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310243862937075712', '文件列表', '2', 'sys:file:data', '', '', '1304793451996381184', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310244103824343040', '文件新增', '2', 'sys:file:add', '', '', '1304793451996381184', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310244248884346880', '文件删除', '2', 'sys:file:remove', '', '', '1304793451996381184', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310390699333517312', '任务列表', '2', 'sch:job:data', '', '', '442650770626711552', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310390994826428416', '任务新增', '2', 'sch:job:add', '', '', '442650770626711552', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310391095670079488', '任务修改', '2', 'sch:job:edit', '', '', '442650770626711552', 'layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310391707069579264', '任务删除', '2', 'sch:job:remove', '', '', '442650770626711552', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310395250908332032', '日志列表', '2', 'sch:log:data', '', '', '442651158935375872', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310397832091402240', '任务恢复', '2', 'sch:job:resume', '', '', '442650770626711552', 'layui-icon-vercode', NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310398020692475904', '任务停止', '2', 'sch:job:pause', '', '', '442650770626711552', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310398158974484480', '任务运行', '2', 'sch:job:run', '', '', '442650770626711552', 'layui-icon-vercode', 4, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310402491631796224', '数据类型列表', '2', 'sys:dictType:data', '', '', '1304387665067507712', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310402688881524736', '数据类型新增', '2', 'sys:dictType:add', '', '', '1304387665067507712', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310402817776680960', '数据类型修改', '2', 'sys:dictType:edit', '', '', '1304387665067507712', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310403004406431744', '数据类型删除', '2', 'sys:dictType:remove', '', '', '1304387665067507712', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310404584291696640', '数据字典视图', '2', 'sys:dictData:main', '', '', '1304387665067507712', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310404705934901248', '数据字典列表', '2', 'sys:dictData:data', '', '', '1304387665067507712', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310404831407505408', '数据字典新增', '2', 'sys:dictData:add', '', '', '1304387665067507712', 'layui-icon-vercode', 5, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310404999599095808', '数据字典删除', '2', 'sys:dictData:remove', '', '', '1304387665067507712', 'layui-icon-vercode', 6, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1310405161587310592', '数据字典修改', '2', 'sys:dictData:edit', '', '', '1304387665067507712', 'layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1313142510486290432', '公告列表', '1', 'sys:notice:data', '/system/notice/data', '0', '1313142171393589248', 'layui-icon-notice', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1313482983558086656', '公告新增', '2', 'sys:notice:add', '', '', '1313142171393589248', 'layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1313483090852577280', '公告修改', '2', 'sys:notice:edit', '', '', '1313142171393589248', 'layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1313483189850734592', '公告删除', '2', 'sys:notice:remove', '', '', '1313142171393589248', 'layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1315584471046553600', '部门管理', '1', 'sys:dept:main', '/system/dept/main', '_iframe', '1', 'layui-icon layui-icon layui-icon layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1316558444790022144', '部门新增', '2', 'sys:dept:add', '', '', '1315584471046553600', 'layui-icon layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1316558556102656000', '部门修改', '2', 'sys:dept:edit', '', '', '1315584471046553600', 'layui-icon layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1316558685442408448', '部门删除', '2', 'sys:dept:remove', '', '', '1315584471046553600', 'layui-icon layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1317555660455411712', '部门列表', '2', 'sys:dept:data', '', '', '1315584471046553600', 'layui-icon layui-icon layui-icon layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1318229908526202880', '模型新增', '2', 'pro:model:add', '', '', '1307562519451140096', 'layui-icon layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1318230013262168064', '模型修改', '2', 'pro:model:edit', '', '', '1307562519451140096', 'layui-icon layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1318230265385975808', '模型删除', '2', 'pro:model:remove', '', '', '1307562519451140096', 'layui-icon layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1320969572051845120', '111111', '2', '', '', '', '1284020948269268992', 'layui-icon-login-qq', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_power` VALUES ('1322085079861690368', '用户管理', '1', 'sys:user:main', '/system/user/main', '_iframe', '1', 'layui-icon layui-icon layui-icon layui-icon layui-icon-rate', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1322085270392143872', '用户列表', '2', 'sys:user:data', '', '', '1322085079861690368', 'layui-icon layui-icon layui-icon layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1322085393021009920', '用户新增', '2', 'sys:user:add', '', '', '1322085079861690368', 'layui-icon layui-icon-vercode', NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1322085497798918144', '用户修改', '2', 'sys:user:edit', '', '', '1322085079861690368', 'layui-icon layui-icon layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1322085659766161408', '用户删除', '2', 'sys:user:remove', '', '', '1322085079861690368', 'layui-icon layui-icon-rate', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1329349076189184000', '', '1', '', '', '', '451002662209589248', 'layui-icon', NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1330865171429588992', '在线用户', '1', 'sys:online:main', '/system/online/main', '_iframe', '694203021537574912', 'layui-icon layui-icon layui-icon-username', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1348562759603716096', '在线列表', '1', 'sys:online:data', '/system/online/data', '_iframe', '1330865171429588992', 'layui-icon layui-icon-username', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349016358033031168', '环境监控', '1', 'sys:monitor:main', '/system/monitor/main', '_iframe', '694203021537574912', 'layui-icon layui-icon-vercode', 9, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349279791521464320', '电子邮件', '1', 'sys:mail:main', '/system/mail/main', '_iframe', '1', 'layui-icon layui-icon layui-icon layui-icon-list', 7, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349636574442160128', '邮件发送', '2', 'sys:mail:save', '', '', '1349279791521464320', 'layui-icon layui-icon layui-icon layui-icon layui-icon layui-icon-vercode', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349636919478190080', '邮件删除', '2', 'sys:mail:remove', '', '', '1349279791521464320', 'layui-icon layui-icon layui-icon layui-icon layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349637786285637632', '邮件列表', '2', 'sys:mail:data', '', '', '1349279791521464320', 'layui-icon layui-icon layui-icon-vercode', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1349638479767666688', '邮件新增', '2', 'sys:mail:add', '', '', '1349279791521464320', 'layui-icon layui-icon layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1355962888132493312', '系统设置', '1', 'sys:setup:main', '/system/setup/main', '_iframe', '1', 'layui-icon layui-icon layui-icon-set', 11, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370412169610395648', '站内消息', '1', 'system:notice:main', '/system/notice/main', '_iframe', '1', 'layui-icon layui-icon layui-icon layui-icon-set-fill', 8, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370412169610395649', '消息列表', '2', 'system:notice:data', '', NULL, '1370412169610395648', 'layui-icon layui-icon-set-fill', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370412169610395650', '消息新增', '2', 'system:notice:add', '', NULL, '1370412169610395648', 'layui-icon layui-icon-set-fill', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370412169610395651', '消息修改', '2', 'system:notice:edit', '', NULL, '1370412169610395648', 'layui-icon layui-icon-set-fill', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370412169610395652', '消息删除', '2', 'system:notice:remove', '', NULL, '1370412169610395648', 'layui-icon layui-icon-set-fill', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('1370974716822552576', '修改设置', '2', 'sys:setup:add', '', '', '1355962888132493312', 'layui-icon layui-icon-vercode', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('2', '用户管理', '2', '', '', '_iframe', '1320969572051845120', 'layui-icon layui-icon layui-icon-username', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('3', '角色管理', '1', 'sys:role:main', '/system/role/main', '_iframe', '1', 'layui-icon layui-icon-user', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('4', '权限管理', '1', 'sys:power:main', '/system/power/main', '_iframe', '1', 'layui-icon layui-icon-vercode', 2, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('442359447487123456', '角色列表', '2', 'sys:role:data', '', '', '3', 'layui-icon layui-icon-rate', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('442417411065516032', '开发工具', '0', '', '', '', '0', 'layui-icon layui-icon layui-icon-senior', 4, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('442418188639145984', '代码生成', '1', 'exp:template:main', '/generate/main', '_iframe', '442417411065516032', 'layui-icon layui-icon layui-icon layui-icon layui-icon layui-icon-template-1', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('442650770626711552', '定时任务', '1', 'sch:job:main', '/schedule/job/main', '_iframe', '694203021537574912', 'layui-icon layui-icon layui-icon layui-icon  layui-icon-chat', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('442651158935375872', '任务日志', '1', 'sch:log:main', '/schedule/log/main', '_iframe', '694203021537574912', 'layui-icon layui-icon layui-icon  layui-icon-file', 1, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('450300705362808832', '行为日志', '1', 'sys:log:main', '/system/log/main', '_iframe', '694203021537574912', 'layui-icon layui-icon layui-icon layui-icon  layui-icon-chart', 7, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('451002662209589248', '工作空间', '1', '', '', '', '451002662209589248', 'layui-icon layui-icon layui-icon-home', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('451003242072117248', '项目总览', '1', 'process:model:main', '/console', '_iframe', '451002662209589248', 'layui-icon  layui-icon-component', 0, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('474356363552755712', '项目介绍', '1', 'home', '/console', '_iframe', '474356044148117504', 'layui-icon layui-icon-home', 1, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_power` VALUES ('694203021537574912', '系统监控', '0', '', '', '', '0', 'layui-icon  layui-icon-console', 3, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_power` VALUES ('694203311615639552', '接口文档', '1', '', '/swagger-ui.html', '_iframe', '442417411065516032', 'layui-icon layui-icon layui-icon  layui-icon-chart', 9, NULL, NULL, NULL, NULL, NULL, '1');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`
(
    `role_id`     char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编号',
    `role_name`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色名称',
    `role_code`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色标识',
    `enable`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否启用',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `create_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `update_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `details`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详情',
    `sort`        int(0) NULL DEFAULT NULL COMMENT '排序',
    PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role`
VALUES ('1309851245195821056', '超级管理员', 'admin', '0', NULL, NULL, NULL, NULL, NULL, '超级管理员', 1);
INSERT INTO `sys_role`
VALUES ('1313761100243664896', '普通管理员', 'manager', '0', NULL, NULL, NULL, NULL, NULL, '普通管理员', 2);
INSERT INTO `sys_role`
VALUES ('1356112133691015168', '应急管理员', 'users', '0', NULL, NULL, NULL, NULL, NULL, '应急管理员', 2);

-- ----------------------------
-- Table structure for sys_role_power
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_power`;
CREATE TABLE `sys_role_power`
(
    `id`          char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `role_id`     char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
    `power_id`    char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
    `create_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
    `create_time` datetime(0) NULL DEFAULT NULL,
    `update_by`   char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
    `update_time` datetime(0) NULL DEFAULT NULL,
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_power
-- ----------------------------
INSERT INTO `sys_role_power`
VALUES ('1284022485632679936', '3', '474356044148117504', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power`
VALUES ('1284022485632679937', '3', '474356363552755712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power`
VALUES ('1284022485632679938', '3', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power`
VALUES ('1284022485632679939', '3', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power`
VALUES ('1284022485632679940', '3', '442359447487123456', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power`
VALUES ('1284022485632679941', '3', '4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679942', '3', '442722702474743808', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679943', '3', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679944', '3', '1284020948269268992', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679945', '3', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679946', '3', '442418188639145984', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679947', '3', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679948', '3', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679949', '3', '442520236248403968', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679950', '3', '694203311615639552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679951', '3', '442650387514789888', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679952', '3', '442650770626711552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679953', '3', '442651158935375872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679954', '3', '451002662209589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1284022485632679955', '3', '451003242072117248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650364506112', '2', '474356044148117504', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700416', '2', '474356363552755712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700417', '2', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700418', '2', '1284020948269268992', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700419', '2', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700420', '2', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700421', '2', '442418188639145984', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700422', '2', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700423', '2', '442520236248403968', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700424', '2', '694203311615639552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700425', '2', '442650387514789888', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700426', '2', '442650770626711552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700427', '2', '442651158935375872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700428', '2', '451002662209589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1305379650368700429', '2', '451003242072117248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380352', '1', '451002662209589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380353', '1', '451003242072117248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380354', '1', '1305875436139446272', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380355', '1', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380356', '1', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380357', '1', '1284020948269268992', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380358', '1', '1284022967767924736', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380359', '1', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380360', '1', '442359447487123456', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380361', '1', '4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380362', '1', '1304387665067507712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380363', '1', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380364', '1', '1304793451996381184', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380365', '1', '1307299332784914432', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380366', '1', '442650387514789888', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380367', '1', '442650770626711552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380368', '1', '442651158935375872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380369', '1', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380370', '1', '442520236248403968', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380371', '1', '694203311615639552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380372', '1', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380373', '1', '442418188639145984', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380374', '1', '1302180351979814912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380375', '1', '1307562196556840960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380376', '1', '1307562519451140096', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1308571532737380377', '1', '1308571483794046976', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897792', '1310215420371795968', '451002662209589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897793', '1310215420371795968', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897794', '1310215420371795968', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897795', '1310215420371795968', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897796', '1310215420371795968', '4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897797', '1310215420371795968', '1304387665067507712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897798', '1310215420371795968', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897799', '1310215420371795968', '1304793451996381184', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897800', '1310215420371795968', '1307299332784914432', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897801', '1310215420371795968', '1313142171393589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897802', '1310215420371795968', '1313142510486290432', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897803', '1310215420371795968', '442650387514789888', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897804', '1310215420371795968', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897805', '1310215420371795968', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1313147486356897806', '1310215420371795968', '1307562196556840960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1320969221462556672', '1320969145759563776', '451002662209589248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1320969221462556673', '1320969145759563776', '451003242072117248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1320969221462556674', '1320969145759563776', '1305875436139446272', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778112', '1309851245195821056', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778113', '1309851245195821056', '1322085079861690368', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778114', '1309851245195821056', '1322085393021009920', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778115', '1309851245195821056', '1322085270392143872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778116', '1309851245195821056', '1322085497798918144', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778117', '1309851245195821056', '1322085659766161408', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778118', '1309851245195821056', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778119', '1309851245195821056', '1310209696916832256', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778120', '1309851245195821056', '1310209900478988288', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778121', '1309851245195821056', '1310210054728712192', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778122', '1309851245195821056', '442359447487123456', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778123', '1309851245195821056', '1310211965188046848', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778124', '1309851245195821056', '4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778125', '1309851245195821056', '1310226416867999744', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778126', '1309851245195821056', '1310226976593674240', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778127', '1309851245195821056', '1310227130998587392', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778128', '1309851245195821056', '1310227300935008256', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778129', '1309851245195821056', '1315584471046553600', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778130', '1309851245195821056', '1316558444790022144', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778131', '1309851245195821056', '1316558556102656000', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778132', '1309851245195821056', '1317555660455411712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778133', '1309851245195821056', '1316558685442408448', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778134', '1309851245195821056', '1304387665067507712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778135', '1309851245195821056', '1310405161587310592', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778136', '1309851245195821056', '1310402491631796224', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778137', '1309851245195821056', '1310404584291696640', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778138', '1309851245195821056', '1310404705934901248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778139', '1309851245195821056', '1310402688881524736', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778140', '1309851245195821056', '1310402817776680960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778141', '1309851245195821056', '1310403004406431744', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778142', '1309851245195821056', '1310404831407505408', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778143', '1309851245195821056', '1310404999599095808', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778144', '1309851245195821056', '1304793451996381184', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778145', '1309851245195821056', '1310243862937075712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778146', '1309851245195821056', '1310244103824343040', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778147', '1309851245195821056', '1310244248884346880', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778148', '1309851245195821056', '1307299332784914432', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778149', '1309851245195821056', '1310238229588344832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778150', '1309851245195821056', '1310238417082122240', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778151', '1309851245195821056', '1310238574355939328', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778152', '1309851245195821056', '1310238700705153024', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778153', '1309851245195821056', '1349279791521464320', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778154', '1309851245195821056', '1349637786285637632', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778155', '1309851245195821056', '1349638479767666688', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778156', '1309851245195821056', '1349636919478190080', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778157', '1309851245195821056', '1349636574442160128', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778158', '1309851245195821056', '1355962888132493312', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778159', '1309851245195821056', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778160', '1309851245195821056', '1330865171429588992', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778161', '1309851245195821056', '1348562759603716096', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778162', '1309851245195821056', '442650770626711552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778163', '1309851245195821056', '1310397832091402240', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778164', '1309851245195821056', '1310390699333517312', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778165', '1309851245195821056', '1310390994826428416', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778166', '1309851245195821056', '1310391095670079488', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778167', '1309851245195821056', '1310391707069579264', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778168', '1309851245195821056', '1310398020692475904', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778169', '1309851245195821056', '1310398158974484480', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778170', '1309851245195821056', '442651158935375872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778171', '1309851245195821056', '1310395250908332032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778172', '1309851245195821056', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778173', '1309851245195821056', '1310232350285627392', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778174', '1309851245195821056', '1310232462562951168', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778175', '1309851245195821056', '1349016358033031168', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778176', '1309851245195821056', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778177', '1309851245195821056', '442418188639145984', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778178', '1309851245195821056', '1302180351979814912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778179', '1309851245195821056', '694203311615639552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778180', '1309851245195821056', '1307562196556840960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778181', '1309851245195821056', '1307562519451140096', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778182', '1309851245195821056', '1318229908526202880', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778183', '1309851245195821056', '1318230013262168064', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778184', '1309851245195821056', '1318230265385975808', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1355962953458778185', '1309851245195821056', '1308571483794046976', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712128', '1313761100243664896', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712129', '1313761100243664896', '1322085079861690368', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712130', '1313761100243664896', '1322085393021009920', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712131', '1313761100243664896', '1322085270392143872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712132', '1313761100243664896', '1322085497798918144', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712133', '1313761100243664896', '1322085659766161408', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712134', '1313761100243664896', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712135', '1313761100243664896', '1310209696916832256', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712136', '1313761100243664896', '1310209900478988288', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712137', '1313761100243664896', '1310210054728712192', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712138', '1313761100243664896', '442359447487123456', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712139', '1313761100243664896', '1310211965188046848', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712140', '1313761100243664896', '4', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712141', '1313761100243664896', '1310226416867999744', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712142', '1313761100243664896', '1310226976593674240', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712143', '1313761100243664896', '1310227130998587392', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712144', '1313761100243664896', '1310227300935008256', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712145', '1313761100243664896', '1315584471046553600', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712146', '1313761100243664896', '1316558444790022144', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712147', '1313761100243664896', '1316558556102656000', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712148', '1313761100243664896', '1317555660455411712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712149', '1313761100243664896', '1316558685442408448', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712150', '1313761100243664896', '1304387665067507712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712151', '1313761100243664896', '1310402491631796224', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712152', '1313761100243664896', '1310404584291696640', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712153', '1313761100243664896', '1310405161587310592', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712154', '1313761100243664896', '1310402688881524736', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712155', '1313761100243664896', '1310404705934901248', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712156', '1313761100243664896', '1310402817776680960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712157', '1313761100243664896', '1310403004406431744', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712158', '1313761100243664896', '1310404831407505408', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712159', '1313761100243664896', '1310404999599095808', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712160', '1313761100243664896', '1304793451996381184', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712161', '1313761100243664896', '1310243862937075712', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712162', '1313761100243664896', '1310244103824343040', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712163', '1313761100243664896', '1310244248884346880', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712164', '1313761100243664896', '1307299332784914432', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712165', '1313761100243664896', '1310238229588344832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712166', '1313761100243664896', '1310238417082122240', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712167', '1313761100243664896', '1310238574355939328', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712168', '1313761100243664896', '1310238700705153024', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712169', '1313761100243664896', '1349279791521464320', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712170', '1313761100243664896', '1349637786285637632', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712171', '1313761100243664896', '1349638479767666688', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712172', '1313761100243664896', '1349636919478190080', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712173', '1313761100243664896', '1349636574442160128', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712174', '1313761100243664896', '1355962888132493312', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712175', '1313761100243664896', '1370974716822552576', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712176', '1313761100243664896', '694203021537574912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712177', '1313761100243664896', '1330865171429588992', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712178', '1313761100243664896', '442650770626711552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712179', '1313761100243664896', '442651158935375872', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712180', '1313761100243664896', '450300705362808832', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712181', '1313761100243664896', '1349016358033031168', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712182', '1313761100243664896', '442417411065516032', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712183', '1313761100243664896', '442418188639145984', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712184', '1313761100243664896', '1302180351979814912', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712185', '1313761100243664896', '694203311615639552', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712186', '1313761100243664896', '1307562196556840960', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712187', '1313761100243664896', '1307562519451140096', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712188', '1313761100243664896', '1318229908526202880', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712189', '1313761100243664896', '1318230013262168064', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712190', '1313761100243664896', '1318230265385975808', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('1370974927745712191', '1313761100243664896', '1308571483794046976', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('442062615250866176', '693913251020275712', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('442062615250866177', '693913251020275712', '2', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('442062615250866178', '693913251020275712', '3', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_role_power` VALUES ('442062615250866179', '693913251020275712', '4', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`
(
    `user_id`     char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
    `username`    char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账户',
    `password`    char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
    `salt`        char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
    `status`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
    `real_name`   char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
    `email`       char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
    `avatar`      varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
    `sex`         char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
    `phone`       char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话',
    `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `create_by`   char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
    `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `update_by`   char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改人',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
    `enable`      char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否启用',
    `login`       char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否登录',
    `dept_id`     char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门编号',
    `last_time`   datetime(0) NULL DEFAULT NULL COMMENT '最后一次登录时间',
    PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user`
VALUES ('1306230031168569344', 'feng', '$2a$10$jjf2h8Cx2lkFMKy3NY9pguADYAMewyPr2IJw8YAI5zSH2/0R/9Kra', NULL, '1', '风筝',
        'feng@gmail.com', NULL, '0', '15553726531', '2000-02-09 00:00:00', NULL, NULL, NULL, '被岁月镂空，亦受其雕琢', '1', NULL,
        '1', NULL);
INSERT INTO `sys_user`
VALUES ('1309861917694623744', 'admin', '$2a$10$6T.NGloFO.mD/QOAUelMTOcjAH8N49h34TsXduDVlnNMrASIGBNz6', NULL, '1', '管理',
        'Jmys1992@qq.com', '1305351580047900672', '0', '15553726531', '2020-09-26 22:26:32', NULL, NULL, NULL,
        '被岁月镂空，亦受其雕琢', '1', NULL, '1', '2021-03-14 13:48:31');
INSERT INTO `sys_user`
VALUES ('1310409555649232897', 'ruhua', '$2a$10$pkvLdCLdFp2sXZpmK34wveekbWvHinW2ldBnic4SqjiKO8jK4Etka', NULL, '1', '如花',
        'ruhua@gmail.com', NULL, '0', '15553726531', '2020-09-28 10:42:39', NULL, NULL, NULL, NULL, '1', NULL, '1',
        NULL);
INSERT INTO `sys_user`
VALUES ('1349016976730619905', 'mwj', '$2a$10$mD0pnwOGjmOKihboidaTveUdrqcDYoluzfCOA0Ho87iwr9PKrDA6i', NULL, '1', '风筝',
        '', NULL, '1', '666666666', '2021-01-12 23:34:45', NULL, NULL, NULL, NULL, '1', NULL, '6',
        '2021-01-12 23:35:12');
INSERT INTO `sys_user`
VALUES ('1349021166525743105', 'xiana', '$2a$10$6VuyGmiEbIix/gPDU8oe3O7DZSxGVByjXCHQGtyEMoRAt74M/daee', NULL, '1', '夏娜',
        'xiana@gmail.com', NULL, '0', '15553726531', '2021-01-12 23:51:24', NULL, NULL, NULL, NULL, '1', NULL, '1',
        NULL);
INSERT INTO `sys_user`
VALUES ('1355966975355912193', 'sanman', '$2a$10$AD3QnQMRhYY7RUDHd1EEL.KHaDW8/S66SsESwh.9ta8bLiUXrZcJe', NULL, '1',
        '散漫', 'sanman@gmail.com', NULL, '0', '15553726531', '2021-02-01 03:51:34', NULL, NULL, NULL, NULL, '1', NULL,
        '1', NULL);
INSERT INTO `sys_user` VALUES ('1355967204012589057', 'langhua', '$2a$10$MNbf6dSvvncpoPsNFyMW6ObPwfj3jCKsZa7LvVAiXco1DWtgA46he', NULL, '1', '浪花', 'langhua@gmail.com', NULL, '0', '15553726531', '2021-02-01 03:52:29', NULL, NULL, NULL, NULL, '1', NULL, '1', NULL);
INSERT INTO `sys_user` VALUES ('1355967579994193921', 'zidian', '$2a$10$c9OatFOMGnj37A6UJTwfGOKqCwCx50K8eZsjV5YoBRlpYHcz8WfyW', NULL, '1', '字典', 'zidian', NULL, '0', '15553726531', '2021-02-01 03:53:58', NULL, NULL, NULL, NULL, '1', NULL, '1', NULL);
INSERT INTO `sys_user` VALUES ('1370973608502886401', 'duanlang', '$2a$10$XNcKlX3AnXR/Gh2g8aLX5OFtLD69Yjl1O8PDLmITH4WCQT.shsrWe', NULL, '1', '断浪', 'duanlang@gmail.com', NULL, '0', '15553726531', '2021-03-14 13:42:34', NULL, NULL, NULL, NULL, '1', NULL, '1', '2021-03-14 13:47:28');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`
(
    `id`      char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
    `user_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户编号',
    `role_id` char(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role`
VALUES ('1302196622322565120', '1302196622007992320', '1');
INSERT INTO `sys_user_role`
VALUES ('1304443027040763904', '1304443026482921472', '1');
INSERT INTO `sys_user_role`
VALUES ('1304443027044958208', '1304443026482921472', '2');
INSERT INTO `sys_user_role`
VALUES ('1304443027044958209', '1304443026482921472', '3');
INSERT INTO `sys_user_role`
VALUES ('1304443307404820480', '1304443306888921088', '1');
INSERT INTO `sys_user_role`
VALUES ('1304443307404820481', '1304443306888921088', '2');
INSERT INTO `sys_user_role` VALUES ('1305359805342285824', '1305359804906078208', '');
INSERT INTO `sys_user_role` VALUES ('1305359807724650496', '1305359807296831488', '');
INSERT INTO `sys_user_role` VALUES ('1305390235135246336', '1305390234694844416', '');
INSERT INTO `sys_user_role` VALUES ('1306229860422647808', '1306229859755753472', '1');
INSERT INTO `sys_user_role` VALUES ('1306229892144168960', '1306229891624075264', '1');
INSERT INTO `sys_user_role` VALUES ('1306243520893288448', '1306243520482246656', '');
INSERT INTO `sys_user_role` VALUES ('1308074663896678400', '1308074663313670144', '1');
INSERT INTO `sys_user_role` VALUES ('1308074663896678401', '1308074663313670144', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308074663896678402', '1308074663313670144', '2');
INSERT INTO `sys_user_role` VALUES ('1308075167091523584', '1308075166433017856', '1');
INSERT INTO `sys_user_role` VALUES ('1308075167091523585', '1308075166433017856', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308075241188098048', '1308074939114323968', '1');
INSERT INTO `sys_user_role` VALUES ('1308075241188098049', '1308074939114323968', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308075407685189632', '1308075407114764288', '1');
INSERT INTO `sys_user_role` VALUES ('1308075407685189633', '1308075407114764288', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308075638158000128', '1308075637621129216', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308328954523811840', '1308328954045661184', '1');
INSERT INTO `sys_user_role` VALUES ('1308328954523811841', '1308328954045661184', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1308328954523811842', '1308328954045661184', '2');
INSERT INTO `sys_user_role` VALUES ('1308571264494862336', '1308076162903179264', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1309445423668133888', '1309444883659882496', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1309445423668133889', '1309444883659882496', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1309445423668133890', '1309444883659882496', '2');
INSERT INTO `sys_user_role` VALUES ('1309752526945386496', '1', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1309752526945386497', '1', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1309752526945386498', '1', '2');
INSERT INTO `sys_user_role` VALUES ('1309860016655695872', '1309860016043327488', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1309860554432577536', '1309860553891512320', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1309861324494209024', '1309861323898617856', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1309861325593116672', '1309861324909445120', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1310080380040118272', '1310080379331280896', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310080380589572096', '1310080379935260672', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310080718918909952', '1310080718256209920', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310080719917154304', '1310080719208316928', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310082314557980672', '1310082313954000896', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310082315195514880', '1310082314545397760', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310083089153654784', '1310083088511926272', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1310083089828937728', '1310083089216569344', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1310083324709961728', '1310083324110176256', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310208453033066496', '1310208452424892416', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1310209026096627712', '1310209025576534016', '1306230258952830976');
INSERT INTO `sys_user_role` VALUES ('1310209026096627713', '1310209025576534016', '1309121036125470720');
INSERT INTO `sys_user_role` VALUES ('1310381721815875584', '1306229381332467712', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1310424875067768832', '1310421836906889217', '1310421428759166976');
INSERT INTO `sys_user_role` VALUES ('1314015448013996032', '1304491590080790528', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1314410103465574400', '1314410059245027329', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1314416691479838720', '1314416690875858945', '');
INSERT INTO `sys_user_role` VALUES ('1316251185065230336', '1306230031168569344', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1316275764227735552', '1316275763711836161', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1316275764227735553', '1316275763711836161', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1316275899439513600', '1315827004456566785', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1316275899439513601', '1315827004456566785', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1316275930657718272', '1315829324519047169', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1316276059032780800', '1310409555649232897', '');
INSERT INTO `sys_user_role` VALUES ('1316410619078901760', '1306229606205882368', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1316410619078901761', '1306229606205882368', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1316410619078901762', '1306229606205882368', '1316407534105395200');
INSERT INTO `sys_user_role` VALUES ('1316410619078901763', '1306229606205882368', '1316408008376320000');
INSERT INTO `sys_user_role` VALUES ('1318205966671413248', '1318205965996130305', '');
INSERT INTO `sys_user_role` VALUES ('1320899195875360768', '1320899195225243649', '');
INSERT INTO `sys_user_role` VALUES ('1329795580615983104', '1329795579919728641', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1329795580615983105', '1329795579919728641', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1329795614484987904', '1329795613730013185', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1329795688124383232', '1329795687465877505', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1329795704863850496', '1329795703882383361', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1329795716930863104', '1329795716255580161', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1329795741211688960', '1329795740536406017', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1349021014649995264', '1349016976730619905', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1349021167326855168', '1349021166525743105', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1349021167326855169', '1349021166525743105', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1355967256000987136', '1355966975355912193', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1355967256000987137', '1355966975355912193', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1355967330718318592', '1355967204012589057', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1355967330718318593', '1355967204012589057', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1355967580686254080', '1355967579994193921', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1355967580686254081', '1355967579994193921', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1360858458609418240', '1309861917694623744', '1309851245195821056');
INSERT INTO `sys_user_role` VALUES ('1360858458609418241', '1309861917694623744', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('1370973609278832640', '1370973608502886401', '1313761100243664896');
INSERT INTO `sys_user_role` VALUES ('442110794142978048', NULL, '1');
INSERT INTO `sys_user_role` VALUES ('442110794142978049', NULL, '2');
INSERT INTO `sys_user_role` VALUES ('442110794142978050', NULL, '3');
INSERT INTO `sys_user_role` VALUES ('442114944884936704', '442114944884936704', '1');
INSERT INTO `sys_user_role` VALUES ('442114944884936705', '442114944884936704', '2');
INSERT INTO `sys_user_role` VALUES ('442114944884936706', '442114944884936704', '3');
INSERT INTO `sys_user_role` VALUES ('442114944884936707', '442114944884936704', '693913251020275712');
INSERT INTO `sys_user_role` VALUES ('442114944884936708', '442114944884936704', '693949793801601024');
INSERT INTO `sys_user_role` VALUES ('442114944884936709', '442114944884936704', '694106517393113088');
INSERT INTO `sys_user_role` VALUES ('442127724396548096', '3', '1');
INSERT INTO `sys_user_role` VALUES ('442127724396548097', '3', '2');
INSERT INTO `sys_user_role` VALUES ('442127724396548098', '3', '3');
INSERT INTO `sys_user_role` VALUES ('445004989551742976', '442492965651353600', '1');
INSERT INTO `sys_user_role` VALUES ('445004989551742977', '442492965651353600', '2');
INSERT INTO `sys_user_role` VALUES ('445005010271604736', '444226209941950464', '1');
INSERT INTO `sys_user_role` VALUES ('445005010271604737', '444226209941950464', '2');
INSERT INTO `sys_user_role` VALUES ('445005010271604738', '444226209941950464', '3');
INSERT INTO `sys_user_role` VALUES ('447196043407396864', '447196042723725312', '1');
INSERT INTO `sys_user_role` VALUES ('447196043407396865', '447196042723725312', '2');
INSERT INTO `sys_user_role` VALUES ('447197132043194368', '447197131518906368', '1');
INSERT INTO `sys_user_role` VALUES ('447197773046091776', '447197772274339840', '1');
INSERT INTO `sys_user_role` VALUES ('447200144400715776', '447199996320813056', '1');
INSERT INTO `sys_user_role` VALUES ('447200144400715777', '447199996320813056', '2');
INSERT INTO `sys_user_role` VALUES ('449248198469488640', '449248198058446848', '3');
INSERT INTO `sys_user_role` VALUES ('463926002653990912', '463926002318446592', '3');
INSERT INTO `sys_user_role` VALUES ('463926371165540352', '442488661347536896', '3');

SET FOREIGN_KEY_CHECKS = 1;
