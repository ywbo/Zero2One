package com.agu.component.excel.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.agu.component.excel.enums.ExcelType;

/**
 * 自定义 Excel 注解
 *
 * @author yuwenbo
 * @since 2021-03-17
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.FIELD})
public @interface Excel {
    // 字段标题名称或者文件名称
    public String value();

    // excel 操作类型 ExcelType
    public ExcelType type() default ExcelType.ALL;

    // 字段字典标识，用于导入导出时进行字典转换（只支持导出操作）
    public String dict() default "";

    // 关联操作实体对象字段名称，用于获取关联数据（只支持导出操作）
    public String joinField() default "";

}
