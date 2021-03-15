package com.agu.component.actionlog.action;

import com.agu.component.actionlog.action.base.BaseActionMap;
import com.agu.component.actionlog.action.base.ResetLog;
import com.agu.component.actionlog.action.model.BusinessMethod;
import com.agu.component.actionlog.action.model.LoginMethod;
import com.agu.component.actionlog.annotation.ActionLog;

/**
 * @ClassName UserAction
 * @Description 用户行为日志
 * @Author yuwenbo
 * @Date 2021-03-15 22:48
 **/
public class UserAction extends BaseActionMap {

    public static final String USER_LOGIN = "user_login";
    public static final String USER_SAVE = "user_save";
    public static final String EDIT_PWD = "edit_pwd";
    public static final String EDIT_ROLE = "edit_role";

    @Override
    public void init() {
        // 用户登陆行为
        putMethod(USER_LOGIN, new LoginMethod("用户登陆", "userLogin"));
        // 保存用户行为
        putMethod(USER_SAVE, new BusinessMethod("用户管理", "userSave"));
        // 修改用户密码行为
        putMethod(EDIT_PWD, new BusinessMethod("用户修改密码","editPwd"));
        // 角色分配行为
        putMethod(EDIT_ROLE, new BusinessMethod("角色分配", "editRole"));
    }

    /**
     * 用户登陆行为方法
     * @param resetLog
     */
    public void userLogin(ResetLog resetLog){
        ActionLog actionLog = resetLog.getActionLog();
    }
}
