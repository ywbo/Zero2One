package com.agu.admin.system.controller;

import com.agu.module.system.service.IMenuService;
import com.agu.module.system.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 后台主体内容
 *
 * @Author yuwenbo
 * @Date 2021-03-23
 **/
@Controller
public class MainController {

    @Autowired
    private IUserService userService;

    @Autowired
    private IMenuService menuService;


}
