package com.agu.admin.system.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

/**
 * @ClassName LoginController
 * @Description TODO
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
     * @param userName
     * @param password
     * @param captcha
     * @param rememberMe
     * @return
     */
    public ResultVo login(String userName, String password, String captcha, String rememberMe){
        // 判断账号密码是否为空
        if (StringUtils.isEmpty(userName) || StringUtils.isEmpty(password)){
            throw new ResultException(ResultEnum.USER_NAME_PWD_NULL);
        }

        // 判断验证码是否正确
        ProjectProperties properties = SpringContextUtil.getBean(ProjectProperties.class);
        if (properties.isCaptcheOpen()){
            Session session = SecurityUtil.getSubject().getSeesion();
        }

        // 1. 获取 Subject 主题对象

        // 2. 封装用户数据

        // 3. 执行登录操作，进入自定义 Realm 类中

        return null;
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
