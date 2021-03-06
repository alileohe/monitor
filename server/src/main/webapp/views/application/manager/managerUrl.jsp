<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>monitor监控系统-管理URL</title>
    <%@include file="/WEB-INF/layouts/base.jsp"%>
    <link href="${ctx}/global/css/manageBusScene/manageBusScene.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(function(){
	$("body").layout({
		top:{topHeight:100},
		bottom:{bottomHeight:30}
	});
	$("#thresholdList").Grid({
        type:"post",
		url : "${ctx}/application/manager/urlmanager/urllist/${bizScenarioId}",
		dataType: "json",
		colDisplay: false,  
		clickSelect: true,
		draggable:false,
		height: "auto",
        sorts:false,
		colums:[  
			{id:'1',text:'URL地址',name:"url",index:'1',align:''},
			{id:'2',text:'描述',name:"description",index:'1',align:''},
			/*{id:'3',text:'可用性',name:"status",index:'1',align:''},
			{id:'4',text:'健康状态',name:"threshold",index:'1',align:''},*/
			{id:'5',text:'操作',name:"operation",index:'1',align:''}
		],  
		rowNum:9999,
		pager : false,
		number:false,  
		multiselect: true
	});
	$("#myDesk").height($("#layout_center").height());
	$("#nav").delegate('li', 'mouseover mouseout', navHover);
	$("#nav,#menu").delegate('li', 'click', navClick);
});
function navHover(){
	$(this).toggleClass("hover")
}
function navClick(){
	$(this).addClass("seleck").siblings().removeClass("seleck");
	if($(this).hasClass('has_sub')){
		var subMav = $(this).children("ul.add_sub_menu");
		var isAdd = false;
		if($(this).parent().attr("id") == "menu"){
			isAdd = true;
		};
		subMav.slideDown('fast',function(){
			$(document).bind('click',{dom:subMav,add:isAdd},hideNav);
			return false;
		});		
	};
}
function hideNav(e){
	var subMenu = e.data.dom;
	var isAdd = e.data.add;
	subMenu.slideUp('fast',function(){
		if(isAdd){
			subMenu.parent().removeClass('seleck');
		};
	});	
	$(document).unbind();
}
function delRow(e){
    msgConfirm('系统消息','确定要删除当前的URL吗？',function(){
        var rows = $(e).parent().parent();
        var id = rows.attr('id');
        /*id前面多了“rows”*/
        var urlId=id.substr(4,32);
        /*删除url操作*/
        window.location.href="${ctx}/application/manager/urlmanager/delete/${bizScenarioId}/"+urlId;
    });
}
function urlBatchDel(){
    var $g = $("#thresholdList div.grid_view > table");
    var selecteds = $("td.multiple :checked",$g);
    if(selecteds.length > 0){
        msgConfirm('系统消息','确定要删除这些URL吗？',function(){
            var _urlIds = [];
            selecteds.each(function(){
                var rows = $(this).parent().parent();
                /*id前面多了“rows”*/
                _urlIds.push(rows.attr('id').substr(4,32));
            });
            $.ajax({
                type:"post",
                url:"${ctx}/application/manager/urlmanager/batchdelete/${bizScenarioId}",
                data:{urlIds:_urlIds},
                success:function(data){
                    if(data){
                        selecteds.each(function(){
                            $(this).parent().parent().remove();
                        });
                        msgSuccess('系统消息','删除成功！')
                    }
                },
                error:function(){
                    msgAlert('系统消息','删除失败！')
                }
            });
        });
    }else{
        msgAlert('系统消息','没有选中的URL！<br />请选择要删除的URL后，继续操作。')
    };
}
function managerMethod(e){
    var rows = $(e).parent().parent();
    var id = rows.attr('id');
    /*id前面多了“rows”*/
    var urlId=id.substr(4,32);
    /*管理method页面*/
    window.location.href="${ctx}/application/manager/methodmanager/methodlist/${bizScenarioId}/"+urlId;
}
function editRow(e){
    var rows = $(e).parent().parent();
    var id = rows.attr('id');
    /*id前面多了“rows”*/
    var urlId=id.substr(4,32);
    /*编辑url页面*/
    window.location.href="${ctx}/application/manager/urlmanager/updateform/${bizScenarioId}/"+urlId;
}
function batchDel(){
	var $g = $("#thresholdList div.grid_view > table");
	var selecteds = $("td.multiple :checked",$g);
	if(selecteds.length > 0){
		msgConfirm('系统消息','确定要删除该条配置文件吗？',function(){
			var checks = [];
			selecteds.each(function(){
				var rows = $(this).parent().parent();
				checks.push(rows.attr('id'));
				rows.remove();
			});
			alert(checks);
			msgSuccess("系统消息", "操作成功，配置已删除！");
		});
	}else{
		msgAlert('系统消息','没有选中的文件！<br />请选择要删除的文件后，继续操作。')
	};
}
</script>
</head>

<body>
<div id="layout_top">
	<div class="header">
        <%@include file="/WEB-INF/layouts/menu.jsp"%>
    </div>
</div>
<div id="layout_center">
    <div class="main">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td style="vertical-align:top">
                    <div class="threshold_file">
                        <h2 class="title2"><b>业务场景名:${bizScenarioName}</b></h2>

                        <div class="tool_bar_top">
                            <a href="${ctx}/application/manager/urlmanager/createurl/${bizScenarioId}"
                               class="add_bus_scene">添加url</a>
                            <a href="javascript:void(0);" class="batch_del" onclick="urlBatchDel()">批量删除</a>
                        </div>
                        <div id="thresholdList"></div>
                        <div class="tool_bar"></div>
                    </div>
                </td>
                <td width="15">&nbsp;</td>
                <td width="33%" style="vertical-align:top">
                    <div class="conf_box help">
                        <div class="conf_title">
                            <div class="conf_title_r"></div>
                            <div class="conf_title_l"></div>
                            <span>帮助信息</span></div>
                        <div class="conf_cont_box">
                            <div class="conf_cont">
                                <ul>
                                    <li class="first"><b>新建应用系统监视器</b><br/>
                                        创建系统监视器后可根据业务需求配置业务场景。
                                    </li>
                                    <li class="first"><b>管理业务场景</b><br/>
                                        点击“管理业务场景”,可以增加新业务场景或管理已有业务场景。
                                    </li>
                                    <li class="first"><b>管理URL</b><br/>
                                        点击“管理URL”,对应业务场景将URL按流程顺序进行添加与监控配置。
                                    </li>
                                    <li class="the_set"><b>管理方法</b><br/>
                                        点击“管理方法”,对URL中所执行的方法按顺序进行添加与监控配置
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>
<div id="layout_bottom">
	<p class="footer">Copyright &copy; 2013 Sinosoft Co.,Lt</p>
</div>
</body>
</html>
