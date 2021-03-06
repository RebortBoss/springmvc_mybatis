<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>


<!DOCTYPE html>
<html>
<head>
<title></title>
<link
	href="${baseURL}/ligerUI/lib/ligerUI/skins/Aqua/css/ligerui-all.css"
	rel="stylesheet" type="text/css" />

<link href="${baseURL}/ligerUI/lib/ligerUI/skins/ligerui-icons.css"
	rel="stylesheet" type="text/css" />
<script src="${baseURL}/ligerUI/lib/jquery/jquery-1.3.2.min.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/core/base.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerLayout.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/jquery/jquery-1.3.2.min.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/core/base.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/json2.js"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/ligerui.all.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerTab.js"></script>
<script src="${baseURL}/ligerUI/lib/jquery.cookie.js"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerGrid.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerTab.js"></script>
<script
	src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerResizable.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerCheckBox.js"
	type="text/javascript"></script>

<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerForm.js"
	type="text/javascript"></script>
<script
	src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerDateEditor.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerComboBox.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerCheckBox.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerButton.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerDialog.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerRadio.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerSpinner.js"
	type="text/javascript"></script>
<script src="${baseURL}/ligerUI/lib/ligerUI/js/plugins/ligerTextBox.js"
	type="text/javascript"></script>

<style type="text/css">
.l-table-edit {
	
}

.l-table-edit-td {
	padding: 4px;
}

.l-button-submit,.l-button-reset {
	width: 80px;
	float: left;
	margin-left: 10px;
	padding-bottom: 2px;
}
</style>


<script type="text/javascript">
	//设置menuId到表单中
	var dialog = frameElement.dialog; //调用页面的dialog对象(ligerui对象)
    var data = dialog.get('data');  //获取参数
    var tree = data["tree"];  //获取树，用户添加子菜单自后刷新数据
	
    
    $(function() {
		$("#parentId").attr("value", "${roleId}");
		
		$("#form1").submit(function(){
			//验证表单数据是否填写
			var name = $("#name").val();
		    
			if(!name){
				alert("输入角色名字");
				return false;
			}
			
			$.ajax({
                cache: true,
                type: "POST",
                url:"${baseURL }/role/addSubmit.do",
                data:$('#form1').serialize(),// 你的formid
                async: false,
                error: function(request) {
                },
                success: function(data) {
        			//重新加载树的数据
        			dialog.close();  //关闭dialog
        			tree.reload();  //刷新树的数据
        			$.ligerDialog.tip( //show delete success tip
        					{
        						title : '提示信息',
        						content : '添加成功'
        					});
                }
            });
		});
	});
</script>

</head>

<body>
	<form id="form1" name="form1" method="post" action="#">
		<div></div>
		<table cellpadding="0" cellspacing="0" class="l-table-edit">
			<tr>
				<td align="right" class="l-table-edit-td">名字:</td>
				<td align="left" class="l-table-edit-td"><input name="name"
					type="text" id="name" ltype="text" /> <input type="hidden"
					id="parentId" name="parentId"></td>
				<td align="left"></td>
			</tr>
			<tr>
				<td align="right" class="l-table-edit-td">desc:</td>
				<td align="left" class="l-table-edit-td"><textarea cols="100"
						rows="4" class="l-textarea" id="desc" name="desc"
						style="width: 400px"></textarea></td>
				<td align="left"></td>
			</tr>
		</table>

		<br /> <input style="margin-left: 40px" type="submit" value="提交"
			id="Button1" class="l-button l-button-submit" /> <input type="reset"
			value="重置" class="l-button l-button-reset" />
	</form>
	<div style="display: none">
		<!--  数据统计代码 -->
	</div>
</body>
</html>
