// src/pages/Dashboard.js
import React, { useContext, useEffect, useState } from 'react';
import axios from '../axios';
import { AuthContext } from '../context/AuthContext';

function Dashboard() {
  const { user, logout, token } = useContext(AuthContext);
  const [users, setUsers] = useState([]);
  const [formData, setFormData] = useState({ name: '', email: '', password: '' });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const res = await axios.get('/users', {
        headers: { Authorization: token },
      });
      setUsers(res.data);
    } catch (err) {
      console.error('Fetch users failed:', err);
    }
  };

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleAddUser = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      await axios.post(
        '/users',
        { ...formData, role: 'viewer' },
        { headers: { Authorization: token } }
      );
      setFormData({ name: '', email: '', password: '' });
      fetchUsers();
    } catch (err) {
      console.error('Error adding user:', err);
      alert('User creation failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="dashboard-container">
      {/* Top Welcome / User Bar */}
      <div className="dashboard-header-card">
        <div className="dashboard-welcome">
          <h2>User Management Dashboard</h2>
          <p className="dashboard-subtitle">Manage system users and access permissions</p>
        </div>
        <div className="user-profile-actions">
          <div className="user-badge-info">
            <span className="user-name">{user?.name}</span>
            <span className={`role-pill ${user?.role === 'admin' ? 'admin' : 'viewer'}`}>
              {user?.role}
            </span>
          </div>
          <button className="logout-btn" onClick={logout}>
            Logout
          </button>
        </div>
      </div>

      <div className="dashboard-grid">
        {/* Add User Form Card */}
        <div className="card form-card">
          <h3>Add New Viewer</h3>
          <form className="user-form" onSubmit={handleAddUser}>
            <div className="input-group">
              <input
                className="form-field"
                type="text"
                name="name"
                placeholder="Full Name"
                value={formData.name}
                onChange={handleChange}
                required
              />
            </div>
            <div className="input-group">
              <input
                className="form-field"
                type="email"
                name="email"
                placeholder="Email Address"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>
            <div className="input-group">
              <input
                className="form-field"
                type="password"
                name="password"
                placeholder="Password"
                value={formData.password}
                onChange={handleChange}
                required
              />
            </div>
            <button type="submit" className="submit-btn" disabled={loading}>
              {loading ? 'Creating...' : '+ Add User'}
            </button>
          </form>
        </div>

        {/* Users Table Card */}
        <div className="card table-card">
          <div className="table-header">
            <h3>Registered Users</h3>
            <span className="user-count-badge">{users.length} Total</span>
          </div>
          <div className="table-responsive">
            <table className="modern-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {users.length > 0 ? (
                  users.map((u) => (
                    <tr key={u.id}>
                      <td className="id-col">#{u.id}</td>
                      <td><strong>{u.name}</strong></td>
                      <td>{u.email}</td>
                      <td>
                        {user?.role === 'admin' ? (
                          <div className="action-buttons">
                            <button className="action-btn edit">Edit</button>
                            <button className="action-btn delete">Delete</button>
                          </div>
                        ) : (
                          <span className="na-text">Restricted</span>
                        )}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="4" className="empty-state">No users found.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;