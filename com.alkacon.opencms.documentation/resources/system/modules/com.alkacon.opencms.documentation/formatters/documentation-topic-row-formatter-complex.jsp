<%@page buffer="none" session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="topicGrabber" class="com.alkacon.opencms.documentation.topics.TopicGrabber">
 <% topicGrabber.init(pageContext, request, response); %>
 </jsp:useBean>

<cms:formatter var="content" val="value" rdfa="rdfa">

<div>

	<c:set var="docuBranch"><cms:property name="opencms.documentation.branch" file="search"/></c:set>
	<c:if test="${not empty docuBranch}">
		<a href="https://github.com/alkacon/opencms-documentation/blob/${docuBranch}/com.alkacon.opencms.documentation.content/resources/${content.filename}" target="_blank" title="Edit topic row content on GitHub" class="glyphicon glyphicon-edit pull-right github-link"></a>
	</c:if>

	<c:if test="${not cms.element.settings.hidetitle}">
		<div class="headline"><h3 ${rdfa.Title}>${fn:escapeXml(value.Title)}</h3></div>
	</c:if>
	<c:if test="${not value.Description.isEmptyOrWhitespaceOnly}">
		<div class="topic-row-teaser">${value.Description}</div>
	</c:if>	
	<div class="row servive-block servive-block-documentation">
		<c:forEach var="item" items="${content.valueList.Item}" varStatus="itemStatus">
			<c:set var="accId" value="acc-${cms.element.id}-${itemStatus.index}" />
			<div class="${cms:lookup(fn:length(content.valueList.Item), '1:col-xs-12|2:col-sm-6|3:col-md-4')}">				
				<div class="tag-box tag-box-v2" style="height:100%;">
					<h4 ${item.rdfa.Headline}>${fn:escapeXml(item.value.Headline)}</h4>
					<div id="${accId}" class="panel-group acc-v1">
						<c:set var="isFirst" value="true" />
						<c:forEach var="topicItem" items="${item.valueList.Topic}" varStatus="tabStatus">
							<c:set var="tabId" value="tab-${cms.element.id}-${itemStatus.index}-${tabStatus.index}" />
							<c:set var="pageLink" value="${topicItem.value.PageLink}" />
							<c:set var="internal" value="${not empty pageLink.xmlText['link/uuid']}" /> <%-- HACK: Determine internal by present uuid. --%>
							<c:set var="topic" value="${topicGrabber.topicContent[pageLink]}" />
							<c:set var="hasTeaser" value="${(not topicItem.value.AltTeaser.isEmptyOrWhitespaceOnly) or (internal && (not empty topic) && topic.value.Teaser.isSet)}" />
							<c:set var="startOpen">
								${(hasTeaser and cms.element.settings['showteaser'] and isFirst)?"in":""}
							</c:set>
							<div class="panel panel-default">
								<div class="panel-heading">
									<h4 class="panel-title panel-title-documentation">
										<c:if test="${hasTeaser}">
											<a style="float:right;" class="accordion-toggle collapsed" 
											   href="#${tabId}" 
											   data-parent="#${accId}" 
											   data-toggle="collapse"
											   title="Show topic teaser"> 
												<span class="glyphicon glyphicon-plus"></span>
											</a>
										</c:if>
										<a href="<cms:link>${pageLink}</cms:link>">${topicItem.value.AltHeading.isEmptyOrWhitespaceOnly ? (internal ? fn:escapeXml(cms.vfs.property[pageLink]["Title"]) : pageLink ) : fn:escapeXml(topicItem.value.AltHeading)}</a>
									</h4>
								</div>
								<div id="${tabId}" class="panel-collapse collapse ${startOpen}">
									<div class="panel-body panel-body-documentation">
										<a href="<cms:link>${pageLink}</cms:link>" title="Go to the topic">
										<c:choose>
										<c:when test="${hasTeaser}">
											${topicItem.value.AltTeaser.isEmptyOrWhitespaceOnly ? topic.value.Teaser : topicItem.value.AltTeaser}
										</c:when>
										<c:otherwise>
											<em>No teaser available</em>
										</c:otherwise>
										</c:choose>
										</a>
									</div>
								</div>
							</div>
							<c:set var="isFirst" value="false" />
						</c:forEach>
					</div>
				</div>
			</div>
		</c:forEach>	
	</div>

</div>

</cms:formatter>
