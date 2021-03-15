package com.agu.common.utils;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 * 获取Spring的ApplicationContext对象的工具类，可以用静态方法的方式获取Spring容器中的Bean
 *
 * @author yuwenbo
 * @since 2021-03-15
 */
@Component
public class SpringContextUtil implements ApplicationContextAware {

    private static ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        SpringContextUtil.applicationContext = applicationContext;
    }

    /**
     * 获取applicationContext
     */
    public static ApplicationContext getApplicationContext(){
        return applicationContext;
    }

    /**
     * 通过 name 获取 bean
     * @param name
     * @return
     */
    public static Object getBean(String name){
        return getApplicationContext().getBean(name);
    }

    /**
     * 通过 class 获取 Bean
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> T getBean(Class<T> clazz){
        return getApplicationContext().getBean(clazz);
    }

    /**
     * 通过 name ，以及 Clazz 返回指定的 Bean
     * @param name
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> T getBean(String name, Class<T> clazz){
        return getApplicationContext().getBean(name, clazz);
    }

    /**
     * 获取配置文件配置项的值
     * @param key
     * @return
     */
    public static String getEnvironmentProperty(String key){
        return getApplicationContext().getEnvironment().getProperty(key);
    }
}
