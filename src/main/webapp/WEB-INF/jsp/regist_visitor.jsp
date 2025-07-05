<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <title>来访登记</title>
    <!-- miniMObile.css、js -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/miniMobile.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.1.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/zepto.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/miniMobile.js"></script>
    <!-- mobileSelect -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mobileSelect.css">
    <script src="${pageContext.request.contextPath}/js/mobileSelect.js" type="text/javascript"></script>
    <!-- noUiSlider -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/nouislider.css" />
    <!-- switchery -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/switchery.css"/>
    <!-- iconfont -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/iconfont.css" />
    <!-- animate.css -->
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;

            /* 核心优化：背景图设置 */
            background: url('${pageContext.request.contextPath}/images/background.jpg') no-repeat center center;
            background-size: 100% 100%; /* 铺满整个屏幕，解决模糊 */
            background-attachment: fixed; /* 背景固定不滚动 */
            position: relative;
        }
        .formheader {
            background-color: #007BFF;
            color: white;
            text-align: center;
            padding: 15px 0;
            font-size: 20px;
            font-weight: 600;
            border-radius: 8px 8px 0 0;
            margin: -20px -20px 20px -20px;
            width: calc(100% + 40px);
        }

        .p3 {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            margin: 20px auto;
            box-sizing: border-box;
            /* 确保表单在遮罩层上方 */
            position: relative;
            z-index: 1;
        }

        .p3 div {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .p3 label {
            margin-bottom: 0;
            font-size: 16px;
            font-weight: 500;
            margin-right: 10px;
            width: 80px;
            text-align: right;
        }

        .p3 input[type="text"],
        .p3 select,
        .p3 input[type="file"],
        .p3 textarea {
            width: calc(100% - 90px);
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .p3 input[type="text"]:focus,
        .p3 select:focus,
        .p3 input[type="file"]:focus,
        .p3 textarea:focus {
            border-color: #007BFF;
            outline: none;
        }

        .p3 input[type="button"] {
            background-color: #007BFF;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        .p3 input[type="button"]:hover {
            background-color: #0056b3;
        }

        .image-preview-container {
            display: none;
            margin-top: 10px;
            text-align: center;
        }
        .image-preview {
            max-width: 150px;
            max-height: 150px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .remove-image-btn {
            color: #ff4d4f;
            font-size: 12px;
            cursor: pointer;
            margin-top: 5px;
            display: inline-block;
        }
    </style>
</head>

<body class="pb12 fadeIn animated">
<div class="p3">
    <form action="${pageContext.request.contextPath}/visitor/addLogin" method="post" name="myform" enctype="multipart/form-data">
        <header class="formheader">
            来访登记
        </header>
        <div>
            <label for="name">姓名：</label>
            <input type="text" class="form-control" name="name" id="name" placeholder="输入姓名"  maxlength="10" />
        </div>
        <div>
            <label for="sno">学号：</label>
            <input type="text" class="form-control" name="sno" id="sno" min="5" max="20" placeholder="输入学号" />
        </div>
        <div>
            <label for="phone">手机：</label>
            <input type="text" class="form-control" name="phone" id="phone" placeholder="输入联系方式" />
        </div>
        <div>
            <label for="place">楼宇：</label>
            <select class="form-control" id="place" name="place">
                <option value="黄淮楼一楼">黄淮楼一楼</option>
                <option value="黄淮楼二楼">黄淮楼二楼</option>
                <option value="黄淮楼三楼">黄淮楼三楼</option>
                <option value="红棉楼一楼">红棉楼一楼</option>
                <option value="红棉楼二楼">红棉楼二楼</option>
                <option value="红棉楼三楼">红棉楼三楼</option>
            </select>
        </div>
        <div>
            <label for="visit_result">备注：</label>
            <textarea class="form-control" id="visit_result" name="visit_result" placeholder="访问原因">公事</textarea>
        </div>
        <div>
            <label for="imageFile">头像：</label>
            <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
        </div>
        <div class="image-preview-container" id="imagePreviewContainer" style="display:none;">
            <img id="imagePreview" class="image-preview" src="#" alt="图片预览"/>
            <div class="remove-image-btn" onclick="removeImage()">移除图片</div>
        </div>
        <div class="t-c">
            <input type="button" onclick="toCheck()" id="sub-btn" class="btn btn-primary" value="提交登记" />
        </div>
    </form>
</div>
<script>
    // 图片预览功能
    $(document).ready(function() {
        $("#imageFile").change(function() {
            if (this.files && this.files[0]) {
                readURL(this);
                $("#imagePreviewContainer").show();
            } else {
                $("#imagePreviewContainer").hide();
            }
        });
    });

    function readURL(input) {
        var reader = new FileReader();
        reader.onload = function(e) {
            $("#imagePreview").attr("src", e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }

    function removeImage() {
        $("#imageFile").val("");
        $("#imagePreview").attr("src", "#");
        $("#imagePreviewContainer").hide();
    }

    function toCheck() {
        var name = $("#name").val().trim();
        var sno = $("#sno").val().trim();
        var phone = $("#phone").val().trim();
        var place = $("#place").val().trim();
        var visit_result = $("#visit_result").val().trim();
        if (name == null || sno == null || phone == null || place == null || visit_result == null
            || name.length == 0 || sno.length == 0 || phone.length == 0 || place.length == 0 || visit_result.length == 0) {
            layer.msg('不能为空，请输入信息...');
            return false;
        }
        document.myform.submit();
    }
    if (${logout_msg != null && !(logout_msg.trim().equals(""))}) {
        layer.msg('${logout_msg}');
    }
    if (${error_msg != null && !("".trim().equals(error_msg))}) {
        layer.msg('${error_msg}');
    }
</script>
</body>
</html>




