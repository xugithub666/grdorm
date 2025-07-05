<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/usersLogin.css">
    <link rel="icon" href="${pageContext.request.contextPath}/images/favicon.ico" sizes="32x32" />
    <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/reset.css"/>
    <script src="${pageContext.request.contextPath}/js/jquery-3.1.1.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
    <title>登录页面--LOGIN</title>
    <style>
        .captcha-box { display: flex; gap: 10px; align-items: center; margin-top: 15px; }
        #captcha-img { flex: 1; height: 40px; background: #f0f0f0; cursor: pointer; border: 1px solid #ddd; }
    </style>
</head>
<body>
<form action="${pageContext.request.contextPath}/login" name="myform" method="post">
    <div id="particles-js">
        <div class="login">
            <div class="login-top">
                广软宿舍
            </div>
            <div class="login-center clearfix">
                <div class="login-center-img"><img src="${pageContext.request.contextPath}/images/name.png"/></div>
                <div class="login-center-input">
                    <input type="text" id="username" name="username" placeholder="请输入您的用户名" onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的用户名'"/>
                    <div class="login-center-input-text">用户名</div>
                </div>
            </div>
            <div class="login-center clearfix">
                <div class="login-center-img"><img src="${pageContext.request.contextPath}/images/password.png"/></div>
                <div class="login-center-input">
                    <input type="password" id="password" name="password" placeholder="请输入您的密码" onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的密码'"/>
                    <div class="login-center-input-text">密码</div>
                </div>
            </div>

            <!-- 验证码区域 -->
            <div class="login-center clearfix captcha-box">
                <div class="login-center-input" style="flex: 1;">
                    <input type="text" id="captcha" name="captcha" placeholder="请输入验证码" onfocus="this.placeholder=''" onblur="this.placeholder='请输入验证码'"/>
                    <div class="login-center-input-text">验证码</div>
                </div>
                <canvas id="captcha-img" width="120" height="40" onclick="refreshCaptcha()"></canvas>
            </div>

            <div class="login-button" onclick="check()">
                登录
            </div>
            <span style="text-align: center;color: red;"><br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;${msg}</span>
        </div>
        <div class="sk-rotating-plane"></div>
    </div>
</form>
<script src="${pageContext.request.contextPath}/js/particles.min.js"></script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script type="text/javascript">
    // 验证码相关逻辑
    let captchaText = '';
    const ctx = document.getElementById('captcha-img').getContext('2d');

    // 初始化验证码
    document.addEventListener('DOMContentLoaded', function() {
        refreshCaptcha();
    });

    // 刷新验证码
    function refreshCaptcha() {
        // 生成4位随机数字
        captchaText = Math.random().toString().slice(2, 6);

        // 绘制验证码
        const canvas = document.getElementById('captcha-img');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.font = 'bold 30px Arial';  // 增大字体并加粗
        ctx.fillStyle = '#333';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(captchaText, canvas.width/2, canvas.height/2);  // 居中显示

        // 添加干扰线
        for (let i = 0; i < 3; i++) {
            ctx.strokeStyle = 'rgba(0,0,0,' + Math.random() * 0.5 + ')';
            ctx.beginPath();
            ctx.moveTo(Math.random() * canvas.width, Math.random() * canvas.height);
            ctx.lineTo(Math.random() * canvas.width, Math.random() * canvas.height);
            ctx.stroke();
        }

        // 添加干扰点
        for (let i = 0; i < 30; i++) {
            ctx.fillStyle = 'rgba(0,0,0,' + Math.random() * 0.5 + ')';
            ctx.beginPath();
            ctx.arc(Math.random() * canvas.width, Math.random() * canvas.height, 1, 0, 2 * Math.PI);
            ctx.fill();
        }
    }

    // 表单验证函数
    function check() {
        var username = $("#username").val().trim();
        var password = $("#password").val().trim();
        var captcha = $("#captcha").val().trim();

        if (username == null || username == "" || username.length == 0) {
            layer.msg('请输入用户帐号');
            return false;
        }
        if (password == null || password == "" || password.length == 0) {
            layer.msg('请输入登录密码');
            return false;
        }
        if (password.length < 4 || password.length > 20) {
            layer.msg('密码格式有误（4-20位字符）');
            return false;
        }

        // 验证码验证
        if (captcha == null || captcha == "" || captcha.length == 0) {
            layer.msg('请输入验证码');
            return false;
        }
        if (captcha !== captchaText) {
            layer.msg('验证码错误');
            refreshCaptcha();
            return false;
        }

        document.myform.submit();
    }
</script>
</body>
</html>