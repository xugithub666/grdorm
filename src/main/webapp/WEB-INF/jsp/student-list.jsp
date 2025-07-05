<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<html class="x-admin-sm">
<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/xadmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.1.1.js"></script>
    <script src="${pageContext.request.contextPath}/lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/xadmin.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <!-- 删除重复的jQuery引入 -->
    <!-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.1.1.js"></script> -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- 添加自定义样式 -->
    <style>
        .fixed-width {
            width: 10px !important; /* 调整为与ID列相同的宽度 */
            text-align: center;
        }
    </style>

    <script>
        function changePageSize() {
            var pageSize = $("#changePageSize").val();
            location.href = "${pageContext.request.contextPath}/student/findAll?page=1&size="+ pageSize;
        }
        $("#serarch_btn").click(function () {
            var keyword = $("#keyword").val();
            location.href="${pageContext.request.contextPath}/student/findAll?page=1&size=5&keyword="+keyword;
        });
        $("#refresh").click(function () {
            $("#myform").reset();
            location.href="${pageContext.request.contextPath}/student/findAll?page=1&size=5";
        });
    </script>
</head>
<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body ">
                    <form id="myform" class="layui-form layui-col-space5">
                        <div class="layui-inline layui-show-xs-block">
                            <input class="layui-input" type="text" autocomplete="off" placeholder="请输入关键字" name="keyword" id="keyword" value="${param.keyword}">
                        </div>
                        <div class="layui-inline layui-show-xs-block">
                            <button class="layui-btn"  id="serarch_btn" lay-submit="" lay-filter="sreach"><i class="layui-icon">&#xe615;</i></button>
                        </div>
                        <div class="layui-inline layui-show-xs-block x-right">
                            <a class="layui-btn layui-btn-normal" href="${pageContext.request.contextPath}/student/findAll?page=1&size=5"><i class="layui-icon">&#xe669;</i></a>
                        </div>
                    </form>
                </div>
                <xblock>
                    <a href="${pageContext.request.contextPath}/student/addStudent" class="layui-btn layui-btn-normal"><i class="layui-icon">&#xe654;</i>添加</a>
                    <a onclick="exportInfo()" class="layui-btn layui-btn-warm" href="javascript:;"><i class="layui-icon">&#xe67c;</i>下载</a>
                    <button class="layui-btn layui-btn-danger" onclick="batchDelete()"><i class="layui-icon">&#xe640;</i>批量删除</button>
                    <span class="x-right" style="line-height:40px">共有数据：${pageInfo.total} 条</span>
                </xblock>
                <div class="layui-card-body">
                    <table class="layui-table layui-form">
                        <thead>
                        <tr style="text-align: center">
                            <!-- 修改复选框列 - 添加lay-filter="selectAll" -->
                            <th class="fixed-width">
                                <span>多选</span>
                                <input type="checkbox" id="selectAll" lay-filter="selectAll">
                            </th>
                            <th style="text-align: center">ID</th>
                            <th style="text-align: center">姓名</th>
                            <th style="text-align: center">性别</th>
                            <th style="text-align: center">学号</th>
                            <th style="text-align: center">班级</th>
                            <th style="text-align: center">联系方式</th>
                            <th style="text-align: center">宿舍号</th>
                            <th style="text-align: center">辅导员</th>
                            <th style="text-align: center">状态</th>
                            <c:if test="${sessionScope.adminInfo.power > 1}">
                            <th style="text-align: center">操作</th>
                            </c:if>
                        </thead>
                        <tbody>
                        <c:forEach items="${pageInfo.list}" var="student" varStatus="status">
                            <tr id="light" style="text-align: center">
                                <!-- 修改复选框数据单元格 - 添加lay-filter="ids" -->
                                <td class="fixed-width">
                                    <input type="checkbox" name="ids" value="${student.sno}" lay-filter="ids">
                                </td>
                                <!-- 全局连续序号 -->
                                <td>${(pageInfo.pageNum - 1) * pageInfo.pageSize + status.index + 1}</td>
                                <td>${student.name}</td>
                                <td>${student.sex}</td>
                                <td>${student.sno}</td>
                                <td>${student.stu_class}</td>
                                <td>${student.phone}</td>
                                <td>${student.dorm_id}</td>
                                <td>${student.teacher}</td>
                                <c:if test="${student.status == 1}">
                                    <td><button class="layui-btn layui-btn-normal layui-btn-sm">已注册</button></td>
                                </c:if>
                                <c:if test="${student.status == 0}">
                                    <td><button class="layui-btn layui-btn-danger layui-btn-sm">禁用</button></td>
                                </c:if>
                                <c:if test="${sessionScope.adminInfo.power > 1}">
                                    <td class="td-manage">
                                        <a title="编辑" href="${pageContext.request.contextPath}/student/editStudent?sno=${student.sno}">
                                            <i class="layui-icon">&#xe642;</i>
                                        </a>
                                        <a title="删除" onclick="member_del(this,${student.sno},${sessionScope.adminInfo.power})" href="javascript:;">
                                            <i class="layui-icon">&#xe640;</i>
                                        </a>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="pull-left">
                    <div class="form-group form-inline">
                        共&nbsp;${pageInfo.pages}&nbsp;页&emsp;当前页：${pageInfo.pageNum}&nbsp;/&nbsp;${pageInfo.pages}&emsp; 每页
                        <select class="form-control" id="changePageSize" onchange="changePageSize()">
                            <option value="1">${pageInfo.size}</option>
                            <option value="5">5</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                        </select> 条
                    </div>
                </div>
                <c:choose>
                    <c:when test="${pageInfo.pages < 5}">
                        <c:set var="begin" value="1">
                        </c:set>
                        <c:set var="end" value="${pageInfo.pages}">
                        </c:set>
                    </c:when>
                    <c:when test="${pageInfo.pageNum <= 3}">
                        <c:set var="begin" value="1">
                        </c:set>
                        <c:set var="end" value="5">
                        </c:set>
                    </c:when>
                    <c:when test="${pageInfo.pageNum > 3 and pageInfo.pageNum <= pageInfo.pages-2}">
                        <c:set var="begin" value="${pageInfo.pageNum - 2}">
                        </c:set>
                        <c:set var="end" value="${pageInfo.pageNum + 2}">
                        </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="begin" value="${pageInfo.pages - 4}">
                        </c:set>
                        <c:set var="end" value="${pageInfo.pages}">
                        </c:set>
                    </c:otherwise>
                </c:choose>
                <div class="layui-card-body x-right" style="height: min-content">
                    <div class="page">
                        <div>
                            <a class="next" href="${pageContext.request.contextPath}/student/findAll?page=1&size=${pageInfo.pageSize}&keyword=${param.keyword}">首页</a>
                            <c:if test="${pageInfo.pageNum > 1}">
                                <a class="prev" href="${pageContext.request.contextPath}/student/findAll?page=${pageInfo.pageNum-1}&size=${pageInfo.pageSize}&keyword=${param.keyword}">上一页</a>
                            </c:if>
                            <c:forEach var="i" begin="${begin}" end="${end}" step="1">
                                <c:if test="${pageInfo.pageNum == i}">
                                    <span class="current">${i}</span>
                                </c:if>
                                <c:if test="${pageInfo.pageNum != i}">
                                    <a class="num" href="${pageContext.request.contextPath}/student/findAll?page=${i}&size=${pageInfo.pageSize}&keyword=${param.keyword}">${i}</a>
                                </c:if>
                            </c:forEach>
                            <c:if test="${pageInfo.pageNum < pageInfo.pages}">
                                <a class="next" href="${pageContext.request.contextPath}/student/findAll?page=${pageInfo.pageNum+1}&size=${pageInfo.pageSize}&keyword=${param.keyword}">下一页</a>
                            </c:if>
                            <a class="next" href="${pageContext.request.contextPath}/student/findAll?page=${pageInfo.pages}&size=${pageInfo.pageSize}&keyword=${param.keyword}">尾页</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 初始化Layui表单组件
    layui.use(['form', 'layer'], function(){
        var form = layui.form;
        var layer = layui.layer;

        // 渲染所有表单元素
        form.render();

        // 全选/取消全选（使用Layui事件监听）
        form.on('checkbox(selectAll)', function(data){
            $("input[name='ids']").prop("checked", data.elem.checked);
            form.render('checkbox');
        });

        // 监听行选择
        form.on('checkbox(ids)', function(data){
            var allChecked = ($("input[name='ids']:checked").length === $("input[name='ids']").length);
            $("#selectAll").prop("checked", allChecked);
            form.render('checkbox');
        });
    });

    // 批量删除函数
    function batchDelete() {
        var ids = [];
        $("input[name='ids']:checked").each(function() {
            ids.push($(this).val());
        });

        if (ids.length === 0) {
            layer.msg("请选择要删除的学生");
            return;
        }

        if (${sessionScope.adminInfo.power < 3}) {
            layer.msg('对不起，您没有权限！');
            return false;
        }

        layer.confirm('确定要删除选中的'+ids.length+'个学生吗？', function(index) {
            $.post("${pageContext.request.contextPath}/student/deleteStudents",
                {"ids": ids.join(",")},
                function(data) {
                    if(data == "success") {
                        layer.msg('删除成功!',{icon:1,time:2000});
                        setTimeout(function () {
                            window.location.href='${pageContext.request.contextPath}/student/findAll';
                        },2000);
                    } else {
                        layer.msg('删除失败!',{icon:2,time:2000});
                    }
                }
            );
            layer.close(index);
        });
    }

    // 删除操作
    function member_del(obj,sno,power){
        layer.confirm('确认要删除吗？',function(index){
            if (power < 3){
                layer.msg('对不起，您没有权限！');
                return false;
            }
            $.get("${pageContext.request.contextPath}/student/delete",{"sno":sno},function (data) {
                if(data){
                    layer.msg('删除成功!',{icon:1,time:2000});
                    setTimeout(function () {window.location.href='${pageContext.request.contextPath}/student/findAll';},2000);
                }else {
                    layer.msg('删除失败!',{icon:1,time:2000});
                    setTimeout(function () {window.location.href='${pageContext.request.contextPath}/student/findAll';},2000);
                }
            });
        });
    }

    // 下载Excel操作
    function exportInfo() {
        if (${sessionScope.adminInfo.power < 3}) {
            layer.msg('对不起，您权限不足');
            return false;
        }
        layer.confirm('确定下载所有学生数据吗？',function (index) {
            location.href="${pageContext.request.contextPath}/student/export";
            layer.close(index);
        });
    }
</script>
</body>
</html>