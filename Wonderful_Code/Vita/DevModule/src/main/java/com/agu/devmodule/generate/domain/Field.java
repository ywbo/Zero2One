package com.agu.devmodule.generate.domain;

import lombok.Data;

import java.util.List;

/**
 * @author yuwenbo
 * @date 2021-04-02
 */
@Data
public class Field {
    private String name;
    private String title;
    private Integer type;
    private Integer query;
    private boolean show;
    private List<Integer> verify;

    public Field() {
    }

    public Field(String name, String title, int type, int query, boolean show, List<Integer> verify) {
        this.name = name;
        this.title = title;
        this.type = type;
        this.query = query;
        this.show = show;
        this.verify = verify;
    }
}
