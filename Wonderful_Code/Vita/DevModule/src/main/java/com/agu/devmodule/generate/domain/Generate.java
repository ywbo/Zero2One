package com.agu.devmodule.generate.domain;

import lombok.Data;

import java.util.List;

/**
 * 封装生成数据
 * @author yuwenbo
 * @date 2021-04-02
 */
@Data
public class Generate {
    private Basic basic = new Basic();
    private List<Field> fields;
    private Template template;
}
