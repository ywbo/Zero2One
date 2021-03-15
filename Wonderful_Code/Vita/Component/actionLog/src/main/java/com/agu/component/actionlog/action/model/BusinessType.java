package com.agu.component.actionlog.action.model;

import com.agu.component.actionlog.annotation.ActionLog;
import com.agu.module.system.enums.ActionLogEnum;
import lombok.Getter;

/**
 * @ClassName BusinessType
 * @Description TODO
 * @Author yuwenbo
 * @Date 2021-03-15 22:19
 **/
@Getter
public class BusinessType extends ActionModel{
    /**
     * 日志名称
     */
    protected String name;

    /**
     * 日志消息
     */
    protected String message;

    /**
     * 日志类型
     */
    protected Byte type = ActionLogEnum.BUSINESS.getCode();

    /**
     * 只是构建行为方法名，日志名称由日志注解 name 定义
     * @param message 行为方法名
     */
    public BusinessType(String message){
        this.message = message;
    }

    /**
     * 构建日志名称和行为方法名
     * @param name 日志名称
     * @param message 行为方法名
     */
    public BusinessType(String name, String message){
        this.name = name;
        this.message = message;
    }
}
