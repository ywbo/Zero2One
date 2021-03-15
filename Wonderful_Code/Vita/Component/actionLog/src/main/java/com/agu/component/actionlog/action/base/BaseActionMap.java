package com.agu.component.actionlog.action.base;

import com.agu.component.actionlog.action.model.BusinessMethod;
import com.agu.component.actionlog.action.model.BusinessType;

import java.util.HashMap;

/**
 * @ClassName BaseActionMap
 * @Description 行为日志父类
 * @Author yuwenbo
 * @Date 2021-03-15 22:01
 **/
public abstract class BaseActionMap {
    protected HashMap<String, Object> dictory = new HashMap<>();

    public BaseActionMap(){
        init();
    }

    /**
     * 初始化行为列表
     */
    public abstract void init();

    /**
     * 获取指定的行为
     * @param key 行为 key
     * @return
     */
    public Object get(String key){
        return this.dictory.get(key);
    }

    /**
     * 添加行为
     * @param key 行为 key
     * @param modelType 模型类型对象
     */
    public void put(String key, Object modelType){
        this.dictory.put(key, modelType);
    }

    /**
     * 添加行为 - 默认类型（业务）
     * @param key 行为 key
     * @param message 日志消息
     */
    public void put(String key, String message){
        this.dictory.put(key,new BusinessType(message));
    }

    /**
     * 添加行为 - 默认类型（业务）
     * @param key 行为 key
     * @param name 日志名称
     * @param message 日志消息
     */
    public void put(String key, String name, String message){
        this.dictory.put(key, new BusinessType(name, message));
    }

    /**
     * 添加行为方法名
     * @param key 行为 key
     * @param modelMethod 模型方法名对象
     */
    public void putMethod(String key, Object modelMethod){
        this.dictory.put(key, modelMethod);
    }

    /**
     * 添加行为方法名 - 默认类型（业务）
     * @param key 行为 key
     * @param method 方法名
     */
    public void putMethod(String key, String method){
        this.dictory.put(key, new BusinessMethod(method));
    }

    /**
     * 添加行为方法名 - 默认类型（业务）
     * @param key 行为 key
     * @param name 日志名称
     * @param method 方法名
     */
    public void putMethod(String key, String name, String method){
        this.dictory.put(name, method);
    }
}
