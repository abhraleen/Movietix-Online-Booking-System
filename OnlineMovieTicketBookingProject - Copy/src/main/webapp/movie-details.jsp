<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    if (id == null || id.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/home");
    } else {
        response.sendRedirect(request.getContextPath() + "/movie?id=" + id.trim());
    }
%>
