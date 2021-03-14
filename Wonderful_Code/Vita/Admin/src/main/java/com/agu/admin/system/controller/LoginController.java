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


    @GetMapping("/login")
    public String toString(Model model){
        return null;
    }

    @Override
    public String getErrorPath() {
        return null;
    }
}
