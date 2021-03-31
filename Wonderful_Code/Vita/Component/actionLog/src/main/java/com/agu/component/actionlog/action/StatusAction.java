package com.agu.component.actionlog.action;

import java.util.List;

import com.agu.common.enums.StatusEnum;
import com.agu.common.utils.StatusUtil;
import com.agu.component.actionlog.action.base.BaseActionMap;
import com.agu.component.actionlog.action.base.ResetLog;

/**
 * 通用：记录数据状态的行为
 *
 * @author yuwenbo
 * @date 2021-03-15 23:50
 */
public class StatusAction extends BaseActionMap {

    @Override
    public void init() {
        // 记录数据状态改变日志
        putMethod("default", "defaultMethod");
    }

    /**
     * 重新包装保存的数据行为方法
     *
     * @param resetLog ResetLog对象数据
     */
    @SuppressWarnings("unchecked")
    public static void defaultMethod(ResetLog resetLog) {
        if(resetLog.isSuccessRecord()){
            String param = (String) resetLog.getParam("param");
            StatusEnum statusEnum = StatusUtil.getStatusEnum(param);
            List<Long> ids = (List<Long>) resetLog.getParam("ids");
            resetLog.getActionLog().setMessage(statusEnum.getMessage() + "ID：" + ids.toString());
        }
    }
}
