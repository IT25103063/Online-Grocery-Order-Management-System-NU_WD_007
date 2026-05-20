<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – Smart Grocery</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .role-tabs { display:flex; margin-bottom:1.8rem; border-radius:12px; overflow:hidden; border:2px solid #e0e0e0; }
    .role-tab { flex:1; padding:.75rem; text-align:center; cursor:pointer; font-weight:700; font-size:.95rem; background:#f8f9fa; border:none; transition:all .2s; color:#888; }
    .role-tab.active-customer { background:#198754; color:#fff; }
    .role-tab.active-admin    { background:#dc3545; color:#fff; }
  </style>
</head>
<body class="auth-body">
<div class="auth-wrapper">

  <div class="auth-left">
    <div class="auth-left-inner">
      <div class="brand-logo">🛒</div>
      <h1 class="brand-name">Smart Grocery</h1>
      <p class="brand-tagline">Your daily fresh grocery destination</p>
      <div class="brand-features">
        <div class="feature-item">✅ Fresh produce daily</div>
        <div class="feature-item">🚚 Fast doorstep delivery</div>
        <div class="feature-item">🎂 Birthday special discounts</div>
        <div class="feature-item">🔒 Safe &amp; secure checkout</div>
      </div>
    </div>
    <div class="auth-left-footer">© 2025 Smart Grocery. All rights reserved.</div>
  </div>

  <div class="auth-right">
    <div class="auth-form-box">
      <div class="auth-top">
        <h2 id="loginTitle">Sign in 👋</h2>
        <p id="loginSubtitle">Welcome back! Choose your account type.</p>
      </div>

      <div class="role-tabs">
        <button class="role-tab active-customer" id="tabCustomer" onclick="switchTab('customer')">🛒 Customer</button>
        <button class="role-tab" id="tabAdmin" onclick="switchTab('admin')">🛡️ Admin</button>
      </div>

      <c:if test="${param.registered == 'true'}">
        <div class="success-msg">✅ Registered successfully! Please sign in.</div>
      </c:if>
      <c:if test="${param.msg == 'PasswordReset'}">
        <div class="success-msg">✅ Password reset! Please sign in.</div>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="error-msg-box">❌ ${errorMessage}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="hidden" name="loginType" id="loginType" value="customer">

        <div class="form-group">
          <label>👤 Username</label>
          <div class="input-wrap">
            <span class="input-icon">👤</span>
            <input type="text" name="username" placeholder="Enter your username" required>
          </div>
        </div>

        <div class="form-group">
          <label>🔒 Password</label>
          <div class="input-wrap">
            <span class="input-icon">🔒</span>
            <input type="password" id="pw" name="password" placeholder="••••••••" required>
            <span class="input-eye" onclick="togglePass()">👁</span>
          </div>
        </div>

        <div class="form-options d-flex justify-content-between align-items-center">
          <label class="remember-me"><input type="checkbox"> Remember me</label>
          <a href="${pageContext.request.contextPath}/forgot-password" class="text-success small fw-semibold">🔑 Forgot Password?</a>
        </div>

        <button type="submit" class="btn-primary-auth" id="submitBtn">🚀 Sign In as Customer</button>
      </form>

      <div id="registerLink">
        <div class="auth-divider"><span>or</span></div>
        <p class="auth-switch">Don't have an account? <a href="${pageContext.request.contextPath}/register">📝 Create one free</a></p>
      </div>
    </div>
  </div>
</div>

<script>
function switchTab(type) {
  const isAdmin = type === 'admin';
  document.getElementById('loginType').value = type;
  document.getElementById('tabCustomer').className = 'role-tab' + (!isAdmin ? ' active-customer' : '');
  document.getElementById('tabAdmin').className    = 'role-tab' + (isAdmin  ? ' active-admin'    : '');
  document.getElementById('loginTitle').textContent    = isAdmin ? 'Admin Login 🛡️' : 'Sign in 👋';
  document.getElementById('loginSubtitle').textContent = isAdmin ? 'Welcome, Administrator!' : 'Welcome back!';
  document.getElementById('submitBtn').textContent     = isAdmin ? '🛡️ Sign In as Admin' : '🚀 Sign In as Customer';
  document.getElementById('registerLink').style.display = isAdmin ? 'none' : 'block';
}
function togglePass() {
  const i = document.getElementById('pw');
  i.type = i.type === 'password' ? 'text' : 'password';
}
<c:if test="${not empty errorMessage}">
  if ('${param.loginType}' === 'admin') switchTab('admin');
</c:if>
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
