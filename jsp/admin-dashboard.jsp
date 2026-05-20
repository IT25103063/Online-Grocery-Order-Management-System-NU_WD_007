<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.user || sessionScope.user.role != 'ADMIN' || sessionScope.user.adminCode != 'SUPER_ADMIN'}">
    <c:redirect url="dashboard.jsp"/>
</c:if>
<c:set var="pageTitle" value="🛡️ Security Dashboard - Smart Grocery" scope="request"/>
<jsp:include page="/WEB-INF/components/header.jsp"/>
<jsp:include page="/WEB-INF/components/navbar.jsp"/>
<jsp:include page="/WEB-INF/components/sidebar.jsp"/>

<style>
.sec-hero {
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    border-radius: 18px; padding: 2rem 2.5rem; color: #fff;
    margin-bottom: 1.5rem; position: relative; overflow: hidden;
}
.sec-hero::before {
    content: '🛡️'; position: absolute; right: 2rem; top: 50%;
    transform: translateY(-50%); font-size: 8rem; opacity: 0.08;
}
.sec-hero h2 { font-family:'Poppins',sans-serif; font-weight:800; margin:0; font-size:1.8rem; }
.sec-hero p  { opacity:0.75; margin:0.5rem 0 0; }
.stat-box {
    border-radius: 16px; padding: 1.5rem; color: #fff;
    box-shadow: 0 4px 15px rgba(0,0,0,0.15); transition: transform 0.2s;
}
.stat-box:hover { transform: translateY(-4px); }
.stat-box .stat-icon { font-size: 2.5rem; opacity: 0.8; }
.stat-box .stat-num  { font-size: 2.2rem; font-weight: 800; font-family:'Poppins',sans-serif; }
.stat-box .stat-label{ font-size: 0.8rem; opacity: 0.8; text-transform: uppercase; letter-spacing: 0.05em; }
.log-terminal {
    background: #0d1117; border-radius: 14px; overflow: hidden;
    box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}
.log-header {
    background: #161b22; padding: 0.75rem 1.2rem;
    display: flex; align-items: center; gap: 0.5rem;
}
.log-dot { width:12px; height:12px; border-radius:50%; }
.log-body { padding: 1rem; max-height: 380px; overflow-y: auto; }
.log-body::-webkit-scrollbar { width:4px; }
.log-body::-webkit-scrollbar-thumb { background:#30363d; border-radius:2px; }
.log-line {
    font-family: 'Courier New', monospace; font-size: 0.82rem;
    color: #7ee787; padding: 0.3rem 0; border-bottom: 1px solid #21262d;
    display: flex; gap: 0.5rem;
}
.log-line:last-child { border-bottom: none; }
.log-prompt { color: #58a6ff; flex-shrink: 0; }
.action-card {
    background: #fff; border-radius: 14px; padding: 1.5rem;
    box-shadow: 0 2px 10px rgba(0,0,0,0.07); transition: all 0.2s;
    text-decoration: none; color: #1a1a1a; display: block; border: 2px solid transparent;
}
.action-card:hover { border-color: #2e7d47; transform: translateY(-3px); color: #2e7d47; }
.action-icon { font-size: 2rem; margin-bottom: 0.75rem; }
.action-title { font-weight: 700; font-size: 0.95rem; margin-bottom: 0.25rem; }
.action-desc  { font-size: 0.78rem; color: #888; }
</style>

<main class="main-content">
<div class="container-fluid fade-in">

    <!-- Hero -->
    <div class="sec-hero">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2>🛡️ Security Dashboard</h2>
                <p>Super Admin Control Panel — Full System Access</p>
            </div>
            <a href="${pageContext.request.contextPath}/admins?action=management"
               style="background:rgba(255,255,255,0.15); border:2px solid rgba(255,255,255,0.4);
                      color:#fff; border-radius:10px; padding:0.6rem 1.2rem;
                      font-weight:600; text-decoration:none; white-space:nowrap;">
                ⚙️ Manage Admins
            </a>
        </div>
    </div>

    <!-- Stat Cards -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-box" style="background:linear-gradient(135deg,#ef4444,#b91c1c)">
                <div class="stat-icon">👮</div>
                <div class="stat-num">${adminCount}</div>
                <div class="stat-label">Active Admins</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-box" style="background:linear-gradient(135deg,#3b82f6,#1d4ed8)">
                <div class="stat-icon">📋</div>
                <div class="stat-num">${fn:length(logs)}</div>
                <div class="stat-label">Log Entries</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-box" style="background:linear-gradient(135deg,#10b981,#065f46)">
                <div class="stat-icon">✅</div>
                <div class="stat-num">Online</div>
                <div class="stat-label">System Status</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-box" style="background:linear-gradient(135deg,#f59e0b,#92400e)">
                <div class="stat-icon">🔐</div>
                <div class="stat-num">SUPER</div>
                <div class="stat-label">Your Access Level</div>
            </div>
        </div>
    </div>

    <div class="row g-4">

        <!-- Activity Log Terminal -->
        <div class="col-lg-8">
            <div class="log-terminal">
                <div class="log-header">
                    <div class="log-dot" style="background:#ff5f56"></div>
                    <div class="log-dot" style="background:#febc2e"></div>
                    <div class="log-dot" style="background:#28c840"></div>
                    <span style="color:#8b949e; font-size:0.82rem; margin-left:0.5rem; font-family:monospace;">
                        system_activity.log — Smart Grocery Admin
                    </span>
                </div>
                <div class="log-body">
                    <c:forEach var="log" items="${logs}">
                        <div class="log-line">
                            <span class="log-prompt">$</span>
                            <span>${log}</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty logs}">
                        <div class="log-line">
                            <span class="log-prompt">$</span>
                            <span style="color:#8b949e;">No activity logs yet. Actions will appear here.</span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="col-lg-4">
            <h5 class="fw-bold mb-3">⚡ Quick Actions</h5>
            <div class="d-flex flex-column gap-3">

                <a href="${pageContext.request.contextPath}/admins?action=management" class="action-card">
                    <div class="action-icon">👥</div>
                    <div class="action-title">Manage Administrators</div>
                    <div class="action-desc">Add, edit or remove admin accounts</div>
                </a>

                <a href="${pageContext.request.contextPath}/admin-approvals" class="action-card">
                    <div class="action-icon">⏳</div>
                    <div class="action-title">Pending Approvals</div>
                    <div class="action-desc">Review new admin registration requests</div>
                </a>

                <a href="${pageContext.request.contextPath}/users?action=list" class="action-card">
                    <div class="action-icon">🛍️</div>
                    <div class="action-title">All Users</div>
                    <div class="action-desc">View and manage customer accounts</div>
                </a>

                <a href="${pageContext.request.contextPath}/discounts" class="action-card">
                    <div class="action-icon">🏷️</div>
                    <div class="action-title">Manage Discounts</div>
                    <div class="action-desc">Set product discounts and offers</div>
                </a>

            </div>
        </div>

    </div>
</div>
</main>

<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/WEB-INF/components/footer.jsp"/>
