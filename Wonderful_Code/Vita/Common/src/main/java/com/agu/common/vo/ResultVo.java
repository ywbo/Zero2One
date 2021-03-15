package com.agu.common.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 功能描述
 *
 * @author yWX983890
 * @since 2021-03-15
 */
@Data
@ApiModel("响应结果")
public class ResultVo<T> {
    /**
     * 状态码
     */
    @ApiModelProperty(notes = "状态码（200-成功；400-错误）")
    private Integer code;

    /**
     * 提示信息
     */
    @ApiModelProperty(notes = "提示信息")
    private String msg;

    /**
     * 响应数据
     */
    @ApiModelProperty(notes = "响应数据")
    private T data;
}
