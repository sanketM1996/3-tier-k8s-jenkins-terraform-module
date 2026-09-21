import React from 'react';

function InfoPopup({ onClose }) {
  return (
    <div className="info-overlay" onClick={onClose}>
      <div className="info-box" onClick={e => e.stopPropagation()}>
        <h3>About This App</h3>
        <p>This project shows how a 3-tier application works with React handling the user interface and Node.js managing the backend.</p>
        <button onClick={onClose}>Close</button>
      </div>
    </div>
  );
}

export default InfoPopup;
