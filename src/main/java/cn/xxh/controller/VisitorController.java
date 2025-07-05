package cn.xxh.controller;

import cn.xxh.pojo.Visitor;
import cn.xxh.service.VisitorService;
import com.github.pagehelper.PageInfo;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.io.File;

@Controller
@RequestMapping("/visitor")
public class VisitorController {

    private VisitorService visitorService;

    @Autowired
    public void setVisitorService(VisitorService visitorService) {
        this.visitorService = visitorService;
    }

    @RequestMapping("/login")
    public String register() {
        return "regist_visitor";
    }

    private String uploadFile(MultipartFile file, HttpServletRequest request) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // 验证文件类型
        String contentType = file.getContentType();
        if (!contentType.startsWith("image/")) {
            throw new IllegalArgumentException("只允许上传图片文件");
        }

        // 创建上传目录 - 修改为使用request.getSession().getServletContext()
        String uploadDir = request.getSession().getServletContext().getRealPath("/uploads/");
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        File dest = new File(dir, fileName);

        // 保存文件
        file.transferTo(dest);

        // 返回相对路径
        return "/uploads/" + fileName;
    }

    /**
     * 来访登记实现（C操作）
     * @param visitor
     * @return
     * @throws Exception
     */
    @RequestMapping("/addLogin")
    public ModelAndView addVisitor(
            Visitor visitor,
            @RequestParam("imageFile") MultipartFile file,  // 添加文件参数
            HttpServletRequest request) throws Exception {  // 添加request参数
        ModelAndView mv = new ModelAndView();
        // 先处理文件上传
        try {
            String imagePath = uploadFile(file, request);
            visitor.setImage(imagePath);
        } catch (Exception e) {
            mv.addObject("error_msg", "头像上传失败: " + e.getMessage());
            mv.setViewName("regist_visitor");
            return mv;
        }

        if (visitor == null || visitor.getName() == null || visitor.getSno() == null || visitor.getPhone() == null || visitor.getPlace() == null) {
            mv.addObject("error_msg","来访登记失败，请重新登记！");
            mv.setViewName("regist_visitor");
            return mv;
        }
        if (visitor.getId() == null || "".trim().equals(visitor.getId())) {
            String uuid = UUID.randomUUID().toString().replace("-", "");
            visitor.setId(uuid);
        }
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        visitor.setBegin_date(date);//设置来访时间为提交来访登记时间
        //先设置离开时间为空串，后续注销时再修改为注销时系统时间
        if (visitor.getEnd_date() == null || "".trim().equals(visitor.getEnd_date())) {
            visitor.setEnd_date("");
        }
        visitorService.add(visitor);
        mv.addObject("id",visitor.getId());
        mv.setViewName("visitor-success");
        return mv;
    }

    /**
     * 访客记录注销
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/login_out")
    public ModelAndView logout(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();
        String id = request.getParameter("id");
        if (id == null || "".trim().equals(id)) {
            mv.addObject("logout_msg","系统繁忙，请稍后再试！");
            mv.setViewName("regist_visitor");
        }
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        visitorService.logout(id,date);
        mv.addObject("logout_msg","注销成功");
        mv.setViewName("regist_visitor");
        return mv;
    }

    /**
     * 管理员手动注销来访状态
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/updateStatus")
    public void updateStatus(HttpServletRequest request,HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        PrintWriter writer = response.getWriter();
        String id = request.getParameter("id");
        if (id == null || "".trim().equals(id)) {
            writer.write("false");
            return;
        }
        String date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        visitorService.logout(id,date);
        writer.write("true");
    }

    /**
     * 查询所有访客记录
     * @param page
     * @param size
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/findAll")
    public ModelAndView findAll(@RequestParam(name = "page", required = true, defaultValue = "1") int page, @RequestParam(name = "size", required = true, defaultValue = "5") int size,HttpServletRequest request,HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        ModelAndView mv = new ModelAndView();
        List<Visitor> visitors = null;
        String keyword = request.getParameter("keyword");
        if (keyword == null || "".trim().equals(keyword) || keyword.length() == 0) {
            visitors = visitorService.findAll(page,size);
        }else {
            visitors = visitorService.search(page,size,keyword);
        }
        PageInfo pageInfo = new PageInfo(visitors);
        mv.addObject("pageInfo",pageInfo);
        mv.setViewName("visitor-list");
        return mv;
    }

    /**
     * 访客日志`
     * @return
     * @throws Exception
     */
    @RequestMapping("/log")
    public ModelAndView log(@RequestParam(name = "page", required = true, defaultValue = "1") int page, @RequestParam(name = "size", required = true, defaultValue = "10") int size) throws Exception {
        ModelAndView mv = new ModelAndView();
        List<Visitor> logs = visitorService.log(page,size);
        PageInfo pageInfo = new PageInfo(logs);
        mv.addObject("pageInfo",pageInfo);
        mv.setViewName("visitor-log");
        return mv;
    }
    /**
     * 下载访客信息
     * @param response
     * @throws Exception
     */
    @RequestMapping("/visitorInfo")
    public void export(HttpServletResponse response) throws Exception {
        InputStream is = visitorService.getInputStream();
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("contentDisposition","attachment;filename=visitorInfo.xls");
        ServletOutputStream outputStream = response.getOutputStream();
        IOUtils.copy(is,outputStream);

    }
}
