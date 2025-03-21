<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sportflow.model.Session" %>
<%@ page import="com.sportflow.util.DateUtil" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/navbar.jsp" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
      integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg=="
      crossorigin="anonymous" referrerpolicy="no-referrer"/>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<style>
    /* Base styling */
    body {
        background-color: #f8fafc;
        font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
        color: #334155;
        line-height: 1.6;
    }

    /* Dashboard Container */
    .dashboard-container {
        padding: 30px 15px;
        max-width: 1400px;
        margin: 0 auto;
    }

    /* Dashboard Header */
    .dashboard-header {
        margin-bottom: 40px;
        padding-bottom: 20px;
        border-bottom: 2px solid rgba(0, 0, 0, 0.05);
        position: relative;
    }

    .dashboard-title {
        color: #0f172a;
        font-weight: 700;
        font-size: 2rem;
        position: relative;
        display: inline-block;
        margin-bottom: 10px;
    }

    .dashboard-title::after {
        content: '';
        position: absolute;
        bottom: -5px;
        left: 0;
        width: 60px;
        height: 4px;
        background: linear-gradient(to right, #3B82F6, #10B981);
        border-radius: 2px;
    }

    /* Enhanced table styling */
    .table-container {
        background-color: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        overflow: hidden;
        margin-bottom: 30px;
    }

    .table {
        margin-bottom: 0;
        width: 100%;
        background-color: transparent;
    }

    .table thead th {
        background-color: #f1f5f9;
        color: #475569;
        font-weight: 600;
        padding: 14px 16px;
        border-bottom: 2px solid #e2e8f0;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .table tbody td {
        padding: 12px 16px;
        border-bottom: 1px solid #f1f5f9;
        vertical-align: middle;
        font-size: 0.95rem;
    }

    .table tbody tr:last-child td {
        border-bottom: none;
    }

    .table tbody tr:hover {
        background-color: #f8fafc;
    }

    /* Button styling */
    .btn {
        border-radius: 8px;
        padding: 9px 18px;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.08);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .btn-primary {
        background-color: #3B82F6;
        border-color: #3B82F6;
    }

    .btn-primary:hover, .btn-primary:focus {
        background-color: #2563EB;
        border-color: #2563EB;
        box-shadow: 0 4px 10px rgba(59, 130, 246, 0.4);
    }

    .btn-danger {
        background-color: #EF4444;
        border-color: #EF4444;
    }

    .btn-danger:hover, .btn-danger:focus {
        background-color: #DC2626;
        border-color: #DC2626;
        box-shadow: 0 4px 10px rgba(239, 68, 68, 0.4);
    }

    /* Modal styling */
    .sf-modal {
        z-index: 1050;
        overflow: auto;
    }

    .sf-modal-dialog {
        max-width: 80%;
        margin: 1.75rem auto;
    }

    .sf-modal-content {
        border-radius: 12px;
        border: none;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        overflow: hidden;
    }

    .sf-modal-header {
        border-bottom: 1px solid #f1f5f9;
        padding: 18px 24px;
        background-color: #f8fafc;
    }

    .sf-modal-title {
        font-weight: 600;
        color: #0f172a;
        font-size: 1.2rem;
    }

    .sf-modal-body {
        padding: 24px;
        overflow-y: auto;
        max-height: 60vh;
    }

    .sf-modal-footer {
        border-top: 1px solid #f1f5f9;
        padding: 16px 24px;
        background-color: #f8fafc;
    }

    .close {
        opacity: 0.6;
        transition: all 0.2s ease;
    }

    .close:hover {
        opacity: 1;
    }

    /* Responsive styles */
    @media (max-width: 992px) {
        .dashboard-title {
            font-size: 1.8rem;
        }

        .table-responsive {
            border-radius: 12px;
            overflow: hidden;
        }
    }

    @media (max-width: 768px) {
        .dashboard-container {
            padding: 20px 10px;
        }

        .dashboard-header {
            margin-bottom: 25px;
        }
    }

    /* Error and success alerts */
    .alert {
        border-radius: 8px;
        border: none;
        padding: 15px 20px;
        margin-bottom: 25px;
        position: relative;
    }

    .alert-success {
        background-color: rgba(16, 185, 129, 0.15);
        color: #059669;
    }

    .alert-danger {
        background-color: rgba(239, 68, 68, 0.15);
        color: #DC2626;
    }

    .alert-info {
        background-color: rgba(59, 130, 246, 0.15);
        color: #2563EB;
    }
</style>

<div class="container dashboard-container">
    <div class="bg-pattern"></div>
    <div class="dashboard-header">
        <h1 class="dashboard-title">Member Dashboard</h1>
    </div>

    <h2>Booked Sessions</h2>

    <!-- Check for any error messages -->
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger" role="alert">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } else { %>

    <% List<Session> bookedSessions = (List<Session>) request.getAttribute("bookedSessions");
        if (bookedSessions != null && !bookedSessions.isEmpty()) { %>
    <div class="table-container">
        <div class="table-responsive">
            <table class="table">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Session bookedSession : bookedSessions) { %>
                <tr>
                    <td><%= bookedSession.getTitle() %></td>
                    <td><%= bookedSession.getDescription() %></td>
                    <td><%= DateUtil.formatDate(bookedSession.getSessionDate()) %></td>
                    <td><%= DateUtil.formatTime(bookedSession.getStartTime()) %></td>
                    <td><%= DateUtil.formatTime(bookedSession.getEndTime()) %></td>
                    <td>
                        <button type="button" class="btn btn-danger btn-sm" data-toggle="modal" data-target="#cancelBookingModal<%= bookedSession.getId() %>">Cancel</button>
                    </td>
                </tr>

                <!-- Cancel Booking Modal -->
                <div class="modal fade sf-modal" id="cancelBookingModal<%= bookedSession.getId() %>" tabindex="-1" role="dialog" aria-labelledby="cancelBookingModalLabel<%= bookedSession.getId() %>" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content sf-modal-content">
                            <div class="modal-header sf-modal-header">
                                <h5 class="modal-title sf-modal-title" id="cancelBookingModalLabel<%= bookedSession.getId() %>">Confirm Cancellation</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">×</span>
                                </button>
                            </div>
                            <div class="modal-body sf-modal-body">
                                Are you sure you want to cancel your booking for this session?
                            </div>
                            <div class="modal-footer sf-modal-footer">
                                <form action="<%=request.getContextPath()%>/member/cancel-booking" method="get">
                                    <input type="hidden" name="bookingId" value="<%= bookedSession.getId() %>">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-danger">Confirm Cancel</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
    <p>You have no booked sessions.</p>
    <% } %>
    <% } %>
</div>

<%@ include file="../common/footer.jsp" %>
