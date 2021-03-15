package com.agu.common.exception.interfaces;

/**
 * 结果枚举接口
 *
 * @author yWX983890
 * @since 2021-03-15
 */
public interface ResultInterface {
    /**
     * 获取状态编码
     * @return 编码
     */
    Integer getCode();

    /**
     * 获取提示信息
     * @return 提示信息
     */
    String getMessage();
}
