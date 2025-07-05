package cn.xxh.controller;

import cn.xxh.pojo.Student;
import cn.xxh.service.StudentService;
import com.github.pagehelper.PageInfo;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {
    private StudentService studentService;
    @Autowired
    public void setStudentService(StudentService studentService) {
        this.studentService = studentService;
    }

    // 查询所有学生信息
    @RequestMapping("/findAll")
    public ModelAndView findAll(@RequestParam(name = "page", required = true, defaultValue = "1") int page, @RequestParam(name = "size", required = true, defaultValue = "5") int size, HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        ModelAndView mv = new ModelAndView();
        List<Student> list = null;
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().equals("") || keyword.length() == 0) {
            list = studentService.findAll(page, size);
        }else {
            list = studentService.search(page,size,keyword);
        }
        //PageInfo就是一个封装了分页数据的bean
        PageInfo pageInfo = new PageInfo(list);
        mv.addObject("pageInfo",pageInfo);
        mv.setViewName("student-list");

        return mv;
    }

    // 根据学号删除学生
    @RequestMapping("/delete")
    public void delete(HttpServletRequest request,HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("utf-8");
        PrintWriter writer = response.getWriter();
        String sno = request.getParameter("sno");
        if (sno == null || "".equals(sno) || sno.length() == 0) {
            writer.write("false");
            return;
        }
        studentService.delete(sno);
        writer.write("true");
    }

    // 批量删除学生
    @RequestMapping("/deleteStudents")
    @ResponseBody
    public String deleteStudents(@RequestParam("ids") String ids) {
        try {
            if (ids != null && !ids.isEmpty()) {
                String[] idArray = ids.split(",");
                for (String sno : idArray) {
                    studentService.delete(sno); // 捕获可能的异常
                    System.out.println("删除了学号为 " + sno + " 的学生");
                }
                return "success"; // 全部删除成功
            }
            return "error"; // 参数为空
        } catch (Exception e) {
            e.printStackTrace(); // 打印异常日志
            return "error"; // 返回错误信息
        }
    }

    // 判断指定学号是否存在
    @RequestMapping("/isExist")
    public void isSnoExist(HttpServletRequest request,HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        PrintWriter writer = response.getWriter();
        String sno = request.getParameter("sno");
        Student isExist = studentService.findBySno(sno);
        if (isExist == null) {
            return;
        }
        //如果isExist不为空说明学号已被注册
        writer.write("true");
    }

    @RequestMapping("/addStudent")
    public ModelAndView addStudent(HttpServletRequest request) throws Exception {
        request.setCharacterEncoding("utf-8");
        ModelAndView mv = new ModelAndView();
        String dorm_id = request.getParameter("dorm_id");
        if (dorm_id != null) {
            mv.addObject("dorm_id",dorm_id);
            mv.setViewName("dormStudent-add");
            return mv;
        }
        mv.setViewName("student-add");
        return mv;
    }

    // 添加学生信息
    @RequestMapping("/add")
    public void add(Student student,HttpServletResponse response) throws Exception {
        PrintWriter writer = response.getWriter();
        if (student == null || studentService.findBySno(student.getSno()) != null) {
            writer.write("false");
            return;
        }

        Student s = studentService.findBySno(student.getSno());
        if (s != null) {
            writer.write("false");
            return;
        }
        boolean isAdd = studentService.add(student);
        if (isAdd) {
            writer.write("true");
        }else {
            writer.write("false");
        }
    }

    @RequestMapping("/editStudent")
    public ModelAndView editStudent(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView();
        request.setCharacterEncoding("utf-8");
        String sno = request.getParameter("sno");
        Student stu = studentService.findBySno(sno);
        mv.addObject("stu",stu);
        mv.setViewName("student-edit");
        return mv;
    }

    // 修改学生信息
    @RequestMapping("/update")
    public void update(Student student,HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("utf-8");
        PrintWriter writer = response.getWriter();
        if (student == null || student.getId() == null) {
            return;
        }
        if (student.getName() == null || "".equals(student.getName()) || student.getName().length() == 0
                || student.getSex() == null || student.getSex().length() == 0 || "".equals(student.getSex())
                || student.getSno() == null || "".equals(student.getSno()) || student.getSno().length() == 0
                || student.getPhone() == null || "".equals(student.getPhone()) || student.getPhone().length() == 0
                || student.getStu_class() == null || "".equals(student.getStu_class()) || student.getStu_class().length() == 0
                || student.getPlace() == null || "".equals(student.getPlace()) || student.getPlace().length() == 0
                || student.getDorm_id() == null || "".equals(student.getDorm_id()) || student.getDorm_id().length() == 0
                || student.getTeacher() == null || "".equals(student.getTeacher()) || student.getTeacher().length() == 0 ) {
            return;
        }
        studentService.update(student);
        writer.write("true");
    }

    // 下载学生数据为Excel
    @RequestMapping("/export")
    public void export(HttpServletResponse response) throws Exception {
        InputStream is = studentService.getInputStream();
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("contentDisposition", "attachment;filename=studentsInfo.xls");
        ServletOutputStream outputStream = response.getOutputStream();
        IOUtils.copy(is,outputStream);
    }
}