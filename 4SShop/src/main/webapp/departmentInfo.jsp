<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<title>部门管理</title>
		
		<link rel="stylesheet" href="layui/css/layui.css" />
		<script type="text/javascript" src="layui/layui.js"></script>
		<script type="text/javascript">
			layui.use(['element', 'table', 'layer', 'laydate','form'], function() {
				var element = layui.element,
					layer = layui.layer,
					$ = layui.$,
					table = layui.table,
					laydate = layui.laydate,
					form=layui.form;
				
				laydate.render({
					elem: '#date1'
				});
				
				//生成表格
				table.render({
					elem: '#test',
					url: 'Dep/select.do',
					method:'post',
					limit:5,
					limits:[2,5,10,15,20],
					cols: [[
				      {field:'deptId', width:120, title: '编号', sort: true},
				      {field:'deptName', width:120, title: '部门名称'},
				      {field:'remark', title: '备注'},
				      {fixed: 'right', title:'操作', toolbar: '#barDemo', width:150} 
				    ]],
					page: true
				  
				});
				//模糊查询
				$("#search").click(function(){
					var keyword=$("input[name=title]").val();
					//重载表格数据
					table.reload('test',{
						page:{curr:1},
						where: {key:keyword}
					});
				});
				
				//监听表格工具栏
				table.on('tool(test)', function(obj) {
					var data = obj.data;
					if(obj.event === 'del') {
						layer.confirm('确定删除吗？', function(index) {
							$.post("Dep/delete.do",{deptId:data.deptId},function(res){
								
								if(res>0){
									layer.msg("删除成功",{time:2000},function(){
										//刷新表格
										table.reload('test',{
											page:{curr:1},
											where: {key:''},
										});
									});
								}else{
									layer.msg("删除失败,请稍后再试....",{time:2000});
								}
							});
						});
					} else if(obj.event === 'edit') {
						layer.open({
							  type: 1, 
							  area: ['400px', 'auto'],
							  offset:'100px',
							  content:$('#xg1'),  //这里content是一个普通的String
							  success:function(){
								$("#updId").val(data.deptId);
								$("#updName").val(data.deptName);
								$("#updremark").val(data.remark);
							  },
							  cancel: function() {
									//右上角关闭回调
									$("#xg1").css("display", "none");
							  }
						});
					} else if(obj.event === 'info') {
						layer.open({
							  type: 1, 
							  area: ['600px', 'auto'],
							  offset:'100px',
							  content:$('#xg2'),  //这里content是一个普通的String
							  success:function(){
								$("#deptId").text(data.deptId);
								$("#deptName").text(data.deptName);
								$("#remark").text(data.remark);
							  },
							  cancel: function() {
									//右上角关闭回调
									$("#xg2").css("display", "none");
							  }
						});
					}
				});
				
				//为添加部门绑定单击事件并且弹出添加层
				$("#addbtn").click(function() {
					layer.open({
						type: 1,
						area: ['400px', 'auto'],
						offset:'100px',
						content: $('#tj1'),
						cancel: function() {
							//右上角关闭回调
							$("#tj1").css("display", "none");
						}
					});
				})
				
				//监听添加表单提交
				form.on('submit(add)',function(){
					var formData=$("#addForm").serialize();
					$.post("Dep/add.do",formData,function(res){
						if(res>0){
							layer.msg("添加成功",{time:1000},function(){
								//重置表单
								$("#addForm")[0].reset();
								//重新加载表格
								table.reload('test',{
									page:{curr:1},
									where: {key:''}
								});
								//关闭弹层
								layer.closeAll();
							});
						}else{
							layer.msg("添加失败");
						}
					});
					return false;
				});
				
				//监听修改表单提交
				form.on('submit(upd)',function(){
					var formData=$("#updForm").serialize();
					$.post("Dep/update.do",formData,function(res){
						
							if(res>0){
								layer.msg("修改成功",{time:1000},function(){
									//重置表单
									$("#updForm")[0].reset();
									//重新加载表格
									table.reload('test',{
										page:{curr:1},
										where: {key:''}
									});
									//关闭当前弹层
									layer.closeAll();
								});
							}else{
								layer.msg("修改失败");
							}
						});
						return false;
				});
				
			});
			
		</script>
	</head>

	<body>
		
			
				<!-- 内容主体区域 -->
				<div class="layui-row">
					<div class="layui-inline" style="margin-left: 10px;">
						<input type="text" name="title" required lay-verify="required" placeholder="请输入部门" autocomplete="off" class="layui-input">
					</div>
					<button class="layui-btn layui-btn-normal" lay-submit="search" id="search">搜索</button>
					<button class="layui-btn" id="addbtn">添加部门</button>
				</div>
				<div>
					<table class="layui-hide" id="test" lay-filter="test"></table>
				</div>
				<script type="text/html" id="barDemo">
					<a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
					<a class="layui-btn layui-btn-xs" lay-event="edit">修改</a>
					<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
				</script>


	</body>
	
	
	<!--添加页面-->
			<div style="display: none"  id="tj1"> 
				<form name="" method="post" action="" class="layui-form" id="addForm">
					 <div class="layui-form-item">
						    <label class="layui-form-label">部门名称：</label>
						    <div class="layui-input-block">
						      <input type="text" id="addName" name="deptName" required  lay-verify="required" placeholder="请输入部门名称" autocomplete="off" class="layui-input">
						    </div>
					  </div>
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					    <div class="layui-input-block">
					      <textarea name="remark"  id="updremark" required lay-verify="required" placeholder="请输入描述" class="layui-textarea"></textarea>
					    </div>
					</div><br /><br />
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <button class="layui-btn" lay-submit lay-filter="add">添加</button>
					      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
					    </div>
					</div>
				</form>
			</div>


	<!--修改页面-->
			<div style="display: none"  id="xg1"> 
				<form name="" method="post" action="" class="layui-form" id="updForm">
					 <input type="hidden" name="deptId" id="updId">
					 <div class="layui-form-item">
						    <label class="layui-form-label">部门名称：</label>
						    <div class="layui-input-block">
						      <input type="text" name="deptName" id="updName" required  lay-verify="required" autocomplete="off" class="layui-input">
						    </div>
					  </div>
					  
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label>
					    <div class="layui-input-block">
					      <textarea name="remark" class="layui-textarea" ></textarea>
					    </div>
					</div><br /><br />
					<div class="layui-form-item">
					    <div class="layui-input-block">
					      <button class="layui-btn" lay-submit lay-filter="upd">修改</button>
					      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
					    </div>
					</div>
				</form>
			</div>



	<!--详情页面-->
			<div style="display: none"  id="xg2"> 
				<table width="80%" style="line-height: 60px;margin-left:10%">
					<tr>
						<td>部门编号：</td>
						<td><span id="deptId"></span></td>
					</tr>
					<tr>
						<td>部门名称：</td>
						<td><span id="deptName"></span></td>
					</tr>
					<tr>
						<td>部门描述：</td>
						<td><span id="remark"></span></td>
					</tr>
				</table>
			</div>
			
			
</html>