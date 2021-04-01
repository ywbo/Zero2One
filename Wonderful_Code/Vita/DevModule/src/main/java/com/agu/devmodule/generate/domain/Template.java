package com.agu.devmodule.generate.domain;

import lombok.Data;

/**
 * @author yuwenbo
 * @date 2021-04-02
 */
@Data
public class Template {
    private boolean entity;
    private boolean controller;
    private boolean service;
    private boolean repository;
    private boolean validator;
    private boolean index;
    private boolean add;
    private boolean detail;
}
