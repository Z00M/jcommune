<%--

    Copyright (C) 2011  JTalks.org Team
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.
    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="jtalks" uri="http://www.jtalks.org/tags" %>
<head>
    <title><c:out value="${topic.title}"/></title>
    <script src="${pageContext.request.contextPath}/resources/javascript/custom/utils.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/resources/javascript/custom/subscription.js"
            type="text/javascript"></script>
</head>
<body>
<div class="wrap topic_page">
<jsp:include page="../template/topLine.jsp"/>
<jsp:include page="../template/logo.jsp"/>
<c:set var="authenticated" value="${false}"/>
<div class="all_forums">
    <h2><a class="heading" href="#"><c:out value="${topic.title}"/></a></h2>
<span class="nav_bottom">
    <c:if test="${previousTopic != null}">
        <a href="${pageContext.request.contextPath}/topics/${previousTopic.id}">
            <spring:message code="label.topic.previous"/>
        </a>
    </c:if>
    &nbsp;
    <c:if test="${nextTopic != null}">
        <a href="${pageContext.request.contextPath}/topics/${nextTopic.id}">
            <spring:message code="label.topic.next"/>
        </a>
    </c:if>
</span>

    <br>
    <jtalks:pagination uri="${topicId}" pagination="${pag}" list="${posts}">
    <nobr>
            <span class="nav_top">
                </jtalks:pagination>
            </span>
    </nobr>
    <a class="button top_button" href="${pageContext.request.contextPath}/branches/${branchId}">
        <spring:message code="label.back"/>
    </a>
    <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
        <c:choose>
            <c:when test="${subscribed}">
                <a id="subscription" class="button top_button"
                   href="${pageContext.request.contextPath}/topics/${topic.id}/unsubscribe">
                    <spring:message code="label.unsubscribe"/>
                </a>
            </c:when>
            <c:otherwise>
                <a id="subscription" class="button top_button"
                   href="${pageContext.request.contextPath}/topics/${topic.id}/subscribe">
                    <spring:message code="label.subscribe"/>
                </a>
            </c:otherwise>
        </c:choose>
        <a class="button top_button" href="${pageContext.request.contextPath}/topics/new?branchId=${branchId}">
            <spring:message code="label.topic.new_topic"/></a>
        <a class="button top_button" href="${pageContext.request.contextPath}/posts/new?topicId=${topicId}">
            <spring:message code="label.answer"/></a>
        <c:set var="authenticated" value="${true}"/>
    </sec:authorize>
    &nbsp; &nbsp; &nbsp;

    <jtalks:breadcrumb breadcrumbList="${breadcrumbList}"/>
    <br>

    <div class="forum_header_table">
        <div class="forum_header">
            <span class="forum_header_userinfo"><spring:message code="label.topic.header.author"/></span>
            <span class="forum_header_topic"><spring:message code="label.topic.header.message"/></span>
        </div>
    </div>
    <ul class="forum_table">
        <jtalks:pagination uri="${topicId}" pagination="${pag}" list="${posts}">
        <c:forEach var="post" items="${list}" varStatus="i">
            <li class="forum_row">
                <div class="forum_userinfo">
                    <a class="username"
                       href="${pageContext.request.contextPath}/users/${post.userCreated.encodedUsername}">
                        <c:out value="${post.userCreated.username}"/>
                    </a>
                    <div class="status">
                        <spring:message var="online" code="label.topic.online_users"/>
                        <spring:message var="offline" code="label.topic.offline_users"/>
                        <jtalks:ifContains collection="${usersOnline}" object="${post.userCreated}"
                                           successMessage="${online}" failMessage="${offline}"/>
                    </div>
                    <img src="${pageContext.request.contextPath}/${post.userCreated.encodedUsername}/avatar"
                         class="avatar"/>
                    <br/>

                    <div class="user_misc_info">
                        <span class="status"><spring:message code="label.topic.registered"/></span>
                        <jtalks:format pattern="dd.MM.yy" value="${post.userCreated.registrationDate}"/><br/>
                        <span class="status"><spring:message code="label.topic.message_count"/></span>
                        ${post.userCreated.postCount}<br/>
                        <c:if test="${post.userCreated.location != null}">
                            <span class="status"><spring:message code="label.topic.from_whence"/></span>
                            ${post.userCreated.location}
                        </c:if>
                    </div>
                </div>
                <div class="forum_message_cell">
                    <div class="post_details">
                        <a class="button" href="#">&#8657;</a>
                        <a class="button postLink" rel="${post.id}">
                            <spring:message code="label.link"/>
                        </a>
                        <sec:accesscontrollist hasPermission="8,16" domainObject="${post}">
                            <c:choose>
                                <c:when test="${pag.page == 1 && i.index == 0}">
                                    <%-- first post - urls to delete & edit topic --%>
                                    <c:set var="delete_url"
                                           value="${pageContext.request.contextPath}/topics/${topic.id}"/>
                                    <%--todo: page settings for edit url? WTF?--%>
                                    <c:set var="edit_url"
                                           value="${pageContext.request.contextPath}/topics/${topic.id}/edit?branchId=${branchId}&page=${pag.page}"/>
                                    <c:set var="confirm_message" value="label.deleteTopicConfirmation"/>
                                </c:when>
                                <c:otherwise>
                                    <%-- url to delete & edit post --%>
                                    <c:set var="delete_url"
                                           value="${pageContext.request.contextPath}/posts/${post.id}"/>
                                    <c:set var="edit_url"
                                           value="${pageContext.request.contextPath}/posts/${post.id}/edit?topicId=${topic.id}&page=${pag.page}"/>
                                    <c:set var="confirm_message" value="label.deletePostConfirmation"/>
                                </c:otherwise>
                            </c:choose>
                            <a class="button delete" href="${delete_url}"
                               rel="<spring:message code="${confirm_message}"/>">
                                <spring:message code="label.delete"/>
                            </a>
                            <a class="button" href="${edit_url}"><spring:message code="label.edit"/></a>
                        </sec:accesscontrollist>
                        <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
                            <a class="button" href="javascript:
                                document.getElementById('selection${post.id}').value = getSelectedText(${post.id});
                                document.forms['quoteForm${post.id}'].submit();">
                                <spring:message code="label.quotation"/>
                            </a>

                            <form action="${pageContext.request.contextPath}/posts/${post.id}/quote"
                                  method="post" id='quoteForm${post.id}'>
                                <input name='selection' id='selection${post.id}' type='hidden'/>
                            </form>
                        </sec:authorize>
                        <a name="${post.id}" href="#${post.id}">
                            <spring:message code="label.added"/>&nbsp;
                            <jtalks:format value="${post.creationDate}"/>
                        </a>
                    </div>
                    <div class="forum_message_cell_text">
                        <jtalks:bb2html bbCode="${post.postContent}"/>
                        <br/><br/><br/>
                        <c:if test="${post.modificationDate!=null}">
                            <spring:message code="label.modify"/>
                            <jtalks:format value="${post.modificationDate}"/>
                        </c:if>
                    </div>
                    <c:if test="${post.userCreated.signature!=null}">
                        <div class="signature">
                            -------------------------
                            <br/>
                            <span><c:out value="${post.userCreated.signature}"/></span>
                        </div>
                    </c:if>
                </div>
            </li>
        </c:forEach>
    </ul>
    <nobr><span class="nav_bottom">
        </jtalks:pagination>
    </span></nobr>

    <a class="button" href="${pageContext.request.contextPath}/branches/${branchId}">
        <spring:message code="label.back"/>
    </a>
    <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
        <a class="button top_button" href="${pageContext.request.contextPath}/topics/new?branchId=${branchId}">
            <spring:message code="label.topic.new_topic"/></a>
        <a class="button top_button" href="${pageContext.request.contextPath}/posts/new?topicId=${topic.id}">
            <spring:message code="label.answer"/></a>
        <c:set var="authenticated" value="${true}"/>
    </sec:authorize>
    <c:if test="${pag.maxPages>1}">
        <c:if test="${pag.pagingEnabled==true}">
            <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
                <a class="button" href="?pagingEnabled=false"><spring:message code="label.showAll"/></a>
                &nbsp; &nbsp; &nbsp;
            </sec:authorize>
        </c:if>
    </c:if>
    <c:if test="${pag.pagingEnabled == false}">
        <sec:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
            <a class="button" href="?pagingEnabled=true"><spring:message code="label.showPages"/></a>
            &nbsp; &nbsp; &nbsp;
        </sec:authorize>
    </c:if>

    &nbsp; &nbsp; &nbsp;

    <jtalks:breadcrumb breadcrumbList="${breadcrumbList}"/>
    <div class="forum_misc_info">

        <br/>
        <spring:message code="label.topic.moderators"/>
        <ul class="users_list">
            <li><a href="#">andreyko</a>,</li>
            <li><a href="#">Староверъ</a>,</li>
            <li><a href="#">Вася</a>.</li>
        </ul>
        <br/>
        <c:if test="${!(empty viewList)}">
            <spring:message code="label.topic.now_browsing"/>
        </c:if>
        <c:forEach var="innerUser" items="${viewList}">
            <a href="${pageContext.request.contextPath}/users/${innerUser.encodedUsername}">
                <c:out value="${innerUser.username}"/>
            </a>
            &nbsp;&nbsp;
        </c:forEach>
        <%--Fake form to delete posts and topics.
Without it we're likely to get lots of problems simulating HTTP DELETE via JS in a String fashion  --%>
        <form:form id="deleteForm" method="DELETE"/>
    </div>
</div>
<div class="footer_buffer"></div>
</div>
</body>