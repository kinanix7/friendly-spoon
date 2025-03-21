package com.sportflow.controller.entrainer;

import com.sportflow.dao.EntrainerDAO;
import com.sportflow.dao.SessionDAO;
import com.sportflow.model.Entrainer;
import com.sportflow.model.Session;
import com.sportflow.model.User;
import com.sportflow.model.Member; // Import Member
import com.sportflow.util.DateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.HashMap; // Import HashMap
import java.util.Map;

@WebServlet(name = "SessionManagementServlet", urlPatterns = {
        "/entrainer/sessions",
        "/entrainer/sessions/add",
        "/entrainer/sessions/edit",
        "/entrainer/sessions/delete"
})
public class SessionManagementServlet extends HttpServlet {

    private SessionDAO sessionDAO;
    private EntrainerDAO entrainerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        sessionDAO = new SessionDAO();
        entrainerDAO = new EntrainerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        Integer userId = user.getId();

        try {
            Entrainer entrainer = entrainerDAO.getEntrainerByUserId(userId);
            List<Session> sessions = sessionDAO.getSessionsByEntrainerId(entrainer.getId());
            request.setAttribute("sessions", sessions);

            Map<Integer, List<Member>> membersBySession = new HashMap<>();
            for (Session s : sessions) {
                List<Member> members = sessionDAO.getMembersBySessionId(s.getId());
                membersBySession.put(s.getId(), members);
            }
            request.setAttribute("membersBySession", membersBySession);

            request.getRequestDispatcher("/WEB-INF/jsp/entrainer/sessions.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/entrainer/sessions/add":
                    addSession(request, response);
                    break;
                case "/entrainer/sessions/edit":
                    editSession(request, response);
                    break;
                case "/entrainer/sessions/delete":
                    deleteSession(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/entrainer/sessions");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }


    private void addSession(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        Entrainer entrainer = entrainerDAO.getEntrainerByUserId(user.getId());
        int entrainerId = entrainer.getId();
        Session newSession = new Session();
        newSession.setEntrainerId(entrainerId);
        newSession.setTitle(request.getParameter("title"));
        newSession.setDescription(request.getParameter("description"));
        newSession.setSessionDate(DateUtil.parseDate(request.getParameter("sessionDate")));
        newSession.setStartTime(DateUtil.parseTime(request.getParameter("startTime")));
        newSession.setEndTime(DateUtil.parseTime(request.getParameter("endTime")));
        newSession.setMaxParticipants(Integer.parseInt(request.getParameter("maxParticipants")));
        sessionDAO.createSession(newSession);

        response.sendRedirect(request.getContextPath() + "/entrainer/sessions");
    }


    private void editSession(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {

        int sessionId = Integer.parseInt(request.getParameter("sessionId"));

        Session session = sessionDAO.getSessionById(sessionId);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Session not found");
            return;
        }

        session.setTitle(request.getParameter("title"));
        session.setDescription(request.getParameter("description"));
        session.setSessionDate(DateUtil.parseDate(request.getParameter("sessionDate")));
        session.setStartTime(DateUtil.parseTime(request.getParameter("startTime")));
        session.setEndTime(DateUtil.parseTime(request.getParameter("endTime")));
        session.setMaxParticipants(Integer.parseInt(request.getParameter("maxParticipants")));

        sessionDAO.updateSession(session);

        response.sendRedirect(request.getContextPath() + "/entrainer/sessions");
    }


    private void deleteSession(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int sessionId = Integer.parseInt(request.getParameter("sessionId"));
        sessionDAO.deleteSession(sessionId);
        response.sendRedirect(request.getContextPath() + "/entrainer/sessions");
    }
}