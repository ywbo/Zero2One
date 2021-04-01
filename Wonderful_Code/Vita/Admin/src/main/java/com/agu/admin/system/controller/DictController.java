package com.agu.admin.system.controller;


import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import com.agu.admin.system.validator.DictValid;
import com.agu.common.enums.ResultEnum;
import com.agu.common.enums.StatusEnum;
import com.agu.common.exception.ResultException;
import com.agu.common.utils.EntityBeanUtil;
import com.agu.common.utils.ResultVoUtil;
import com.agu.common.utils.StatusUtil;
import com.agu.common.vo.ResultVo;
import com.agu.component.actionlog.action.SaveAction;
import com.agu.component.actionlog.action.StatusAction;
import com.agu.component.actionlog.annotation.ActionLog;
import com.agu.component.actionlog.annotation.EntityParam;
import com.agu.module.system.service.IDictService;

import cn.hutool.core.lang.Dict;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
@Controller
@RequestMapping("/system/dict")
public class DictController {

    @Autowired
    private IDictService dictService;

    /**
     * 列表页面
     */
    @GetMapping("/index")
    @RequiresPermissions("system:dict:index")
    public String index(Model model, Dict dict){

        // 创建匹配器，进行动态查询匹配
        ExampleMatcher matcher = ExampleMatcher.matching().
                withMatcher("title", match -> match.contains());

        // 获取字典列表
        Example<Dict> example = Example.of(dict, matcher);
        Page<Dict> list = dictService.getPageList(example);

        // 封装数据
        model.addAttribute("list", list.getContent());
        model.addAttribute("page", list);
        return "/system/dict/index";
    }

    /**
     * 跳转到添加页面
     */
    @GetMapping("/add")
    @RequiresPermissions("system:dict:add")
    public String toAdd(){
        return "/system/dict/add";
    }

    /**
     * 跳转到编辑页面
     */
    @GetMapping("/edit/{id}")
    @RequiresPermissions("system:dict:edit")
    public String toEdit(@PathVariable("id") Dict dict, Model model){
        model.addAttribute("dict", dict);
        return "/system/dict/add";
    }

    /**
     * 保存添加/修改的数据
     * @param valid 验证对象
     */
    @PostMapping({"/add","/edit"})
    @RequiresPermissions({"system:dict:add","system:dict:edit"})
    @ResponseBody
    @ActionLog(name = "字典管理", message = "字典：${title}", action = SaveAction.class)
    public ResultVo save(@Validated DictValid valid, @EntityParam Dict dict){
        // 清除字典值两边空格
        dict.setValue(dict.getValue().trim());

        // 判断字典标识是否重复
        if (dictService.repeatByName(dict)) {
            throw new ResultException(ResultEnum.DICT_EXIST);
        }

        // 复制保留无需修改的数据
        if(dict.getId() != null){
            Dict beDict = dictService.getById(dict.getId());
            EntityBeanUtil.copyProperties(beDict, dict);
        }

        // 保存数据
        dictService.save(dict);
        if(dict.getId() != null){
            DictUtil.clearCache(dict.getName());
        }
        return ResultVoUtil.SAVE_SUCCESS;
    }

    /**
     * 跳转到详细页面
     */
    @GetMapping("/detail/{id}")
    @RequiresPermissions("system:dict:detail")
    public String toDetail(@PathVariable("id") Dict dict, Model model){
        model.addAttribute("dict",dict);
        return "/system/dict/detail";
    }

    /**
     * 设置一条或者多条数据的状态
     */
    @RequestMapping("/status/{param}")
    @RequiresPermissions("system:dict:status")
    @ResponseBody
    @ActionLog(name = "字典状态", action = StatusAction.class)
    public ResultVo status(
            @PathVariable("param") String param,
            @RequestParam(value = "ids", required = false) List<Long> ids){
        // 更新状态
        StatusEnum statusEnum = StatusUtil.getStatusEnum(param);
        if (dictService.updateStatus(statusEnum, ids)) {
            return ResultVoUtil.success(statusEnum.getMessage() + "成功");
        } else {
            return ResultVoUtil.error(statusEnum.getMessage() + "失败，请重新操作");
        }
    }
}
