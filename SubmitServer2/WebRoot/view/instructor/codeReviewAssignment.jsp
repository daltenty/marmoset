<%--

 Marmoset: a student project snapshot, submission, testing and code review
 system developed by the Univ. of Maryland, College Park
 
 Developed as part of Jaime Spacco's Ph.D. thesis work, continuing effort led
 by William Pugh. See http://marmoset.cs.umd.edu/
 
 Copyright 2005 - 2011, Univ. of Maryland
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may not
 use this file except in compliance with the License. You may obtain a copy of
 the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations under
 the License.

--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ss" uri="http://www.cs.umd.edu/marmoset/ss"%>


<!DOCTYPE HTML>
<html>

<ss:head title="Code review for Project ${project.fullTitle}" />

<body>
	<ss:header />
	<ss:instructorBreadCrumb />

	<div class="sectionTitle">
		<h2>
			<c:out value="${codeReviewAssignment.kind.description}" />
			for project
			<c:out value="${project.fullTitle}" />
		</h2>
		<p>
			<c:out value="${codeReviewAssignment.description}" />
        <p>
			Due
			<fmt:formatDate value="${codeReviewAssignment.deadline}"
				pattern="dd MMM, hh:mm a" />
				<c:if test="${codeReviewAssignment.byStudents}">
					<c:choose>
				<c:when test="${codeReviewAssignment.anonymous}">
					<p>Student identities are anonymous
				</c:when>
				<c:otherwise>
					<p>Student identities are shown
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${codeReviewAssignment.otherReviewsVisible}">
					<p>Reviewers can see comments from other reviewers
				</c:when>
				<c:otherwise>
					<p>Comments from other reviewers are hidden
				</c:otherwise>
			</c:choose>
			</c:if>
	</div>



	<c:url var="changeCodeReviewAssignmentVisibilityLink"
		value="/action/instructor/ChangeCodeReviewAssignmentVisibility" />

	<c:choose>
		<c:when test="${codeReviewAssignment.prototype}">
			<h2>Prototype code review</h2>
			<ul>

				<c:url var="editAssignment"
					value="/view/instructor/createCodeReviewAssignment.jsp">
					<c:param name="codeReviewAssignmentPK">${codeReviewAssignment.codeReviewAssignmentPK}</c:param>
				</c:url>
				<li><a href="${editAssignment}">Edit assignment</a></li>

				<c:url value="/action/instructor/AddSampleCodeReview"
					var="addSampleCodeReviewAction" />

				<c:choose>
					<c:when
						test="${hasOtherStaffSubmissions && !codeReviewAssignment.byStudents}">
						<li><form action="${addSampleCodeReviewAction}" method="POST"
								id="add-sample-code-review">
								<input type="hidden" name="coursePK" value="${course.coursePK}" />
								<input type="hidden" name="projectPK"
									value="${project.projectPK}" /> <input type="hidden"
									name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" /> Add
								sample review of submission by <select name="of-instructional"
									id="exemplar-submission-instructional">
									<c:forEach var="studentRegistration"
										items="${staffStudentSubmissions}">
										<c:if
											test="${studentRegistration.studentPK != user.studentPK || studentRegistration.pseudoStudent }">
											<option
												value="${lastSubmission[studentRegistration.studentRegistrationPK].submissionPK}">
												<c:out value="${studentRegistration.fullname}" />
											</option>
										</c:if>
									</c:forEach>
								</select><input type="submit" value="do it" />
							</form>
					</c:when>
					<c:when test="${codeReviewAssignment.byStudents}">
						<li><form action="${addSampleCodeReviewAction}" method="POST"
								id="add-sample-code-review">
								<input type="hidden" name="coursePK" value="${course.coursePK}" />
								<input type="hidden" name="projectPK"
									value="${project.projectPK}" /> <input type="hidden"
									name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" /> Add
								sample review of submission by <select name="of-peer"
									id="exemplar-submission-peer">
									<c:forEach var="studentRegistration"
										items="${staffStudentSubmissions}">
										<c:if
											test="${studentRegistration.studentPK != pseudoStudentRegistration.studentPK}">

											<option
												value="${lastSubmission[studentRegistration.studentRegistrationPK].submissionPK}">
												<c:out value="${studentRegistration.fullname}" />
											</option>
										</c:if>
									</c:forEach>

								</select><input type="submit" value="do it" />
							</form>
					</c:when>
				</c:choose>

				<c:url var="assignReviews"
					value="/view/instructor/assignCodeReviews.jsp">
					<c:param name="codeReviewAssignmentPK">${codeReviewAssignment.codeReviewAssignmentPK}</c:param>
				</c:url>
				<li><a href="${assignReviews}">Assign reviews</a></li>

				<c:url var="deleteAssignment"
					value="/action/instructor/DeleteCodeReview" />
				<li><form action="${deleteAssignment}" method="post"
						name="deleteAssignmentForm">
						<input type="hidden" name="codeReviewAssignmentPK"
							value="${codeReviewAssignment.codeReviewAssignmentPK}" /> Delete
						code review<input type="submit" value="do it">
					</form></li>
			</ul>
		</c:when>

		<c:when test="${canRevertCodeReview}">
		<c:choose>
		<c:when test="${!codeReviewAssignment.visibleToStudents}">
		<h2>Code review created but not visible to students</h2>
		</c:when>
		<c:otherwise>
		<h2>Code review assigned and visible, but not started</h2>
		</c:otherwise>
		</c:choose>
			
			<ul>
				<c:url var="unassignReviews"
					value="/action/instructor/UnassignCodeReview" />

				<li><form method="POST" action="${unassignReviews}">
						<input type="hidden" name="codeReviewAssignmentPK"
							value="${codeReviewAssignment.codeReviewAssignmentPK}" /> <input
							type="submit" value="Revert to prototype review" />
					</form></li>

				<c:choose>
					<c:when test="${codeReviewAssignment.visibleToStudents}">
						<li><form method="post"
								action="${changeCodeReviewAssignmentVisibilityLink}">
								<input type="hidden" name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" />
								Currently visible to students. <input type="hidden"
									name="visibleToStudents" value="false" /> <input type="submit"
									value="Make Invisible" style="color: #003399" />
							</form>
					</c:when>
					<c:otherwise>
						<li><form method="post"
								action="${changeCodeReviewAssignmentVisibilityLink}">
								<input type="hidden" name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" />
								Currently invisible to students. <!- XXX1 -> <input type="hidden"
									name="visibleToStudents" value="true" /> <input type="submit"
									value="Make Visible" style="color: #003399" />
							</form>
					</c:otherwise>
				</c:choose>
			</ul>
		</c:when>
		<c:otherwise>
			<h2>Code review started</h2>
			<ul>
				<c:choose>
					<c:when test="${!codeReviewAssignment.visibleToStudents}">
						<li><form method="post"
								action="${changeCodeReviewAssignmentVisibilityLink}">
								<input type="hidden" name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" />
								Currently invisible to students. <!-- XXX2 --> <input type="hidden"
									name="visibleToStudents" value="true" /> <input type="submit"
									value="Make Visible" style="color: #003399" />
							</form>
					</c:when>
					<c:otherwise>
						<li><form method="post"
								action="${changeCodeReviewAssignmentVisibilityLink}">
								<input type="hidden" name="codeReviewAssignmentPK"
									value="${codeReviewAssignment.codeReviewAssignmentPK}" />
								Currently visible to students. <input type="hidden"
									name="visibleToStudents" value="false" /> <input type="submit"
									value="Make Invisible" style="color: #003399" />
							</form>
					</c:otherwise>
				</c:choose>
				<c:url var="PrintCodeReviewAssignmentGrades"
					value="/data/instructor/PrintCodeReviewAssignmentGrades">
					<c:param name="codeReviewAssignmentPK"
						value="${codeReviewAssignment.codeReviewAssignmentPK}" />
				</c:url>
				<li><a href="${PrintCodeReviewAssignmentGrades}">Print code
						review assignment grades</a></li>

				<c:if test="${! empty rubrics }">
					<c:url var="PrintRubricEvaluationsForDatabase"
						value="/data/instructor/PrintRubricEvaluationsForDatabase">
						<c:param name="codeReviewAssignmentPK"
							value="${codeReviewAssignment.codeReviewAssignmentPK}" />
					</c:url>
					<c:url var="PrintRubricsForDatabase"
						value="/data/instructor/PrintRubricsForDatabase">
						<c:param name="codeReviewAssignmentPK"
							value="${codeReviewAssignment.codeReviewAssignmentPK}" />
					</c:url>


					<li><a href="${PrintRubricsForDatabase}">List rubrics in
							CSV format for upload to grades server</a>
					<li><a href="${PrintRubricEvaluationsForDatabase}">List
							rubric evaluations in CSV format for upload to grades server</a></li>
				</c:if>
				<li><c:url var="removeCodeReviewers"
						value="/action/instructor/RemoveCodeReviewers" />
					<form action="${reviewCodeReviewers}" method="post"
						name="removeCodeReviewersForm">
						<input type="hidden" name="codeReviewAssignmentPK"
							value="${codeReviewAssignment.codeReviewAssignmentPK}" /> Remove
						reviewers with no comments <input type="submit" value="Do it">
					</form></li>
			</ul>
		</c:otherwise>
	</c:choose>

	<c:if test="${! empty rubrics }">
		<h2>Rubrics</h2>
		<ul>
			<c:forEach var="rubric" items="${rubrics}">
				<li><c:choose>
						<c:when test="${rubric.presentation == 'NUMERIC' }">
							<input type="number" size="2" readonly="readonly">
						</c:when>
						<c:when test="${rubric.presentation == 'CHECKBOX' }">
							<input type="checkbox" checked="checked" readonly="readonly">
						</c:when>
						<c:when test="${rubric.presentation == 'DROPDOWN' }">
							<select name="r">
								<c:forEach var="data" items="${rubric.dataAsMap}">
									<option>
										<c:out value="${data.key}" />
										[
										<c:out value="${data.value}" />
										]
									</option>
								</c:forEach>
							</select>
						</c:when>
					</c:choose> <c:out value="${rubric.name}" /> <c:if
						test="${not empty rubric.description}">: <c:out
							value="${rubric.description}" />
					</c:if>
			</c:forEach>
		</ul>
	</c:if>
	<c:set var="showComments"
		value="${!canRevertCodeReview && codeReviewAssignment.visibleToStudents}" />

	<c:if test="${not empty submissionsUnderReview }">
		<h2>
			<a href="javascript:toggle('submissionList')"
				title="Click to toggle display of submissions" id="submissions">
				<c:out value="${fn:length(submissionsUnderReview)}" /> Submissions
				being reviewed
			</a>
		</h2>

		<c:set var="initialStyle" value="display: none" />
		<c:if test="${fn:length(submissionsUnderReview) < 4}">
			<c:set var="initialStyle" value="display: inline" />
		</c:if>
		<div id="submissionList" style="${initialStyle}">

			<c:set var="cols" value="2" />
			<c:if test="${not empty rubrics}">
				<c:set var="cols" value="3" />
			</c:if>
			<c:set var="evaluations" value="" />
			<table>
				<tr>
					<th>Code Author <c:if test="${showComments}">
							<th>Response<br>needed
							</th>
						</c:if> <c:if test="${not empty sections}">
							<th>Section</th>
						</c:if>
					<th>Reviewer <c:if test="${showComments}">
							<th colspan="${cols}">comments</th>
							<th>response<br>needed
							</th>
						</c:if>
				</tr>
				<c:forEach var="submission" items="${submissionsUnderReview}"
					varStatus="counter">


					<c:url var="viewCodeReview" value="/view/codeReview/index.jsp">
						<c:param name="submissionPK" value="${submission.submissionPK}" />
					</c:url>

					<c:choose>
						<c:when test="${project.tested}">
							<c:url var="submissionLink"
								value="/view/instructor/submission.jsp">
								<c:param name="submissionPK" value="${submission.submissionPK}" />
							</c:url>
						</c:when>
						<c:otherwise>
							<c:url var="submissionLink" value="/view/allSourceCode.jsp">
								<c:param name="submissionPK" value="${submission.submissionPK}" />
							</c:url>
						</c:otherwise>
					</c:choose>

					<c:set var="studentRegistration"
						value="${studentRegistrationMap[submission.studentRegistrationPK]}" />
					<c:set var="reviewers"
						value="${reviewersForSubmission[submission.submissionPK]}" />
					<c:set var="author"
						value="${authorForSubmission[submission.submissionPK]}" />
					<c:set var="authorSummary" value="${codeReviewSummary[author]}" />

					<c:set var="status" value="${codeReviewStatus[submission]}" />
					<c:choose>
						<c:when test="${!showComments || status == 'NOT_STARTED'}">
							<tr class="r${counter.index % 2}">
								<td rowspan="${fn:length(reviewers)}"><a
									href="${viewCodeReview}" target="codeReview"
									title="code review"> <c:out
											value="${studentRegistration.fullname}" />
								</a> <c:if test="${showComments}">
										<br>
										<a href="${submissionLink}" title="test results"><c:out
												value="${submission.testSummary}" /></a>
									</c:if></td>

								<c:if test="${showComments}">
									<td rowspan="${fn:length(reviewers)}"><c:if
											test="${authorSummary.needsResponse}">yes</c:if></td>
								</c:if>


								<c:if test="${not empty sections}">
									<td rowspan="${fn:length(reviewers)}"><c:out
											value="${studentRegistration.section}" /></td>
								</c:if>

								<c:forEach var="codeReviewer" items="${reviewers}"
									varStatus="counter2">

									<c:if test="${counter2.index > 0}">
										<tr class="r${counter.index % 2}">
									</c:if>
									<td><c:out value="${codeReviewer.nameForInstructor}" /></td>
									<c:if test="${showComments && counter2.index == 0}">
										<td colspan="${cols+1}" rowspan="${fn:length(reviewers)}" />
									</c:if>
								</c:forEach>
						</c:when>


						<c:otherwise>
							<tr class="r${counter.index % 2}">
								<td rowspan="${fn:length(reviewers)}"><a
									href="${viewCodeReview}" target="codeReview"
									title="code review"> <c:out
											value="${studentRegistration.fullname}" />
								</a> <br> <a href="${submissionLink}" title="test results"><c:out
											value="${submission.testSummary}" /></a></td>
								<td rowspan="${fn:length(reviewers)}"><c:if
										test="${authorSummary.needsResponse}">yes</c:if> <c:if
										test="${not empty sections}">
										<td rowspan="${fn:length(reviewers)}"><c:out
												value="${studentRegistration.section}" /></td>
									</c:if> <c:forEach var="codeReviewer" items="${reviewers}"
										varStatus="counter2">

										<c:set var="summary"
											value="${codeReviewSummary[codeReviewer]}" />
										<c:if test="${counter2.index > 0}">
											<tr class="r${counter.index % 2}">
										</c:if>
										<td><c:out value="${codeReviewer.nameForInstructor}" /></td>
										<c:if test="${! empty rubrics}">
											<c:set var="evaluations"
												value="${ss:evaluationsForReviewer(codeReviewer, connection)}" />
										</c:if>

										<c:choose>
											<c:when test="${status == 'NOT_STARTED'}">
												<td>
											</c:when>
											<c:when
												test="${codeReviewer.numComments > 0 || ! empty evaluations}">
												<td><c:out value="${codeReviewer.numComments}" /></td>
												<td><fmt:formatDate value="${codeReviewer.lastUpdate}"
														pattern="dd MMM, hh:mm a" /></td>

												<c:if test="${! empty rubrics}">
													<td class="description"><c:forEach var="e"
															items="${evaluations}">
															<c:if test="${e.status == 'LIVE' }">
																<c:set var="r" value="${rubricMap[e.rubricPK]}" />
																<c:out value="${e.value}" />
																<c:out value="${r.name}" />.
   													<c:out value="${e.explanation}" />
																<br>
															</c:if>
														</c:forEach></td>
												</c:if>
												<td><c:if test="${summary.needsResponse}">yes</c:if>
											</c:when>
											<c:otherwise>
												<td colspan="${cols+1}" />
											</c:otherwise>
										</c:choose>
									</c:forEach>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</table>
		</div>

		<h2>
			<a href="javascript:toggle('reviewersList')"
				title="Click to toggle display of reviewers" id="reviewers"> <c:out
					value="${fn:length(reviewsByStudent)}" /> Reviewers
			</a>
		</h2>
		<c:set var="initialStyle" value="display: none" />
		<c:if test="${fn:length(reviewsByStudent) < 4}">
			<c:set var="initialStyle" value="display: inline" />
		</c:if>
		<div id="reviewersList" style="${initialStyle}">

			<table>
				<tr>
					<th>Reviewer
					<th>Author <c:if test="${showComments}">
							<th>Comments
							<th>Last update</th>
							<th>Response<br>needed
							</th>
						</c:if>
				</tr>
				<c:forEach var="entry" items="${reviewsByStudent}"
					varStatus="counter">
					<c:set var="student" value="${entry.key}" />
					<c:set var="reviews" value="${entry.value}" />
					<tr class="r${counter.index % 2}">
						<td rowspan="${fn:length(reviews)}"><c:out
								value="${student.fullname}" /></td>

						<c:forEach var="review" items="${reviews}" varStatus="counter2">
							<c:set var="submission" value="${review.submission}" />
							<c:set var="author"
								value="${authorForSubmission[submission.submissionPK]}" />
							<c:set var="status" value="${codeReviewStatus[submission]}" />
							<c:set var="summary" value="${codeReviewSummary[review]}" />

							<c:url var="viewCodeReview" value="/view/codeReview/index.jsp">
								<c:param name="submissionPK" value="${submission.submissionPK}" />
							</c:url>

							<c:if test="${counter2.index > 0}">
								<tr class="r${counter.index % 2}">
							</c:if>

							<td><a href="${viewCodeReview}"><c:out
										value="${author.student.fullname}" /></a> <c:choose>
									<c:when test="${!showComments}" />
									<c:when test="${review.numComments > 0}">
										<td><c:out value="${review.numComments}" /></td>
										<td><fmt:formatDate value="${review.lastUpdate}"
												pattern="dd MMM, hh:mm a" /></td>
										<td><c:if test="${summary.needsResponse}">yes</c:if>
									</c:when>
									<c:otherwise>
										<td colspan="3" />
									</c:otherwise>
								</c:choose>
						</c:forEach>
				</c:forEach>
			</table>
		</div>
	</c:if>

	<ss:footer />
</body>
</html>
