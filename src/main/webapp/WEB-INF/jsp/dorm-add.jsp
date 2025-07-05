<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.1.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/layer/layer.js"></script>
</head>
<body>
<br />
<form>
    <table class="table" style="width: 100%;text-align: center;">
        <tbody>
        <tr>
            <td><label for="dorm3">宿舍号</label></td>
            <td>
                <select class="form-control" name="dorm1" id="dorm1">
                    <option value="黄淮楼" selected>黄淮楼</option>
                    <option value="红棉楼">红棉楼</option>
                    <option value="书院楼">书院楼</option>
                    <option value="书院楼">书院楼</option>
                </select>
            </td>
            <td><select class="form-control" name="dorm2" id="dorm2">
                <option value="Y" selected>Y</option>
                <option value="R" selected>R</option>
                <option value="S" selected>S</option>
            </select></td>
            <td>
                <input type="text" name="dorm3" placeholder="请直接输入宿舍号" class="form-control" id="dorm3" list="did" required>
                <datalist id="did">
                    <option value="101" />
                    <option value="102" />
                    <option value="103" />
                    <option value="104" />
                    <option value="105" />
                    <option value="106" />
                    <option value="107" />
                    <option value="108" />
                    <option value="109" />
                    <option value="110" />
                    <option value="111" />
                    <option value="112" />
                    <option value="201" />
                    <option value="202" />
                    <option value="203" />
                    <option value="204" />
                    <option value="205" />
                    <option value="206" />
                    <option value="207" />
                    <option value="208" />
                    <option value="209" />
                    <option value="210" />
                    <option value="211" />
                    <option value="212" />
                </datalist>
            </td>
            <!-- <input type="text" name="dorm3" placeholder="请直接输入宿舍号" class="form-control" id="dorm3" required> -->
            </td>
        </tr>
        <tr>
            <td><label for="dorm_intro">宿舍简介</label></td>
            <td colspan="3">
                <textarea class="form-control" id="dorm_intro" name="dorm_intro" cols="2" maxlength="80" placeholder="请输入宿舍简介" required="required"></textarea>
            </td>
        </tr>
        <tr>
            <td>
                <label for="dorm_rps">宿舍奖惩</label>
            </td>
            <td colspan="3">
                <select name="dorm_rps" class="form-control" id="dorm_rps" required>
                    <option value="" selected disabled>请选择</option>
                    <option value="年度最佳宿舍">年度最佳宿舍</option>
                    <option value="年度活跃宿舍">年度活跃宿舍</option>
                    <option value="年度文明宿舍">年度文明宿舍</option>
                    <option value="最佳学习宿舍">最佳学习宿舍</option>
                    <option value="卫生最佳宿舍">卫生最佳宿舍</option>
                    <option value="最佳骨干宿舍">最佳骨干宿舍</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <label for="dorm_leader">宿舍长</label>
            </td>
            <td colspan="3">
                <input type="text" name="dorm_leader" class="form-control" id="dorm_leader" required>
            </td>
        </tr>
        <tr>
            <td><label for="teacher">辅导员</label></td>
            <td>
                <select class="form-control" name="teacher" id="teacher">
                    <option value="李思远" selected>李思远</option>
                    <option value="张雨辰">张雨辰</option>
                    <option value="王梓涵">王梓涵</option>
                    <option value="吴宇航">吴宇航</option>
                    <option value="王老师">王老师</option>
                    <option value="林老师">林老师</option>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <button type="button" id="add-dorm" class="btn btn-primary">确认添加</button>
                <a href="javascript:window.history.back(-1)" target="_self" class="btn btn-default">返回列表</a>
            </td>
        </tr>
        </tbody>
    </table>
</form>
<script>
    $("#dorm3").change(function () {
        var d1 = $("#dorm1").val();
        var d2 = $("#dorm2").val();
        var dorm3 = $("#dorm3").val().trim();
        var dorm_id = d1+""+d2+""+dorm3;
        $.ajax({
            url: "${pageContext.request.contextPath}/dorm/isExist",//要请求的服务器url
            data: {
                dorm_id:dorm_id
            },
            type: "POST", //请求方式为POST
            dataType: "json",
            success:function(result){  //这个方法会在服务器执行成功时被调用 ，参数data就是服务器返回的值(现在是json类型)
                //alert(result);
                if(result){
                    layer.msg('该宿舍已存在，请重新注册！');
                }
            }
        });
    });
    $("#add-dorm").click(function () {
        var dorm3 = $("#dorm3").val().trim();
        var dorm_intro = $("#dorm_intro").val().trim();
        var dorm_rps = $("#dorm_rps").val().trim();
        var dorm_leader = $("#dorm_leader").val().trim();
        var teacher = $("#teacher").val().trim();

        if (dorm3.length == 0 || dorm_intro.length == 0 || dorm_rps.length == 0 || dorm_leader == 0 || teacher.length == 0) {
            layer.msg('字段不能为空');
            return false;
        }
        if (${sessionScope.adminInfo.power < 2}) {
            layer.msg('权限不足');
            return false;
        }
        var d1 = $("#dorm1").val();
        var d2 = $("#dorm2").val();
        var dorm_id = d1+""+d2+""+dorm3;
        //alert(dorm_id);
        $.ajax({
            url: "${pageContext.request.contextPath}/dorm/add",//要请求的服务器url
            //这是一个对象，表示请求的参数，两个参数：method=ajax&val=xxx，服务器可以通过request.getParameter()来获取
            //data:{method:"ajaxTest",val:value},
            data: {
                dorm_id:dorm_id,
                dorm_intro:dorm_intro,
                dorm_rps: dorm_rps,
                dorm_leader:dorm_leader,
                teacher: teacher,
            },
            type: "POST", //请求方式为POST
            dataType: "json",
            success:function(result){  //这个方法会在服务器执行成功时被调用 ，参数data就是服务器返回的值(现在是json类型)
                //alert(result);
                if(result){
                    layer.msg('添加成功');
                    if (${sessionScope.adminInfo.power == 2}) {
                        setTimeout(function () {window.location.href='${pageContext.request.contextPath}/dorm/byTeacher?uid=${sessionScope.adminInfo.uid}';},2000);
                        return flase;
                    }
                    setTimeout(function () {window.location.href='${pageContext.request.contextPath}/dorm/findAll';},2000);
                }else {
                    layer.msg('添加失败，请重新添加');
                    if (${sessionScope.adminInfo.power == 2}) {
                        setTimeout(function () {window.location.href='${pageContext.request.contextPath}/dorm/byTeacher?uid=${sessionScope.adminInfo.uid}';},2000);
                        return flase;
                    }
                    setTimeout(function () {window.location.href='${pageContext.request.contextPath}/dorm/findAll';},2000);
                }
            }
        });
    });
</script>
</body>
</html>
