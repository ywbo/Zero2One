package com.agu.admin.system.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import com.agu.common.exception.ResultException;
import com.agu.common.utils.ResultVoUtil;
import com.agu.common.vo.ResultVo;
import com.agu.component.fileupload.FileUpload;
import com.agu.component.fileupload.enums.UploadResultEnum;
import com.agu.module.system.domain.Upload;
import com.agu.module.system.service.IUploadService;

/**
 * @author yuwenbo
 * @date 2021-04-01
 */
@Controller
public class UploadController {

    @Autowired
    private IUploadService uploadService;

    /**
     * 上传web格式图片
     */
    @PostMapping("/upload/image")
    @ResponseBody
    public ResultVo uploadImage(@RequestParam("image") MultipartFile multipartFile) {

        // 创建Upload实体对象
        Upload upload = FileUpload.getFile(multipartFile, "/images");
        try {
            return saveImage(multipartFile, upload);
        } catch (IOException | NoSuchAlgorithmException e) {
            return ResultVoUtil.error("上传图片失败");
        }
    }

    /**
     * 上传web格式头像
     */
    @PostMapping("/upload/picture")
    @ResponseBody
    public ResultVo uploadPicture(@RequestParam("picture") MultipartFile multipartFile) {

        // 创建Upload实体对象
        Upload upload = FileUpload.getFile(multipartFile, "/picture");
        try {
            return saveImage(multipartFile, upload);
        } catch (IOException | NoSuchAlgorithmException e) {
            return ResultVoUtil.error("上传头像失败");
        }
    }

    /**
     * 保存上传的web格式图片
     */
    private ResultVo saveImage(MultipartFile multipartFile, Upload upload) throws IOException, NoSuchAlgorithmException {
        // 判断是否为支持的图片格式
        String[] types = {
                "image/gif",
                "image/jpg",
                "image/jpeg",
                "image/png"
        };
        if(!FileUpload.isContentType(multipartFile, types)){
            throw new ResultException(UploadResultEnum.NO_FILE_TYPE);
        }

        // 判断图片是否存在
        Upload uploadSha1 = uploadService.getBySha1(FileUpload.getFileSha1(multipartFile));
        if (uploadSha1 != null) {
            return ResultVoUtil.success(uploadSha1);
        }

        FileUpload.transferTo(multipartFile, upload);
        // 将文件信息保存到数据库中
        uploadService.save(upload);
        return ResultVoUtil.success(upload);
    }

}
