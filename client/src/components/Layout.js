import React, { useState } from 'react';
import logo from '../logo.svg';
import InfoPopup from './InfoPopup';
import AnimatedBanner from './AnimatedBanner';

function Layout({ children }) {
  const [showInfo, setShowInfo] = useState(false);

  return (
    <div className="app-layout">
      {/* Sleek Modern Header */}
      <header className="app-header slide-down">
        <div className="brand">
          <div className="logo-glow-wrapper">
            <img src={logo} alt="Sanket" className="logo" />
          </div>
          <div>
            <h1 className="brand-title">Sanket</h1>
            <p className="nav-subtitle">3-Tier DevSecOps Platform</p>
          </div>
        </div>
        <div className="header-badge">
          <span className="status-dot"></span> Live System
        </div>
      </header>

      {/* Top Animated Banner */}
      <AnimatedBanner message="the devops journey with sanket" />

      {/* Main Body Grid */}
      <div className="app-body">
<aside className="devops-sidebar slide-in-left">
  <div className="learning-header">
    <span className="learning-badge">DEVOPS HUB</span>
    <h3>Keep Learning 🚀</h3>
    <p>Build. Automate. Deploy.</p>
  </div>

  <div className="learning-card">
    <div className="card-top">
      <span>Currently Learning</span>
      <span className="status-dot"></span>
    </div>

    <h4>AWS & Cloud DevOps</h4>
    <p>
      Learn cloud infrastructure, automation,
      CI/CD and scalable deployments.
    </p>

    <div className="progress-info">
      <span>Learning Progress</span>
      <strong>75%</strong>
    </div>

    <div className="progress-bar">
      <div className="progress-fill"></div>
    </div>
  </div>

  <div className="tech-section">
    <div className="section-title">
      <span>⚡</span>
      <h4>Tech Stack</h4>
    </div>

    <div className="tech-grid">
      <div className="tech-item">
        <span>☁️</span>
        <p>AWS</p>
      </div>

      <div className="tech-item">
        <span>🐳</span>
        <p>Docker</p>
      </div>

      <div className="tech-item">
        <span>☸️</span>
        <p>Kubernetes</p>
      </div>

      <div className="tech-item">
        <span>⚙️</span>
        <p>Jenkins</p>
      </div>

      <div className="tech-item">
        <span>🏗️</span>
        <p>Terraform</p>
      </div>

      <div className="tech-item">
        <span>🔀</span>
        <p>Git</p>
      </div>
    </div>
  </div>

  <div className="quote-card">
    <span className="quote-icon">"</span>
    <p>
      Automation is not about doing things faster.
      It's about building systems that scale.
    </p>
  </div>

  <div className="sidebar-cta">
    <div>
      <span>📚</span>
      <div>
        <strong>Keep Building</strong>
        <small>One concept at a time.</small>
      </div>
    </div>

    <button type="button">
      Explore →
    </button>
  </div>
</aside>
        <main className="main-content fade-in">
          <div className="content-card">
            {children}
          </div>
        </main>
      </div>

      {/* Modern Footer */}
      <footer className="app-footer">
        <p>&copy; {new Date().getFullYear()} <strong>Sanket</strong>. All rights reserved.</p>
      </footer>

      {/* Floating Help Button & Popup */}
      <button className="help-btn" onClick={() => setShowInfo(true)} title="Project Info">?</button>
      {showInfo && <InfoPopup onClose={() => setShowInfo(false)} />}

      {/* Background Ambient Elements */}
      <div className="bubble-container">
        {[...Array(6)].map((_, i) => (
          <div key={i} className="bubble" />
        ))}
      </div>
      <div className="star-container">
        {[...Array(12)].map((_, i) => (
          <div key={i} className="star" />
        ))}
      </div>
    </div>
  );
}

export default Layout;