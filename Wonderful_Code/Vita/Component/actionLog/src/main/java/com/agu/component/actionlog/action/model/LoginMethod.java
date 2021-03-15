package com.agu.component.actionlog.action.model;

import com.agu.module.system.enums.ActionLogEnum;
import lombok.Getter;

/**
 * @ClassName LoginMethod
 * @Description TODO
 * @Author yuwenbo
 * @Date 2021-03-15 22:57
 **/
@Getter
public class LoginMethod extends BusinessMethod {

    /**
     * 日志类型
     */
    protected Byte type = ActionLogEnum.LOGIN.getCode();

    public LoginMethod(String method){
        super(method);
    }

    public LoginMethod(String name, String method){
        super(name, method);
    }
}
