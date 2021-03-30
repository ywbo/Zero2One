package com.agu.admin.system.controller;

import com.agu.common.utils.ResultVoUtil;
import com.agu.common.vo.ResultVo;
import com.agu.module.system.domain.ActionLog;
import com.agu.module.system.service.IActionLogService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Page;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 功能介绍: 日志记录
 *
 * @Author yuwenbo
 * @Date 2021-03-30
 **/
@RestController(value = "/system/actionLog")
public class ActionLogController {

    @Autowired
    private IActionLogService actionLogService;

    /**
     * 页面列表
     *
     * @param model 实体
     * @param actionLog 日志实体
     * @return 返回列表数据
     */
    @GetMapping("/index")
    @RequiresPermissions("system:actionLogLindex")
    public String index(Model model, ActionLog actionLog) {
        // 创建匹配器，进行动态查询匹配
        ExampleMatcher matcher = ExampleMatcher.matching();

        // 获取日志目录
        Example<ActionLog> example = Example.of(actionLog, matcher);
        Page<ActionLog> pageList = actionLogService.getPageList(example);

        // 封装数据
        model.addAttribute("list", pageList.getContent());
        model.addAttribute("page", pageList);

        return "/system/actionLog/index";
    }

    /**
     * 跳转到详情页面
     * @param actionLog 日志实体
     * @param model 实体
     * @return 返回详情数据
     */
    @GetMapping("/detail/{id}")
    @RequiresPermissions("system:actionLog:detail")
    public String toDetail(@PathVariable("id") ActionLog actionLog, Model model) {
        model.addAttribute("actionLog", actionLog);
        return "/system/actionLog/detail";
    }

    /**
     * 删除指日志
     * @param id 日志id
     * @return
     */
    @RequestMapping("/status/delete")
    @RequiresPermissions("system:actionLog:delete")
    @ResponseBody
    public ResultVo delete(@RequestParam(value = "id", required = false) Long id) {
        if (id != null) {
            actionLogService.deleteId(id);
            return ResultVoUtil.success("日志删除成功！");
        } else {
            actionLogService.clearLog();
            return ResultVoUtil.success("日志清空成功！");
        }
    }
}
