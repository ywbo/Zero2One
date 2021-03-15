package com.agu.common.utils;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.FatalBeanException;

import javax.persistence.Id;
import java.beans.PropertyDescriptor;
import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * @ClassName EntityBeanUtil
 * @Description 实体对象操作工具
 * @Author yuwenbo
 * @Date 2021-03-15 23:50
 **/
public class EntityBeanUtil {

    /**
     * 复制实体对象保留的默认字段
     */
    private static String[] defaultFields = new String[]{
            "createDate",
            "updateDate",
            "createBy",
            "updateBy",
            "status"
    };

    public static Object[] getId(Object entity){
        Field[] fields = entity.getClass().getDeclaredFields();
        for (Field field : fields){
            Id id = field.getAnnotation(Id.class);
            if(id != null){
                try {
                    field.setAccessible(true);
                    return new Object[]{field.getName(), field.get(entity)};
                } catch (IllegalAccessException e) {
                    throw new FatalBeanException("获取" + entity.getClass().getName() + "实体对象主键出错！", e);
                }
            }
        }
        return null;
    }

    /**
     * 根据字段名获取实体对象值
     *
     * @param entity 实体对象
     * @param fieldName 字段名
     * @return Object对象
     * @throws InvocationTargetException
     * @throws IllegalAccessException
     */
    public static Object getField(Object entity, String fieldName) throws InvocationTargetException, IllegalAccessException {
        PropertyDescriptor beanObjectPd = BeanUtils.getPropertyDescriptor(entity.getClass(), fieldName);
        if (beanObjectPd != null){
            Method readMethod = beanObjectPd.getReadMethod();
            if(readMethod != null){
                if(!Modifier.isPublic(readMethod.getDeclaringClass().getModifiers())){
                    readMethod.setAccessible(true);
                }
                return readMethod.invoke(entity);
            }
        }
        return null;
    }
}
