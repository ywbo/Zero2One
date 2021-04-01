package com.agu.devmodule.generate.domain;

import lombok.Data;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
@Data
public class Basic {
    private String projectPath;
    private String packagePath;
    private String author;
    private String genTitle;
    private String genModule;
    private String genGroup;
    private Long genPMenu;
    private String tablePrefix;
    private String tableName;
    private String tableEntity;
    private String requestMapping;
    private Integer moduleType;
}
