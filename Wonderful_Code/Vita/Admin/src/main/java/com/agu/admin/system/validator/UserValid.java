package com.agu.admin.system.validator;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;

import com.agu.module.system.domain.Dept;

import lombok.Data;

/**
 * @ClassName UserValid
 * @Description TODO
 * @Author yuwenbo
 * @Date 2021-03-13 21:23
 **/
@Data
public class UserValid implements Serializable {
    @NotEmpty(message = "用户名不能为空")
    private String username;
    @NotEmpty(message = "用户昵称不能为空")
    @Size(min = 2, message = "用户昵称：请输入至少2个字符")
    private String nickname;
    private String confirm;
    @NotNull(message = "所在部门不能为空")
    private Dept dept;
}
