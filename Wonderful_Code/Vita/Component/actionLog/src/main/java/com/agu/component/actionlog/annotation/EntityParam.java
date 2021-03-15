package com.agu.component.actionlog.annotation;

import java.lang.annotation.*;

/**
 * @ClassName EntityParam
 * @Description 控制器实体参数注解
 * @Author yuwenbo
 * @Date 2021-03-15 23:38
 **/
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.PARAMETER, ElementType.METHOD})
@Documented
public @interface EntityParam {
}
