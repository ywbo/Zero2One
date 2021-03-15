package com.agu.module.system.enums;

import lombok.Getter;

/**
 * @ClassName ActionLogEnum
 * @Description 行为日志枚举类
 * @Author yuwenbo
 * @Date 2021-03-15 22:32
 **/
@Getter
public enum ActionLogEnum {

    /**
     * 业务日志行为
     */
    BUSINESS((byte) 1, "业务");

    /**
     * 用户登录日志行为
     */
    LOGIN((byte) 2, "登陆");

    /**
     * 系统日志行为（报错信息）
     */
    SYSTEM((byte) 3, "系统");

    private Byte code;

    private String message;

    ActionLogEnum(Byte code, String message){
        this.code = code;
        this.message = message;
    }
}
