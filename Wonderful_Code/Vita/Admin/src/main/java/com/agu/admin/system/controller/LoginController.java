package com.agu.admin.system.controller;

import com.agu.common.config.properties.ProjectProperties;
import com.agu.common.data.URL;
import com.agu.common.enums.ResultEnum;
import com.agu.common.exception.ResultException;
import com.agu.common.utils.ResultVoUtil;
import com.agu.common.utils.SpringContextUtil;
import com.agu.common.vo.ResultVo;
import com.agu.component.actionlog.action.UserAction;
import com.agu.component.actionlog.annotation.ActionLog;
import com.agu.component.shrio.ShrioUtil;
import com.agu.module.system.domain.User;
import com.agu.module.system.service.IRoleService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.xml.ws.Action;

/**
 * @ClassName LoginController
 * @Description 用户登陆
 * @Author yuwenbo
 * @Date 2021-03-13 21:21
 **/
@Controller
public class LoginController implements ErrorController {

    @Autowired
    private IRoleService roleService;

    /**
     * 跳转登陆界面
     * @param model
     * @return
     */
    @GetMapping("/login")
    public String toString(Model model){
        ProjectProperties properties = SpringContextUtil.getBean(ProjectProperties.class);
        model.addAttribute("isCaptcha", properties.isCaptchaOpen());
        return "/login";
    }

    /**
     * 实现用户登录
     *
     * @param username
     * @param password
     * @param captcha
     * @param rememberMe
     * @return
     */
    @PostMapping("/login")
    @ResponseBody
    @ActionLog(key= UserAction.USER_LOGIN, action = UserAction.class)
    public ResultVo login(String username, String password, String captcha, String rememberMe){
        // 判断账号密码是否为空
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)){
            throw new ResultException(ResultEnum.USER_NAME_PWD_NULL);
        }

        // 判断验证码是否正确
        ProjectProperties properties = SpringContextUtil.getBean(ProjectProperties.class);
        if (properties.isCaptcheOpen()){
            Session session = SecurityUtils.getSubject().getSession();
        }

        // 1. 获取 Subject 主题对象
        Subject subject = SecurityUtils.getSubject();

        // 2. 封装用户数据
        UsernamePasswordToken token = new UsernamePasswordToken(username, password);

        // 3. 执行登录操作，进入自定义 Realm 类中
        try {
            // 判断是否自动登录
            if (rememberMe != null) {
                token.setRememberMe(true);
            } else {
                token.setRememberMe(false);
            }
            subject.login(token);

            // 判断是否拥有后台角色
            User user = ShrioUtil.getSubject();
            if (roleService.existsUserOk(user.getId())) {
                return ResultVoUtil.success("登录成功", new URL("/"));
            } else {
                SecurityUtils.getSubject().logout();
                return ResultVoUtil.error("您不是后台管理员！");
            }
        } catch (LockedAccountException e) {
            return ResultVoUtil.error("该账号已被冻结");
        } catch (AuthenticationException e) {
            return ResultVoUtil.error("用户名或密码错误");
        }
    }

    /**
     * 自定义错误页面
     * @return
     */
    @Override
    public String getErrorPath() {
        return "/error";
    }
}
