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

/*
 * Created on Jun 8, 2005
 */
package edu.umd.cs.submitServer.filters;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.CheckForNull;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.umd.cs.marmoset.modelClasses.BuildServer;
import edu.umd.cs.marmoset.modelClasses.Course;
import edu.umd.cs.marmoset.modelClasses.Project;
import edu.umd.cs.marmoset.utilities.SystemInfo;
import edu.umd.cs.submitServer.WebConfigProperties;

public class CourseStatusFilter extends SubmitServerFilter {

    private static final WebConfigProperties webProperties = WebConfigProperties.get();
    
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) resp;
		Course course = (Course) request.getAttribute("course");
		Map<Project,Map<String,Integer>> buildStatusCount = new HashMap<Project,Map<String,Integer>>();
        List<Project> projectList = (List<Project>) request.getAttribute(PROJECT_LIST);
        @CheckForNull String universalBuilderserverKey = webProperties.getProperty("buildserver.password.universal");
        
        
		Connection conn = null;
		try {
			conn = getConnection();
			
			Collection<BuildServer> buildServers = BuildServer.getAll(course, universalBuilderserverKey, conn);
			request.setAttribute("buildServers", buildServers);
			request.setAttribute("systemLoad", SystemInfo.getSystemLoad());
			List<Project> hiddenProjects = Project.lookupAllByCoursePK(course.getCoursePK(), true, conn);
			request.setAttribute("hiddenProjects", hiddenProjects);
			for(Project p : projectList) {
                buildStatusCount.put(p, p.getBuildStatusCount(conn));
            }
			request.setAttribute(PROJECT_BUILD_STATUS_COUNT, buildStatusCount);
            
			
		} catch (SQLException e) {
			throw new ServletException(e);
		} finally {
			releaseConnection(conn);
		}
		chain.doFilter(request, response);
	}

}
