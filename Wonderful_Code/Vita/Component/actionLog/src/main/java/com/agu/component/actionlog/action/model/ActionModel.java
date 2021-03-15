package com.agu.component.actionlog.action.model;

import lombok.Getter;

/**
 * @ClassName ActionModel
 * @Description TODO
 * @Author yuwenbo
 * @Date 2021-03-15 22:02
 **/
@Getter
public class ActionModel {
    /**
     * 日志名称
     */
    protected String name;

    /**
     * 日志类型
     */
    protected Byte type;
}
