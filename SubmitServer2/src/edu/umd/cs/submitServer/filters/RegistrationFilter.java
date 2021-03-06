package edu.umd.cs.submitServer.filters;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.umd.cs.marmoset.modelClasses.Student;
import edu.umd.cs.submitServer.SubmitServerConstants;
import edu.umd.cs.submitServer.WebConfigProperties;
import edu.umd.cs.submitServer.dao.RegistrationDao;
import edu.umd.cs.submitServer.dao.impl.MySqlRegistrationDaoImpl;

/**
 * Filter to get a list of all courses available for registration and any pending registration requests.
 * 
 * @author rwsims
 *
 */
public class RegistrationFilter extends SubmitServerFilter {
	private static final WebConfigProperties webProperties = WebConfigProperties.get();

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String gradesServer = webProperties.getProperty("grades.server");
        if (gradesServer == null) {
            Student user = (Student) request.getAttribute(SubmitServerConstants.USER);
            RegistrationDao dao = new MySqlRegistrationDaoImpl(user, submitServerDatabaseProperties);
            request.setAttribute("pendingRequests", dao.getPendingRequests());
            request.setAttribute(SubmitServerConstants.OPEN_COURSES, dao.getOpenCourses());
        }
        chain.doFilter(request, response);
    }
}
