package net.itaem.article.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.itaem.article.entity.Article;
import net.itaem.article.entity.ArticleAndType;
import net.itaem.article.entity.ArticleType;
import net.itaem.article.service.IArticleService;
import net.itaem.article.service.IArticleTypeService;
import net.itaem.base.controller.BaseController;
import net.itaem.user.entity.User;
import net.itaem.util.DateUtil;
import net.itaem.util.JsonUtil;
import net.itaem.util.UUIDUtil;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 添加文章
 * */
@Controller
public class ArticleAddController extends BaseController {

	@Autowired
	IArticleService articleService;
	@Autowired
	IArticleTypeService articleTypeService;

	/**
	 * 跳转到添加文章界面
	 * */
	@RequestMapping("/article/add.do")
	public String add(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		List<ArticleType> articleTypeList = articleTypeService.listAll();
		StringBuilder sb = new StringBuilder();
		int i=0;
		sb.append("<tr>");
		for(ArticleType type: articleTypeList){
			String str = "<td><input id='hk_tag_' name='typeId' type='checkbox' value='"+type.getId()+"'>"
					+ "<label for='chk_tag_'>"+type.getName()+"</label></td>";
			sb.append(str);
			i++;
			if(i % 6 == 0 && i != articleTypeList.size()){
				sb.append("</tr>");
				sb.append("<tr>");
			}
		}
		sb.append("</tr>");
		req.setAttribute("typeList", sb.toString());

		return "article/add";
	}

	/**
	 * 移动端列出用户的日志类别
	 * */
	@RequestMapping("/article/addByAndroid.do")
	public void addByAndroid(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		User user = super.getLoginUser(req);
		if(user == null){
			println(resp, JsonUtil.createJson("error", "请登录"));
			return;
		}

		String userId = super.getLoginUser(req).getId();
		List<ArticleType> articleTypeList = articleTypeService.listByUserId(userId);
		StringBuilder sb = new StringBuilder();
		int i=0;
		sb.append("<tr>");
		for(ArticleType type: articleTypeList){
			String str = "<td><input id='hk_tag_' name='typeId' type='checkbox' value='"+type.getId()+"'>"
					+ "<label for='chk_tag_'>"+type.getName()+"</label></td>";
			sb.append(str);
			i++;
			if(i % 6 == 0 && i != articleTypeList.size()){
				sb.append("</tr>");
				sb.append("<tr>");
			}
		}
		sb.append("</tr>");
		req.setAttribute("typeList", sb.toString());
		req.getRequestDispatcher("/kindeditor/jsp/index.jsp").forward(req, resp);
	}

	/**
	 * 添加成功，重定向到该文章详情界面
	 * */
	@RequestMapping("/article/addSubmit.do")
	public void addSubmit(HttpServletRequest req, HttpServletResponse resp, Article article) throws ServletException, IOException{
		User user = super.getLoginUser(req);

		article.setUserId(user.getId());
		article.setId(UUIDUtil.uuid());
		String name = super.getLoginUserName(req, null);
		article.setCreator(name);
		article.setCreatedTime(DateUtil.getNowDate(null));

		//设置多对多关系
		List<ArticleAndType> aatList = new ArrayList<ArticleAndType>();
		String[] types = req.getParameterValues("typeId");

		if(types != null){
			for(String type: types){
				aatList.add(new ArticleAndType(UUIDUtil.uuid(), article.getId(), type));
			}
			article.setArticleAndTypeList(aatList);
		}

		System.out.println("-->" + article.getArticleAndTypeList());
		articleService.add(article);

		req.setAttribute("content", article.getContent());
		req.setAttribute("title", article.getTitle());

		resp.sendRedirect(super.getBaseURL(req) + "/article/front/detail.do?id=" + article.getId());
	}

	/**
	 * 
	 * */
	@RequestMapping("/article/addSubmitByAndroid.do")
	public void addSubmitByAndroid(HttpServletRequest req, HttpServletResponse resp, Article article) throws ServletException, IOException{
		article.setId(UUIDUtil.uuid());

		article.setCreatedTime(DateUtil.getNowDate(null));

		//设置多对多关系
		List<ArticleAndType> aatList = new ArrayList<ArticleAndType>();
		String[] types = req.getParameterValues("typeId");

		if(types != null){
			for(String type: types){
				aatList.add(new ArticleAndType(UUIDUtil.uuid(), article.getId(), type));
			}
			article.setArticleAndTypeList(aatList);
		}

		articleService.add(article);
		JSONObject json = new JSONObject();
		json.put("status", "success");
		json.put("id", article.getId());

		println(resp, json.toString());
	}
}
