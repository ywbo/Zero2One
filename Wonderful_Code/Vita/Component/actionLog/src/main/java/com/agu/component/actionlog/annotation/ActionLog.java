package com.agu.component.actionlog.annotation;

import com.agu.component.actionlog.action.base.BaseActionMap;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @ClassName ActionLog
 * @Description 行为日志注解
 * @Author yuwenbo
 * @Date 2021-03-15 21:58
 **/
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
public @interface ActionLog {
    // 日志名称
    String name() default "";

    // 日志消息
    String message() default "";

    // 行为 key
    String key() default "";

    // 行为类
    Class<? extends BaseActionMap> action() default BaseActionMap.class;

}
