/**
 * Marmoset: a student project snapshot, submission, testing and code review
 * system developed by the Univ. of Maryland, College Park
 * 
 * Developed as part of Jaime Spacco's Ph.D. thesis work, continuing effort led
 * by William Pugh. See http://marmoset.cs.umd.edu/
 * 
 * Copyright 2005 - 2011, Univ. of Maryland
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 * 
 */

package edu.umd.cs.submitServer.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.umd.cs.marmoset.modelClasses.CodeReviewAssignment;
import edu.umd.cs.marmoset.modelClasses.CodeReviewAssignment.Kind;
import edu.umd.cs.marmoset.modelClasses.CodeReviewer;

public class UnassignCodeReview extends SubmitServerServlet {

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		CodeReviewAssignment assignment = (CodeReviewAssignment) request
				.getAttribute(CODE_REVIEW_ASSIGNMENT);

		boolean canRevert = (Boolean) request
				.getAttribute("canRevertCodeReview");
		if (!canRevert)
			throw new IllegalArgumentException(
					"Can't review code reviewers for assignment "
							+ assignment.getCodeReviewAssignmentPK());

		Connection conn = null;
		boolean transactionSuccess = false;
		try {
			conn = getConnection();
			conn.setAutoCommit(false);
			conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

			CodeReviewer.deleteInactiveReviewers(conn, assignment);
			switch (assignment.getKind()) {
			case INSTRUCTIONAL_BY_SECTION:
			case INSTRUCTIONAL:
				assignment.setKind(Kind.INSTRUCTIONAL_PROTOTYPE);
				break;
			case PEER:
			case PEER_BY_SECTION:
				assignment.setKind(Kind.PEER_PROTOTYPE);
				break;
			case EXEMPLAR:
				break;
			}
			assignment.update(conn);
			
			conn.commit();
			transactionSuccess = true;
			String redirectUrl = request.getContextPath()
					+ "/view/instructor/codeReviewAssignment.jsp?codeReviewAssignmentPK="
					+ assignment.getCodeReviewAssignmentPK();

			response.sendRedirect(redirectUrl);
		} catch (SQLException e) {
			handleSQLException(e);
			throw new ServletException(e);
		} finally {
			rollbackIfUnsuccessfulAndAlwaysReleaseConnection(
					transactionSuccess, request, conn);
		}
	}

}
