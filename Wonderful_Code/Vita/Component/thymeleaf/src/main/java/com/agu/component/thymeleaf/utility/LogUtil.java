package com.agu.component.thymeleaf.utility;


import com.agu.common.utils.EntityBeanUtil;
import com.agu.common.utils.SpringContextUtil;
import com.agu.module.system.domain.ActionLog;
import com.agu.module.system.service.IActionLogService;

import javax.persistence.Table;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
public class LogUtil {

    /**
     * 获取实体对象的日志
     * @param entity 实体对象
     */
    public List<ActionLog> entityList(Object entity){
        IActionLogService actionLogService = SpringContextUtil.getBean(IActionLogService.class);
        Table table = entity.getClass().getAnnotation(Table.class);
        String tableName = table.name();
        try {
            Object object = EntityBeanUtil.getField(entity, "id");
            Long entityId = Long.valueOf(String.valueOf(object));
            return actionLogService.getDataLogList(tableName, entityId);
        } catch (InvocationTargetException | IllegalAccessException e) {
            e.printStackTrace();
        }
        return null;
    }
}
