package com.agu.common.exception;

import com.agu.common.enums.ResultEnum;
import com.agu.common.exception.interaces.ResultInterface;

import lombok.Getter;

/**
 * 功能描述
 *
 * @author yuwenbo
 * @since 2021-03-15
 */
@Getter
public class ResultException extends RuntimeException {

    private Integer code;

    /**
     * 统一 异常处理
     * @param resultEnum 状态枚举
     */
    public ResultException(ResultEnum resultEnum){
        super(resultEnum.getMessage());
        this.code = resultEnum.getCode();
    }

    /**
     * 统一异常处理
     * @param resultEnum 枚举类型，需要实现枚举接口
     */
    public ResultException(ResultInterface resultEnum){
        super(resultEnum.getMessage());
        this.code = resultEnum.getCode();
    }

    /**
     * 统一异常处理
     * @param code 状态码
     * @param message 提示信息
     */
    public ResultException(Integer code, String message){
        super(message);
        this.code = code;
    }
}
